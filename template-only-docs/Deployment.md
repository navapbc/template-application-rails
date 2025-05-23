# Deployment to cloud environments

## Requirements

- External service access: The application must be able to make network calls to the public internet.
- AWS Cognito: The application comes with AWS Cognito enabled by default, so AWS Cognito must be set up before deploying the application.
- Custom domain name with HTTPS support: AWS Cognito requires HTTPS for callback urls to function.
- Access to write to temporary directory: Rails needs to be able to write out temporary files.
- Environment variables: You must provide the application with the environment variables listed in [local.env.example](/template/{{app_name}}/local.env.example).
- Secrets: You must provide the application with a secret `SECRET_KEY_BASE`. For more information, see the [Rails Guide on Security](https://guides.rubyonrails.org/v7.1/security.html#environmental-security).

## Deploying using the Platform Infrastructure Template

This template can be deployed using the [Nava Platform Infrastructure Template](https://github.com/navapbc/template-infra). Using the infrastructure template will handle creating and configuring all of the resources required in AWS.

While following the [infrastructure template installation instructions](https://github.com/navapbc/template-infra?tab=readme-ov-file#installation) and [setup instructions](https://github.com/navapbc/template-infra/blob/main/infra/README.md), use the following configuration:

1. Be sure you've installed this template and the infra-app template via [the nava-platform tool](https://github.com/navapbc/platform-cli) using the same `<APP_NAME>`.
1. In `/infra/<APP_NAME>/app-config/main.tf`:
    1. Set `has_external_non_aws_service` to `true`.
    2. Set `enable_identity_provider` to `true`.
1. In `/infra/<APP_NAME>/app-config/<ENVIRONMENT>.tf`:
    1. Set the `domain_name`.
    2. Set `enable_https` to `true`.
1. In `/infra/<APP_NAME>/app-config/env-config/service.tf`:
    1. Configure the service's `ephemeral_write_volumes`:
        ```terraform
        ephemeral_write_volumes = [
          "/rails/tmp"
        ]
        ```
1. In `/infra/<APP_NAME>/app-config/env-config/environment-variables.tf`:
    1. Add an entry to `secrets`:
    ```terraform
    SECRET_KEY_BASE = {
      manage_method     = "generated"
      secret_store_name = "/${var.app_name}-${var.environment}/service/rails-secret-key-base"
    }
    ```
1. Follow the infrastructure template instructions to configure [custom domains](https://github.com/navapbc/template-infra/blob/main/docs/infra/set-up-custom-domains.md) and [https support](https://github.com/navapbc/template-infra/blob/main/docs/infra/https-support.md).

## Enabling Lookbook on the dev environment

Lookbook is useful for sharing in progress components with teammates, including product managers and designers. To enable Lookbook on the dev environment, add an environment variable `ENABLE_LOOKBOOK` set to `true` in `/infra/<APP_NAME>/app-config/dev.tf` by adding the following code.

```terraform
service_override_extra_environment_variables = {
  ENABLE_LOOKBOOK = "true"
}
```

## Deploying using another method

- AWS Cognito requires a lot of configuration to work correctly. See the Nava Platform infrastructure template for example configuration.
- If you are deploying using AWS ECS, but don't want to use the Platform infrastructure template, pass in environment variables and secrets using the ECS task definition. Use the `environment` key for environment variables and the `secrets` key with `valueFrom` for secrets.
