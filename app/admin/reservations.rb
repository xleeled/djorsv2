ActiveAdmin.register Reservation do
  
  menu :parent => "Tickets" ,:label => "Reservation Tickets"
  filter :name
  filter :date
  filter :email
 
  index do 
    column "Reservation Number",:id
    column "Guest Name", :name
    column "Service Type", :service
    column "Booked Date", :date
    column "Time Start", :timeStart# do |x|
      # x.timeStart.to_s(:long)
    #end
    column "Time End",:timeEnd
    column "Number of guest", :numGuest
    default_actions
  end
  
  form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Reservation Information" do
    f.input :service
    f.input :name
    f.input :address
    f.input :contact, :as => :string
    f.input :date
    #time issue#
    f.input :timeStart,:label => "Time Start"
    f.input :timeEnd ,:label => "Time End"
    ##
    f.input :numGuest, :as => :string
    f.input :email
    end
  f.buttons
 end
 
 
 
 sidebar :customer_information, :only => :show do
    attributes_table_for reservation do
      row("name") { auto_link reservation.name }
      row("Date") {reservation.date}
      row("Number of Guest") {reservation.numGuest}
      row("time Start") { reservation.timeStart}
      row("time End") { reservation.timeEnd}
      row :email
      row :contact
      row :total_price
    end
  end
 
 
 controller do
   def destory
                      @reservation = Reservation.find(params[:id])
                      destroy_reservation_session
                      
                      if @reservation.destroy
                       redirect_to :action => :index, :notice => "This is a test notice!"
                      end
   end
 end
 
end
