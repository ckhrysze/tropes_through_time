defmodule TttWeb.PageController do
  use TttWeb, :controller

  def rules(conn, _params) do
    render(conn, "rules.html")
  end
end
