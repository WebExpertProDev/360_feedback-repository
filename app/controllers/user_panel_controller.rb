class UserPanelController < ApplicationController
	before_action :authenticate_user!,except: :leadership_survey
	def payment
		@amount = (params[:amount].to_f * 100).to_i
		@intent = Stripe::PaymentIntent.create({
	        amount: @amount,
	        currency: 'usd',
	        payment_method_types: ['card'],
	        description: current_user.email
	    })

	    respond_to do |format|
	    	format.html {}
	    	format.js {}
	    end
	end

	def invites
		@tests = current_user.invites
	end
	
	private
		
end
