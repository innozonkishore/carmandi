# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def dealer_role_id
    return @dealer_role_id if @dealer_role_id
    @dealer_role_id = Role.find_by_name("Dealer").id
  end
  
  def buyer_role_id
    return @buyer_role_id if @buyer_role_id
    @buyer_role_id = Role.find_by_name("Buyer").id
  end
  
  def private_seller_role_id
    return @private_seller_role_id if @private_seller_role_id
    @private_seller_role_id = Role.find_by_name("Private seller").id
  end

  def decimal_two(number)
    "%.2f" %number
  end
  
end
