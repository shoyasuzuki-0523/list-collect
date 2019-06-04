class Link < ApplicationRecord
    validates :title, presence: true, uniqueness: true
    validates :url, presence: true, uniqueness: true

    belongs_to :shop
end
