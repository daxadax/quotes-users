require 'minitest/autorun'
require 'bcrypt'

$LOAD_PATH.unshift('lib', 'spec')

# require all support files
Dir.glob('./spec/support/*.rb')  { |f| require f }

require 'users'

class FakeGatewayBackend

  def initialize
    @memories = Hash.new
    @next_uid = 0
  end

  def reset
    @memories.clear
    @next_uid = 0
  end

  def insert(user)
    user[:uid] = next_uid

    @memories[user[:uid]] = user
    user[:uid]
  end

  def get(uid)
    @memories[uid]
  end

  def fetch(nickname)
    user = @memories.select do |uid, values|
      values[:nickname] == nickname
    end

    user.values.first
  end

  def all
    @memories.values
  end

  def update(user)
    @memories[user[:uid]] = user
    user[:uid]
  end

  def delete(uid)
    @memories.delete(uid)
  end

  private

  def next_uid
    @next_uid += 1
  end

end

BCrypt::Engine::DEFAULT_COST = 1

class Minitest::Spec
  include Support::AssertionHelpers
  include Support::FactoryHelpers
  include Users

  @@gateway_backend_stub = FakeGatewayBackend.new

  Users::Gateways::Gateway.send(:define_method, :backend_for_users) do
    @@gateway_backend_stub
  end

  after { @@gateway_backend_stub.reset }


end
