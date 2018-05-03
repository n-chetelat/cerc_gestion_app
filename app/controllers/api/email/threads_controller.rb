module Api
  module Email
    class ThreadsController < ApiController
      before_action :authenticate_admin_user!
      before_action :authorize_gmail
      before_action :set_resource, only: [:update]
      after_action :broadcast_changes, only: [:create, :update]

      def create
        mail = format_message
        @resource = ::EmailService.new(request).send_email_to(mail, {})
        head :ok
      end

      def update
        mail = format_message
        mail_options = {
          thread_id: @resource.google_thread_id
        }
        email_service = EmailService.new(request)
        email_service.send_email_to(mail, mail_options)
        head :ok
      end

      private

        def set_resource
          @resource ||= ::Email::Thread.find(params[:id])
        end

        def format_message
          mail = Mail.new({
            to: params[:recipients],
            cc: params[:cc],
            bcc: params[:bcc],
            subject: params[:subject]
          })
          text_content = Nokogiri::HTML.fragment(params[:body]).text
          text_part = Mail::Part.new({
            body: text_content
          })
          html_part = Mail::Part.new({
            content_type: "text/html; charset=UTF-8",
            body: params[:body]
          })
          mail.text_part = text_part
          mail.html_part = html_part
          mail
        end

        def broadcast_changes
          person_ids = @resource.persons.pluck(:uuid)
          person_ids.each do |person|
            BoardChannel.send_emails_update(person)
          end
        end

    end
  end
end
