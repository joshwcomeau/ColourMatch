module ApplicationHelper
  def current_path
    request.env["PATH_INFO"].split("/").last
  end
end
