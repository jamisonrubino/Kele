require 'httparty'

class Kele
    include HTTParty
    
    def initialize(email, password)
        response = self.class.post 'https://www.bloc.io/api/v1/sessions', body: {email: email, password: password}
        raise "Invalid username or password" if response.code != 200
        @auth_token = response["auth_token"]
    end
    
    def get_me
        response = self.class.get 'https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token }
        current_user = JSON.parse(response.body)
    end
end