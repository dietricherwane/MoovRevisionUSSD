class Parameter < ActiveRecord::Base
  attr_accessible :sms_gateway_url, :billing_url
end
