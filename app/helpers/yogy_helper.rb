module YogyHelper
  def alert_devise_to_bootstrap( devise )
    alert_type = {"alert": "warning", "notice": "success"}
    alert_type[devise.to_sym]
  end
end
