# Application Security

Application security is a top priority for technology application development, which is why the Rails framework's security helper methods and countermeasures help speed up secure application delivery. However, the framework isn't useful by itself; its helper methods and configurations only work if they are used properly. 

Each item below will be checked if it is already implemented by default, or unchecked if it is not implemented by default. This is meant to be a living document and should be updated as additional security tools and configurations are implemented, as well as when new vulnerabilities are discovered or introduced.

This document uses the Rails Guide to [Securing Rails Applications](https://guides.rubyonrails.org/security.html) to audit this project's Rails security best practices.

## Sessions
This template application uses Devise to manage sessions and cookies. You can manage the Devise configuration in the [`devise.rb`](app-rails/config/initializers/devise.rb) file, and for more detailed information you can read the [Devise documentation](https://rubydoc.info/github/heartcombo/devise).
- [x] SSL (`config.force_ssl = true`) is enforced in production environments.
- [x] Provide the user with a prominent logout button to make it easy to clear the session on public computers.
- [x] Cookies stored client side do not contain sensitive information.
- [x] Cookies time out in 15 minutes of inactivity 
    - Note: That is set with `config.timeout_in` in the [Devise configuration file](app-rails/config/initializers/devise.rb).
- [x] Cookies are encrypted client side.
    - Note: Devise uses BCrypt and the secret_key_base by default for secret hashing.
- [ ] Expire sessions after a set amount of time, regardless of activity, 
    - Note: Automated session expiration can be easily set by the auth service, such as in AWS Cognito.
- [ ] Use a nonce generator to protect against cookie replay attacks. 
    - Note: The commented out code for this is located in [`/app-rails/config/initializers/content_security_policy.rb`](/app-rails/config/initializers/content_security_policy.rb) Review the impact this may have on your application if you have several application servers.
- [x] Automatically expire sessions on sign in and sign out.
    - Note. This is set in the [Devise configuration file](app-rails/config/initializers/devise.rb) with `config.expire_all_remember_me_on_sign_out = true`.

## Cross-Site Request Forgery (CSRF)
- [x] GET, POST, DELETE, and rails’ resources are used appropriately in the `routes.rb` file.
- [x] Pass a CSRF token to the client.
    - Note: This is accomplished with `<%= csrf_meta_tags %>` in [application.html.erb](app-rails/app/views/layouts/application.html.erb)
- [ ] Set forgery protection in production  

## Redirection and Files
The template application doesn't have any file upload or download functionality at this time, so please review these items when adding file management functionality.
- [x] Do not use user inputs to generate routes (ie. creating a route with the username), which is vulnerable to XSS attacks.
    - [x] `link_to` methods do not interpolate to user inputs.
    - [x] `redirect_to` methods do not interpolate to user inputs.
- [ ] Check filename for file imports against a set of permitted characters.
    - Note: filtering filename imports alone can still leave an application vulnerable to XSS attacks.
- [ ] Do not allow file uploads to place files in the public directory as code in those files may be executed by the browser.
- [ ] Prevent users from downloading files to which they shouldn't have access.
    - [ ] Check filename for download against a set of permitted characters.
    - [ ] Check the file returned from the search is from the appropriate directory.

## User Management
- [x] Store only cryptographically hashed passwords, not plain-text passwords.
- [x] Consider Rails' built-in `has_secure_password` method which supports secure password hashing, confirmation, and recovery mechanisms.
    - Note: When using Devise there's no need to use `has_secure_password`.
- [x] Username error is generic and does not indicate whether it was an error with the username or password.
- [x] Forgot password confirms the email was sent, and not whether the username exists.
- [x] Use a secondary verification when users change their password
    - Note: Change password requires 6 digit code from email sent to user's email address.
- [ ] Require user's password when changing email.
- [ ] Include honeypot fields and logic on Non logged in forms to catch bots that spam all fields (good resource: https://nedbatchelder.com/text/stopbots.html).
- [ ] Consider using Captcha on account creation, login, change password, and change email forms.
    - Note: Captchas are often not accessible to screen readers and their use should be part of a UX discussion.
- [x] Filter log entries so they do not include passwords or secrets
    - Note:  Log filtering is set in  [filter_parameter_logging.rb](app-rails/config/initializers/filter_parameter_logging.rb): `:passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn`.
- [x] Use the correct Ruby REGEX: `\A` and `\z` and not the more common: `/^` and `$/`.
- [ ] Add multiline: true to our regex format: in validations.
- [x] When searching for data belonging to the user, search using Active Record from the user and not from the target data object. ie. Instead of doing: `@task = Task.find(params[:id])`, instead do: `@user.tasks.find(params[:id])`. 

## Injection
- [ ] Use `except: […]` instead of `only:[…]` for security related actions so when adding actions, they are behind the security by default. Ex. `app-rails/app/controllers/application_controller.rb line: 8`. `after_action :verify_policy_scoped, only: :index`.
- [x] Not generally an issue with rails applications. We aren’t interpolating params into SQL fragments, which would also be against ruby and rails best practices, ie. .where(“name = `#{params[:name]}`”.
- [x] While we’re not setting secure: true on the cookies themselves, the `config.force_ssl = true` option in production ensures all cookies are `httponly`.
- [x] The template application doesn't have any inputs that are then displayed to the user, aside from the user email, which prevents scripting. However, when those inputs are created, it will be important to sanitize the outputs in the erb files, using `<%=h <some user provided input> =>` to protect against defacement.
- [x] An additional step can be taken to sanitize inputs, but those should use a permitted list of tags, instead of restricted lists, using:
```
tags = %w(a acronym b strong i em li ul ol h1 h2 h3 h4 h5 h6 blockquote br cite sub sup ins p)
s = sanitize(user_input, tags: tags, attributes: %w(href title))
```
- [x] While consensus seems mixed about the necessity to sanitize Rails input fields for defacement, sanitizing inputs is very useful to protect against encoding injection, and the Rails sanitize() method should be used on inputs that will be presented to the UI at any point.
- [x] This is rarely needed as applications, especially government applications, rarely if ever offer the user the ability to input custom colors or input css filters.
- [x] This template application doesn't allow users to enter text to be converted into html, that's more common in content management system applications. If that feature set is added, it is important to do so with a permitted input filter similar to 6.3.2.3 Defacement Countermeasures. The most common Rails tool for text to html conversion is RedCloth, which is being mentioned in case folks search the repo for RedCloth, they should find this recommendation.
- [x] The output has to be escaped in the controller already, if the action doesn't render a view. However, we have no case of outputting strings rather than views in our template application. However, rendering data from the controller seems like a Rails anti-pattern.
- [x] Only relevant if the application takes a user input and executes a command on the underlying operating system. Applicable methods include: 
    * `system()`
    * `exec()`
    * `spawn()`
    * `command`
- [x] Don't use the `open()` method to access files, instead use `File.open()` or `IO.open()` that will not execute commands. Using `open()` method seems like a Rails anti-pattern so this shouldn't be an issue.
- [x] This applies to adding user input to the `<head></head>` tags in erb files, using the `content_for :head` method in erb files, and adding user input to a response with `head :some_header` in controllers. The template doesn't use any of those features, but this may come up in the future.
- [ ] Configure [`ActionDispatch::HostAuthorization`](https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization) in production to prevent DNS rebinding attacks.
- [x] This template uses rails version > 2.- [x]2, therefore this is not a concern.

## Unsafe Query Generation
- [x] Confirm `deep_munge` hasn't been disabled. 
    - Note: `config.action_dispatch.perform_deep_munge` is `true` by default.

## HTTP Security Headers
Default security headers can be overridden in [application.rb](app-rails/config/application.rb) with `config.action_dispatch.default_headers`.
- [x] Lock down X-Frame-Options to be as restrictive as possible.
    - Note: By default this is set to allow iframes from the same origin.
    - Note: Set this to deny if not using any iframes to embed. 
    - Note: If you need to permit an iframe from another origin, a controller can then use an `after_action :allow_some_service`.
- [ ] To help protect against XSS and injection attacks, define a Content-Security-Policy in the provided [content security policy file](app-rails/config/initializers/content_security_policy.rb). 
    - Note: Set the policy to be more restrictive than you need and you can override defaults when necessary in the controllers.
- [ ] Log content security policy violations to continuously improve security by setting the report_uri config on the content security policy and configure a controller to log the reports. 
    - Note: `report_uri` is being deprecated, and will eventually become `report_to`.
- [x] Set `csp_meta_tag` in [application.rb](app-rails/config/application.rb).
- [ ] Use the `csp_meta_tag` tag with nonce generation in the content security policy.
- [ ] Configure which browser features are allowed in [permissions_policy.rb](app-rails/config/initializers/permissions_policy.rb). 
    - Note: This policy can be more restrictive than necessary because features can be allowed on specific controllers.
- [ ] If opening up endpoints as APIs, configure CORS, by installing and configuring the `rack-cors` gem.

## Intranet and Admin Security
- [x] The template doesn't include a admin view, but if that is added, be sure to sanitize all user inputs as they may be viewed here even if they aren't visible anywhere else in the application.
- [x] Same as CSRF countermeasures discussed above.
- [x] Some effective admin protection strategies includes:
    * Limit admin role privileges using the principle of least privilege
    * Geofence admin login IP to the USA.
    * Consider putting the admin app at a subdomain so the cookie for application can't be used for the admin console and vice-versa.

## Environmental Security
- [x] Secret management is covered in the template infrastructure repo and is out of scope of this template application.

## Dependency Management and CVEs'
- [x] We're using dependabot to notify us if we have outdated gems.

## Additional Reading
* [Securing Rails Applications](https://guides.rubyonrails.org/security.html)
