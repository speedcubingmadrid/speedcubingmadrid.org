class Owner < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user

  validates_presence_of :item
  validates_presence_of :user

  validate :dates_must_be_valid
  private def dates_must_be_valid
    return errors.add(:start, "Fecha de inicio no válida") unless start.present?
    return errors.add(:end, "Fecha de finalización no válida") unless self[:end].present?

    if self[:end] < start
      errors.add(:end, "La fecha de finalización no puede ser anterior a la fecha de inicio")
    end
  end
end
