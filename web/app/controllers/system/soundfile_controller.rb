class System::SoundfileController < SystemController
  def index
    @soundfiles = Soundfile.all
    @custom_soundfiles = CustomSoundfile.order("title ASC")
  end

  def update
    @soundfile = Soundfile.find(params[:id])
    @soundfile.update_attribute(:file,params[:soundfile][:file])
    redirect_to action: 'index'
  end

  def clear
    @soundfile = Soundfile.find(params[:id])
    @soundfile.remove_file!
    @soundfile.save
    redirect_to action: 'index'
  end

  def create_custom
    @soundfile = CustomSoundfile.create(strong_params_custom_soundfile)
    @soundfile.save!
    redirect_to action: 'index'
  end

  def delete_custom
    @soundfile = CustomSoundfile.find(params[:id])
    @soundfile.destroy
    redirect_to action: 'index'
  end

  private

  def strong_params_custom_soundfile
    params.require(:custom_soundfile).permit(:title,:file)
  end
end
