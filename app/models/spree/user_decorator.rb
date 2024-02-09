module Spree
  module UserDecorator

    attr_accessor :referral_code, :affiliate_code

    def self.prepended(base)
      base.has_one :referral
      base.has_one :referred_record
      base.has_one :affiliate, through: :referred_record, foreign_key: :affiliate_id
      base.has_one :affiliate_record, class_name: 'Spree::ReferredRecord'

      base.after_create :create_referral
      base.after_create :referral_affiliate_check
    end

    def referred_by
      referred_record.try(:referral).try(:user)
    end

    def referred_count
      referral.referred_records.count
    end

    def referred?
      !referred_record.try(:referral).try(:user).nil?
    end

    def affiliate?
      !affiliate.nil?
    end

    private
      def referral_affiliate_check
        if !self.referral_code.nil?
          referred = Referral.find_by(code: referral_code)
        elsif !self.affiliate_code.nil?
          referred = Affiliate.find_by(path: affiliate_code)
        end
        if referred
          referred.referred_records.create(user: self)
        end
      end

    Spree::User.prepend self
  end
end
