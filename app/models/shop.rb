class Shop < ApplicationRecord
    validates :name, uniqueness: true, presence: true

    has_many :links, dependent: :destroy
end
