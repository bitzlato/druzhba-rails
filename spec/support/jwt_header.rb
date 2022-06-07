# frozen_string_literal: true

def jwt_header_for(user)
  jwt = JWT.encode({ 'sub' => user.uid }, nil, 'none')
  { 'Authorization' => "Bearer #{jwt}" }
end
