#!/usr/bin/env ruby

require 'json'
require 'bson'
require 'mongo'
require 'symmetric-encryption'

Mongo::Logger.logger.level = ::Logger::FATAL

$client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'enroll_development')

def create_family(people_id, people_employee_role_id, benefit_group_id, census_benefit_group_assignment_id, hbx_id, hbx_enrollment_id, aasm_state)

	family_id = BSON::ObjectId.new

	cf = {}
	
    	cf['_id'] = BSON::ObjectId.new 
    	cf['seed'] = $SEED
    	cf['version'] = 1
    	cf['is_active'] = true
    	cf['status'] =  ""
    	cf['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
    	cf['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
    	cf['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
    	cf['hbx_assigned_id'] = hbx_id
    	cf['family_members'] = []

    			_fm = {}
            	_fm['_id'] = family_id #ObjectId("5833621f3616b61de5000014")
            	_fm['is_coverage_applicant'] = true
            	_fm['is_active'] = true
            	_fm['person_id'] = people_id   #BSON::ObjectId("5833621f3616b61de500000f") 
            	_fm['is_primary_applicant'] = true
            	_fm['is_consent_applicant'] = false
            	_fm['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
            	_fm['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.694Z")
            	_fm['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.694Z")

        cf['family_members'] << _fm

    	cf['irs_groups'] = []
        
        		_irs = {}
            	_irs['_id'] = BSON::ObjectId.new #ObjectId("5833621f3616b61de5000015")
            	_irs['is_active'] = true
            	_irs['effective_starting_on'] = DateTime.now #ISODate("2016-11-21T00:00:00Z")
            	_irs['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
            	_irs['effective_ending_on'] = nil
            	_irs['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.694Z")
            	_irs['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.694Z")
        
        cf['irs_groups'] << _irs



    	cf['households'] = []
        #{
                _cf = {}
            	_cf['_id'] = BSON::ObjectId.new   #BSON::ObjectId("5833621f3616b61de5000016")
            	_cf['is_active'] = true
            	_cf['irs_group_id'] = _irs['_id'] ##BSON::ObjectId("5833621f3616b61de5000015")
            	_cf['effective_starting_on'] = DateTime.now  #ISODate("2016-11-21T00:00:00Z")
            	_cf['submitted_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.638Z")
            	_cf['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
            	_cf['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
            	_cf['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")

            	_cf['coverage_households'] = []
                #{
                        _cfh = {}
                    	_cfh['_id'] = BSON::ObjectId.new  #BSON::ObjectId("5833621f3616b61de5000017")
                    	_cfh['aasm_state'] = "applicant"
                    	_cfh['is_immediate_family'] = true
                    	_cfh['is_determination_split_household'] = false
                    	_cfh['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
                    	_cfh['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
                    	_cfh['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")

                    		_cfh['coverage_household_members'] = []

                        		_cfm = {}
                            	_cfm['_id'] = BSON::ObjectId.new  #BSON::ObjectId("5833621f3616b61de5000018")
                            	_cfm['family_member_id'] =family_id    ##BSON::ObjectId("5833621f3616b61de5000014")
                            	_cfm['is_subscriber'] = true
                            	_cfm['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.694Z")
                            	_cfm['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.694Z")

                        	_cfh['coverage_household_members'] << _cfm
 
  						_cf['coverage_households'] << _cfh

  						_cfh = {}
                    	_cfh['_id'] = BSON::ObjectId.new  #BSON::ObjectId("5833621f3616b61de5000019")
                    	_cfh['aasm_state'] = "applicant"
                    	_cfh['is_immediate_family'] = false
                    	_cfh['is_determination_split_household'] = false
                    	_cfh['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
                    	_cfh['updated_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")
                    	_cfh['created_at'] = DateTime.now #ISODate("2016-11-21T21:07:43.696Z")

                		_cf['coverage_households'] << _cfh


                ###############This should select healthplan for person (exact copy of hbx_enrollments right below this)

				_cf['hbx_enrollments'] = []

	       			_hbx = {}
	                    _hbx['_id'] = hbx_enrollment_id   ##BSON::ObjectId.new  #BSON::ObjectId("583362343616b61de5000021") ##This number gets put into census_members hbx_enrollment_id
	                    _hbx['enrollment_kind'] = "open_enrollment"
	                    _hbx['coverage_kind'] = "health"
	                    _hbx['elected_amount'] = {}
	                        _hbx['elected_amount']['cents'] = 0
	                        _hbx['elected_amount']['currency_iso'] = "USD"
	                    	
	                    _hbx['elected_premium_credit'] = {}
	                        _hbx['elected_premium_credit']['cents'] = 0
	                        _hbx['elected_premium_credit']['currency_iso'] = "USD"
	                    
	                    _hbx['applied_premium_credit'] = {}
	                        _hbx['applied_premium_credit']['cents'] = 0
	                        _hbx['applied_premium_credit']['currency_iso'] = "USD"
	                    
	                    _hbx['elected_aptc_pct'] = 0
	                    _hbx['applied_aptc_amount'] = {}
	                        _hbx['applied_aptc_amount']['cents'] = 0
	                        _hbx['applied_aptc_amount']['currency_iso'] = "USD"
	                    
	                    _hbx['is_active'] = true
	                    _hbx['review_status'] = "incomplete"
	                    _hbx['changing'] = false
	                    _hbx['external_enrollment'] = false
	                 #   if (isEnrolled)
	                    	_hbx['aasm_state'] = aasm_state   #{}"coverage_selected"
	                  #  else
	                   # 	_hbx['aasm_state'] = "inactive"
	                    #end
	                    _hbx['submitted_at'] = DateTime.now #ISODate("2016-11-21T21:08:04.724Z"),
	                    _hbx['kind'] = "employer_sponsored"

	                    _hbx['employee_role_id'] = people_employee_role_id   ###BSON::ObjectId("5833621f3616b61de500001b")	##people id	

	                    _hbx['effective_on'] = Time.utc(2017, 1, 1)

	                    _hbx['benefit_group_id'] = benefit_group_id   ###BSON::ObjectId("58335ccd3616b61da1000008")		###[benefit_group][_id] -- inside plan_years in organizations
	                    _hbx['benefit_group_assignment_id'] = census_benefit_group_assignment_id    ##BSON::ObjectId("58335d963616b61de5000002") ###Frank Sinatra in CensusMember

	                    _hbx['enrollment_signature'] = "0cb8b32df427efdb877e9cefa48b9230"

	                    _hbx['writing_agent_id'] = nil
	                    _hbx['original_application_type'] = nil
	                    _hbx['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
	                    _hbx['hbx_id'] = "f45ce5de4b0f4694bff64e2bc035d8ec"
	                    _hbx['updated_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.892Z"),
	                    _hbx['created_at'] = DateTime.now #ISODate("2016-11-21T21:08:04.743Z"),

	                    _hbx['hbx_enrollment_members'] = []
	                        _hbxm = {}
	                        _hbxm['_id'] = BSON::ObjectId.new  #BSON::ObjectId("583362343616b61de5000022")
	                        _hbxm['applied_aptc_amount'] = {}
	                            _hbxm['applied_aptc_amount'] ['cents'] = 0
	                            _hbxm['applied_aptc_amount'] ['currency_iso'] = "USD"
	                            
	                        _hbxm['applicant_id'] = family_id    ###BSON::ObjectId("5833621f3616b61de5000014")
	                        _hbxm['is_subscriber'] = true
	                        _hbxm['eligibility_date'] = Time.utc(2017, 1, 1)  #DateTime.now #ISODate("2017-01-01T00:00:00Z"),
	                        _hbxm['coverage_start_on'] = Time.utc(2017, 1, 1)  #DateTime.now #ISODate("2017-01-01T00:00:00Z")

	                    _hbx['hbx_enrollment_members'] << _hbxm  

	                    if (aasm_state == 'coverage_selected')
		                    _hbx['plan_id'] = $reference_plan_id  #BSON::ObjectId("58332b243616b608eb000000")
		                    _hbx['workflow_state_transitions'] = []
		                        
		                        	_wst = {}
		                            _wst['_id'] = BSON::ObjectId.new  #BSON::ObjectId("583362483616b61de5000024")
		                            _wst['from_state'] = "shopping"
		                            _wst['to_state'] = "coverage_selected"
		                            _wst['transition_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.894Z"),
		                            _wst['updated_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z"),
		                            _wst['created_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z")

		                    _hbx['workflow_state_transitions'] << _wst
		                else
		                	_hbx['waiver_reason'] = "I have coverage through spouse’s employer health plan"
	                    end

	            _cf['hbx_enrollments'] << _hbx


        cf['households'] << _cf 

        cf['hbx_enrollments'] = [] 
        
        			_hbx = {}
                    _hbx['_id'] = hbx_enrollment_id   ##BSON::ObjectId.new  #BSON::ObjectId("583362343616b61de5000021") ##This number gets put into census_members hbx_enrollment_id
                    _hbx['enrollment_kind'] = "open_enrollment"
                    _hbx['coverage_kind'] = "health"
                    _hbx['elected_amount'] = {}
                        _hbx['elected_amount']['cents'] = 0
                        _hbx['elected_amount']['currency_iso'] = "USD"
                    	
                    _hbx['elected_premium_credit'] = {}
                        _hbx['elected_premium_credit']['cents'] = 0
                        _hbx['elected_premium_credit']['currency_iso'] = "USD"
                    
                    _hbx['applied_premium_credit'] = {}
                        _hbx['applied_premium_credit']['cents'] = 0
                        _hbx['applied_premium_credit']['currency_iso'] = "USD"
                    
                    _hbx['elected_aptc_pct'] = 0
                    _hbx['applied_aptc_amount'] = {}
                        _hbx['applied_aptc_amount']['cents'] = 0
                        _hbx['applied_aptc_amount']['currency_iso'] = "USD"
                    
                    _hbx['is_active'] = true
                    _hbx['review_status'] = "incomplete"
                    _hbx['changing'] = false
                    _hbx['external_enrollment'] = false
                    _hbx['aasm_state'] = "coverage_selected"
                    _hbx['submitted_at'] = DateTime.now #ISODate("2016-11-21T21:08:04.724Z"),
                    _hbx['kind'] = "employer_sponsored"

                    _hbx['employee_role_id'] = people_employee_role_id   ###BSON::ObjectId("5833621f3616b61de500001b")	##people id	

                    _hbx['effective_on'] = Time.utc(2017, 1, 1)

                    _hbx['benefit_group_id'] = benefit_group_id   ###BSON::ObjectId("58335ccd3616b61da1000008")		###[benefit_group][_id] -- inside plan_years in organizations
                    _hbx['benefit_group_assignment_id'] = census_benefit_group_assignment_id    ##BSON::ObjectId("58335d963616b61de5000002") ###Frank Sinatra in CensusMember

                    _hbx['enrollment_signature'] = "0cb8b32df427efdb877e9cefa48b9230"

                    _hbx['writing_agent_id'] = nil
                    _hbx['original_application_type'] = nil
                    _hbx['updated_by_id'] = BSON::ObjectId("583362003616b61de500000d")
                    _hbx['hbx_id'] = "f45ce5de4b0f4694bff64e2bc035d8ec"
                    _hbx['updated_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.892Z"),
                    _hbx['created_at'] = DateTime.now #ISODate("2016-11-21T21:08:04.743Z"),

                    _hbx['hbx_enrollment_members'] = []
                        _hbxm = {}
                        _hbxm['_id'] = BSON::ObjectId.new  #BSON::ObjectId("583362343616b61de5000022")
                        _hbxm['applied_aptc_amount'] = {}
                            _hbxm['applied_aptc_amount'] ['cents'] = 0
                            _hbxm['applied_aptc_amount'] ['currency_iso'] = "USD"
                            
                        _hbxm['applicant_id'] = family_id    ###BSON::ObjectId("5833621f3616b61de5000014")
                        _hbxm['is_subscriber'] = true
                        _hbxm['eligibility_date'] = Time.utc(2017, 1, 1)  #DateTime.now #ISODate("2017-01-01T00:00:00Z"),
                        _hbxm['coverage_start_on'] = Time.utc(2017, 1, 1)  #DateTime.now #ISODate("2017-01-01T00:00:00Z")

                    _hbx['hbx_enrollment_members'] << _hbxm    
                    

                    _hbx['plan_id'] = $reference_plan_id  ##BSON::ObjectId("58332b243616b608eb000000")
                    _hbx['workflow_state_transitions'] = []
                        
                        	_wst = {}
                            _wst['_id'] = BSON::ObjectId.new  #BSON::ObjectId("583362483616b61de5000024")
                            _wst['from_state'] = "shopping"
                            _wst['to_state'] = "coverage_selected"
                            _wst['transition_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.894Z"),
                            _wst['updated_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z"),
                            _wst['created_at'] = DateTime.now #ISODate("2016-11-21T21:08:24.895Z")

                    _hbx['workflow_state_transitions'] << _wst

        cf['hbx_enrollments'] << _hbx

    	$client[:families].insert_one cf 
end