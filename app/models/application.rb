class Application < ApplicationRecord
  include StartingDates
  include Taggable

  before_save :clean_up_unused_fields, unless: :new_record?

  store_accessor :fields

  belongs_to :person, foreign_key: "person_id"
  belongs_to :position, foreign_key: "position_id"

  has_many :comments, class_name: "Applications::Comment", foreign_key: "application_id", dependent: :destroy

  delegate :time_interval, to: :position

  validates :starting_date, presence: true

  def attachments
    @attachments ||= begin

      uploads = self.fields.select {|k, v| /input_upload/.match(k) }
      uploads.values.flatten.map do |upload|
        if uri = upload["uri"]
          GlobalID::Locator.locate(uri)
        end
      end.compact

    end
  end

  def starting_date_to_s
    case self.time_interval
    when :semester
      self.class.semester_to_s(self.starting_date)
    when :month
      self.class.month_to_s(self.starting_date)
    else
      ""
    end
  end


  def fields_for_current_position
    self.fields.select do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      self.position.recruitment_form.form_fields.exists?(id: form_field_id)
    end
  end

  def clean_up_unused_fields
    self.fields.each do |key, value|
      form_field_type, form_field_id = /input_(\w+)_(\d+)/.match(key).captures
      unless self.position.recruitment_form.form_fields.exists?(id: form_field_id)
        self.fields.delete(key)
      end
    end
  end

end
