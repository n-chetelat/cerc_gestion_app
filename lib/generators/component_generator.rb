class ComponentGenerator < Rails::Generators::Base
  argument :component_name, required: true, desc: "Component name, e.g: message"

  def create_vue_file
    create_file "#{component_path}/#{component_name}.vue" do
      <<-FILE
      <template>
        div.#{component_name}
      </template>

      <script>
      export default {
        name: #{component_name.underscore.camelize}
      }
      </script>

      <style scoped>
      </style>
      FILE
    end
  end

  protected

    def component_path
      "frontend/components"
    end

end
