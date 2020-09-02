defmodule AuthMe.UserManager.ErrorHandler do
  import Plug.Conn
  use AuthMeWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    message = to_string(type)
    conn
    |> put_flash(:info, message)
    |> redirect(to: "/auth/login")  
    #body = to_string(type)
    #conn
    #|> put_resp_content_type("text/plain")
    #|> send_resp(401, body)
  end

  #@impl Guardian.Plug.ErrorHandler
  #def auth_error(conn, {type, _reason}, _opts) do
  #  body = to_string(type)
  #  conn
  #  |> put_resp_content_type("text/plain")
  #  |> send_resp(401, body)
  #end
end
