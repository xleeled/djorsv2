ActiveAdmin.register Mmenu do
  #filter :menu_category
 
  filter :name
  
  
    
  index do 
    column :name
   # column :price, :sortable => :price do |d|
   #   div :class => "price" do
   #     number_to_currency d.price, :unit => "&#8369;"
   #   end
   # end
   # column :menu_category
  #  column :menu_type
  default_actions
  end
  
  
  
   form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Details" do
    
   # f.input :menu_category
  #  f.input :menu_type
    f.input :name
    f.input :description
    #f.input :price, :as => :string
    #f.input :image_function_room, :as => :file  #,:hint => "current image: #{f.template.image_tag(f.object.image_function_room.url(:thumb))}"
    end
  f.buttons
 end
end