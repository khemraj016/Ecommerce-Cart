require 'rails_helper'

RSpec.describe Discount, type: :model do
  let(:discount) { build_stubbed(:discount) }

  describe '#ActiveRecord associations' do
    it { expect(discount).to have_many(:product_discounts) }
  end

  describe '#price' do
    it { expect(discount).to validate_presence_of(:price) }
  end

  describe '#total_quantity' do
    it { expect(discount).to validate_presence_of(:total_quantity) }
  end

  describe '#name' do
    it { expect(discount).to have_db_column(:name).of_type(:string) }
  end

  describe '#price' do
    it { expect(discount).to have_db_column(:price).of_type(:decimal) }
  end

  describe '#total_quantity' do
    it { expect(discount).to have_db_column(:total_quantity).of_type(:integer) }
  end

  describe '#status' do
    it { expect(discount).to have_db_column(:status).of_type(:string)
                                                    .with_options(default: 'active') }
  end
end
