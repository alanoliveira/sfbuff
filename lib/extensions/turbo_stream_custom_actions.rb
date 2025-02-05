ActiveSupport.on_load :turbo_streams_tag_builder do
  def toast(content = nil)
    append "toasts" do
      content || yield
    end
  end
end
