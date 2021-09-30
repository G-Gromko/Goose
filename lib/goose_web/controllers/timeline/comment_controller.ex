defmodule GooseWeb.Timeline.CommentController do
  use GooseWeb, :controller

  alias Goose.Timeline
  alias Goose.Timeline.Comment


  plug :require_existing_author
  plug :authorize_comment when action in [:edit, :update, :delete]


  def index(conn, %{"post_id" => post_id}) do
    comments = Timeline.get_comments_by_post_id(post_id)
    render(conn, "index.html", comments: comments, post_id: post_id)
  end

  def new(conn, %{"post_id" => post_id}) do
    changeset = Timeline.change_comment(%Comment{})
    render(conn, "new.html", changeset: changeset, post_id: post_id)
  end

  def create(conn, %{"post_id" => post_id, "comment" => comment_params}) do
    case Timeline.create_comment(conn.assigns.current_author, String.to_integer(post_id), comment_params) do
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully.")
        |> redirect(to: Routes.timeline_post_comment_path(conn, :index, post_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, post_id: post_id)
    end
  end

  def show(conn, %{"id" => id, "post_id" => post_id}) do
    comment = Timeline.get_comment!(id)
    render(conn, "show.html", comment: comment, post_id: post_id)
  end

  def edit(conn, %{"post_id" => post_id}) do
    changeset = Timeline.change_comment(conn.assigns.comment)
    render(conn, "edit.html", changeset: changeset, post_id: post_id)
  end

  def update(conn, %{"post_id" => post_id, "comment" => comment_params}) do

    case Timeline.update_comment(conn.assigns.comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: Routes.timeline_post_comment_path(conn, :show, post_id, comment.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"post_id" => post_id}) do
    {:ok, _comment} = Timeline.delete_comment(conn.assigns.comment)

    conn
    |> put_flash(:info, "Comment deleted successfully.")
    |> redirect(to: Routes.timeline_post_comment_path(conn, :index, post_id))
  end

  defp require_existing_author(conn, _) do
    author = Timeline.ensure_author_exists(conn.assigns.current_user)
    assign(conn, :current_author, author)
  end

  defp authorize_comment(conn, _) do
    comment = Timeline.get_comment!(conn.params["id"])
    post = Timeline.get_comment!(conn.params["post_id"])

    if conn.assigns.current_author.id == comment.author_id do
      assign(conn, :comment, comment)
    else
      conn
      |> put_flash(:error, "You can't modify other people stuff")
      |> redirect(to: Routes.timeline_post_comment_path(conn, :index, post))
      |> halt()
    end
  end



end
