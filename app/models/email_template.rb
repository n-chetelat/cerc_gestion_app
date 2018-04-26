class EmailTemplate < ApplicationRecord

  translates :subject, :body
  active_admin_translates :subject, :body do
    validates_presence_of :subject
    validates_presence_of :body
  end

  globalize_accessors :locales => [:en, :fr], :attributes => [:subject, :body]

  has_many :callbacks_email_templates, class_name: "Phases::CallbackEmailTemplate", foreign_key: "email_template_id", inverse_of: :email_template
  has_many :phases_callbacks, through: :callbacks_email_templates

  TEMPLATE_VARIABLES = [
    "name", "lastname", "full_name", "email",
    "position", "starting_date_label"
  ]

  def to_s
    self.subject
  end

  def compile_with_vars(recipient)
    compiled_attrs = {}
    recipient_locale = recipient.application.try(:locale) || I18n.locale
    ["subject", "body"].each do |attr|
      attr_with_locale = "#{attr}_#{recipient_locale}"
      compiled = self.send(attr_with_locale)
      if (matches = self.send(attr_with_locale).scan(/(\{\{\w+\}\})/))
        matches.flatten.uniq.each do |match|
          method = match.gsub(/[\{|\}]/, "").strip
          replacement = recipient.respond_to?(method) ? recipient.send(method).try(:to_s) : ""
          compiled.gsub!(match, replacement)
        end
      end
      compiled_attrs[attr.to_sym] = compiled
    end
    compiled_attrs[:plain] = Nokogiri::HTML.parse(compiled_attrs[:body]).text
    OpenStruct.new(compiled_attrs)
  end

end
