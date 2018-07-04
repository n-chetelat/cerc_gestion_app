ActiveAdmin.register Positions::Milestone do
  menu false

  config.sort_order = 'time_interval_ordinality_asc'
  config.paginate = false

  orderable

end
