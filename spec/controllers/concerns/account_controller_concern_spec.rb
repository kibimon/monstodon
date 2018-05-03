# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController, type: :controller do
  controller do
    include AccountControllerConcern

    def success
      head 200
    end
  end

  before do
    routes.draw { get 'success' => 'anonymous#success' }
  end

  context 'when routing is correct and account is not suspended or remote' do
    it 'sets link headers' do
      account = Fabricate(:v1_trainer, username: 'username')
      get 'success', params: { account_username: account.username, type: 'v1_trainer' }
      expect(response.headers['Link'].to_s).to eq '<http://test.host/.well-known/webfinger?resource=acct%3Ausername%40cb6e6126.ngrok.io>; rel="lrdd"; type="application/xrd+xml", <http://test.host/users/username.atom>; rel="alternate"; type="application/atom+xml", <https://cb6e6126.ngrok.io/users/username>; rel="alternate"; type="application/activity+json"'
    end
  end
end
