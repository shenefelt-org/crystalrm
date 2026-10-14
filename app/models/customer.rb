class Customer < ApplicationRecord
    has_many :projects, dependent: :destroy
    has_many :orders, dependent: :destroy
    # concat the full name from the first and last
    def full_name
        "#{first_name} #{last_name}"
    end
end
