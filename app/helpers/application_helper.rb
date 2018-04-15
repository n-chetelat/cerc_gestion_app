module ApplicationHelper

  def epoch_to_timesamp(epoch)
    if epoch
      Time.at(epoch).to_datetime
    end
  end
end
