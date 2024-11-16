module Buckler
  module Api
    module Parser
      class CallbackConfigParser
        def self.parse(body)
          new(body).parse
        end

        def initialize(body)
          @document = Nokogiri.HTML(body)
        end

        def parse
          {
            action:,
            wa:,
            wresult:,
            wctx:
          }
        end

        private

        def action
          form.attr("action").value
        end

        def wa
          extract_attr("wa")
        end

        def wresult
          extract_attr("wresult")
        end

        def wctx
          extract_attr("wctx")
        end

        def extract_attr(name)
          form.xpath("//input[@name='#{name}']").attr("value").value
        end

        def form
          @document.xpath("//form")
        end
      end
    end
  end
end
