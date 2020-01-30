require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}
  
  let(:product) {FactoryGirl.create(:product)}
  let(:shopping_cart) {FactoryGirl.create(:cart, user_id: user.id, product_id: product.id)}
  
  describe "GET #index" do

    it "returns http success" do
      get :index
      
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #cart" do
    
    context "create a new cart for user if there is no cart exists" do
      it "returns http success" do
        shopping_cart = Cart.where(product_id: product.id)
        expect(shopping_cart.present?).to eq(false)

        params = {product: {id: product.id, quantity: 1}}
        post :cart, params: params

        response_body = JSON.parse(response.body)
        expect(response_body['success']).to eq(true)
        shopping_cart = shopping_cart.reload.last
        expect(shopping_cart.present?).to eq(true)
        expect(shopping_cart.quantity).to eq(1)
        expect(shopping_cart.status).to eq(Cart.statuses[:active])
      end
    end
    
    context "update cart for user if cart already exists" do
      it "returns http success" do
        allow_any_instance_of(ProductsController).to receive(:guest_user).and_return(user)
        shopping_cart.update_column(:status, Cart.statuses[:inactive])
        params = {product: {id: product.id, quantity: 4}}
        
        post :cart, params: params
        
        response_body = JSON.parse(response.body)
        expect(response_body['success']).to eq(true)
        shopping_cart.reload
        expect(shopping_cart.quantity).to eq(4)
        expect(shopping_cart.status).to eq(Cart.statuses[:active])
      end
    end
  end

  describe "GET #cart_clear" do
    it "update the cart status and quantity" do
      allow_any_instance_of(ProductsController).to receive(:guest_user).and_return(user)
      shopping_cart
      
      get :cart_clear

      expect(response).to have_http_status(:success)
      shopping_cart.reload
      expect(shopping_cart.quantity).to eq(0)
      expect(shopping_cart.status).to eq(Cart.statuses[:inactive])
    end
  end

  describe "GET #calculate" do
    let!(:product_b) {FactoryGirl.create(:product, item: 'B', price: 20)}
    let!(:product_c) {FactoryGirl.create(:product, item: 'C', price: 50)}
    let!(:product_d) {FactoryGirl.create(:product, item: 'D', price: 15)}
  
    let!(:discount) {FactoryGirl.create(:discount)}
    let!(:product_discount_a) {FactoryGirl.create(:product_discount, product_id: product.id, discount_id: discount.id)}
    let!(:discount_b) {FactoryGirl.create(:discount, price: 35, total_quantity: 2)}
    let!(:product_discount_b) {FactoryGirl.create(:product_discount, product_id: product_b.id, discount_id: discount_b.id, quantity: 2)}
    
    let!(:global_discount) {FactoryGirl.create(:global_discount)}
    
    let(:cart_b) {FactoryGirl.create(:cart, user_id: user.id, product_id: product_b.id)}
    let(:cart_c) {FactoryGirl.create(:cart, user_id: user.id, product_id: product_c.id)}
    let(:cart_d) {FactoryGirl.create(:cart, user_id: user.id, product_id: product_d.id)}

    context "when one item of product A, B and C in the cart" do
      let(:expected_response) do
        {
          "success" => true, "data" => {
            "cart_price" => "100.0", "discount_price" => 0, "additional_discount" => "0.0", "total" => "100.0"
          }
        }
      end
      
      it "returns json which will have best applicable discount details" do
        allow_any_instance_of(ProductsController).to receive(:guest_user).and_return(user)
        shopping_cart
        cart_b
        cart_c

        get :calculate

        response_body = JSON.parse(response.body)
        expect(response_body).to eq(expected_response)
      end
    end

    context "when product of A has 3 items and product of B has 2 items in the cart" do
      let(:expected_response) do
        {
          "success" => true, "data" => {
            "cart_price" => "130.0", "discount_price" => "110.0", "additional_discount" => "0.0", "total" => "110.0"
          }
        }
      end
      
      it "returns json which will have best applicable discount details" do
        allow_any_instance_of(ProductsController).to receive(:guest_user).and_return(user)
        shopping_cart.update_column(:quantity, 3)
        cart_b.update_column(:quantity, 2)

        get :calculate

        response_body = JSON.parse(response.body)
        expect(response_body).to eq(expected_response)
      end
    end

    context "when product of A has 3 items and product of B has 2 items and product C & D have one item in the cart" do
      let(:expected_response) do
        {
          "success" => true, "data" => {
            "cart_price" => "195.0", "discount_price" => "110.0", "additional_discount" => "20.0", "total" => "155.0"
          }
        }
      end
      
      it "returns json which will have best applicable discount details" do
        allow_any_instance_of(ProductsController).to receive(:guest_user).and_return(user)
        shopping_cart.update_column(:quantity, 3)
        cart_b.update_column(:quantity, 2)
        cart_c
        cart_d

        get :calculate

        response_body = JSON.parse(response.body)
        expect(response_body).to eq(expected_response)
      end
    end

    context "when product of A has 3 items and product of C & D have 1 item in the cart" do
      let(:expected_response) do
        {
          "success" => true, "data" => {
            "cart_price" => "155.0", "discount_price" => "75.0", "additional_discount" => "0.0", "total" => "140.0"
          }
        }
      end
      
      it "returns json which will have best applicable discount details" do
        allow_any_instance_of(ProductsController).to receive(:guest_user).and_return(user)
        shopping_cart.update_column(:quantity, 3)
        cart_c
        cart_d

        get :calculate

        response_body = JSON.parse(response.body)
        expect(response_body).to eq(expected_response)
      end
    end
  end
end
