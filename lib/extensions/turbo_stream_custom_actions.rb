ActiveSupport.on_load :turbo_streams_tag_builder do
  def toast(...)
    append "toasts" do
      @view_context.toast(...)
    end
  end

  def alert(...)
    append "alerts" do
      @view_context.alert(...)
    end
  end
end
