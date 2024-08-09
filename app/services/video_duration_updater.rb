class VideoDurationUpdater
  ROUNDING_LIMIT = 10
  def self.update_all_durations
    new.update_all_durations
  end

  def self.update_duration(video)
    new.update_duration(video)
  end

  def update_all_durations
    wistia_response = wistia_client.list
    names_and_durations = names_and_durations(wistia_response)
    names_and_durations.each_pair do |name, duration|
      Video.find_by(name: name)&.update(length_in_minutes: duration)
    end
  end

  def update_duration(video)
    wistia_response = wistia_client.show(video.wistia_id)
    length_in_minutes = seconds_to_minutes(wistia_response["duration"])
    video.update(length_in_minutes: length_in_minutes)
  end

  private

  def wistia_client
    @_wistia_client ||= WistiaApiClient::Media.new
  end

  def names_and_durations(data)
    data.reduce({}) do |aggregator, video|
      aggregator.merge(get_duration(video))
    end
  end

  def get_duration(data)
    {data["name"] => seconds_to_minutes(data["duration"])}
  end

  def seconds_to_minutes(seconds)
    minutes = (seconds / 60).to_i
    seconds_remaining = seconds % 60
    if seconds_remaining < ROUNDING_LIMIT
      minutes
    else
      minutes + 1
    end
  end
end
