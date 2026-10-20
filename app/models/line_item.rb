class LineItem < ApplicationRecord
    belongs_to :quote
    belongs_to :item

    monetize :unit_price_cents

    def create_random_map
    end
end
