class Application < ApplicationRecord
  include Taggable

  before_save :clean_up_unused_fields, unless: :new_record?
  before_save :reassign_starting_date_on_position_change, if: Proc.new {|application| !application.new_record? && application.changes["position_id"] }

  store_accessor :fields

  belongs_to :person, foreign_key: "person_id"
  belongs_to :position, foreign_key: "position_id"

  has_many :comments, class_name: "Applications::Comment", foreign_key: "application_id", dependent: :destroy

  delegate :time_interval, to: :position

  validates :starting_date, presence: true
  validate :only_accepted_when_closed
  validate :starting_date_in_range, on: :create
  validate :match_dates_with_milestones

  def attachments
    @attachments ||= begin

      uploads = self.fields.select {|k, v| /input_upload/.match(k) }
      uploads.values.flatten.compact.map do |upload|
        if uri = upload["uri"]
          GlobalID::Locator.locate(uri) rescue nil
        end
      end.compact

    end
  end

  def attachment_ids
    upload_uris = self.fields.select {|k, v| /input_upload/.match(k) }
      .values.flatten.compact.map {|upload| upload["uri"] }.compact
    upload_uris.map {|uri| uri.scan(/(\d+$)/).flatten.first.try(:to_i) }
  end

  def starting_date_to_s
    self.date_to_s(self.starting_date)
  end

  def ending_date_to_s
    self.date_to_s(self.ending_date) if self.ending_date
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

  def reassign_starting_date_on_position_change
    return unless changes = self.changes["position_id"]
    old_position = Position.find_by(id: changes[0])
    if old_position.try(:time_interval) != self.time_interval
      self.starting_date = ::DatesService.generate_starting_dates(self.time_interval).first[:id]
    end
  end

  protected

    def date_to_s(date)
      return if date.nil?
      case self.time_interval
      when :semester
        ::DatesService.semester_to_s(date)
      when :month
        ::DatesService.month_to_s(date)
      else
        ""
      end
    end

    def only_accepted_when_closed
      if !self.closed_at && self.accepted
        errors.add(:accepted, "Application cannot be accepted if not closed.")
      end
    end

    def starting_date_in_range
      date_choices = ::DatesService.generate_starting_dates(self.time_interval).map {|d| d[:id].to_s }
      unless (date_choices.include?(self.starting_date.try(:to_s)))
        errors.add(:starting_date, "The date #{self.starting_date} is invalid for the interval type #{self.time_interval}")
      end
    end

    def match_dates_with_milestones
      persons_milestones = self.person.persons_positions_milestones
      return unless persons_milestones.any?
      unless persons_milestones.minimum(:date) >= self.starting_date
        errors.add(:starting_date, "Milestone dates cannot come before starting date")
      end

      return if self.ending_date.nil?
      unless persons_milestones.maximum(:date) <= self.ending_date
        errors.add(:ending_date, "Milestone dates cannot exceed ending date")
      end
    end

end
