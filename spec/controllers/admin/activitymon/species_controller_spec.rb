require 'rails_helper'

RSpec.describe Admin::ActivityMon::SpeciesController, type: :controller do

  context "as an admin" do

    let(:user) { Fabricate(:user, admin: true) }

    before do
      sign_in user, scope: :user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

  end

  context "as a regular user" do

    let(:user) { Fabricate(:user, admin: false) }

    before do
      sign_in user, scope: :user
    end

    describe "GET #index" do
      it "returns http forbidden" do
        get :index
        expect(response).to have_http_status(:forbidden)
      end
    end

  end

end
