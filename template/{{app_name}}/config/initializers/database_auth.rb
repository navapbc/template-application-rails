# frozen_string_literal: true

# Database authentication strategy
#
# Patches PG::Connection to inject a short-lived authentication token as the
# password on every new connection. The strategy is selected via the
# DB_AUTH_METHOD environment variable:
#
#   DB_AUTH_METHOD=azure_entra  — Azure Managed Identity token (Azure Container Apps)
#   DB_AUTH_METHOD=aws_iam      — AWS RDS IAM auth token
#   (unset)                     — use DB_PASSWORD as-is (local development)
#
# Azure Entra prerequisites:
#   IDENTITY_ENDPOINT   — set automatically by Azure Container Apps
#   IDENTITY_HEADER     — set automatically by Azure Container Apps
#   AZURE_CLIENT_ID     — client ID of the user-assigned managed identity
#
# AWS IAM prerequisites:
#   AWS_REGION          — AWS region where the RDS instance lives
#   DB_HOST             — RDS instance hostname
#   DB_PORT             — RDS instance port (default 5432)
#   DB_USER             — DB username matching the IAM role

module DatabaseAuth
  class AzureEntra
    def token
      resource  = ENV.fetch("AZURE_DB_RESOURCE_URI")
      endpoint  = ENV.fetch("IDENTITY_ENDPOINT")
      header    = ENV.fetch("IDENTITY_HEADER")
      client_id = ENV.fetch("AZURE_CLIENT_ID")

      uri = URI(endpoint)
      uri.query = URI.encode_www_form(
        resource:  resource,
        client_id: client_id,
        "api-version" => "2019-08-01"
      )

      response = Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new(uri)
        request["X-IDENTITY-HEADER"] = header
        http.request(request)
      end

      raise "Azure MSI token request failed: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)

      JSON.parse(response.body).fetch("access_token")
    end
  end

  class AwsIAM
    def token
      generator = Aws::RDS::AuthTokenGenerator.new(
        credentials: Aws::CredentialProviderChain.new.resolve
      )
      generator.auth_token(
        region:   ENV.fetch("AWS_REGION"),
        endpoint: "#{ENV.fetch("DB_HOST")}:#{ENV.fetch("DB_PORT", "5432")}",
        user_name: ENV.fetch("DB_USER")
      )
    end
  end
end

db_auth_method = ENV["DB_AUTH_METHOD"]

if db_auth_method.present?
  strategy = case db_auth_method
  when "azure_entra" then DatabaseAuth::AzureEntra.new
  when "aws_iam"     then DatabaseAuth::AwsIAM.new
  else raise ArgumentError, "Unknown DB_AUTH_METHOD: #{db_auth_method}. Valid values: azure_entra, aws_iam"
  end

  PG::Connection.singleton_class.prepend(Module.new do
    define_method(:parse_connect_args) do |*args|
      conn_string = super(*args)
      token = strategy.token
      # Append password to the libpq keyword=value connection string.
      # Azure AD tokens are base64url-encoded JWTs (no spaces or single quotes),
      # so single-quoting is safe without additional escaping.
      "#{conn_string} password='#{token}'"
    end
  end)
end
