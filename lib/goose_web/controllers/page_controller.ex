defmodule GooseWeb.PageController do
  use GooseWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/home")
  end
end
