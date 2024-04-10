# Template Ruby on Rails application

This is a template repository for a Ruby on Rails application.

See [`navapbc/platform`](https://github.com/navapbc/platform) for other template repos.

## Features

- [U.S. Web Design System](https://designsystem.digital.gov/) for themeable styling and a set of common components
- Integration with AWS services, including
  - Database integration with AWS RDS Postgresql using UUIDs
  - Active Storage configuration with AWS S3
  - Action Mailer configuration with AWS SES
  - Authentication with [devise](https://github.com/heartcombo/devise) and AWS Cognito
- Internationalization (i18n)
- Authorization using [pundit](https://github.com/varvet/pundit)
- Linting and code formatting using [rubocop](https://rubocop.org/)
- Testing using [rspec](https://rspec.info)

## Repo structure

```text
├── .github                       # GitHub workflows and repo templates
├── docs                          # Project docs and decision records
├── template-application-rails    # Web application
```

## Installation

To get started using the template application on your project:

1. Run the [download and install script](./template-only-bin/download-and-install-template.sh) in your project's root directory.

    ```bash
    curl https://raw.githubusercontent.com/navapbc/template-application-rails/main/template-only-bin/download-and-install-template.sh | bash -s
    ```

    This script will:

    1. Clone the template repository
    2. Copy the template files into your project directory
    3. Remove any files specific to the template repository, like this README.
2. [Follow the steps in `template-application-rails/README.md`](./template-application-rails/README.md) to set up the application locally.
3. Optional, if using the Platform infra template: [Follow the steps in the `template-infra` README](https://github.com/navapbc/template-infra#installation) to set up the various pieces of your infrastructure.

## Getting started

Now that you're all set up, you're now ready to [get started](./template-application-rails/README.md).

## Learn more about this template

- [Dependency management](./template-only-docs/set-up-dependency-management.md)
- [Deployment](./template-only-docs/set-up-cd.md)
