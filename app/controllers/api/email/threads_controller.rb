module Api
  module Email
    class ThreadsController < ApiController
      before_action :authenticate_admin_user!
      before_action :authorize_gmail
      before_action :set_resource, only: [:update]

      def create
        mail = format_message
        response = ::EmailService.new(request).send_email_to(mail, {})
        head :ok
      end

      def update
        mail = format_message
        mail_options = {
          thread_id: @resource.google_thread_id
        }
        response = ::EmailService.new(request).send_email_to(mail, mail_options)
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

    end
  end
end
