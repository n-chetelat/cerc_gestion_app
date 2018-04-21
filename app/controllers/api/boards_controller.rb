module Api
  class BoardsController < ApiController
    before_action :set_resource, only: [:show]

    def show
    end

    def partial_path
      "api/boards/board"
    end

    def resource_name
      :board
    end

    private

      def set_resource
        @resource = Board.find_by(slug: params[:id])
      end

  end
end
