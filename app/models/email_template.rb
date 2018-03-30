class EmailTemplate < ApplicationRecord

  translates :subject, :body
  active_admin_translates :subject, :body do
    validates_presence_of :subject
    validates_presence_of :body
  end

  globalize_accessors :locales => [:en, :fr], :attributes => [:subject, :body]

  TEMPLATE_VARIABLES = [
    "name", "last_name", "full_name", "email",
    "position", "starting_semester_label"
  ]

  def to_s
    self.subject
  end

  def compile_with_vars(recipient)
    compiled_attrs = {}
    ["subject", "body"].each do |attr|
      compiled = self.send(attr)
      if (matches = /(\{\{.+\}\})/.match(self.send(attr)))
        matches.captures.uniq.each do |match|
          method = match.gsub(/[\{|\}]/, "").strip
          compiled.gsub!(match, recipient.send(method).try(:to_s))
        end
      end
      compiled_attrs[attr.to_sym] = compiled
    end
    compiled_attrs[:plain] = Nokogiri::HTML.parse(compiled_attrs[:body]).text
    OpenStruct.new(compiled_attrs)
  end

end
