SyncBumper.configure do |c|
  c.url = case
    when Rails.env.production?
      lambda { |id| "http://example.com/todos/#{id}/bumper" }
    when Rails.env.development?
      lambda { |id| "http://example.com/todos/#{id}/bumper" }
    else
      lambda { |id| "http://example.com/todos/#{id}/bumper" }
    end
end
