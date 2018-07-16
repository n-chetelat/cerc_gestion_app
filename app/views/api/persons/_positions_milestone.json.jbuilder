json.extract! person_milestone, :id, :positions_milestone_id, :time_interval_ordinality

date = person_milestone.date.try(:to_date).try(:to_s)
json.date date
json.semester month_date_to_semester_date(date)
json.person_id person_milestone.person.uuid
