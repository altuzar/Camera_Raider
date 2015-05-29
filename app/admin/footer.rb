class Footer < ActiveAdmin::Component
 
  def build
    super :id => "footer"
 
    span "Powered by Me #{Date.today.year}"
  end
 
end