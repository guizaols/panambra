#encoding: UTF-8
class Gcm < ActiveRecord::Base
  

	def self.create_configuration
		Push::ConfigurationGcm.create(
			app: 'com.example.panambramobile', 
			connections: 2, 
			enabled: true,
    		key: 'AIzaSyBNh0TGVFYbLC5w7XyOS3Nbbac3FvCYJx4')
	end


	def self.send_android_message(user_gcm)
	    Push::MessageGcm.create(
		    app: 'com.example.panambramobile',
    		device: user_gcm,
    		payload: { message: 'Existe uma nova Ocorrência' },
    		collapse_key: 'MSG')
	end

end
