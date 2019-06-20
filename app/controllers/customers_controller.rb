class CustomersController < InheritedResources::Base
  private

  def customer_params
    params.require(:customer).permit(:email, :password, :first_name, :last_name)
  end
end
