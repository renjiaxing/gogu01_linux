module ApplicationHelper
  def link_back
    link_to "返回", request.env["HTTP_REFERER"].blank? ? "/" : request.env["HTTP_REFERER"],
            class: "btn btn-primary white-color"
  end

end
