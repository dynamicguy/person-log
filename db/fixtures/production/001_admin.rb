User.delete_all
User.seed(:id, [
    id: 1,
    email: "admin@personlog.com",
    name: "Administrator",
    password: "please",
    password_confirmation: "please",
    confirmed_at: Time.now
])