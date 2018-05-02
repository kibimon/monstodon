# frozen_string_literal: true

module AccountFinderConcern
  extend ActiveSupport::Concern

  class_methods do
    def find_no!(no_name, numero)
      find_no(no_name, numero) || raise(ActiveRecord::RecordNotFound)
    end

    def find_by_username!(username, domain = nil)
      find_by_username(username, domain) || raise(ActiveRecord::RecordNotFound)
    end

    def find_no(no_name, numero)
      AccountNoFinder.new(no_name, numero).account
    end

    def find_by_username(username, domain = nil)
      AccountByUsernameFinder.new(username, domain).account
    end
  end

  class AccountNoFinder
    attr_reader :no_name, :numero

    def initialize(no_name, numero)
      @no_name = no_name
      @numero = numero
    end

    def account
      scoped_accounts.order(id: :asc).take
    end

    private

    def scoped_accounts
      Account.unscoped.tap do |scope|
        scope.merge! with_no
        scope.merge! matching_no
      end
    end

    def with_no
      Account.where.not(no_name => 0)
    end

    def matching_no
      Account.where(no_name => numero.to_i)
    end
  end

  class AccountByUsernameFinder
    attr_reader :username, :domain

    def initialize(username, domain)
      @username = username
      @domain = domain
    end

    def account
      scoped_accounts.order(id: :asc).take
    end

    private

    def scoped_accounts
      Account.unscoped.tap do |scope|
        scope.merge! with_usernames
        scope.merge! matching_username
        scope.merge! matching_domain
      end
    end

    def with_usernames
      Account.where.not(username: '')
    end

    def matching_username
      Account.where(Account.arel_table[:username].lower.eq username.to_s.downcase)
    end

    def matching_domain
      if domain.nil?
        Account.where(domain: nil)
      else
        Account.where(Account.arel_table[:domain].lower.eq domain.to_s.downcase)
      end
    end
  end
end
