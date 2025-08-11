class BucklerCredential
  module ExpirableAttribute
    def expirable_attribute(attr_name)
      attr_name = attr_name.to_s

      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def expire_#{attr_name}!
          if update_#{attr_name}!(nil)
            refresh_#{attr_name}_later
          end
        end

        def set_#{attr_name}!(value)
          raise ArgumentError if value.blank?

          update_#{attr_name}!(value)
        end

        def refresh_#{attr_name}_later
          Refresh#{attr_name.camelize}Job.perform_later(self)
        end

        def refresh_#{attr_name}_now
          Refresh#{attr_name.camelize}Job.perform_now(self)
        end

        def update_#{attr_name}!(new_value)
          current_value = #{attr_name}
          transaction do
            lock!
            next false if #{attr_name} != current_value || #{attr_name} == new_value
            update!(#{attr_name}: new_value)
          end
        end

        private :update_#{attr_name}!
      RUBY
    end
  end
end
