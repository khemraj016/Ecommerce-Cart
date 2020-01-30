require 'rails_helper'

RSpec.describe ProductDiscount, type: :model do
  let(:product_discount) { build_stubbed(:product_discount) }

  describe '#ActiveRecord associations' do
    it { should belong_to(:product) }
    it { should belong_to(:discount) }
  end

  describe '#quantity' do
    it { expect(product_discount).to validate_presence_of(:quantity) }
  end

  describe '#product_id' do
    it { expect(product_discount).to have_db_column(:product_id).of_type(:integer) }
  end

  describe '#discount_id' do
    it { expect(product_discount).to have_db_column(:discount_id).of_type(:integer) }
  end

  describe '#quantity' do
    it { expect(product_discount).to have_db_column(:quantity).of_type(:integer) }
  end
end
