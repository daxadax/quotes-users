require 'spec_helper'

class UseCaseSpec < Minitest::Spec

  def gateway
    @gateway ||= Gateways::UserGateway.new
  end

end