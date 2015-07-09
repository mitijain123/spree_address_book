module Spree
  module Api
    class AddressesController < Spree::Api::BaseController

    	load_and_authorize_resource class: Spree::Address
    	
    	def index    
		    @addresses = @current_api_user.addresses
		    # expires_in 15.minutes, :public => true
      #   headers['Surrogate-Control'] = "max-age=#{15.minutes}"
		    render json:  @addresses,  
		      :methods => [:state_name , :country_name, :defult_shippiing_address_id ]

		      #render json:  @addresses.as_json(include: {:state_name => :state_name })
		  end

		  def create
		    @address = @current_api_user.addresses.build(address_params)
		    if @address.save
		      flash[:notice] = I18n.t(:successfully_created, scope: :address_book)
		      #redirect_to account_path
		      save_to_account_params
		      @current_api_user.update_attributes({ship_address_id: @address.id}) if params[:save_to_account]
		      render json:  @address, :methods => [:state_name , :country_name, :defult_shippiing_address_id ]
		    else
		      #render :action => 'new'
		      render :json => {:error => "not-found"}.to_json, :status => 404
		    end
		  end

		  # def show
		  #   redirect_to account_path
		  # end

		  # def edit
		  #   session['spree_user_return_to'] = request.env['HTTP_REFERER']
		  # end

		  # def new
		  #   @address = Spree::Address.default
		  # end

		  def update
		    if @address.editable?
		      if @address.update_attributes(address_params)
		        flash[:notice] = I18n.t(:successfully_updated, scope: :address_book)
		        #redirect_back_or_default(account_path)
		        save_to_account_params
		        @current_api_user.update_attributes({ship_address_id: @address.id}) if params[:save_to_account]
		        render json:  @address, :methods => [:state_name , :country_name, :defult_shippiing_address_id ]
		      else
		        #render :action => 'edit'
		        render :json => {:error => "not-found"}.to_json, :status => 404

		      end
		    else
		      new_address = @address.clone
		      new_address.attributes = address_params
		      @address.update_attribute(:deleted_at, Time.now)
		      if new_address.save
		        flash[:notice] = I18n.t(:successfully_updated, scope: :address_book)
		        #redirect_back_or_default(account_path)
		        render json:  @address, :methods => [:state_name , :country_name ]
		      else
		        #render :action => 'edit'
		        render :json => {:error => "not-found"}.to_json, :status => 404		        
		      end
		    end
		  end

		  def destroy
		  	if @address.can_be_deleted?
		    	@address.destroy
		    	render json:  {status: 200}
		    else
		    	render :json => {:error => "not-found"}.to_json, :status => 404
		    end

		    
		  end

		  private
		    def address_params
		      params[:address].permit(:address,
		                              :firstname,
		                              :lastname,
		                              :address1,
		                              :address2,
		                              :city,
		                              :state_id,
		                              :zipcode,
		                              :country_id,
		                              :phone
		                             )      
		    end   
		    def save_to_account_params
		      params.permit(:save_to_account)
		    end
    end
  end
end