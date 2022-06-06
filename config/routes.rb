Rails.application.routes.draw do
  mount Api::Mount => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'
end
