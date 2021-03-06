# encoding: utf-8

class Patient < ActiveRecord::Base
  # Base data
  validates :birth_date, :presence => true
  validates :sex, :presence => true

  # Insurance
  has_many :insurance_policies, :autosave => true, :validate => true
  accepts_nested_attributes_for :insurance_policies, :reject_if => proc { |attrs| attrs['insurance_id'].blank? }
  has_many :insurances, :through => :insurance_policies

  def kvg_insurance_policy
    policy = insurance_policies.by_policy_type('KVG').first

    policy ||= insurance_policies.build(:policy_type => 'KVG')

    return policy
  end

  def insurance
    kvg_insurance_policy.insurance
  end
  def insurance=(value)
    kvg_insurance_policy.insurance = value
    kvg_insurance_policy.save
  end

  def insurance_id
    kvg_insurance_policy.insurance_id
  end
  def insurance_id=(value)
    kvg_insurance_policy.insurance_id = value
    kvg_insurance_policy.save
  end

  def insurance_nr
    kvg_insurance_policy.number
  end
  def insurance_nr=(value)
    kvg_insurance_policy.number = value
    kvg_insurance_policy.save
  end

  # Doctor
  belongs_to :doctor
  def doctor_id
    self[:doctor_id] || cases.last.try(:doctor_id)
  end

  def doctor_with_history_fallback
    doctor_without_history_fallback || cases.last.try(:doctor)
  end
  alias_method_chain :doctor, :history_fallback

  # Address
  has_one :vcard, :as => :object, :conditions => {:vcard_type => 'private'}
  accepts_nested_attributes_for :vcard
  def vcard_with_autobuild
    vcard_without_autobuild || build_vcard
  end
  alias_method_chain :vcard, :autobuild

  has_one :billing_vcard, :class_name => 'Vcard', :as => :object, :conditions => {:vcard_type => 'billing'}
  accepts_nested_attributes_for :billing_vcard
  def billing_vcard_with_autobuild
    billing_vcard_without_autobuild || build_billing_vcard
  end
  alias_method_chain :billing_vcard, :autobuild

  def invoice_vcard
    if use_billing_address?
      return billing_vcard
    else
      return vcard
    end
  end

  validate :validate_address
  def validate_address
    vcard.validate_name
    errors.add(:base, 'name invalid for vcard') if vcard.errors.present?

    invoice_vcard.validate_name
    errors.add(:base, 'name invalid for invoice_vcard') if invoice_vcard.errors.present?
    invoice_vcard.address.validate_address
    errors.add(:base, 'address invalid for invoice_vcard') if invoice_vcard.address.errors.present?
  end

  before_save do
    vcard.family_name = UnicodeUtils.upcase(vcard.family_name)
    billing_vcard.family_name = UnicodeUtils.upcase(billing_vcard.family_name || '')
  end

  # Cases
  has_many :cases, :order => 'id DESC'
  has_many :finished_cases, :class_name => 'Case', :conditions => 'screened_at IS NOT NULL', :order => 'id DESC'

  # Invoices
  scope :dunning_stopped, where(:dunning_stop => true)

  # CyDoc associations
  has_many :appointments
  has_many :medical_cases
  has_many :recalls
  has_many :service_records
  has_many :sessions
  has_many :tiers
  has_many :treatments

  def self.by_text(query, options = {})
    options.merge!({:match_mode => :extended, :order => 'family_name ASC, given_name ASC'})

    search(build_query(query), options)
  end

  def self.quote_query(query)
    "\"#{query}\""
  end

  def self.build_query_part(part)
    case part
    when /([0-9]{1,2})\/([0-9]{1,5})/
      # Use .to_i as leading 0 let's them be interpreted as octal otherwise
      eingangs_nr = "%02i/%05i" % [$1.to_i, $2.to_i]
      quote_query(eingangs_nr)
    when /[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{2,4}/
      day, month, year = part.split('.').map(&:to_i)
      if year < 100
        year1900 = quote_query(Date.new(1900 + year, month, day).to_s(:db))
        year2000 = quote_query(Date.new(2000 + year, month, day).to_s(:db))
        return "(#{year1900} | #{year2000})"
      else
        return quote_query(Date.new(year, month, day).to_s(:db))
      end
    else
      return part
    end
  end

  def self.build_query(query)
    return '' unless query.present?

    parts = query.split(/ /)

    parts.map{|part| build_query_part(part)}.join(' ')
  end

  #TODO: differs from CyLab version as birth_date is overloaded
  def to_s(format = :default)
    case format
      when :short
        name
      else
        s = name
        s += " ##{doctor_patient_nr}" unless doctor_patient_nr.blank?
        s += ", #{birth_date}" unless birth_date.blank?
    end
  end

  # Merging
  def merge(drop_patient)
    self.cases << drop_patient.cases
    self.appointments << drop_patient.appointments
    self.medical_cases << drop_patient.medical_cases
    self.recalls << drop_patient.recalls
    self.service_records << drop_patient.service_records
    self.sessions << drop_patient.sessions
    self.tiers << drop_patient.tiers
    self.treatments << drop_patient.treatments

    if drop_patient.remarks.present?
      self.remarks += "\nVon verknüpftem Patienten:\n"
      self.remarks += drop_patient.remarks
    end

    self
  end

  # Attributes
  def name
    vcard.full_name unless vcard.nil?
  end

  def birth_date=(value)
    if value.is_a?(String)
      day, month, year = value.split('.')
      month ||= Date.today.month
      year ||= Date.today.year
      year = 1900 + year.to_i if year.to_i < 100

      write_attribute(:birth_date, "#{year}-#{month}-#{day}")
    else
      write_attribute(:birth_date, value)
    end
  end

  def birth_date_before_type_cast
    read_attribute(:birth_date).strftime("%d.%m.%Y") unless read_attribute(:birth_date).nil?
  end

  def birth_date
    read_attribute(:birth_date).strftime("%d.%m.%Y") unless read_attribute(:birth_date).nil?
  end

  def birth_date_db
    read_attribute(:birth_date)
  end
end
