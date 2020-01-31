ActiveAdmin.register Discount do
  permit_params :price, :total_quantity, :status, :name

  filter :price
  filter :total_quantity
  filter :status
  filter :created_at

  actions :all, :except => [:destroy]

  index download_links: false

  before_action :validate_discount_price, only: [:create, :update]

  controller do
    def validate_discount_price
      discount_price = params[:discount][:price].to_d
      product_discounts = params[:discount][:product_discounts_attributes]
      return if product_discounts.blank?

      product_ids = []
      quantities = []
      product_discounts.values.each do |product_discount|
        product_ids << product_discount['product_id']
        quantities << product_discount['quantity']
      end
      quantity_value = quantities.map(&:to_d).sum
      price = Product.where(id: product_ids).sum(:price).to_d * quantity_value

      total_quantity = params[:discount][:total_quantity].to_d
      raise I18n.t('discount.price_error') if discount_price >= price
      raise I18n.t('discount.quantity_error') if total_quantity != quantities.map(&:to_d).sum
    rescue StandardError => ex
      flash[:error] = ex.message
      redirect_to "/admin/discounts/#{params[:id]}"
    end
  end

  before_save do
    product_discounts = params[:discount][:product_discounts_attributes]
    product_discounts.each do |key, value|
      product_discount = ProductDiscount.where(
        discount_id: params[:id], product_id: value[:product_id], quantity: value[:quantity]
        ).first_or_create
    end
  end

  show do
    panel 'Discount' do
      attributes_table_for discount do
        row :id
        row :name
        row :price
        row :total_quantity
        row :status
        row :created_at
        row :updated_at
      end
    end

    discount.product_discounts.includes(:product).each_with_index do |product_discount, index|
      panel "Product Discount #{index+1} Details" do
        attributes_table_for product_discount do
          row 'Product Item' do |product|
            product_discount.product.item
          end
          row :quantity
        end
      end
    end
  end

  form do |discount|
    discount.inputs 'Create/Edit Vendor Lead' do
      discount.input :name, label: 'About Discount'
      discount.input :price
      discount.input :total_quantity
      discount.input :status, collection: Discount.statuses.values
    end
    
    discount.inputs 'Product Gallery' do
      discount.has_many :product_discounts do |product_discount|
        product_discount.input :product_id, as: :select, collection: Product.active.pluck('item, id')
        product_discount.input :quantity
      end
    end
    discount.actions
  end
end
