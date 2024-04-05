# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_04_02_072312) do
  create_table "MSreplication_options", id: false, force: :cascade do |t|
    t.string "optname", null: false
    t.boolean "value", null: false
    t.integer "major_version", null: false
    t.integer "minor_version", null: false
    t.integer "revision", null: false
    t.integer "install_failures", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spt_fallback_db", id: false, force: :cascade do |t|
    t.varchar "xserver_name", limit: 30, null: false
    t.datetime "xdttm_ins", precision: nil, null: false
    t.datetime "xdttm_last_ins_upd", precision: nil, null: false
    t.integer "xfallback_dbid", limit: 2
    t.varchar "name", limit: 30, null: false
    t.integer "dbid", limit: 2, null: false
    t.integer "status", limit: 2, null: false
    t.integer "version", limit: 2, null: false
  end

  create_table "spt_fallback_dev", id: false, force: :cascade do |t|
    t.varchar "xserver_name", limit: 30, null: false
    t.datetime "xdttm_ins", precision: nil, null: false
    t.datetime "xdttm_last_ins_upd", precision: nil, null: false
    t.integer "xfallback_low"
    t.char "xfallback_drive", limit: 2
    t.integer "low", null: false
    t.integer "high", null: false
    t.integer "status", limit: 2, null: false
    t.varchar "name", limit: 30, null: false
    t.varchar "phyname", limit: 127, null: false
  end

  create_table "spt_fallback_usg", id: false, force: :cascade do |t|
    t.varchar "xserver_name", limit: 30, null: false
    t.datetime "xdttm_ins", precision: nil, null: false
    t.datetime "xdttm_last_ins_upd", precision: nil, null: false
    t.integer "xfallback_vstart"
    t.integer "dbid", limit: 2, null: false
    t.integer "segmap", null: false
    t.integer "lstart", null: false
    t.integer "sizepg", null: false
    t.integer "vstart", null: false
  end

  create_table "spt_monitor", id: false, force: :cascade do |t|
    t.datetime "lastrun", precision: nil, null: false
    t.integer "cpu_busy", null: false
    t.integer "io_busy", null: false
    t.integer "idle", null: false
    t.integer "pack_received", null: false
    t.integer "pack_sent", null: false
    t.integer "connections", null: false
    t.integer "pack_errors", null: false
    t.integer "total_read", null: false
    t.integer "total_write", null: false
    t.integer "total_errors", null: false
  end

end
