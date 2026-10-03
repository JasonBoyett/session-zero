 # frozen_string_literal: true

 {
  type: :object,
  required: User.user_visible_attributes_for_openapi,
  properties: {
    id: { type: :integer },
    email: { type: :string, format: :email, nullable: true },
    name: { type: :string, nullable: true },
    profilePicture: { type: :string, nullable: true },
    createdAt: { type: :string, format: "date-time" },
    updatedAt: { type: :string, format: "date-time" }
  }
}
