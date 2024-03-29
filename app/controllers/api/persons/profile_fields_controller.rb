module Api
  module Persons
    class ProfileFieldsController < ApiController
      before_action :authenticate_admin_user!
      attr_reader :partial_path, :resource_name

      def initialize
        @partial_path = "api/profiles/profile"
        @resource_name = :person
      end

      def show
      end

      def create
        @resource = Person.find_by(uuid: params[:person_id])
        field = @resource.persons_profile_fields.build(
          profile_field_id: params[:profile_field_id], data: params[:data]
        )
        if field.save
          render :show
        else
          raise "Profile information cannot be created"
        end
      end

      def update
        field = PersonProfileField.find_by(id: params[:id])
        field.data = params[:data]
        if field.save
          @resource = field.person
          render :show
        else
          raise "Profile information cannot be updated"
        end
      end

    end
  end
end
