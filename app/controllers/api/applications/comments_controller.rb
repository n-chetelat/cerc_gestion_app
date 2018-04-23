module Api
  module Applications
    class CommentsController < ApiController
      before_action :authenticate_admin_user!
      before_action :set_application
      before_action :set_resource, only: [:show, :update, :destroy]

      def index
        @resources = @application.comments
      end

      def show
      end

      def create
        render :show
      end

      def update
        render :show
      end

      def destroy
        @resource.destroy!
        render :show
      end

      def partial_path
        "api/applications/comments/comment"
      end

      def resource_name
        :comment
      end

      private

        def set_application
          @application ||= Application.find(params[:application_id])
        end

        def set_resource
          @resource ||= @application.comments.find(params[:id])
        end

    end
  end
end
