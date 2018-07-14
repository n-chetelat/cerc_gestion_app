module Api
  class BoardsController < ApiController
    before_action :authenticate_admin_user!
    before_action :set_resource, only: [:show]

    attr_reader :partial_path, :resource_name

    def initialize
      @partial_path = "api/boards/board"
      @resource_name = :board
    end

    def index
      boards = Board.pluck(:slug, :title).map do |board|
        {slug: board[0], title: board[1]}
      end
      render json: boards
    end

    def show
    end

    private

      def set_resource
        @resource = Board.find_by(slug: params[:id])
      end

  end
end
