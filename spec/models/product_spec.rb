require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { build_stubbed(:product) }

  describe '#ActiveRecord associations' do
    it { expect(product).to have_many(:product_discounts) }
    it { expect(product).to have_many(:discounts).through(:product_discounts) }
  end

  describe '#item' do
    it { expect(product).to validate_presence_of(:item) }
  end

  describe '#price' do
    it { expect(product).to validate_presence_of(:price) }
  end

  describe '#item' do
    it { expect(product).to have_db_column(:item).of_type(:string) }
  end

  describe '#price' do
    it { expect(product).to have_db_column(:price).of_type(:decimal) }
  end

  describe '#status' do
    it { expect(product).to have_db_column(:status).of_type(:string)
                                                   .with_options(default: 'active') }
  end
end
