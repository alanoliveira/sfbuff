module ApplicationHelper
  def search_form(**, &block)
    form_with url: nil, method: :get, role: "search", ** do |f|
      content_tag :div, class: "input-group" do
        concat (f.text_field :q, value: params[:q], placeholder: t("helpers.search_form.placeholder"),
          class: "form-control", type: "search", required: true, minlength: 4)

        yield f if block_given?
      end
    end
  end
end
