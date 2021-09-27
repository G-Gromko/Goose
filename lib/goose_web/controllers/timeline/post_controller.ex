defmodule GooseWeb.Timeline.PostController do
  use GooseWeb, :controller

  alias Goose.Timeline
  alias Goose.Timeline.Post

  plug :require_existing_author
  plug :authorize_post when action in [:edit, :update, :delete]

  def index(conn, _params) do
    posts = Timeline.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Timeline.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Timeline.create_post(conn.assigns.current_author, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.timeline_post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def show(conn, %{"id" => id}) do
    post =
      id
      |> Timeline.get_post!()
      |> Timeline.inc_post_views()

    render(conn, "show.html", post: post)
  end

  def edit(conn, _) do
    changeset = Timeline.change_post(conn.assigns.post)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"post" => post_params}) do

    case Timeline.update_post(conn.assigns.post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.timeline_post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _post} = Timeline.delete_post(conn.assigns.post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.timeline_post_path(conn, :index))
  end

  defp require_existing_author(conn, _) do
    author = Timeline.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  defp authorize_post(conn, _) do
    post = Timeline.get_post!(conn.params["id"])

    if conn.assigns.current_author.id == post.author_id do
      assign(conn, :post, post)
    else
      conn
      |> put_flash(:error, "You can't modify other people posts")
      |> redirect(to: Routes.timeline_post_path(conn, :index))
      |> halt()
    end
  end



end
