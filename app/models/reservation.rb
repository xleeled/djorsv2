class Reservation < ActiveRecord::Base
  has_one :reservation_package ,:dependent => :destroy
  has_one :book_reservation ,:dependent => :destroy
  belongs_to :service
  has_many :reservation_function_rooms, :dependent => :destroy
  has_many :package_line_items, :dependent => :destroy
  has_many :menu_addons_line_items ,:dependent => :destroy
  has_many :menus , :through => :package_line_items, :uniq => true
  has_many :function_rooms, :through =>:reservation_function_rooms
  has_many :reservation_crews ,:dependent => :destroy
  has_many :reservation_recipes, :dependent => :destroy

  ##### validation #####
  validates :event_start,:event_end, :overlap => {:scope => :date,:message => "time already taken"}
  validates :name,:address,:contact,:email,:date,:event_start,:event_end,:numGuest,:reservation_option,:service,:presence => :true
  # validates_numericality_of :contact , :only_integer => true, :message => "must be numbers only."
  #validates_format_of :name, :with => /^[-a-z]+$/
  #validates_format_of :numGuest, :with => /[0-9]/
  validates_numericality_of :contact,:numGuest, :only_integer => true ,:message => "invalid not a number"
  validates_inclusion_of :numGuest, :in => 5..9999999999, :message =>  "minimum of 5 persons"
  
  # validates :duration, :range => { :not_overlapping => Proc.new{ |m| Reservation.where(:date => m.date) } }

  #def find_reservation_addons(recipe_id)
  # #  addons = self.menu_addons_line_items.find_all_by_recipe_id(recipe_id)
  #   addons

  # end
  def sumofaddons
    Array.wrap(menu_addons_line_items).sum {|recipe| recipe.price}
  end

  ###########global############
  def remove_menu_upon_destroy(reservation_id)
    menus = package_line_items.find_all_by_reservation_id(reservation_id)
    menus.each do |menu|
      menu.destroy
    end
  end

  def remove_addons_upon_destroy(reservation_id)
    addons = menu_addons_line_items.find_all_by_reservation_id(reservation_id)
    addons.each do |addon|
      addon.destroy
    end
  end

  def remove_crew_upon_destroy(reservation_id)
    reservation_crew = reservation_crews.find_all_by_reservation_id(reservation_id)
    reservation_crew.each do |rc|
      rc.destroy
    end
  end

  def remove_function_room_upon_destroy(reservation_id)
    reservation_function_room = reservation_function_rooms.find_all_by_reservation_id(reservation_id)
    reservation_function_room.each do |rfr|
      rfr.destroy
    end
  end

  #########self################

  def remove_all_associated(reservation_id)
    self.remove_menu_upon_destroy(reservation_id)
    self.remove_addons_upon_destroy(reservation_id)
    self.remove_crew_upon_destroy(reservation_id)
    self.remove_function_room_upon_destroy(reservation_id)
  end

  def compute_for_total_hours
    differences=Time.diff(Time.parse(self.event_start.to_s), Time.parse(self.event_end.to_s))
    min = ("." +"#{differences[:minute]}").to_d
    min = min / ".60".to_d
    min = sprintf("%.1f",(min))
    total = ("#{differences[:hour]}").to_d + min.to_d
    total
  end

  #########functionrooms############

  def sumoffunctionroom
    function = reservation_function_rooms
    Array.wrap(function).sum {|room| room.price}
  end

  def add_function_room(function_room_id)
    current_function_room = reservation_function_rooms.find_by_function_room_id(function_room_id)

    if current_function_room
    current_function_room
    else
      current_function_room = reservation_function_rooms.build(:function_room_id => function_room_id)
      current_function_room.price = current_function_room.function_room.price * compute_for_total_hours
    self.total_price += current_function_room.price
    self.save!
    end
    current_function_room
  end

  ###########package#################

  def remove_packageitems(reservation_id)
    self.remove_menu_upon_destroy(reservation_id)
    self.remove_addons_upon_destroy(reservation_id)
    self.remove_crew_upon_destroy(reservation_id)
  end

  def reservation_crew_total
    total = reservation_crew.crew_total_price
    total
  end

  def packagecrew(package_id)
    total = reservation_package.find_by_package_id(package_id)
    #total = reservation_package.total_crew(package_id)
    total.total_crew
  end

  def add_package(package_id)
    current_package = build_reservation_package(:package_id => package_id)
    sumofcrew = reservation_package.total_crew
    current_package.price = current_package.package.price + sumofcrew 
    self.total_price = self.total_price + current_package.price
    self.save
    current_package
  end

  def scan_my_self_tru_package(package_id)
    current_package = self.find_by_package_id(package_id)
    current_package = current_package.reservation_id
  end

  def add_reservationmenu(package_id)
    reservationpackagemenus = reservation_package.package.find_menu_for_reservation(package_id)
    reservationpackagemenus.each do |a|
      @package_line_item = package_line_items.create(:reservation_id => self, :menu_id => a.menu_id , :price => a.price)
      @package_line_item.save
      
    end
  end

  def add_reservationcrew(package_id)
    reservationpackagecrews = reservation_package.package.find_crew_for_reservation(package_id)
    reservationpackagecrews.each do |b|
      @reservation_crew= reservation_crews.create(:reservation_id => self,:crew_id => b.crew_id,:quantity => b.quantity, :price => b.price)
      @reservation_crew.save
    end
  end
  
  def search_menu(package_id)
      recipes = package_line_items.open_menu_by_package(package_id) 
      
  end
  
  
  
  ##############
  

  
  
  #def add_recipe_to_lock(package_id)
   # reservationrecipes = reservation_package.find_my_package#.package.package_line_item.find_my_menu(package_id)#reservation_package.package.find_menu_for_reservation(package_id)
    #reservationrecipes.each do |c|
     # recipes = c
    #end
  #end
#####################
  def add_menu_price_to_reservation_package
    price = package_line_items.open_menu
    self.reservation_package.price = self.reservation_package.price + (price * self.numGuest)
    self.reservation_package.save
    self.total_price = self.total_price + (price * self.numGuest)
    self.save
  end

  ############menu###############

  # def sumofmenu
  #  menu = package_line_items
  #   Array.wrap(menu).sum {|menu| menu.price}
  #   end

  def get_total() 
  
  end

  def add_menu(menu_id)
    current_menu = package_line_items.find_by_menu_id(menu_id)
    if current_menu
    current_menu
    else
      current_menu = package_line_items.build(:menu_id => menu_id)
    self.reservation_package.price = self.reservation_package.price + (current_menu.get_menu_price * self.numGuest)
    self.reservation_package.save
    #  current_menu.price = current_menu.menu.price
    #  self.reservation_package.price = self.reservation_package.price + (current_menu.price * self.numGuest)
    #self.reservation_package.save
    self.total_price =  self.total_price  + (current_menu.get_menu_price* self.numGuest)
    self.save
    end
    current_menu
  end

  ############addons#############
  def sumofaddon
    addon = menu_addons_line_items
    Array.wrap(addon).sum {|addon| addon.price}
  end

  def add_addon(recipe_id)
    current_addon = menu_addons_line_items.find_by_recipe_id(recipe_id)
    if current_addon
    current_addon
    else
      current_addon = menu_addons_line_items.build(:recipe_id => recipe_id)
    current_addon.price  = current_addon.recipe.price  * self.numGuest
    self.reservation_package.price = self.reservation_package.price + current_addon.price
    self.reservation_package.save
    self.total_price =   self.total_price +  current_addon.price
    self.save
    end
    current_addon
  end
  ##################################################################################################

  def get_crews_for_package(package_id)
    crews
  end

  def add_package_to_reservation(package_id)
    @reservation_package
  end

end
