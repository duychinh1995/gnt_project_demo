class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  belongs_to :parent, class_name: Category.name, foreign_key: :parent_id, optional: true, inverse_of: :children
  has_many :children, class_name: Category.name, foreign_key: :parent_id, dependent: :nullify, inverse_of: :parent
  validates :catcontent, presence: true
  validates :title, presence: true
  validates :status, presence: true
  scope :ordered_by_title, ->{order(title: :asc)}
  scope :by_ids, ->(ids){where.not(id: ids)}
  scope :search_by_title, ->(title){where("title LIKE ? ", "%#{title}%") if title.present?}
  enum status: {hide: 0, show: 1}

  def family_name
    return "" unless parent
    parent.family_name + parent.title + " >> "
  end

  def long_name
    family_name + title
  end
end
