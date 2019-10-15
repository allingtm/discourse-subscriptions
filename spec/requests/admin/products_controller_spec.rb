# frozen_string_literal: true

require 'rails_helper'

module DiscoursePatrons
  module Admin
    RSpec.describe ProductsController do
      it 'is a subclass of AdminController' do
        expect(DiscoursePatrons::Admin::ProductsController < ::Admin::AdminController).to eq(true)
      end

      context 'unauthenticated' do
        it "does nothing" do
          ::Stripe::Product.expects(:list).never
          get "/patrons/admin/products.json"
          expect(response.status).to eq(403)
        end

        it "does nothing" do
          ::Stripe::Product.expects(:create).never
          post "/patrons/admin/products.json"
          expect(response.status).to eq(403)
        end
      end

      context 'authenticated' do
        let(:admin) { Fabricate(:admin) }

        before { sign_in(admin) }

        describe 'index' do
          it "gets the empty products" do
            ::Stripe::Product.expects(:list)
            get "/patrons/admin/products.json"
          end
        end

        describe 'create' do
          it 'is of product type service' do
            ::Stripe::Product.expects(:create).with(has_entry(:type, 'service'))
            post "/patrons/admin/products.json", params: {}
          end

          it 'has a name' do
            ::Stripe::Product.expects(:create).with(has_entry(:name, 'Jesse Pinkman'))
            post "/patrons/admin/products.json", params: { name: 'Jesse Pinkman' }
          end

          it 'has an active attribute' do
            ::Stripe::Product.expects(:create).with(has_entry(active: false))
            post "/patrons/admin/products.json", params: { active: false }
          end

          it 'has a metadata' do
            ::Stripe::Product.expects(:create).with(has_entry(:metadata, { group_name: 'discourse-user-group-name' }))
            post "/patrons/admin/products.json", params: { group_name: 'discourse-user-group-name' }
          end
        end
      end
    end
  end
end
