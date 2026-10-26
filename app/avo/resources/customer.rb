class Avo::Resources::Customer < Avo::BaseResource
  self.icon = "tabler/outline/user"
  # self.avatar = {
  #   source: :avatar
  # }
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    # field :avatar, as: :avatar
    field :first_name, as: :text
    field :last_name, as: :text
    field :email, as: :text
    field :stripe_customer_id, as: :text
    field :company_name, as: :text
    field :balance_cents, as: :number
    field :balance_currency, as: :text
    field :description, as: :textarea
    field :past_due, as: :boolean
    field :active_customer, as: :boolean
    field :projects, as: :has_many
    field :quotes, as: :has_many
    field :account_balance_transactions, as: :has_many
    field :pay_customers, as: :has_many
    field :pay_charges, as: :has_many, through: :pay_customers
    field :pay_subscriptions, as: :has_many, through: :pay_customers
    field :payment_processor, as: :has_one
  end
end
