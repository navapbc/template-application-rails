# Template Ruby on Rails application

This is a template repository for a Ruby on Rails application.

See [`navapbc/platform`](https://github.com/navapbc/platform) for other template repos.

## Features

- [U.S. Web Design System (USWDS)](https://designsystem.digital.gov/) for themeable styling and a set of common components
    - Custom USWDS form builder
- Integration with AWS services, including:
  - Database integration with AWS RDS Postgresql using UUIDs
  - Active Storage configuration with AWS S3
  - Action Mailer configuration with AWS SES
  - Authentication with [devise](https://github.com/heartcombo/devise) and AWS Cognito
- Internationalization (i18n)
- Authorization using [pundit](https://github.com/varvet/pundit)
- Linting and code formatting using [rubocop](https://rubocop.org/)
- Testing using [rspec](https://rspec.info)

<img width="1023" alt="CleanShot 2024-05-22 at 16 35 53@2x" src="https://github.com/navapbc/template-application-rails/assets/67701/fb291a98-7dfa-429e-91e2-30beacf58b9e">

## Repo structure

```text
├── .github                       # GitHub workflows and repo templates
├── docs                          # Project docs and decision records
├── app-rails                     # Web application
├── template-only-bin             # Scripts for managing this template; not copied into your project
├── template-only-docs            # Documentation for this template; not copied into your project
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

    You can optionally pass in a branch, commit hash, or release that you want to install. For example:

    ```bash
    curl https://raw.githubusercontent.com/navapbc/template-application-rails/main/template-only-bin/download-and-install-template.sh | bash -s -- <commit_hash>
    ```
2. [Follow the steps in `app-rails/README.md`](./app-rails/README.md) to set up the application locally.
3. Optional, if using the Platform infrastructure template: [Follow the steps in the `template-infra` README](https://github.com/navapbc/template-infra#installation) to set up the various pieces of your infrastructure.

## Updates

If you have previously installed this template and would like to update your project to use a newer version of this application:

1. Run the [download and install script](./template-only-bin/download-and-install-template.sh) in your project's root directory and pass in the branch, commit hash, or release that you want to update to, followed by the name of your application directory (e.g. `app-rails`).

    ```bash
    curl https://raw.githubusercontent.com/navapbc/template-application-rails/main/template-only-bin/download-and-install-template.sh | bash -s -- <commit_hash> <app_name>
    ```

    This script will:

    1. Clone the template repository
    2. Copy the template files into your project directory
    3. Remove any files specific to the template repository, like this README.

⚠️ Warning! This will modify existing files. Review all changes carefully after executing the script by running `git diff`.
