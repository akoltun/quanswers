class Tag < ActiveRecord::Base
  has_and_belongs_to_many :questions

  validates :name, presence: true
  strip_attributes only: :name, collapse_spaces: true
  validate :name_cannot_contain_comma

  before_validation :lowercase_name
  before_save :create_color_index

  private

  def lowercase_name
    self.name.downcase! if name.present?
  end

  def name_cannot_contain_comma
    if name && name.include?(',')
      errors.add(:name, "can't contain comma")
    end
  end

  def create_color_index
    self.color_index = (Tag.maximum("color_index") || -1) + 1
  end
end
