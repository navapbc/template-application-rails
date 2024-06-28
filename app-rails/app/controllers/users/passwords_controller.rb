# frozen_string_literal: true

class Users::PasswordsController < ApplicationController
  skip_after_action :verify_authorized

  def forgot
    @form = Users::ForgotPasswordForm.new
  end

  def send_reset_password_instructions
    email = params[:users_forgot_password_form][:email]
    hp_field = params[:users_forgot_password_form][:hp_field]
    @form = Users::ForgotPasswordForm.new(email: email, hp_field: hp_field)

    if @form.invalid?
      flash.now[:errors] = @form.errors.full_messages
      return render :forgot, status: :unprocessable_entity
    end

    begin
      auth_service.forgot_password(email)
    rescue Auth::Errors::BaseAuthError => e
      flash.now[:errors] = [ e.message ]
      return render :forgot, status: :unprocessable_entity
    end

    redirect_to users_reset_password_path
  end

  def reset
    @form = Users::ResetPasswordForm.new
  end

  def confirm_reset
    @form = Users::ResetPasswordForm.new(reset_password_params)

    if @form.invalid?
      flash.now[:errors] = @form.errors.full_messages
      return render :reset, status: :unprocessable_entity
    end

    begin
      auth_service.confirm_forgot_password(
        @form.email,
        @form.code,
        @form.password
      )
    rescue Auth::Errors::BaseAuthError => e
      flash.now[:errors] = [ e.message ]
      return render :reset, status: :unprocessable_entity
    end

    redirect_to new_user_session_path, notice: I18n.t("users.passwords.reset.success")
  end

  private

    def auth_service
      AuthService.new
    end

    def reset_password_params
      params.require(:users_reset_password_form).permit(:email, :code, :password, :hp_field)
    end
end
