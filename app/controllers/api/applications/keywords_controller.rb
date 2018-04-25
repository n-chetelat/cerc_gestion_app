module Api
  module Applications
    class KeywordsController < ApiController
      before_action :authenticate_admin_user!
      before_action :set_application, except: [:autocomplete]

      def autocomplete
        filter = "%#{params[:q].parameterize(separator: '%')}%"
        results = ActsAsTaggableOn::Tag.where("name ILIKE ?", filter)
          .limit(10).pluck(:name)
        results.map! {|res| {id: res, name: res} }
        render json: results
      end

      def show
        render json: @application.keyword_list
      end

      def update
        @application.keyword_list.add(params[:keywords])
        if @application.save!
          render json: @application.keyword_list
        else
          render json: {
            error: "There was an error when saving the keyword", status: 500
            }, status: 500
        end
      end

      def destroy
        @application.keyword_list.remove(params[:keywords])
        if @application.save!
          render json: @application.keyword_list
        else
          render json: {
            error: "There was an error when deleting the keyword", status: 500
            }, status: 500
        end
      end

      private

        def set_application
          @application ||= Application.find(params[:application_id])
        end

    end
  end
end
