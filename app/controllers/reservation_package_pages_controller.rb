class ReservationPackagePagesController < ApplicationController
   def menulist
      @reservation = Reservation.find(params[:reservation_id])
     # @reservation_package = ReservationPackage.find(params[:reservation_package_id])
      @menu = Menu.all
  end

  def menu
    @reservation = Reservation.find(params[:reservation_id])
    @menu = Menu.find(params[:menu_id])
    
  end
  
    def function_alone
    @functionroom = FunctionRoom.find(params[:function_room_id])
  end
  
 
end
