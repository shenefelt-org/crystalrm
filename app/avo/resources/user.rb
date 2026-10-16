class Avo::Resources::User < Avo::BaseResource
  self.icon = "tabler/outline/users"
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
    field :email, as: :text
    field :sign_in_count, as: :number
    field :current_sign_in_at, as: :date_time
    field :last_sign_in_at, as: :date_time
    field :current_sign_in_ip, as: :text
    field :last_sign_in_ip, as: :text
  end
end
