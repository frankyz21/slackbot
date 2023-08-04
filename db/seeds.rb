# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


10.times do |index|
  title = "Title #{index+1}"
  description = "Some random description about the incident #{index+1}"
  severity = Incident.severities.keys.sample
  status = Incident.statuses.keys.sample
  resolved_at = status == 'resolved' ? DateTime.now + 1.hour : nil
  creator = "Creator #{index+1}"
  channel_id = "channel #{index+1}"

  Incident.create!(
    title: title,
    description: description,
    severity: severity,
    status: status,
    resolved_at: resolved_at,
    creator: creator,
    channel_id: channel_id
  )
end