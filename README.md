<p>
  <img src="template/docs/assets/Nava-Strata-Logo-V02.svg" alt="Nava Strata" width="400">
</p>
<p><i>Open source tools for every layer of government service delivery.</i></p>
<p><b>Strata is a gold-standard target architecture and suite of open-source tools that gives government agencies everything they need to run a modern service.</b></p>

<h4 align="center">
  <a href="https://github.com/navapbc/template-application-rails/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-apache_2.0-red" alt="Nava Strata is released under the Apache 2.0 license" >
  </a>
  <a href="https://github.com/navapbc/template-application-rails/blob/main/CONTRIBUTING.md">
    <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen" alt="PRs welcome!" />
  </a>
  <a href="https://github.com/navapbc/template-application-rails/issues">
    <img src="https://img.shields.io/github/commit-activity/m/navapbc/template-application-rails" alt="git commit activity" />
  </a>
  <a href="https://github.com/navapbc/template-application-rails/repos/">
    <img alt="GitHub Downloads (all assets, all releases)" src="https://img.shields.io/github/downloads/navapbc/template-application-rails/total">
  </a>
</h4>

# Template Ruby on Rails application

This is a template repository for a Ruby on Rails application.

See [`navapbc/platform`](https://github.com/navapbc/strata) for other template repos.

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
.
├── template           # The template (the things that get installed/updated)
│   ├── .github        # GitHub workflows
│   ├── docs           # Project docs and decision records
│   └── {{app_name}}   # Application code
└── template-only-docs # Template repo docs
```

## Installation

To get started using the template application on your project, for an
application to be called `<APP_NAME>`:

1. [Install the nava-platform tool](https://github.com/navapbc/platform-cli).
2. Install template by running in your project's root:
    ```sh
    nava-platform app install --template-uri https://github.com/navapbc/template-application-rails . <APP_NAME>
    ```
3. Follow the steps in `<APP_NAME>/README.md` to set up the application locally.
4. Optional, if using the Platform infrastructure template: [Follow the steps in the `template-infra` README](https://github.com/navapbc/template-infra#installation) to set up the various pieces of your infrastructure.

## Updates

If you have previously installed this template and would like to update your
project to use a newer version of this template:

1. [Install the nava-platform tool](https://github.com/navapbc/platform-cli).
2. Update app template by running in your project's root:
    ```sh
    nava-platform app update . <APP_NAME>
    ```
## License

This project is licensed under the Apache 2.0 License. See the [LICENSE](LICENSE) file for details.

## Community

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Contributing Guidelines](CONTRIBUTING.MD)
- [Security Policy](SECURITY.md)