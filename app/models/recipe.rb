class Recipe < ActiveRecord::Base
  has_many :menu_recipes
  has_many :menu_addons_line_items
	#has_many :menus, :through => :menu_recipes, :uniq=> true
	belongs_to :recipe_category
end
