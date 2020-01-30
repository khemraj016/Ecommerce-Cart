require 'rails_helper'

RSpec.describe GlobalDiscount, type: :model do
  let(:global_discount) { build_stubbed(:global_discount) }

  describe '#cart_min_value' do
    it { expect(global_discount).to validate_presence_of(:cart_min_value) }
  end

  describe '#discount' do
    it { expect(global_discount).to validate_presence_of(:discount) }
  end

  describe '#cart_min_value' do
    it { expect(global_discount).to have_db_column(:cart_min_value).of_type(:decimal) }
  end

  describe '#discount' do
    it { expect(global_discount).to have_db_column(:discount).of_type(:decimal) }
  end

  describe '#status' do
    it { expect(global_discount).to have_db_column(:status).of_type(:string)
                                                           .with_options(default: 'active') }
  end
end
