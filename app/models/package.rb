class Package < ActiveRecord::Base
  has_one :reservation_package
 # has_many :crews, :through => :package_crews, :uniq => true
  has_many :package_crews
 
  def add_crew(crew_id)
    current_package = package_crews.find_by_crew_id(crew_id)
    if current_package
      current_package.quantity = current_package.quantity.to_i + 1
      #current_package.price = current_package.crew.price * current_package.quantity
    else
      current_package = package_crews.build(:crew_id => crew_id)
      current_package.price = current_package.crew.price
    end
   #current_package.reservation_package.price = current_package.reservation_package.price + current_package.price
   # current_package.reservation_package.save
    current_package
  end
  
  def find_crew_for_reservation(package_id)
    package_crew = package_crews.find_all_by_package_id(package_id)
    package_crew
  end
  
  
  
  
  def sumofcrew
    #current_crew = package_crews.find_by_package_id(package_id)
    Array.wrap(package_crews).sum{|crew| crew.total_price}
  end
  
  def total_items
    package_crews.sum(:quantity)
  end
end
