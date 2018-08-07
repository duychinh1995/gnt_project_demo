class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details, dependent: :nullify
  has_many :orders, through: :order_detail
  validates :productname, presence: true
  validates :productcontent, presence: true
  validate  :image_size
  validates :price, presence: true, numericality: true
  validates :discount, numericality: true
  validates :onhand, numericality: true
  validates :status, presence: true
  validates :author, presence: true
  scope :order_by_created, ->{order(created_at: :desc)}
  scope :by_status, ->(status){where(status: status)}
  scope :by_product_id, ->(product_ids){where(id: product_ids)}
  enum status: {hide: 0, show: 1}
  delegate :title, to: :category, prefix: true, allow_nil: true
  mount_uploader :image, PictureUploader
  scope :by_product_id, ->(product_ids){where(id: product_ids)}
  scope :by_id, ->(product_id){where(id: product_id)}
  scope :by_history_order, ->(id){Product.joins(order_details: {order: :user}).where("user_id = ? ", id).uniq}
  scope :search_by_productname, ->(productname){where("productname LIKE ? ", "%#{productname}%") if productname.present?}
  scope :filter_by_alphabet, ->(alphabet){where("productname LIKE ?", "#{alphabet}%") if alphabet.present?}
  scope :filter_by_name, ->(name){where("productname LIKE ?", "%#{name}%") if name.present?}
  scope :filter_by_category, ->(category_id){where(category_id: category_id) if category_id.present?}
  scope :filter_by_min_price, ->(min_price){where("price >= ?", min_price) if min_price.present?}
  scope :filter_by_max_price, ->(max_price){where("price <= ?", max_price) if max_price.present?}

  def image_size
    return if image.size <= Settings.pic_size.megabytes
    errors.add(:image, t("model.user.pic_less_5"))
  end

  def self.import file
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      product = find_by(id: row["id"]) || new
      product.attributes = row.to_hash.slice(*row.to_hash.keys)
      product.save!
    end
  end

  def self.open_spreadsheet file
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise file.original_filename
    end
  end
end
