json.set! :simulation do
  json.extract! @simulation, *([:id, :project_id, :name, :description, :created_at, :updated_at] + Simulation.attribute_names)
end
json.set! :message, @message
