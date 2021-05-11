class HomeController < ApplicationController
    skip_before_action :verify_authenticity_token, only: :webhooks

    def index
    end
    def design
    	
    end

    def webhooks
    	# ap params
    	payload = request.body.read
	    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
	    event = nil
	    begin
	        event = Stripe::Webhook.construct_event(
	            payload, sig_header, ENV['STRIPE_ENDPOINT_SECRET']
	        )
	    rescue JSON::ParserError => e
	        # Invalid payload
	        render body: nil, :status => :bad_request
	        return
	    rescue Stripe::SignatureVerificationError => e
	        # Invalid signature
	        render body: nil, :status => :bad_request
	        return
	    end
	    case params[:type]
    	when "payment_intent.payment_failed"
	      intent_id = params[:data][:object][:id]
	      PaymentIntentJob.perform_later(intent_id)
	      puts 'Payment intent has been failed.'
	      redirect_to(root_path)
	    when "payment_intent.succeeded"
	      # email = params[:data][:object][:charges][:data][0][:billing_details][:email]
	      user_email = params[:data][:object][:charges][:data][0][:description]
	      amount = params[:data][:object][:amount_received]
	      user = User.find_by_email(user_email)
	      user.increment!(:balance_cents,amount) if user.present?
	      
	    else
	    	render body: nil, :status => :bad_request
	    	return
	    end
	    head :no_content
		end
		
		# def set_locale
		# 	p I18n.locale = params[:locale]
		# 	p 'Hamza'
		# 	p "#{request.referrer}?#{params[:locale]}"
		# 	redirect_to "#{request.referrer}?#{params[:locale]}"
		# end
end
