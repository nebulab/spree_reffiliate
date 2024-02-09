module Spree::UserControllerDecorator
  def self.prepended(base)
    base.before_action :check_referral_and_affiliate, :only => :create
  end

  def check_referral_and_affiliate
    params[:spree_user].merge!(:referral_code => session[:referral], :affiliate_code => session[:affiliate])
  end

  Spree::UsersController.prepend self
end
