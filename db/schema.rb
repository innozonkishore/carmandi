# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091023050020) do

  create_table "ad_images", :force => true do |t|
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "content_type"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ad_locations", :force => true do |t|
    t.string   "name"
    t.integer  "ad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ads", :force => true do |t|
    t.string   "ad_name"
    t.string   "advertiser_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "ad_type"
    t.text     "comments"
    t.text     "code"
    t.boolean  "status",          :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_photos", :force => true do |t|
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "parent_id"
    t.string   "height"
    t.string   "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "width"
  end

  create_table "coupons", :force => true do |t|
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "content_type"
    t.string   "name"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",          :default => "active"
    t.boolean  "primary_display", :default => false
  end

  create_table "dealer_logos", :force => true do |t|
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "content_type"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dealers", :force => true do |t|
    t.string   "dealership_name"
    t.string   "city"
    t.string   "province"
    t.string   "address"
    t.string   "website_url"
    t.boolean  "account_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "upload_limit"
    t.string   "phone_number"
    t.string   "postal_code"
  end

  create_table "links", :force => true do |t|
    t.string   "name_english"
    t.integer  "position",     :default => 0
    t.boolean  "useful"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",       :default => "active"
    t.string   "name_hindi"
    t.string   "name_urdu"
    t.string   "name_punjabi"
  end

  create_table "listings", :force => true do |t|
    t.string   "name"
    t.string   "web_address"
    t.string   "full_address"
    t.string   "contact_info"
    t.text     "description"
    t.integer  "position",        :default => 0
    t.integer  "link_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "display_options"
    t.string   "status",          :default => "active"
  end

  create_table "payment_infos", :force => true do |t|
    t.string   "firstname"
    t.string   "middlename"
    t.string   "lastname"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.float    "price_option"
    t.integer  "vehicle_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.boolean  "category"
    t.boolean  "vehicle_make"
    t.boolean  "vehicle_model"
    t.boolean  "create_dealer"
    t.boolean  "modify_dealer"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "upload_vehicle"
    t.boolean  "modify_vehicle"
    t.boolean  "view_vehicle_list"
    t.boolean  "vehicle_trim_types"
    t.boolean  "add_link",           :default => true
    t.boolean  "add_listing"
    t.boolean  "manage_ad"
  end

  create_table "photos", :force => true do |t|
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "content_type"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "private_vehicles", :force => true do |t|
    t.string   "status",           :default => "active"
    t.string   "vin"
    t.string   "model_year"
    t.string   "fuel"
    t.string   "doors"
    t.string   "interior_color"
    t.string   "exterior_color"
    t.string   "trim"
    t.string   "engine_type"
    t.string   "transmission"
    t.string   "zipcode"
    t.text     "vin_data"
    t.text     "detailed_info"
    t.float    "mileage"
    t.float    "asking_price"
    t.float    "lat"
    t.float    "lng"
    t.float    "amount_collected", :default => 0.0
    t.integer  "user_id"
    t.integer  "vehicle_make_id"
    t.integer  "category_id"
    t.integer  "days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "drive"
    t.string   "model"
    t.text     "options"
    t.string   "plan"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "saved_vehicles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "unsupported_vehicles", :force => true do |t|
    t.string   "status",              :default => "active"
    t.string   "vin"
    t.string   "model_year"
    t.string   "fuel"
    t.string   "doors"
    t.string   "interior_color"
    t.string   "exterior_color"
    t.string   "trim"
    t.string   "body_style"
    t.string   "engine_type"
    t.string   "engine_displacement"
    t.string   "transmission"
    t.string   "zipcode"
    t.text     "vin_data"
    t.text     "detailed_info"
    t.float    "mileage"
    t.float    "asking_price"
    t.float    "lat"
    t.float    "lng"
    t.integer  "user_id"
    t.integer  "vehicle_make_id"
    t.integer  "category_id"
    t.integer  "days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "drive"
    t.string   "model"
    t.text     "options"
    t.string   "plan"
  end

  create_table "users", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "email"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "reset_code"
    t.string   "address"
    t.string   "phone_number"
    t.boolean  "active",                    :default => true
    t.string   "username"
    t.string   "fax_number"
    t.string   "zipcode"
  end

  create_table "vehicle_makes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
  end

  create_table "vehicle_models", :force => true do |t|
    t.string   "name"
    t.integer  "vehicle_make_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
  end

  create_table "vehicle_photos", :force => true do |t|
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "content_type"
    t.integer  "height"
    t.integer  "width"
    t.integer  "size"
    t.integer  "parent_id"
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicle_trim_types", :force => true do |t|
    t.string   "trim_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vehicles", :force => true do |t|
    t.string   "status",               :default => "active"
    t.string   "vin"
    t.string   "fuel"
    t.string   "body_styles"
    t.string   "interior_color"
    t.string   "exterior_color"
    t.text     "vin_data"
    t.text     "dealer_comment"
    t.boolean  "clearance_center",     :default => false
    t.float    "mileage"
    t.float    "price"
    t.integer  "dealer_id"
    t.integer  "vehicle_make_id"
    t.integer  "vehicle_model_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vehicle_trim_type_id"
    t.string   "trim"
    t.integer  "model_year"
    t.float    "lat"
    t.float    "lng"
    t.string   "zipcode"
    t.text     "standard_features"
    t.text     "optional_features"
    t.text     "other_features"
    t.string   "stock_number"
  end

  create_table "vin_queries", :force => true do |t|
    t.string   "vin"
    t.text     "vin_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
