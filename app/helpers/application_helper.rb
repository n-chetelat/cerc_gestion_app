module ApplicationHelper

  def epoch_to_timesamp(epoch)
    if epoch
      Time.at(epoch).to_datetime
    end
  end

  def render_template(path, locals = {})
    render(path, locals)
  end

  def app_documentation_url
    dragonfly_store = Dragonfly.app.datastore
    storage = Google::Cloud::Storage.new(
      project_id: dragonfly_store.project,
      credentials: dragonfly_store.keyfile
    )

    bucket = storage.bucket(dragonfly_store.bucket_name)
    bucket.signed_url("app_documentation.pdf")
  end

end
