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
  
  sidebar :customer_information, :only => :show do
    attributes_table_for reservation do
      row("Reservation Edit") { link_to "Edit Details",reservation_path(@reservation)}
    end
  end
  form :html => { :enctype => "multipart/form-data" } do |f|
   f.inputs "Reservation Information" do
    f.input :service
    f.input :name
    f.input :address
    f.input :contact, :as => :string
    f.input :date, :as => :date, :hint => 'Select a date',
         :prompt => {:day => "Day", :month => "Month", :year => "Year"},
         :start_year => Time.now.year
    #time issue#
    f.input :timeStart ,:label => "Time Start", :twelve_hour => true 
    f.input :timeEnd ,:label => "Time End" , :twelve_hour => true 
    ##
    f.input :numGuest, :as => :string
    f.input :email
    end
  f.buttons
 end
 
 
 

 
 
 controller do
   def destroy
                      @reservation = Reservation.find(params[:id])
                     
                      
                      if @reservation.destroy
                       destroy_reservation_session
                       redirect_to :action => :index, :notice => "This is a test notice!"
                      end
   end
 end
 
end
