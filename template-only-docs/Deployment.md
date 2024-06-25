# Deployment to cloud environments

## Requirements

- External service access: The application must be able to make network calls to the public internet.
- AWS Cognito: The application comes with AWS Cognito enabled by default, so AWS Cognito must be set up before deploying the application.
- Custom domain name with HTTPS support: AWS Cognito requires HTTPS for callback urls to function.
- Access to write to temporary directory: Rails needs to be able to write out temporary files.
- Environment variables: You must provide the application with the environment variables listed in [local.env.example](/app-rails/local.env.example).
- Secrets: You must provide the application with a secret `SECRET_KEY_BASE`. For more information, see the [Rails Guide on Security](https://guides.rubyonrails.org/v7.1/security.html#environmental-security).

## Deploying using the Platform Infrastructure Template

This template can be deployed using the [Nava Platform Infrastructure Template](https://github.com/navapbc/template-infra). Using the infrastructure template will handle creating and configuring all of the resources required in AWS.

While following the [infrastructure template installation instructions](https://github.com/navapbc/template-infra?tab=readme-ov-file#installation) and [setup instructions](https://github.com/navapbc/template-infra/blob/main/infra/README.md), use the following configuration:

1. Rename `/infra/app` to `/infra/<APP_NAME>` so that it matches the directory name of your application. By default, this is `app-rails`.
1. In `/infra/<APP_NAME>/app-config/main.tf`:
    1. Set `has_external_non_aws_service` to `true`.
    2. Set `enable_identity_provider` to `true`.
1. In `/infra/<APP_NAME>/app-config/<ENVIRONMENT>.tf`:
    1. Set the `domain_name`.
    2. Set `enable_https` to `true`.
    3. Set `enable_command_execution` to `true`: This is necessary temporarily until a temporary file system can be enabled. Otherwise, ECS will run with read-only root filesystem, which will cause rails to error.
1. In `/infra/<APP_NAME>/app-config/env-config/environment-variables.tf`:
    1. Add an entry to `default_extra_environment_variables`:
    ```terraform
    AWS_BUCKET_NAME = local.bucket_name
    ```
    2. Add an entry to `secrets`:
    ```terraform
    SECRET_KEY_BASE = {
      manage_method     = "generated"
      secret_store_name = "/${var.app_name}-${var.environment}/service/rails-secret-key-base"
    }
    ```
1. In `/infra/networks/main.tf`:
    1. Modify the `app_config` module to change the path to match the directory name of your application. By default, this is `app-rails`.
    ```terraform
    module "app_config" {
      source = "../<APP_NAME>/app-config"
    }
    ```
1. Follow the infrastructure template instructions to configure [custom domains](https://github.com/navapbc/template-infra/blob/main/docs/infra/set-up-custom-domains.md) and [https support](https://github.com/navapbc/template-infra/blob/main/docs/infra/https-support.md).
