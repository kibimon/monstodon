# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, account_type: :controller do
  controller do
    include AccountAccessConcern

    def success
      head 200
    end
  end

  before do
    routes.draw { get 'success' => 'anonymous#success' }
  end

  context 'when account is suspended' do
    it 'returns http gone' do
      account = Fabricate(:v1_trainer, suspended: true)
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(response).to have_http_status(410)
    end
  end

  context 'when account is remote' do
    it 'returns http not found' do
      account = Fabricate(:v1_trainer, domain: 'some-other.instance')
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(response).to have_http_status(404)
    end
  end

  context 'when routing is incorrect' do
    it 'returns http not found for v1 trainers' do
      account = Fabricate(:v1_trainer)
      get 'success', params: { account_no: account.numero, account_type: 'trainer' }
      expect(response).to have_http_status(404)
    end

    it 'returns http not found for v2 mon' do
      account = Fabricate(:mon)
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(response).to have_http_status(404)
    end

    it 'returns http not found for v2 routes' do
      account = Fabricate(:route)
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(response).to have_http_status(404)
    end

    it 'returns http not found for v2 trainers' do
      account = Fabricate(:trainer)
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(response).to have_http_status(404)
    end
  end

  context 'when routing is correct and account is not suspended or remote' do
    it 'assigns @account for v1 trainers' do
      account = Fabricate(:v1_trainer)
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(assigns(:account)).to eq account
    end

    it 'assigns @account for v2 mon' do
      account = Fabricate(:mon)
      get 'success', params: { account_no: account.numero, account_type: 'mon' }
      expect(assigns(:account)).to eq account
    end

    it 'assigns @account for v2 routes' do
      account = Fabricate(:route)
      get 'success', params: { account_no: account.numero, account_type: 'route' }
      expect(assigns(:account)).to eq account
    end

    it 'assigns @account for v2 trainers' do
      account = Fabricate(:trainer)
      get 'success', params: { account_no: account.numero, account_type: 'trainer' }
      expect(assigns(:account)).to eq account
    end

    it 'assigns @account for short v1 trainers' do
      account = Fabricate(:v1_trainer)
      get 'success', params: { account_username: account.username, account_type: 'short_trainer' }
      expect(assigns(:account)).to eq account
    end

    it 'assigns @account for short v2 trainers' do
      account = Fabricate(:trainer)
      get 'success', params: { account_username: account.username, account_type: 'short_trainer' }
      expect(assigns(:account)).to eq account
    end

    it 'returns http success' do
      account = Fabricate(:v1_trainer)
      get 'success', params: { account_username: account.username, account_type: 'v1_trainer' }
      expect(response).to have_http_status(:success)
    end
  end
end
