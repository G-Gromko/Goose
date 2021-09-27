defmodule GooseWeb.HomeController do
  use GooseWeb, :controller

  def index(conn, _params) do
    render(conn, "home.html")
  end

end
