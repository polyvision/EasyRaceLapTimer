class AlsaMixer
	# AlsaMixer::change_volume("10%+")
	# AlsaMixer::change_volume("10%")
	def self.change_volume(percentage)
		pid = spawn("amixer -q sset PCM #{percentage}")
  		Process.detach pid
	end
end
