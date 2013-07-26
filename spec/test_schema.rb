ActiveRecord::Schema.define(version: 20130315203352) do
  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end
end
