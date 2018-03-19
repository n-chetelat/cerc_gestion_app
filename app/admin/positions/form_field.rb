ActiveAdmin.register Positions::FormField do
  menu false

  config.sort_order = 'position_asc'
  config.paginate = false

  orderable

end
