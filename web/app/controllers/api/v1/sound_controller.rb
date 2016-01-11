class Api::V1::SoundController < Api::V1Controller
	def play_custom
		CustomSoundfileWorker.perform_async(params[:id])
		render status: 200, text: ""
	end
end
