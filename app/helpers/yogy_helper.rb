module YogyHelper
  def alert_devise_to_bootstrap( devise )
    alert_type = {"alert": "warning", "notice": "success", "error": "danger"}
    alert_type[devise.to_sym]
  end
end
