require 'httparty'

class Kele
    include HTTParty
    
    def initialize(username, password)
        response = self.class.post 'https://www.bloc.io/api/v1/sessions', body: {email: username, password: password}
        raise "Invalid username or password" if response.code != 200
        @auth_token = response["auth_token"]
    end
end