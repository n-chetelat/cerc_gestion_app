ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #
    #   end
    # end

    # Here is an example of a simple dashboard with columns and panels.

    columns do
      column do
        panel "Links to Boards" do
          ul do
            Board.all.map do |board|
              li link_to(board.title, "/#/admin/boards/#{board.slug}", target: "_blank")
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Links" do
          ul do
            li link_to("Recruitment form", root_path, target: "_blank")
            li link_to("Grant Google authorization", "/admin/google/authorize")
            li link_to("App documentation", app_documentation_url, target: "_blank")
          end
        end
      end
    end

    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
