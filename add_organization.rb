#!/usr/bin/env ruby

require 'json'
require 'bson'
require 'mongo'
require 'date'
require 'symmetric-encryption'
require_relative 'family'

SymmetricEncryption.cipher = SymmetricEncryption::Cipher.new(
  key:         '1234567890ABCDEF1234567890ABCDEF',
  iv:          '1234567890ABCDEF',
  cipher_name: 'aes-128-cbc'
)

Mongo::Logger.logger.level = ::Logger::FATAL

$client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'enroll_development')

def clean_db(seed)
	$client[:organizations].find(:seed => seed).each do |org|
		puts "*********  REMOVING SEED ORGANIZATIONS **********\n"
		$client[:organizations].delete_one(org)
	end

		$client[:census_members].find(:seed => seed).each do |peeps|
		puts "*********  REMOVING SEED CENSUS MEMBERS ACCOUNTS **********\n"
		$client[:census_members].delete_one(peeps)
	end

		$client[:people].find(:seed => seed).each do |peeps|
		puts "*********  REMOVING SEED PEOPLE ACCOUNTS **********\n"
		$client[:people].delete_one(peeps)
	end

	$client[:users].find(:seed => seed).each do |usr|
		puts "*********  REMOVING SEED USER ACCOUNTS **********\n"
		$client[:users].delete_one(usr)
	end

	$client[:families].find(:seed => seed).each do |usr|
		puts "*********  REMOVING SEED FAMILIES ACCOUNTS **********\n"
		$client[:families].delete_one(usr)
	end
end
#def add_organization(co_name, hbxid, oe_start, oe_end, plan_year)
def add_organization(co_name, hbxid, plan_year, mode)

	_org = {}

		_org['_id'] = BSON::ObjectId.new 
		_org['seed'] = $SEED
		_org['version'] = 1
		_org['legal_name'] = co_name
		_org['dba'] = co_name
		_org['fein'] = hbxid
		_org['updated_by_id'] = BSON::ObjectId("575050d3c3b5a07d4f000000") 		#user_id in people collection -- Frodo is who this equals
		_org['hbx_id'] = hbxid   #'dbe630f6ae5f4bafa2717a105b2cd6e8'
		_org['office_locations'] = []
		_org['employer_profile'] = []
		_org['updated_at'] = DateTime.now  #2016
		_org['created_at'] = DateTime.now

		_office_locations = []

			_loc = {}
			_loc['_id'] = BSON::ObjectId.new 
			_loc['is_primary'] = true
			_loc['address'] = {}
			_loc['address']['_id'] = BSON::ObjectId.new 
			_loc['address']['address_1'] = '601 H Street NW'
			_loc['address']['address_2'] = ''
			_loc['address']['address_3'] = ''
			_loc['address']['city'] = 'Washington'
			_loc['address']['state'] = 'DC'
			_loc['address']['zip'] = '20001'
			_loc['address']['kind'] = 'primary'
			_loc['address']['updated_at'] = DateTime.now
			_loc['address']['created_at'] = DateTime.now

			_loc['phone'] = {}
			_loc['phone']['_id'] = BSON::ObjectId.new 
			_loc['phone']['country_code'] = ''
			_loc['phone']['area_code'] = '202'
			_loc['phone']['extension'] = nil
			_loc['phone']['kind'] = 'phone main'
			_loc['phone']['number'] = '4686571'
			_loc['phone']['updated_at'] = DateTime.now
			_loc['phone']['created_at'] = DateTime.now

			_office_locations << _loc

		_org['office_locations'] = _office_locations

		_org['employer_profile'] = {}
		_org['employer_profile']['_id'] = BSON::ObjectId.new 
		_org['employer_profile']['aasm_state'] = 'registered'
		_org['employer_profile']['profile_source'] = 'self_serve'
		_org['employer_profile']['entity_kind'] = 'tax_exempt_organization'
		_org['employer_profile']['registered_on'] = DateTime.now
		_org['employer_profile']['updated_by_id'] = BSON::ObjectId("575050d3c3b5a07d4f000000")	#user_id in people collection -- Frodo is who this equals
		_org['employer_profile']['updated_at'] = DateTime.now
		_org['employer_profile']['created_at'] = DateTime.now

		_org['employer_profile']['inbox'] = {}
		_org['employer_profile']['inbox']['_id'] = BSON::ObjectId.new 
		_org['employer_profile']['inbox']['access_key'] = '57505191c3b5a07d4f00000a2a8dad92eb04f770fbf0'

		_org['employer_profile']['plan_years'] = []

			_plan_years = {}
			_plan_years['_id'] = BSON::ObjectId.new
			_plan_years['fte_count'] =
		
			_plan_years['pte_count'] = 0
			_plan_years['msp_count'] = 0
			_plan_years['aasm_state'] = "published"
			_plan_years['imported_plan_year'] = false

			plan = Date.parse(plan_year)

#			puts plan.year
#			puts plan.day
#			puts plan.month

			oe_start = plan << 2		## 2 months back
			oe_end = (plan << 1) + 15 	## 15 days from plan_start

			_plan_years['start_on'] = plan #Time.parse(plan_year)  #Time.utc(2017, 2, 1)
			_plan_years['end_on'] = plan + 365 #Time.parse(plan_year) + 364  #Time.new(2018,12,30) ##BSON::ISODate("#{plan.year+1}-11-26T02:07:45.559Z") ##Time.utc(2018, 12, pd)
			_plan_years['open_enrollment_start_on'] = oe_start #Time.parse(oe_start) #Time.utc(2017, 1, 1)
			_plan_years['open_enrollment_end_on'] = oe_end  #Time.parse(oe_end)  #Time.utc(2017, 2, 13)
			_plan_years['benefit_groups'] = []

				_bg = {}
				_bg['_id'] = BSON::ObjectId.new
				_bg['_type'] = "BenefitGroup"
				_bg['title'] = "The Big Plan"
				_bg['description'] = "Big Plan"
				_bg['effective_on_kind'] = "first_of_month"
				_bg['terminate_on_kind'] = "end_of_month"
				_bg['contribution_pct_as_int'] = 0
				_bg['employee_max_amt'] = {}
					_bg['employee_max_amt']['cents'] = 0
					_bg['employee_max_amt']['currency_iso'] = "USD"
				_bg['first_dependent_max_amt'] = {}
					_bg['first_dependent_max_amt']['cents'] = 0
					_bg['first_dependent_max_amt']['currency_iso'] = "USD"
				_bg['over_one_dependents_max_amt'] = {}
					_bg['over_one_dependents_max_amt']['cents'] = 0
					_bg['over_one_dependents_max_amt']['currency_iso'] = "USD"

				_bg['effective_on_offset'] = 0
				_bg['employer_max_amt_in_cents'] = 0
				_bg['dental_relationship_benefits_attributes_time'] = "0"
				_bg['elected_dental_plan_ids'] = []
				_bg['elected_plan_ids'] = []  #ObjectId("5831bc9f3616b65f97000000")

				_bg['elected_plan_ids'] << $reference_plan_id ##BSON::ObjectId("58332b243616b608eb000000")

				_bg['reference_plan_id'] = $reference_plan_id  ##BSON::ObjectId("58332b243616b608eb000000")

				_bg['dental_reference_plan_id'] = nil
				_bg['plan_option_kind'] = "metal_level"
				_bg['default'] = true
				_bg['is_congress'] = false
				_bg['lowest_cost_plan_id'] = $reference_plan_id   ##BSON::ObjectId("58332b243616b608eb000000")
				_bg['highest_cost_plan_id'] = $reference_plan_id  ##BSON::ObjectId("58332b243616b608eb000000")


				_bg['relationship_benefits'] = []
					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "employee"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "spouse"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 35
					rel_ben['offered'] = true
					rel_ben['relationship'] = "domestic_partner"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_under_26"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_26_and_over"
					_bg['relationship_benefits'] << rel_ben

				_bg['dental_relationship_benefits'] = []
					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "employee"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "spouse"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 35
					rel_ben['offered'] = true
					rel_ben['relationship'] = "domestic_partner"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_under_26"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_26_and_over"
					_bg['dental_relationship_benefits'] << rel_ben

			_plan_years['benefit_groups'] << _bg

		_org['employer_profile']['plan_years'] << _plan_years

		if (mode != '')

			_plan_years = {}
			_plan_years['_id'] = BSON::ObjectId.new
			_plan_years['fte_count'] =
		
			_plan_years['pte_count'] = 0
			_plan_years['msp_count'] = 0
			_plan_years['aasm_state'] = mode
			_plan_years['imported_plan_year'] = false

			plan = Date.parse(plan_year)
			plan = (plan >> 12) + 14

#			puts plan.year
#			puts plan.day
#			puts plan.month

			oe_start = Date.today + 15 #>> 1 #plan << 2 ##2 months back
			oe_end = Date.today + 45  #(plan << 1) + 15  ##15 days from plan_start

			_plan_years['start_on'] = plan #Time.parse(plan_year)  #Time.utc(2017, 2, 1)
			_plan_years['end_on'] = plan + 365 #Time.parse(plan_year) + 364  #Time.new(2018,12,30) ##BSON::ISODate("#{plan.year+1}-11-26T02:07:45.559Z") ##Time.utc(2018, 12, pd)
			_plan_years['open_enrollment_start_on'] = oe_start #Time.parse(oe_start) #Time.utc(2017, 1, 1)
			_plan_years['open_enrollment_end_on'] = oe_end  #Time.parse(oe_end)  #Time.utc(2017, 2, 13)
			_plan_years['benefit_groups'] = []

				_bg = {}
				_bg['_id'] = BSON::ObjectId.new
				_bg['_type'] = "BenefitGroup"
				_bg['title'] = "The Big Plan " + plan.year.to_s
				_bg['description'] = "Big Plan"
				_bg['effective_on_kind'] = "first_of_month"
				_bg['terminate_on_kind'] = "end_of_month"
				_bg['contribution_pct_as_int'] = 0
				_bg['employee_max_amt'] = {}
					_bg['employee_max_amt']['cents'] = 0
					_bg['employee_max_amt']['currency_iso'] = "USD"
				_bg['first_dependent_max_amt'] = {}
					_bg['first_dependent_max_amt']['cents'] = 0
					_bg['first_dependent_max_amt']['currency_iso'] = "USD"
				_bg['over_one_dependents_max_amt'] = {}
					_bg['over_one_dependents_max_amt']['cents'] = 0
					_bg['over_one_dependents_max_amt']['currency_iso'] = "USD"

				_bg['effective_on_offset'] = 0
				_bg['employer_max_amt_in_cents'] = 0
				_bg['dental_relationship_benefits_attributes_time'] = "0"
				_bg['elected_dental_plan_ids'] = []
				_bg['elected_plan_ids'] = []  #ObjectId("5831bc9f3616b65f97000000")

				_bg['elected_plan_ids'] << $reference_plan_id  #BSON::ObjectId("58332b243616b608eb000000")

				_bg['reference_plan_id'] = $reference_plan_id  #BSON::ObjectId("58332b243616b608eb000000")

				_bg['dental_reference_plan_id'] = nil
				_bg['plan_option_kind'] = "metal_level"
				_bg['default'] = true
				_bg['is_congress'] = false
				_bg['lowest_cost_plan_id'] = $reference_plan_id #BSON::ObjectId("58332b243616b608eb000000")
				_bg['highest_cost_plan_id'] = $reference_plan_id #BSON::ObjectId("58332b243616b608eb000000")

				_bg['relationship_benefits'] = []
					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "employee"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "spouse"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 35
					rel_ben['offered'] = true
					rel_ben['relationship'] = "domestic_partner"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_under_26"
					_bg['relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_26_and_over"
					_bg['relationship_benefits'] << rel_ben

				_bg['dental_relationship_benefits'] = []
					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "employee"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 75
					rel_ben['offered'] = true
					rel_ben['relationship'] = "spouse"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 35
					rel_ben['offered'] = true
					rel_ben['relationship'] = "domestic_partner"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_under_26"
					_bg['dental_relationship_benefits'] << rel_ben

					rel_ben = {}
					rel_ben['_id'] = BSON::ObjectId.new
					rel_ben['premium_pct'] = 0
					rel_ben['offered'] = true
					rel_ben['relationship'] = "child_26_and_over"
					_bg['dental_relationship_benefits'] << rel_ben

			_plan_years['benefit_groups'] << _bg

		_org['employer_profile']['plan_years'] << _plan_years

		end
		##########LINK BROKER AGENCY
		####
		_broker_agency_profile = []

			_bap = {}
			_bap['_id'] = BSON::ObjectId.new 
			_bap['is_active'] = true
			_bap['broker_agency_profile_id'] = $broker_agency_profile_id   ##BSON::ObjectId("576ae89a3616b60ee1000d8e")	#broker_agency_profile_id - Chase & Assoc
			_bap['writing_agent_id'] = $broker_writing_agent_id ##BSON::ObjectId("576ae8993616b60ee1000d4a")	#primary_broker_role_id - Bill Murray
										#BSON::ObjectId("576ae89a3616b60ee1000d5d")	#primary_broker_role_id - Jane Curtain
			_bap['updated_at'] = DateTime.now
			_bap['created_at'] = DateTime.now

			_broker_agency_profile << _bap

		_org['employer_profile']['broker_agency_accounts'] = _broker_agency_profile

	 	$client[:organizations].insert_one _org 

	puts "********* INSERTED ORG **********\n"

	# 	[_org['_id'], _bg['_id']]
	 	[_org['employer_profile']['_id'], _bg['_id'] ]
end


def create_user(email, isBroker=false)

	du = {}

	du['_id'] = BSON::ObjectId.new 
	du['seed'] = $SEED
	du['approved'] = true
	du['idp_verified'] = true
	du['updated_at'] = DateTime.now
	du['created_at'] = DateTime.now
	du['last_sign_in_at'] = DateTime.now
	du['current_sign_in_at'] = DateTime.now
	du['email'] = email #"batman@jl.com"
	du['encrypted_password'] = "$2a$10$QguNmsAHn2ZkYDQm3lgLhOFdGIbne/jNIWxYxKsLEA58za73Uy6ZG"

		roles = {}
		if (isBroker)
			roles = "broker"
		else
			roles = "employee"
		end

	du['roles'] = []
	du['roles'] << roles

	$client[:users].insert_one du

	puts "********* INSERTED USER **********\n"

	du['_id']
end


def create_census(first_name, last_name, email, ssn, org_id, aasm, benefit_plan_id, hbx_enrollment_id)

	ce = {}
	ce['_id'] = BSON::ObjectId.new
	ce['_type'] = "CensusEmployee"

	ce['is_business_owner'] = false
	ce['aasm_state'] = "employee_role_linked" #"eligible"
	ce['employee_relationship'] = "self"
	ce['first_name'] = first_name
	ce['middle_name'] = nil
	ce['last_name'] = last_name
	ce['name_sfx'] = nil

	ce['dob'] = Time.utc(1970, 1, 1)
	ce['seed'] = $SEED

	val = ssn #{}"001-01-#{$npn_start}"
	ssn_val = val.to_s.gsub(/\D/, '')
	ce['encrypted_ssn'] = SymmetricEncryption.encrypt(ssn_val)  

	ce['gender'] = "male"
	ce['hired_on'] = Time.utc(2016, 9, 15)

	ce['employer_profile_id'] = org_id
    ce['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
    ce['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")

	ce['address'] = {}
	ce['address']['_id'] = BSON::ObjectId.new 
	ce['address']['address_1'] = '601 H Street NW'
	ce['address']['address_2'] = ''
	ce['address']['address_3'] = ''
	ce['address']['country_name'] = ''
	ce['address']['city'] = 'Washington'
	ce['address']['state'] = 'DC'
	ce['address']['zip'] = '20001'
	ce['address']['kind'] = 'home'

	ce['email'] = {}
	ce['email']['_id'] = BSON::ObjectId.new
	ce['email']['kind'] = "work"
	ce['email']['address'] = email #"#{$last_name}@example.com"

	#aasm_state:
		#coverage_waived
		#coverage_selected
		#initialized			-- We do not create any of these here. Used only when employee create employee on roster and employee has not signed up yet

	ce['benefit_group_assignments'] = []

		_bga = {}
		_bga['_id'] = BSON::ObjectId.new
		_bga['aasm_state'] = aasm
		_bga['is_active'] = true
		_bga['start_on'] = Time.utc(2017, 1, 1)		####PLAN YEAR BEGIN
	    _bga['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
    	_bga['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
		_bga['benefit_group_id'] = benefit_plan_id
		_bga['hbx_enrollment_id'] = hbx_enrollment_id

                    _bga['workflow_state_transitions'] = []
                        
                        	_wst = {}
                            _wst['_id'] = BSON::ObjectId.new  #BSON::ObjectId("583362483616b61de5000024")
                            _wst['from_state'] = "initialized"
                            _wst['to_state'] = "coverage_selected"
                            _wst['transition_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.894Z"),
                            _wst['updated_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z"),
                            _wst['created_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z")

                    _bga['workflow_state_transitions'] << _wst

	ce['benefit_group_assignments'] << _bga	

           _bga['workflow_state_transitions'] = []
                
                	_wst = {}
                    _wst['_id'] = BSON::ObjectId.new  #BSON::ObjectId("583362483616b61de5000024")
                    _wst['from_state'] = "eligible"
                    _wst['to_state'] = "employee_role_linked"
                    _wst['transition_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.894Z"),
                    _wst['updated_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z"),
                    _wst['created_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z")

            _bga['workflow_state_transitions'] << _wst

	ce['employee_role_id'] = BSON::ObjectId.new

	$client[:census_members].insert_one ce 
	puts "********* INSERTED CENSUS **********\n"

	[ce['_id'], ce['benefit_group_assignments'][0]['_id']]
end



def create_people(first, last, org_id, user_id, email, ssn, census_id, isBroker=false)

	dp = {}

	dp['_id'] = BSON::ObjectId.new
	dp['version'] = 1

dp['seed'] = $SEED

    dp['is_tobacco_user'] = "unknown"
    dp['no_dc_address_reason'] = ""
    dp['is_active'] = true
    dp['name_pfx'] = nil
   	dp['first_name'] = first #"Bruce"
	dp['last_name'] = last #'Wayne'
    dp['middle_name'] = nil
    dp['name_sfx'] = nil

    dp['no_ssn'] = nil
    dp['dob'] = Time.utc(1970, 1, 1)	
    dp['gender'] = "male"
 #   dp['user_id'] = BSON::ObjectId("5835d6f73616b630e800002b")
    dp['no_dc_address'] = false
    dp['updated_by_id'] = BSON::ObjectId("5835d6f73616b630e800002b")
#    dp['hbx_id'] = "249c5af5f183432593380c74d09ce654"

	#dp['seed'] = true

	dp['hbx_id'] = BSON::ObjectId.new  #"123456789"
	dp['user_id'] = user_id #data_users['_id']

    dp['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
    dp['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")


	dp['inbox'] = {}

	dp['inbox']['_id'] = BSON::ObjectId.new
	dp['inbox']['access_key'] = "5835c7023616b630e800000d028069fbb40fbe432370"
	dp['inbox']['messages'] = []

		inbox_msg = {}
		inbox_msg['_id'] = BSON::ObjectId.new 
		inbox_msg['subject'] = "Welcome to DC Health Link"
		inbox_msg['body'] = "DC Health Link is the District of Columbia's on-line marketplace to shop, compare, and select health insurance that meets your health needs and budgets."
		inbox_msg['from'] = "DC Health Link"
		inbox_msg['message_read'] = false
		inbox_msg['created_at'] = DateTime.now

 	dp['inbox']['messages'] << inbox_msg


	dp['emails'] = []

		_email = {}
		_email['_id'] = BSON::ObjectId.new #emp_role_id
		_email['address'] = email #{}"batman@jl.com"
		_email['kind'] = 'work'

	dp['emails'] << _email

	dp['phones'] = []

		phones = {}
		phones['_id'] = BSON::ObjectId.new #emp_role_id
		phones['country_code'] = ""
		phones['kind'] = 'work'
		phones['area_code'] = "202"
		phones['extension'] = nil
		phones['number'] = "5551234"
		phones['full_phone_number'] = "2025551234"

	dp['phones'] << phones

	dp['addresses'] = []

		address = {}
		address['_id'] = BSON::ObjectId.new #emp_role_id
		address['address_1'] = "601 H Street NW"
		address['address_2'] = 'work'
		address['address_3'] = "202"
		address['country_name'] = nil
		address['kind'] = "home"
		address['city'] = "Washington"
		address['state'] = "DC"
		address['zip'] = "20001"

	dp['addresses'] << address

	val = ssn #"111-22-1111"   #{}"001-01-#{$npn_start}"
	ssn_val = val.to_s.gsub(/\D/, '')
	dp['encrypted_ssn'] = SymmetricEncryption.encrypt(ssn_val) #"NhYeWwk913MXhWs6tCw/nw=="    #{}"NhYeWwk913MXhWs6tCw/nw=="

	puts "********* INSERTing PEOPLE **********\n"
	puts org_id

	employee_role_id = nil

	if (isBroker)
    	dp['broker_role'] = {}
        dp['broker_role']['_id'] = BSON::ObjectId.new
        dp['broker_role']['languages_spoken'] = []
        dp['broker_role']['languages_spoken'] << "en"
            
        dp['broker_role']['npn'] = "1682457"		##This has to be unique
        dp['broker_role']['provider_kind'] = "broker"
        dp['broker_role']['working_hours'] = false
        dp['broker_role']['aasm_state'] = "active"
        dp['broker_role']['updated_by_id'] = nil
        dp['broker_role']['updated_at'] = DateTime.now
        dp['broker_role']['created_at'] = DateTime.now

        dp['broker_role']['workflow_state_transitions'] = []

            _wst = {}
            _wst['_id'] = BSON::ObjectId.new  
            _wst['from_state'] = "broker_agency_pending"
            _wst['to_state'] = "active"
            _wst['transition_at'] = DateTime.now 
            _wst['updated_at'] = DateTime.now 
            _wst['created_at'] = DateTime.now 

        dp['broker_role']['workflow_state_transitions'] << _wst

        dp['broker_role']['broker_agency_profile_id'] = $broker_agency_profile_id  ##ObjectId("576ae89a3616b60ee1000d8e")
    else
		#######employer_staff_roles I believe is the OWNER of the company????
		emp_roles = {}
		emp_roles['_id'] = BSON::ObjectId.new #emp_role_id
		emp_roles['is_active'] = true
		emp_roles['aasm_state'] = "is_active"
		emp_roles['employer_profile_id'] = org_id
		emp_roles['census_employee_id'] = census_id

		emp_roles['contact_method'] = "Only Paper communication"
		emp_roles['language_preference'] = "English"
		emp_roles['hired_on'] = Time.utc(2016, 9, 1)
		emp_roles['terminated_on'] = nil
	    emp_roles['updated_by_id'] = BSON::ObjectId("5835c6da3616b630e800000a")
	    emp_roles['updated_at'] = DateTime.now
	    emp_roles['created_at'] = DateTime.now
	    emp_roles['bookmark_url'] = "/families/home"

	#	dp['employer_staff_roles'] = []
	#	dp['employer_staff_roles'] << emp_roles

		dp['employee_roles'] = []
		dp['employee_roles'] << emp_roles

		employee_role_id = emp_roles['_id']
	end
	#dp['employer_staff_roles']['_id'] = BSON::ObjectId.new #emp_role_id
	#dp['employer_staff_roles']['is_owner'] = true
	#dp['employer_staff_roles']['is_active'] = true
	#dp['employer_staff_roles']['aasm_state'] = "is_active"
	#dp['employer_staff_roles']['employer_profile_id'] = org_id

#######employee_roles are for employees of a company
#	dp['employee_roles'][0]['_id'] = emp_role_id
#	dp['employee_roles'][0]['employer_profile_id'] = org_id
#	dp['employee_roles'][0]['census_employee_id'] = census_id



	$client[:people].insert_one dp 

	puts "********* INSERTED PEOPLE **********\n"

	if (isBroker)
		dp['broker_role']['_id']
	else
		[dp['_id'], employee_role_id]
	end
end

