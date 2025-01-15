require "rails_helper"

RSpec.describe AuthServiceFactory do
  let(:mock_uid) { "mock_uid" }
  let(:mock_auth_adapter) { Auth::MockAdapter.new(uid_generator: -> { mock_uid }) }
  let(:cognito_auth_adapter) { Auth::MockAdapter.new(uid_generator: -> { mock_uid }) }


  let(:mock_adapter) { instance_double("Auth::MockAdapter") }
  let(:cognito_adapter) { instance_double("Auth::CognitoAdapter") }
  let(:auth_service) { instance_double("AuthService") }

  before(:each) do
    # Reset the singleton instance before each test
    AuthServiceFactory.instance_variable_set(:@singleton__instance__, nil)
  end

  before do
    allow(Auth::MockAdapter).to receive(:new).and_return(mock_adapter)
    allow(Auth::CognitoAdapter).to receive(:new).and_return(cognito_adapter)
    allow(AuthService).to receive(:new).with(mock_adapter).and_return(auth_service)
    allow(AuthService).to receive(:new).with(cognito_adapter).and_return(auth_service)
  end

  it "returns a singleton instance" do
    instance1 = AuthServiceFactory.instance
    instance2 = AuthServiceFactory.instance
    expect(instance1).to be(instance2)
  end

  context "when AUTH_ADAPTER is not 'mock'" do
    before do
      stub_const("ENV", ENV.to_h.merge("AUTH_ADAPTER" => "any string"))
    end

    it "initializes with CognitoAdapter" do
      expect(Auth::CognitoAdapter).to receive(:new)
      expect(AuthService).to receive(:new).with(cognito_adapter)

      factory = AuthServiceFactory.instance
      expect(factory.auth_service.inspect).to eq(auth_service.inspect)
    end
  end

  context "when AUTH_ADAPTER is 'mock'" do
    before do
      stub_const("ENV", ENV.to_h.merge("AUTH_ADAPTER" => "mock"))
    end

    it "initializes with MockAdapter" do
      expect(Auth::MockAdapter).to receive(:new)
      expect(AuthService).to receive(:new).with(mock_adapter)

      factory = AuthServiceFactory.instance
      expect(factory.auth_service.inspect).to eq(auth_service.inspect)
    end
  end


end

