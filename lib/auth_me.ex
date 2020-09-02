defmodule AuthMe do
  import Plug.Conn
  @moduledoc """
  AuthMe keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  #plug
  def current_user(conn, _opts) do
    assign(conn, :current_user, current_user(conn))
  end
end
