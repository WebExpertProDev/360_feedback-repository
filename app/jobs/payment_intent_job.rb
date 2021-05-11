class PaymentIntentJob < ApplicationJob
	queue_as :default

    # Do something later
	def perform(intent)
	    # Do something later
	    begin Stripe::PaymentIntent.cancel(intent)
	      # puts 'Payment Intent will be cancelled only if certain conditions are met. Check stripe API docs for more details.'
	    rescue Stripe::InvalidRequestError => e
	      # puts 'Unable to cancel Payment Intent which is succeeded before.'
	    end
	end
end
