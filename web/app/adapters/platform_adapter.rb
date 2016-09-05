class PlatformAdapter
  def self.platform?
    if RUBY_PLATFORM.include?("darwin")
      return :platform_osx
    end

    return :platform_unknown
  end
end
