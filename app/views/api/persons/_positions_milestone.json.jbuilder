json.extract! person_milestone, :id, :positions_milestone_id, :time_interval_ordinality
json.date person_milestone.date.try(:to_date).try(:to_s)
json.person_id person_milestone.person.uuid
