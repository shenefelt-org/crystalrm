class Avo::Resources::Subscription < Avo::BaseResource
  self.icon = "tabler/outline/credit-card"
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
    field :customer, as: :belongs_to
    field :plan, as: :belongs_to
    field :stripe_subscription_id, as: :text
    field :status, as: :text
    field :current_period_end, as: :date_time
  end
end
