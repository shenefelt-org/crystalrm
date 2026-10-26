class Avo::Resources::Pay::Customer < Avo::BaseResource
  self.icon = "tabler/outline/chart-bar"
  self.title = "Customers"

  # self.avatar = {
  #   source: :avatar
  # }
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def navigation_label
    "Balance Transactions"
  end

  def plural_name
    "Balance Transactions"
  end

  def fields
    field :id, as: :id
    # field :avatar, as: :avatar
    field :customer, as: :belongs_to
    field :amount, as: :number
    field :amount_currency, as: :text
    field :stripe_balance_transaction_id, as: :text
    field :description, as: :textarea
    field :transaction_type, as: :number
  end
end
