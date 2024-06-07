# Application Security

Application security is a top priority for government technology application development, which is why the Rails framework's security helper methods and countermeasures help speed up secure application delivery. However, the framework isn't useful by itself; its helper methods and configurations only work if they are used properly. This document uses the Rails Guide to [Securing Rails Applications](https://guides.rubyonrails.org/security.html) to audit the template's use of Rails security best practices. This is meant to be a living document and should be updated as additional security tools and configurations are implemented, as well as when new vulnerabilities are discovered or introduced.

Areas for improvement are marked with `TODO` that describe a security implementation. They should be accompanied by a comment in the codebase referencing the action needed, like `# **TODO:** sanitize input to protect against SQL injection`.

## Conforms to Best Practices
As outlined in [Securing Rails Applications](https://guides.rubyonrails.org/security.html)

### 1 Introduction

### 2 Sessions
#### 2.1 What Are Sessions
#### 2.2 Session Hijacking: 
1. `config.force_ssl = true` is set for production environments.
1. Provided the user with a logout button.
#### 2.3 Session Storage
1. Using Devise's Session Controller to manage session storage.
1. Cookies stored client side do not contain sensitive information.
1. Cookies time out in 15 minutes of inactivity with devise `config.timeout_in`.
1. Cookies are encrypted client side.
1. Devise uses BCrypt and the secret_key_base by default for secret hashing.
1. **TODO:** Cognito, the auth service, is also managing sessions and if wanted to expire sessions after a certain time, regardless of activity, we’d have to do it there.
#### 2.4 Rotating Encrypted and Signed Cookies Configurations
1. **TODO:** We are not rotating secrets for hashing nor the hashing algorithm, could do with cognito.
#### 2.5 Replay Attacks for CookieStore Sessions
1. **TODO:** We’re not using a nonce generator that would protect against cookie replay attacks. The commented out code for this is located in `/app-rails/config/initializers/generate_security_policy.rb` This however ties users to a particular server/session as we don’t want to save nonces in the database.
#### 2.6 Session Fixation
#### 2.7 Session Fixation - Countermeasures
1. Devise will automatically expire sessions on sign in and sign out with `config.expire_all_remember_me_on_sign_out = true`.
#### 2.8 Session Expiry

### 3 Cross-Site Request Forgery (CSRF)
#### 3.1  CSRF Countermeasures
1. GET, POST, DELETE, and rails’ resources are used appropriately in the `routes.rb` file.
1. **TODO:** We’re not setting forgery protection in production despite passing a CSRF token to the client, therefore If I change my CSRF token manually in my browser, I’m not prevented from taking any actions (GET or POST requests) as a signed in user.

### 4 Redirection and Files
#### 4.1 Redirection
1. link_tos do not route to user inputs, which is XSS vulnerable.
1. redirect_to does not use params or user inputs in the routes.
4.2 File Uploads
1. **TODO:** App doesn’t currently handle file imports but that should be documented as it is a common need in Government Applications.

### 5. User Management
1. When using devise we don’t need to set has_secure_password on password fields.
#### 5.1 Brute Forcing Accounts
1. Username error is generic and does not indicate whether it was an error with the username or password.
1. Forgot password confirms the email was sent, and not whether the username exists.
#### 5.2 Account Hijacking
1. Change password includes email 6 digit code.
1. **TODO:** Require entering the password when changing email.
#### 5.3 CAPTCHA
1. **TODO:** Include Captcha on account creation, login, change password, and change email.
1. **TODO:** Include honeypot fields and logic on Non logged in forms to catch bots that spam all fields (good resource: https://nedbatchelder.com/text/stopbots.html).
#### 5.4 Logging
1. We’re filtering the following parameter partials (if all or any part matches) in the `config/initialization/filter_paramater_logging.rb` file: `:passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn`.
#### 5.5 Regex
1. Two places where regex is used (`mailto.rb` and devise) use the correct ruby `\A` and `\z` and not the more common: `/^` and `$/`.
1. **TODO:** Add multiline: true to our regex format: in validations.
#### 5.6 Privilege Escalation
1. **TODO:** By manually changing a parameter, a hacker may get access to information they should not be able to access. Instead of doing things like: `@task = Task.find(params[:id])`, instead do `@user.tasks.find(params[:id])`. This is not in the template, but it is in the app the template is based on.

### 6 Injection
#### 6.1 Permitted Lists Versus Restricted Lists
1. **TODO:** Use `except: […]` instead of `only:[…]` for security related actions so when adding actions, they are behind the security by default. Ex. `app-rails/app/controllers/application_controller.rb line: 8`. `after_action :verify_policy_scoped, only: :index`.
#### 6.2 SQL Injection
1. Not generally an issue with rails applications. We aren’t interpolating params into SQL fragments, which would also be against ruby and rails best practices, ie. .where(“name = `#{params[:name]}`”.
#### 6.3.2.1 Cookie Theft
1. While we’re not setting secure: true on the cookies themselves, the `config.force_ssl = true` option in production ensures all cookies are `httponly`.
#### 6.3.2.3 Defacement Countermeasures
1. The template application doesn't have any inputs that are then displayed to the user, aside from the user email, which prevents scripting. However, when those inputs are created, it will be important to sanitize the outputs in the erb files, using `<%=h <some user provided input> =>` to protect against defacement.
1. An additional step can be taken to sanitize inputs, but those should use a permitted list of tags, instead of restricted lists, using:
```
tags = %w(a acronym b strong i em li ul ol h1 h2 h3 h4 h5 h6 blockquote br cite sub sup ins p)
s = sanitize(user_input, tags: tags, attributes: %w(href title))
```
#### 6.3.2.4 Obfuscation and Encoding Injection
1. While consensus seems mixed about the necessity to sanitize Rails input fields for defacement, sanitizing inputs is very useful to protect against encoding injection, and the Rails sanitize() method should be used on inputs that will be presented to the UI at any point.
#### 6.4 CSS Injection
1. This is rarely needed as applications, especially government applications, rarely if ever offer the user the ability to input custom colors or input css filters.
#### 6.5 Textile Injection
1. This template application doesn't allow users to enter text to be converted into html, that's more common in content management system applications. If that feature set is added, it is important to do so with a permitted input filter similar to 6.3.2.3 Defacement Countermeasures. The most common Rails tool for text to html conversion is RedCloth, which is being mentioned in case folks search the repo for RedCloth, they should find this recommendation.
#### 6.6 Ajax Injection
1. The output has to be escaped in the controller already, if the action doesn't render a view. However, we have no case of outputting strings rather than views in our template application. However, rendering data from the controller seems like a Rails anti-pattern.
#### 6.7 Command Line Injection
1. Only relevant if the application takes a user input and executes a command on the underlying operating system. Applicable methods include: 
    1. `system()`
    1. `exec()`
    1. `spawn()`
    1. `command`
#### 6.7.1 Kernel#open's Vulnerability
1. Don't use the `open()` method to access files, instead use `File.open()` or `IO.open()` that will not execute commands. Using `open()` method seems like a Rails anti-pattern so this shouldn't be an issue.
#### 6.8 Header Injection
1. This applies to adding user input to the `<head></head>` tags in erb files, using the `content_for :head` method in erb files, and adding user input to a response with `head :some_header` in controllers. The template doesn't use any of those features, but this may come up in the future.
#### 6.8.1 DNS Rebinding and Host Header Attacks
1. **TODO:** Configure [`ActionDispatch::HostAuthorization`](https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization) in production to prevent DNS rebinding attacks.
#### 6.8.2 Response Splitting
1. This template uses rails version > 2.1.2, therefore this is not a concern.

### 7 Unsafe Query Generation
1. Unless you know what you're doing, don't disable `deep_munge` with `config.action_dispatch.perform_deep_munge = false`

### 8 HTTP Security Headers
#### 8.1 Default Security Headers
1. Rails locks down the headers by default, and we have no need to open these up. However, the defaults can be overridden in `config/application.rb` with `config.action_dispatch.default_headers`.
1. X-Frame-Options is set to allow iframes from the same origin, set this to deny if not using any iframes to embed. If you need to permit an iframe from another origin, a controller can then use an `after_action :allow_some_service`.
#### 8.2 Strict-Transport-Security Header
1. This is set in production with `config.force_ssl = true`
#### 8.3 Content-Security-Policy Header
1. **TODO:** To help protect against XSS and injection attacks, define a Content-Security-Policy in the provided file: `app-rails/config/initializers/content_security_policy.rb`. The policy can be more restrictive, and controllers can override defaults when necessary.
#### 8.3.1 Reporting Violations
1. **TODO:** In addition to preventing attacks, it's important to log them to continuously improve security. Set the report_uri config on the content security policy and configure a controller to log the reports. Note that `report_uri` is being deprecated, and will eventually become `report_to`
#### 8.3.2 Adding a Nonce
1. **TODO:** We're already adding the `csp_meta_tag` to the application.html.erb, but we're not taking advantage of it with nonce generation in the content security policy.
#### 8.4 Feature-Policy Header
1. **TODO:** Configure which browser features are allowed in `app-rails/config/initializers/permissions_policy.rb`. This policy can be more restrictive than necessary because features can be allowed on specific controllers.
#### 8.5 Cross-Origin Resource Sharing
1. As of now, this application envisioned as a full-stack application template. However, if there is a need to open up endpoints as APIs, we need to configure CORS, by installing and configuring the `rack-cors` gem.

### 9 Intranet and Admin Security

