module ApplicationHelper

  def epoch_to_timesamp(epoch)
    if epoch
      Time.at(epoch).to_datetime
    end
  end

  def render_template(path, locals = {})
    render(path, locals)
  end

end
