defmodule GooseWeb.Timeline.PostView do
  use GooseWeb, :view

  alias Goose.Timeline

  def author_name(%Timeline.Post{author: author}) do
    author.user.name
  end

end
