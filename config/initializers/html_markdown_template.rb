module Handlers
  class HtmlMarkdownHandler
    def call(template, source)
      content = Commonmarker.to_html(source, options: { render: { unsafe: true, hardbreaks: false } }).gsub('"', '\"')
      %("#{content}")
    end
  end
end

ActionView::Template.register_template_handler "html.md", Handlers::HtmlMarkdownHandler.new
