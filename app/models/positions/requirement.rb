module Positions
  class Requirement < ApplicationRecord
    include ::FormEnumerable

    self.table_name = "positions_requirements"

    translates :label
    active_admin_translates :label

  end
end
