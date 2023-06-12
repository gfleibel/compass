class MatchTimeJob < ApplicationJob
  queue_as :default

  def perform(match)
    timestamp = match.created_at
    created_at = timestamp.to_time
    current_timestamp = Time.now
    days_passed = (current_timestamp - created_at) / (60 * 60 * 24)
    match.destroy if days_passed.to_i > 7 && match.matched == false
  end
end
