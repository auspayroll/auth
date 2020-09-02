defmodule AuthMe.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :password, :string
    field :username, :string
    field :confirm_password, :string, virtual: true
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :confirm_password])
    |> validate_required([:username, :password, :confirm_password])
    |> password_match()
    |> put_password_hash()
    |> unique_constraint(:username)
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  defp password_match(%Ecto.Changeset{valid?: true, changes: %{password: password, confirm_password: confirm_password }} = changeset) do
    if password != confirm_password do
      add_error(changeset, :password, "Password does not match")
    else
      changeset
    end
  end

  defp password_match(changeset), do: changeset


 
end
