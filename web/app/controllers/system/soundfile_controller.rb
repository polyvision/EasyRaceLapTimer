class System::SoundfileController < SystemController
  def index
    @soundfiles = Soundfile.all
  end

  def update
    @soundfile = Soundfile.find(params[:id])
    @soundfile.update_attribute(:file,params[:soundfile][:file])
    redirect_to action: 'index'
  end
end
