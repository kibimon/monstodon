require 'rails_helper'

describe Monstodon::MonBoxesController do
  render_views

  let(:alice) { Fabricate(:trainer, username: 'alice') }
  let(:alices_snubbull) { Fabricate(:mon) }
  let(:alices_umbreon) { Fabricate(:mon) }
  let(:seviper) { Fabricate(:mon) } # should not be owned by alice

  describe 'GET #index' do
    it 'assigns mon' do
      alices_snubbull.update!(owner: alice)
      alices_umbreon.update!(owner: alice)

      get :index, params: { account_type: 'trainer', account_no: alice.trainer_no }

      assigned = assigns(:mon).to_a
      expect(assigned.size).to eq 2
      expect(assigned[0]).to eq alices_snubbull
      expect(assigned[1]).to eq alices_umbreon

      expect(response).to have_http_status(:success)
    end
  end
end
