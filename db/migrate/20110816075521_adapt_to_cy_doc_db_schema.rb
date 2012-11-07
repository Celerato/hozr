# encoding: UTF-8

class AdaptToCyDocDbSchema < ActiveRecord::Migration
  def self.up
    # Add missing columns
    add_column :doctors, "ean_party", :string, :limit => 13
    add_column :doctors, "zsr", :string, :limit => 7
    add_column :doctors, "remarks", :text
    add_column :doctors, "imported_id", :integer

    add_column :honorific_prefixes, :position, :integer

    add_column :insurances, "ean_party", :string, :limit => 13
    add_column :insurances, "role", :string
    add_column :insurances, "group_ean_party", :string, :limit => 13
    add_column :insurances, "imported_id", :integer

    add_index "insurances", ["ean_party"], :name => "index_insurances_on_ean_party"
    add_index "insurances", ["group_ean_party"], :name => "index_insurances_on_group_ean_party"
    add_index "insurances", ["imported_id"], :name => "index_insurances_on_imported_id"
    add_index "insurances", ["role"], :name => "index_insurances_on_role"

    add_column :offices, :printers, :string

    add_column :patients, "active", :boolean, :default => true,  :null => false
    add_column :patients, "name", :string
    add_column :patients, "imported_id", :integer

    add_index "patients", ["doctor_patient_nr"]

    add_column :phone_numbers, :vcard_id, :integer
    add_index "phone_numbers", ["phone_number_type"], :name => "index_phone_numbers_on_phone_number_type"
    add_index "phone_numbers", ["vcard_id"], :name => "phone_numbers_vcard_id_index"

    # Create new tables
    create_table "accounts", :force => true do |t|
      t.string   "number"
      t.integer  "bank_id"
      t.string   "esr_id"
      t.string   "pc_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "type"
      t.integer  "holder_id"
      t.string   "holder_type"
      t.string   "title"
      t.string   "code"
    end

    create_table "appointments", :force => true do |t|
      t.integer  "patient_id"
      t.integer  "recall_id" 
      t.integer  "treatment_id"
      t.text     "remarks"
      t.string   "state"  
      t.datetime "created_at"
      t.datetime "updated_at"
      t.date     "date"
      t.time     "from"
      t.time     "to"  
    end

    add_index "appointments", ["patient_id"], :name => "index_appointments_on_patient_id"
    add_index "appointments", ["recall_id"], :name => "index_appointments_on_recall_id"  
    add_index "appointments", ["state"], :name => "index_appointments_on_state"
    add_index "appointments", ["treatment_id"], :name => "index_appointments_on_treatment_id"

    create_table "banks", :force => true do |t|
      t.integer  "vcard_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "bookings", :force => true do |t|
      t.string   "title",             :limit => 100
      t.decimal  "amount",                            :precision => 8, :scale => 2
      t.integer  "credit_account_id"
      t.integer  "debit_account_id" 
      t.date     "value_date"
      t.string   "comments",          :limit => 1000,                               :default => ""
      t.integer  "reference_id"
      t.string   "reference_type"
      t.integer  "imported_id"   
      t.datetime "created_at"    
      t.datetime "updated_at"    
    end

    add_index "bookings", ["credit_account_id"], :name => "index_bookings_on_credit_account_id"
    add_index "bookings", ["debit_account_id"], :name => "index_bookings_on_debit_account_id"  
    add_index "bookings", ["reference_id", "reference_type"], :name => "index_bookings_on_reference_id_and_reference_type"

    create_table "diagnoses", :force => true do |t|
      t.string   "type"
      t.string   "code"
      t.text     "text"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "diagnoses_sessions", :id => false, :force => true do |t|
      t.integer "diagnosis_id"
      t.integer "session_id"  
    end

    create_table "diagnoses_treatments", :id => false, :force => true do |t|
      t.integer "diagnosis_id"
      t.integer "treatment_id"
    end

    create_table "drug_articles", :force => true do |t|
      t.string   "code"
      t.string   "group_code" 
      t.string   "assort_key1"
      t.string   "assort_key2"
      t.integer  "drug_product_id"
      t.string   "swissmedic_cat"
      t.string   "swissmedic_no"
      t.boolean  "hospital_only"
      t.boolean  "clinical"
      t.string   "article_type"
      t.integer  "vat_class_id"
      t.boolean  "active"
      t.boolean  "insurance_limited"
      t.float    "insurance_limitation_points"
      t.boolean  "grand_frere" 
      t.boolean  "stock_fridge"
      t.string   "stock_temperature"
      t.boolean  "narcotic"   
      t.boolean  "under_bg"   
      t.integer  "expires"    
      t.float    "quantity"   
      t.text     "description"
      t.text     "name"
      t.string   "quantity_unit"
      t.string   "package_type"
      t.string   "multiply"
      t.string   "alias"
      t.boolean  "higher_co_payment"
      t.integer  "number_of_pieces" 
      t.datetime "created_at"
      t.datetime "updated_at"
      t.date     "out_of_sale_on"
    end

    add_index "drug_articles", ["code"], :name => "index_drug_articles_on_code"
    add_index "drug_articles", ["drug_product_id"], :name => "index_drug_articles_on_drug_product_id"
    add_index "drug_articles", ["vat_class_id"], :name => "index_drug_articles_on_vat_class_id"

    create_table "drug_prices", :force => true do |t|
      t.date     "valid_from"
      t.decimal  "price",           :precision => 8, :scale => 2
      t.string   "price_type"
      t.integer  "drug_article_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "drug_prices", ["drug_article_id"], :name => "index_drug_prices_on_drug_article_id"
    add_index "drug_prices", ["price_type"], :name => "index_drug_prices_on_price_type"
    add_index "drug_prices", ["valid_from"], :name => "index_drug_prices_on_valid_from"

    create_table "drug_products", :force => true do |t|
      t.text     "description"
      t.string   "name"
      t.string   "second_name"
      t.string   "size"
      t.string   "info"
      t.boolean  "original"
      t.string   "generic_group"
      t.integer  "drug_code1_id"
      t.integer  "drug_code2_id"
      t.integer  "therap_code1_id"
      t.integer  "therap_code2_id"
      t.integer  "drug_compendium_id"
      t.string   "application_code"  
      t.float    "dose_amount"
      t.string   "dose_units" 
      t.string   "dose_application"
      t.integer  "interaction_relevance"
      t.boolean  "active"
      t.integer  "partner_id"
      t.integer  "drug_monograph_id"
      t.boolean  "galenic"
      t.integer  "galenic_code_id"
      t.float    "concentration"  
      t.string   "concentration_unit"
      t.string   "special_drug_group_code"
      t.string   "drug_for"
      t.boolean  "probe_suited"
      t.float    "life_span"   
      t.float    "application_time"
      t.string   "excip_text"
      t.string   "excip_quantity"
      t.string   "excip_comment" 
      t.datetime "created_at"    
      t.datetime "updated_at"    
    end

    create_table "drug_substances", :id => false, :force => true do |t|
      t.string   "id"
      t.string   "name"
      t.string   "description"
      t.datetime "created_at" 
      t.datetime "updated_at" 
    end

    create_table "esr_files", :force => true do |t|
      t.integer  "size"
      t.string   "content_type"
      t.string   "filename"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "remarks",      :default => ""
    end

    create_table "esr_records", :force => true do |t|
      t.string   "bank_pc_id"
      t.string   "reference" 
      t.decimal  "amount",            :precision => 8, :scale => 2
      t.string   "payment_reference"
      t.date     "payment_date"
      t.date     "transaction_date"
      t.date     "value_date"
      t.string   "microfilm_nr"
      t.string   "reject_code" 
      t.string   "reserved"    
      t.string   "payment_tax" 
      t.datetime "created_at"  
      t.datetime "updated_at"  
      t.integer  "booking_id"  
      t.integer  "invoice_id"  
      t.integer  "esr_file_id" 
      t.string   "remarks",                                         :default => ""
      t.string   "state",                                                           :null => false
    end

    add_index "esr_records", ["booking_id"], :name => "index_esr_records_on_booking_id"
    add_index "esr_records", ["esr_file_id"], :name => "index_esr_records_on_esr_file_id"
    add_index "esr_records", ["invoice_id"], :name => "index_esr_records_on_invoice_id"  

    create_table "insurance_policies", :force => true do |t|
      t.integer  "insurance_id"
      t.integer  "patient_id"  
      t.date     "valid_from"  
      t.date     "valid_to"    
      t.string   "number"      
      t.string   "policy_type" 
      t.datetime "created_at"  
      t.datetime "updated_at"  
    end

    add_index "insurance_policies", ["insurance_id"], :name => "index_insurance_policies_on_insurance_id"
    add_index "insurance_policies", ["patient_id"], :name => "index_insurance_policies_on_patient_id"
    add_index "insurance_policies", ["policy_type"], :name => "index_insurance_policies_on_policy_type"

    create_table "invoices", :force => true do |t|
      t.text     "remark"
      t.integer  "tiers_id"
      t.integer  "law_id"  
      t.integer  "treatment_id"
      t.text     "role_title"  
      t.text     "role_type"   
      t.string   "place_type",               :default => "Praxis"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state",                    :default => "prepared"
      t.date     "value_date"
      t.date     "due_date"  
      t.integer  "invoice_replaced_by"
      t.integer  "imported_id"
      t.integer  "imported_invoice_id"
      t.string   "imported_esr_reference"
      t.date     "reminder_due_date"
      t.date     "second_reminder_due_date"
      t.date     "third_reminder_due_date" 
    end

    add_index "invoices", ["invoice_replaced_by"], :name => "index_invoices_on_invoice_replaced_by"
    add_index "invoices", ["law_id"], :name => "index_invoices_on_law_id"
    add_index "invoices", ["state"], :name => "index_invoices_on_state"  
    add_index "invoices", ["tiers_id"], :name => "index_invoices_on_tiers_id"
    add_index "invoices", ["treatment_id"], :name => "index_invoices_on_treatment_id"

    create_table "invoices_service_records", :id => false, :force => true do |t|
      t.integer "invoice_id"
      t.integer "service_record_id"
    end

    add_index "invoices_service_records", ["invoice_id"], :name => "index_invoices_service_records_on_invoice_id"
    add_index "invoices_service_records", ["service_record_id"], :name => "index_invoices_service_records_on_service_record_id"

    create_table "invoices_sessions", :id => false, :force => true do |t|
      t.integer "invoice_id"
      t.integer "session_id"
    end

    add_index "invoices_sessions", ["invoice_id", "session_id"], :name => "index_invoices_sessions_on_invoice_id_and_session_id"

    create_table "laws", :force => true do |t|
      t.string   "insured_id"
      t.string   "case_id"   
      t.datetime "case_date" 
      t.string   "ssn"
      t.string   "nif"
      t.string   "type"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "medical_cases", :force => true do |t|
      t.integer  "patient_id"
      t.integer  "doctor_id" 
      t.datetime "duration_from"
      t.datetime "duration_to"  
      t.text     "remarks"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "type"
      t.integer  "diagnosis_id"
      t.integer  "treatment_id"
      t.integer  "imported_id" 
    end

    add_index "medical_cases", ["diagnosis_id"], :name => "index_medical_cases_on_diagnosis_id"
    add_index "medical_cases", ["doctor_id"], :name => "index_medical_cases_on_doctor_id"
    add_index "medical_cases", ["patient_id"], :name => "index_medical_cases_on_patient_id"
    add_index "medical_cases", ["treatment_id"], :name => "index_medical_cases_on_treatment_id"
    add_index "medical_cases", ["type"], :name => "index_medical_cases_on_type"


    create_table "recalls", :force => true do |t|
      t.integer  "patient_id"
      t.date     "due_date"  
      t.text     "remarks"   
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state"
      t.integer  "appointment_id"
      t.datetime "sent_at"
    end

    add_index "recalls", ["appointment_id"], :name => "index_recalls_on_appointment_id"
    add_index "recalls", ["patient_id"], :name => "index_recalls_on_patient_id"
    add_index "recalls", ["state"], :name => "index_recalls_on_state"

    create_table "service_items", :force => true do |t|
      t.integer "tariff_item_id"
      t.integer "tariff_item_group_id"
      t.decimal "quantity",                           :precision => 8, :scale => 2
      t.string  "ref_code",             :limit => 10
      t.integer "position"
    end

    add_index "service_items", ["ref_code"], :name => "index_service_items_on_ref_code"
    add_index "service_items", ["tariff_item_group_id"], :name => "index_service_items_on_tariff_item_group_id"
    add_index "service_items", ["tariff_item_id"], :name => "index_service_items_on_tariff_item_id"

    create_table "service_records", :force => true do |t|
      t.string   "treatment",                                                       :default => "ambulatory"
      t.string   "tariff_type",                                                     :default => "001"
      t.string   "tariff_version",     :limit => 10
      t.string   "contract_number",    :limit => 10
      t.string   "code",               :limit => 10,                                                             :null => false
      t.string   "ref_code",           :limit => 10
      t.integer  "session",                                                         :default => 1
      t.decimal  "quantity",                          :precision => 8, :scale => 2, :default => 1.0
      t.datetime "date",                                                                                         :null => false
      t.integer  "provider_id"
      t.integer  "responsible_id"
      t.integer  "location_id"   
      t.string   "billing_role",                                                    :default => "both"
      t.string   "medical_role",                                                    :default => "self_employed"
      t.string   "body_location",                                                   :default => "none"
      t.decimal  "unit_factor_mt",                    :precision => 3, :scale => 2
      t.decimal  "scale_factor_mt",                   :precision => 3, :scale => 2, :default => 1.0
      t.decimal  "external_factor_mt",                :precision => 3, :scale => 2, :default => 1.0
      t.decimal  "amount_mt",                         :precision => 8, :scale => 2, :default => 0.0
      t.decimal  "unit_factor_tt",                    :precision => 3, :scale => 2
      t.decimal  "scale_factor_tt",                   :precision => 3, :scale => 2, :default => 1.0
      t.decimal  "external_factor_tt",                :precision => 3, :scale => 2, :default => 1.0
      t.decimal  "amount_tt",                         :precision => 8, :scale => 2, :default => 0.0
      t.decimal  "vat_rate",                          :precision => 5, :scale => 2, :default => 0.0
      t.decimal  "splitting_factor",                  :precision => 3, :scale => 2, :default => 1.0
      t.boolean  "validate",                                                        :default => false
      t.boolean  "obligation",                                                      :default => true 
      t.string   "section_code",       :limit => 6
      t.string   "remark",             :limit => 700
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "patient_id"
      t.decimal  "unit_mt",                           :precision => 8, :scale => 2
      t.decimal  "unit_tt",                           :precision => 8, :scale => 2
      t.integer  "vat_class_id"
      t.integer  "imported_id" 
    end

    add_index "service_records", ["patient_id"], :name => "index_service_records_on_patient_id"
    add_index "service_records", ["provider_id"], :name => "index_service_records_on_provider_id"
    add_index "service_records", ["responsible_id"], :name => "index_service_records_on_responsible_id"
    add_index "service_records", ["vat_class_id"], :name => "index_service_records_on_vat_class_id"

    create_table "service_records_sessions", :id => false, :force => true do |t|
      t.integer "service_record_id"
      t.integer "session_id"
    end

    add_index "service_records_sessions", ["service_record_id"], :name => "index_service_records_sessions_on_service_record_id"
    add_index "service_records_sessions", ["session_id"], :name => "index_service_records_sessions_on_session_id"
    create_table "sessions", :force => true do |t|
      t.integer  "patient_id"
      t.datetime "duration_from"
      t.datetime "duration_to"  
      t.text     "remarks"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "state",         :default => "open"
      t.integer  "treatment_id"
      t.integer  "imported_id" 
    end

    add_index "sessions", ["patient_id"], :name => "index_sessions_on_patient_id"
    add_index "sessions", ["state"], :name => "index_sessions_on_state"
    add_index "sessions", ["treatment_id"], :name => "index_sessions_on_treatment_id"

    create_table "tariff_codes", :force => true do |t|
      t.string   "tariff_code"
      t.string   "record_type_v4"
      t.string   "record_type_v5"
      t.string   "description"   
      t.date     "valid_from"    
      t.date     "valid_to"      
      t.datetime "created_at"    
      t.datetime "updated_at"    
    end

    create_table "tariff_items", :force => true do |t|
      t.decimal  "amount_mt",                   :precision => 8, :scale => 2
      t.decimal  "amount_tt",                   :precision => 8, :scale => 2
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "code",          :limit => 10
      t.text     "remark"
      t.boolean  "obligation",                                                :default => true
      t.string   "type"
      t.string   "tariff_type",   :limit => 3
      t.integer  "vat_class_id"
      t.integer  "imported_id" 
      t.string   "imported_type"
    end

    add_index "tariff_items", ["code"], :name => "index_tariff_items_on_code"
    add_index "tariff_items", ["tariff_type"], :name => "index_tariff_items_on_tariff_type"
    add_index "tariff_items", ["type"], :name => "index_tariff_items_on_type"
    add_index "tariff_items", ["vat_class_id"], :name => "index_tariff_items_on_vat_class_id"

    create_table "tiers", :force => true do |t|
      t.integer  "biller_id"
      t.integer  "provider_id"
      t.integer  "insurance_id"
      t.integer  "patient_id"  
      t.integer  "guarantor_id"
      t.integer  "referrer_id" 
      t.integer  "employer_id" 
      t.string   "type"
      t.string   "payment_periode"
      t.boolean  "invoice_modification"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "tiers", ["biller_id"], :name => "index_tiers_on_biller_id"
    add_index "tiers", ["employer_id"], :name => "index_tiers_on_employer_id"
    add_index "tiers", ["guarantor_id"], :name => "index_tiers_on_guarantor_id"
    add_index "tiers", ["insurance_id"], :name => "index_tiers_on_insurance_id"
    add_index "tiers", ["patient_id"], :name => "index_tiers_on_patient_id"
    add_index "tiers", ["provider_id"], :name => "index_tiers_on_provider_id"
    add_index "tiers", ["referrer_id"], :name => "index_tiers_on_referrer_id"

    create_table "treatments", :force => true do |t|
      t.date     "date_begin"
      t.date     "date_end"  
      t.string   "canton"    
      t.string   "reason"    
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "patient_id"
      t.integer  "law_id"
      t.integer  "referrer_id"
      t.string   "place_type",  :default => "Praxis"
      t.integer  "imported_id"
    end

    add_index "treatments", ["law_id"], :name => "index_treatments_on_law_id"
    add_index "treatments", ["patient_id"], :name => "index_treatments_on_patient_id"
    add_index "treatments", ["referrer_id"], :name => "index_treatments_on_referrer_id"

    create_table "vat_classes", :force => true do |t|
      t.date     "valid_from"
      t.decimal  "rate",       :precision => 5, :scale => 2
      t.string   "code"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "vat_classes", ["code"], :name => "index_vat_classes_on_code"
    add_index "vat_classes", ["valid_from"], :name => "index_vat_classes_on_valid_from"
  end

  def self.down
  end
end
