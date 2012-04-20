ActiveAdmin.register PackageMenu do
   menu :parent => "Group Manager"
   actions :all, :except => [:edit]
   
    index do 
    column :package
    column :menu
    
  default_actions
  end
   
   form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Details" do
    f.input :package
    f.input :menu
    end
  f.buttons
 end
   
   
   controller do
     def create
        @package = Package.find(params[:package_menu][:package_id])
        menu = Menu.find(params[:package_menu][:menu_id])
        @package_menu = @package.add_menu(menu.id)
       if @package_menu.save
        redirect_to {admin_package_crew_url}
       end
     end
    
   end
end