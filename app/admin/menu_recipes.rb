ActiveAdmin.register MenuRecipe do
    menu :parent => "Manage Package"
    filter :recipe
    filter :menu
   # filter :price, :as => :numeric
  # form :partial => "menu_recipe"
    
    
    
    
    controller do
      def new
          @menu_recipe = MenuRecipe.new  
      end
      
      def create
          @menu = Menu.find(params[:menu_recipe][:menu_id])
          recipe = Recipe.find(params[:menu_recipe][:recipe_id])
          @menu_recipe = @menu.add_recipe(recipe.id)
          
           if @menu_recipe.save
            redirect_to {admin_menu_recipe_url}
          end
       end
      
      def destroy
          
          
      @menu_recipe = MenuRecipe.find(params[:id])
      @menu_recipe.remove_recipe
      @menu_recipe.destroy
    
   
      
      end     

    end
    
end
