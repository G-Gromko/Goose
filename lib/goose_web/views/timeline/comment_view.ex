defmodule GooseWeb.Timeline.CommentView do
  use GooseWeb, :view

  alias Goose.Timeline

  def author_name(%Timeline.Comment{author: author}) do
    author.user.name
  end

end
