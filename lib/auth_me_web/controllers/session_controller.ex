defmodule AuthMeWeb.SessionController do
  use AuthMeWeb, :controller
  require IEx

  alias AuthMe.{UserManager, UserManager.User, UserManager.Guardian}

  def new(conn, _) do
    changeset = UserManager.change_user(%User{})
    render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
  end

  def register(conn, _ ) do
    changeset = UserManager.change_user(%User{})
    render(conn, "register.html", changeset: changeset, action: Routes.session_path(conn, :register))
  end

  def register_post(conn, %{"user" => %{"username" => username, "password" => password } = user}) do
    case UserManager.create_user(user) do
      {:ok, _user } -> 
        UserManager.authenticate(username, password)
        |> login_reply(conn)

      {:error, changeset} ->
          render(conn, "register.html", changeset: changeset, action: Routes.session_path(conn, :register))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserManager.authenticate(username, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    start_page = Application.get_env(:auth_me, :start_page, "/protected")
    conn
    |> put_flash(:info, "Welcome back!")
    |> UserManager.sign_in(user)   #This module's full name is Auth.UserManager.Guardian.Plug,
    |> redirect(to: start_page)    #and the arguments specified in the Guardian.Plug.sign_in()
  end                                #docs are not applicable here.

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(conn)
  end

  def logout(conn, _) do
    login_page = Application.get_env(:auth_me, :login_page, "/login")
    conn
    |> UserManager.sign_out() #This module's full name is Auth.UserManager.Guardian.Plug,
    |> redirect(to: login_page)   #and the arguments specfied in the Guardian.Plug.sign_out()
  end     

end
