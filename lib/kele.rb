require 'httparty'
require_relative 'roadmap'

class Kele
    include HTTParty
    include Roadmap
    
    def initialize(email, password)
        response = self.class.post 'https://www.bloc.io/api/v1/sessions', body: {email: email, password: password}
        raise "Invalid username or password" if response.code != 200
        @auth_token = response["auth_token"]
    end
    
    def get_me
        response = self.class.get 'https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth_token }
        current_user = JSON.parse(response.body)
    end
    
    def get_mentor_availability(mentor_id)
        url = "https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability"
        response = self.class.get url, headers: { "authorization" => @auth_token }
        mentor_availability = []
        JSON.parse(response.body).map { |m| mentor_availability << {"starts_at": m["starts_at"], "ends_at": m["ends_at"]} }
        mentor_availability
    end
    
    def get_messages(page = 1)
        values = { "page": page }
        response = self.class.get "https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token }
        JSON.parse(response.body)
    end
    
    def create_message(sender, recipient_id, subject, stripped_text)
        url = "https://www.bloc.io/api/v1/messages"
        values = {
            "sender": sender,
            "recipient_id": recipient_id,
            "subject": subject,
            "stripped-text": stripped_text
        }       
        headers = { "authorization" => @auth_token }
        response = self.class.post url, values
        raise "Something went wrong." if response.code != 200
    end
end