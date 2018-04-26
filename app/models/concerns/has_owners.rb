module HasOwners
  extend ActiveSupport::Concern
  included do
    has_many :owners,
      -> { order(:start) },
      dependent: :destroy,
      inverse_of: :item,
      as: :item
    accepts_nested_attributes_for :owners, allow_destroy: true

    def current_owner
      last_current_owner = nil
      today = Date.today
      self.owners.select do |owner|
        if owner.start <= today and owner.end > today
          last_current_owner = owner.user
        end
      end
      last_current_owner
    end
  end
end
