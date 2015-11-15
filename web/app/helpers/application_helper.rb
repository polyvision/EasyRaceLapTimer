module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-warning"
      when "error"
        "alert-warning"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      when "notice"
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def formated_lap_time(t) # convert to seconds
    return "#{(t / 1000.0).round(4)}s"
  end
end
