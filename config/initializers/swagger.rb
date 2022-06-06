GrapeSwaggerRails.options.url      = '/api/swagger.json'
GrapeSwaggerRails.options.app_name = 'Druzhba API'

GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end
