class Api::V1::PaymentsController < ApplicationController
  before_action :authenticate_user


  def checkout
    # validate user cart items item by item
    # calculate total value 
    # create an order object with status :under process
    # add background job to delete the order after set of time if status didnt success
    # return order object or errors if cart has errors
  end


  def pay
    # recieving order id and payment method id
    # find order id and check status to avoid duplicate
    # create payment intent with confirm set to true
    # if payment done =>
      # reset cart
      # change order status to succeed
      # save payment intent id in order object
      # return success response
    # if 3d required =>
      # return payment intent id
    # if rejected =>
      # 
      # return errors
  end

  def confirm

  end

end