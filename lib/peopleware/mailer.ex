defmodule Peopleware.Mailer do
  require Logger

  @moduledoc """
  Responsible for sending mails.
  Configuration options:
      config :peopleware,
        email_sender: "myapp@example.com",
        mailgun_domain: "example.com",
        mailgun_key: "secret"
  """
  use Mailgun.Client,
    domain: Application.get_env(:peopleware, :mailgun_domain),
    key: Application.get_env(:peopleware, :mailgun_key),
    mode: Application.get_env(:peopleware, :mailgun_mode),
    test_file_path: Application.get_env(:peopleware, :mailgun_test_file_path)


  @doc """
  Sends a welcome mail to the user.
  Subject and body can be configured in :peopleware, :welcome_email_subject and :welcome_email_body.
  Both config fields have to be functions returning binaries. welcome_email_subject receives the user and
  welcome_email_body the user and confirmation token.
  """
  def send_welcome_email(user) do
    subject = Application.get_env(:peopleware, :welcome_email_subject) <> user.name
    url = Application.get_env(:peopleware, :confirm_url) <> user.reset_token
    body = EEx.eval_file Application.get_env(:peopleware, :welcome_email_body) , [url: url]
    from = Application.get_env(:peopleware, :email_sender)

    {:ok, _} = send_email(to: user.email,
               from: from,
               subject: subject,
               html: body)

    Logger.info "Sent welcome email to #{user.email}"
  end

  @doc """
  Sends an email with instructions on how to reset the password to the user.
  Subject and body can be configured in :peopleware, :password_reset_email_subject and :password_reset_email_body.
  Both config fields have to be functions returning binaries. password_reset_email_subject receives the user and
  password_reset_email_body the user and reset token.
  """
  def send_password_reset_email(user) do
    subject = "Cambio de contraseña para " <> user.name
    url = Application.get_env(:peopleware, :reset_pass_url) <> user.reset_token
    body = EEx.eval_file Application.get_env(:peopleware, :change_pass_email_body) , [url: url]
    from = Application.get_env(:peopleware, :email_sender)

    {:ok, _} = send_email(to: user.email,
                from: from,
                subject: subject,
                html: body)

    Logger.info "Sent password_reset email to #{user.email}"
  end

  @doc """
  Sends an email with instructions on how to confirm a new email address to the user.
  Subject and body can be configured in :peopleware, :new_email_address_email_subject and :new_email_address_email_body.
  Both config fields have to be functions returning binaries. new_email_address_email_subject receives the user and
  new_email_address_email_body the user and confirmation token.
  """
  def send_new_email_address_email(user, confirmation_token) do
    subject = Application.get_env(:peopleware, :new_email_address_email_subject).(user)
    body = Application.get_env(:peopleware, :new_email_address_email_body).(user, confirmation_token)
    from = Application.get_env(:peopleware, :email_sender)

    {:ok, _} = send_email(to: user.unconfirmed_email,
                from: from,
                subject: subject,
                html: body)

    Logger.info "Sent new email address email to #{user.unconfirmed_email}"
  end

  @doc """
  Sends an email  to contacto@recluit.com with cv file, name, email, phone
  and search words
  """
  def send_register_email_to_recluit(profile_params, path) do

    if profile_params["second_surname"] == nil or profile_params["second_surname"] == "" do
      name = profile_params["name"] <> " " <> profile_params["last_name"]
    else
      name = profile_params["name"] <> " " <> profile_params["last_name"] <> " " <> profile_params["second_surname"]
    end
    email = profile_params["email"]
    cel = profile_params["cel"]
    tel = profile_params["tel"]
    keywords = profile_params["keywords"]

    subject = "Registro de nuevo usuario en RecluIT"
    to = Application.get_env(:peopleware, :to_recluit)
    from    = Application.get_env(:peopleware, :email_sender)
    body = EEx.eval_file Application.get_env(:peopleware, :recluit_email_body), [name: name, email: email, cel: cel, tel: tel, keywords: keywords]
    file_path = path

    if file_path == "" || file_path == nil do
      {:ok, _} = send_email(
                  to: to,
                  from: from,
                  subject: subject,
                  html: body)
    else
      {:ok, _} = send_email(
                  to: to,
                  from: from,
                  subject: subject,
                  html: body,
                  attachments: [%{path: file_path,
                  filename: "cv_" <> name}])
    end

  end

end
