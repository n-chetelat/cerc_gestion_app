module Api
  module Applications
    class CommentsController < ApiController
      before_action :authenticate_admin_user!
      before_action :set_application
      before_action :set_resource, only: [:show, :update, :destroy]

      after_action :broadcast_changes, only: [:create, :update, :destroy]

      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/applications/comments/comment"
        @resource_name = :comment
      end

      def index
        @resources = @application.comments.order(:created_at)
      end

      def show
      end

      def create
        @resource = @application.comments.build(content: params[:content],
          author: current_admin_user)
        if @resource.save!
          render :show
        end
      end

      def update
        if @resource.update(content: params[:content])
          render :show
        end
      end

      def destroy
        @resource.destroy!
        render :show
      end

      private

        def set_application
          @application ||= Application.find(params[:application_id])
          @current_admin_user_id ||= current_admin_user.id
        end

        def set_resource
          @resource ||= @application.comments.find(params[:id])
        end

        def broadcast_changes
          BoardChannelService.send_comments_update(@application)
        end

    end
  end
end
