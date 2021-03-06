class PagesController < ApplicationController
  
  def functionroomlist
    @reservation = Reservation.find(params[:reservation_id])
    @function_room = FunctionRoom.all 
    @schema = FunctionRoomSchema.find(1)
  end
  
  def packagelist
    @reservation = Reservation.find(params[:reservation_id])
    @package = Package.find(:all, :order => 'package_category_id')
  end
     
  
  def package
    @reservation = Reservation.find(params[:reservation_id])   
    reservation = Reservation.find(params[:reservation_id])
    
    @reservation_crew = ReservationCrew.find_by_reservation_id(reservation.id)
    @reservation_package = ReservationPackage.find_by_reservation_id(reservation.id)
  end
  
  def menu_add_on
    @reservation = Reservation.find(params[:reservation_id])
    @recipe = Recipe.all
    
  end
  
   def recipe_alone
    @recipe = Recipe.find(params[:recipe_id])
  end
  

end
