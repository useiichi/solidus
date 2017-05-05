require 'spec_helper'

# This test tests the functionality within
# spree/core/controller_helpers/respond_with.rb
# Rather than duck-punching the existing controllers, let's define a custom one:
class Spree::CustomController < Spree::BaseController
  def index
    respond_with(Spree::Address.new) do |format|
      format.html { render plain: "neutral" }
    end
  end

  def create
    # Just need a model with validations
    # Address is good enough, so let's go with that
    address = Spree::Address.new(params[:address])
    respond_with(address)
  end
end

describe Spree::CustomController, type: :controller do
  after do
    Spree::CustomController.clear_overrides!
  end

  before do
    @routes = ActionDispatch::Routing::RouteSet.new.tap do |r|
      r.draw {
        get 'index', to: 'spree/custom#index'
        post 'create', to: 'spree/custom#create'
      }
    end
  end

  context "extension testing" do
    context "index" do
      context "specify symbol for handler instead of Proc" do
        before do
          Spree::CustomController.class_eval do
            respond_override({ index: { html: { success: :success_method } } })

            private

            def success_method
              render plain: 'success!!!'
            end
          end
        end

        describe "GET" do
          it "has value success" do
            get :index
            expect(response).to be_success
            expect(response.body).to match(/success!!!/)
          end
        end
      end

      context "render" do
        before do
          Spree::CustomController.instance_eval do
            respond_override({ index: { html: { success: lambda { render(plain: 'success!!!') } } } })
            respond_override({ index: { html: { failure: lambda { render(plain: 'failure!!!') } } } })
          end
        end

        describe "GET" do
          it "has value success" do
            get :index
            expect(response).to be_success
            expect(response.body).to match(/success!!!/)
          end
        end
      end

      context "redirect" do
        before do
          Spree::CustomController.instance_eval do
            respond_override({ index: { html: { success: lambda { redirect_to('/cart') } } } })
            respond_override({ index: { html: { failure: lambda { render(plain: 'failure!!!') } } } })
          end
        end

        describe "GET" do
          it "has value success" do
            get :index
            expect(response).to be_redirect
          end
        end
      end

      context "validation error" do
        before do
          Spree::CustomController.instance_eval do
            respond_to :html
            respond_override({ create: { html: { success: lambda { render(plain: 'success!!!') } } } })
            respond_override({ create: { html: { failure: lambda { render(plain: 'failure!!!') } } } })
          end
        end

        describe "POST" do
          it "has value success" do
            post :create
            expect(response).to be_success
            expect(response.body).to match(/success!/)
          end
        end
      end

      context 'A different controllers respond_override. Regression test for #1301' do
        before do
          Spree::CheckoutController.instance_eval do
            respond_override({ index: { html: { success: lambda { render(plain: 'success!!!') } } } })
          end
        end

        describe "POST" do
          it "should not effect the wrong controller" do
            get :index
            expect(response.body).to match(/neutral/)
          end
        end
      end
    end
  end
end
