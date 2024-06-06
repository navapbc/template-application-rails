# Application Security

Application security is a top priority for government technology application development, which is why the Rails framework's security helper methods and countermeasures help speed up secure application delivery. However, the framework isn't useful by itself; its helper methods and configurations only work if they are used properly. This document uses the Rails Guide to [Securing Rails Applications](https://guides.rubyonrails.org/security.html) to audit the template's use of Rails security best practices. This is meant to be a living document and should be updated as additional security tools and configurations are implemented, as well as when new vulnerabilities are discovered or introduced.

Areas for improvement are marked with `TODO` that describe a security implementation. They should be accompanied by a comment in the codebase referencing the action needed, like `# TODO: sanitize input to protect against SQL injection`.

## Conforms to best practices
As outlined in [Securing Rails Applications](https://guides.rubyonrails.org/security.html)

### 1 Introduction

### 2 Sessions
#### 2.1 What are sessions
### 2.2 Session hijacking: 
1. `config.force_ssl = true` is set for production environments 
1. Provided the user with a logout button
#### 2.3 Session storage
1. Using Devise's Session Controller to manage session storage
1. Cookies stored client side do not contain sensitive information
1. Cookies time out in 15 minutes of inactivity with devise config.timeout_in
1. Cookies are encrypted client side
1. Devise uses BCrypt and the secret_key_base by default for secret hashing 
1. TODO: Cognito, the auth service, is also managing sessions and if wanted to expire sessions after a certain time, regardless of activity, we’d have to do it there
#### 2.4 Rotating Encrypted and Signed Cookies Configurations
1. TODO: We are not rotating secrets for hashing nor the hashing algorithm, could do with cognito
#### 2.5 Replay Attacks for CookieStore Sessions
1. TODO: We’re not using a nonce generator that would protect against cookie replay attacks. The commented out code for this is located in `/app-rails/config/initializers/generate_security_policy.rb` This however ties users to a particular server/session as we don’t want to save nonces in the database.
#### 2.6 Session Fixation
#### 2.7 Session Fixation - Countermeasures
1. Devise will automatically expire sessions on sign in and sign out with config.expire_all_remember_me_on_sign_out = true
#### 2.8 Session Expiry

### 3 Cross-Site Request Forgery (CSRF)
#### 3.1  CSRF Countermeasures
1. get, post, delete, and rails’ resources are used appropriately in the routes.rb file
1. TODO: We’re not setting forgery protection on in production however https://guides.rubyonrails.org/v7.1/security.html#:~:text=3.1.2%20Required%20Security%20Token  
1. TODO: If I change my csrf token manually in my browser, I’m not prevented from taking any actions (get or post requests) as a signed in user 

### 4 Redirection and Files
#### 4.1 Redirection
1. link_tos do not route to user inputs, which is XSS vulnerable
1. redirect_to does not use params or user inputs in the routes
4.2 File Uploads
1. TODO: App doesn’t currently handle file imports but that should be documented as it is a common need in Government Applications

### 5. User Management
1. When using devise we don’t need to set has_secure_password on password fields
#### 5.1 brute forcing accounts
1. Username error is generic and does not indicate whether it was an error with the username or password
1. Forgot password confirms the email was sent, and not whether the username exists
#### 5.2 Account Hijacking
1. Change password includes email 6 digit code
1. TODO: Require entering the password when changing email
#### 5.3 CAPTCHA
1. TODO: Include Captcha on account creation, login, change password, and change email
1. TODO: Include honeypot fields and logic on Non logged in forms to catch bots that spam all fields (good resource: https://nedbatchelder.com/text/stopbots.html
#### 5.4 Logging
1. We’re filtering the following parameter partials (if all or any part matches) in the config/initialization/filter_paramater_logging.rb file: :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssn
#### 5.5 Regex
1. Two places where regex is used (mailto.rb and devise) use the correct ruby \A and \z and not the more common: /^ and $/
1. TODO: Add multiline: true to our regex format: in validations
5.6 Privilege Escalation
1. TODO: By manually changing a parameter, a hacker may get access to information they should not be able to access. Instead of doing things like: @task = Task.find(params[:id]), instead do @user.tasks.find(params[:id]). This is not in the template, but it is in the app the template is based on.


### 6 Injection
#### 6.1 Permitted Lists Versus Restricted Lists
1. TODO: Use except: […] instead of only:[…] for security related actions so when adding actions, they are behind the security by default. Ex. app-rails/app/controllers/application_controller.rb line: 8. after_action :verify_policy_scoped, only: :index
#### 6.2 SQL Injection
1. Not generally an issue with rails applications. We aren’t interpolating params into SQL fragments, which would also be against ruby and rails best practices, ie. .where(“name = `#{params[:name]}`”
#### 6.3.2.1 Cookie Theft
1. While we’re not setting secure: true on the cookies themselves, the config.force_ssl = true option in production ensures all cookies are httponly
