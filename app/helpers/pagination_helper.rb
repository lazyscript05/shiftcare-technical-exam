module PaginationHelper
  def custom_pagy_bootstrap_nav(pagy)
    pagy_bootstrap_nav(pagy).gsub("&gt;", content_tag(:span, "Next")).gsub("&lt;", content_tag(:span, "Prev"))
  end
end
