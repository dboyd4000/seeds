#!/usr/bin/env ruby

require 'json'
require 'bson'
require 'mongo'
require 'symmetric-encryption'
require_relative 'add_organization'


$RENEWING_DRAFT = "renewing_draft"
$RENEWING_ENROLLING = "renewing_enrolling"

$SEED = "David"

	def choose_weighted(weighted)
	  sum = weighted.inject(0) do |sum, item_and_weight|
	    sum += item_and_weight[1]
	  end
	  target = rand(sum)
	  weighted.each do |item, weight|
	    return item if target <= weight
	    target -= weight
	  end
	end

clean_db($SEED)

aasm_state = { :coverage_selected => 51, :inactive => 27 }
#3.times { puts choose_weighted(aasm_state) }

	$reference_plan_id = nil

	$client[:plans].find(:name => "Super Duper Health - Silver").each do |ref_plan|
        puts "*********  FOUND REFERENCE PLAN **********\n"
        $reference_plan_id = ref_plan['_id']
    end

	$broker_agency_profile_id = nil
	$broker_writing_agent_id = nil

	$client[:organizations].find(:legal_name => "Chase & Assoc").each do |bap|
        puts "*********  FOUND BROKER_AGENCY_PROFILE_ID **********\n"
        $broker_agency_profile_id = bap['broker_agency_profile']['_id']
    end

	$client[:people].find(:first_name => "Bill", :last_name => "Murray").each do |broker|
        puts "*********  FOUND BROKER_WRITING_AGENT_ID **********\n"
        $broker_writing_agent_id = broker['broker_role']['_id']
    end

	bCreateBroker = true

    if (bCreateBroker)
		new_user_email = "wallyworld@example.com"
		new_user_ssn = "100-10-2000"
		new_user_first = "Wally"
		new_user_last = "World"
		#new_hbx_id = 10012

		user_id = create_user(new_user_email, true)
	##	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_waived", bg_id, hbx_enrollment_id)
		$broker_writing_agent_id = create_people(new_user_first, new_user_last, nil, user_id, new_user_email, new_user_ssn, nil, true) 
	end


	org = {}
	org, bg_id = add_organization('Performance Company 1', '000000111', '2017-01-01', '')		##CREATE IN OPEN ENROLLMENT

	hbx_enrollment_id = BSON::ObjectId.new

	$i = 0
	$num = 50

	while $i < $num  do
	   	new_user_email = "PerfEmployee#{$i}@example.com"

	   	 last_four = 3000 + $i

		new_user_ssn = "200-10-#{last_four}"
		new_user_first = "Perf#{$i}"
		new_user_last = "Test"
		new_hbx_id = 10100 + $i

		user_id = create_user(new_user_email)
		census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
		people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
		create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, choose_weighted(aasm_state).to_s)

	   $i +=1
	end



	exit












	org = {}
	org, bg_id = add_organization('Best Brau', '000000110', '2016-01-01', 'renewing_enrolling')		##CREATES IN PENDING RENEWAL

	hbx_enrollment_id = BSON::ObjectId.new

########USER 1
######
	new_user_email = "waltdisney@example.com"
	new_user_ssn = "100-10-1028"
	new_user_first = "Walt"
	new_user_last = "Disney"
	new_hbx_id = 10012

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_waived", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "inactive")

########USER 2
######
	new_user_email = "peterpan@example.com"
	new_user_ssn = "100-10-1029"
	new_user_first = "Peter"
	new_user_last = "Pan"
	new_hbx_id = 10013

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "coverage_selected")

bContinue = true

if bContinue
	org = {}
	org, bg_id = add_organization('OPEN Art Studio', '000000111', '2017-01-01', '')		##CREATE IN OPEN ENROLLMENT

	hbx_enrollment_id = BSON::ObjectId.new

########USER 1
######
	new_user_email = "elvispresley@example.com"
	new_user_ssn = "100-10-1030"
	new_user_first = "Elvis"
	new_user_last = "Presley"
#	new_hbx_id = 10011

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_waived", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
#	new_hbx_id = create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, false)

########USER 2
######
	new_user_email = "ringostarr@example.com"
	new_user_ssn = "100-10-1031"
	new_user_first = "Ringo"
	new_user_last = "Starr"
#	new_hbx_id = 10012

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
#	new_hbx_id = create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, true)

########USER 2
######
	new_user_email = "jerrylewis@example.com"
	new_user_ssn = "100-10-1032"
	new_user_first = "Jerry"
	new_user_last = "Lewis"
#	new_hbx_id = 10013

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
#	new_hbx_id = create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, true)





	org = {}
	org, bg_id = add_organization('Courageous Consulting, LLC', '000000112', '2017-01-01', '')	##CREATE IN OPEN ENROLLMENT

	hbx_enrollment_id = BSON::ObjectId.new

########USER 1
######
	new_user_email = "sammydavis@example.com"
	new_user_ssn = "100-10-1033"
	new_user_first = "Sammy"
	new_user_last = "Davis"
#	new_hbx_id = 10014

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_waived", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
#	new_hbx_id = create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, false)

########USER 2
######
	new_user_email = "franksinatra@example.com"
	new_user_ssn = "100-10-1034"
	new_user_first = "Frank"
	new_user_last = "Sinatra"
#	new_hbx_id = 10015

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
#	new_hbx_id = create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, true)






	org = {}
	org, bg_id = add_organization('District Yoga', '0000000113', '2017-01-01', '')	##CREATE IN OPEN ENROLLMENT - MINIMUM MET

	hbx_enrollment_id = BSON::ObjectId.new

########USER 1
######
	new_user_email = "mickeymouse@example.com"
	new_user_ssn = "100-10-1035"
	new_user_first = "Mickey"
	new_user_last = "Mouse"
	new_hbx_id = 10014

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_waived", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "inactive")

########USER 2
######
	new_user_email = "daffyduck@example.com"
	new_user_ssn = "100-10-1036"
	new_user_first = "Daffy"
	new_user_last = "Duck"
	new_hbx_id = 10015

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "coverage_selected")

########USER 2
######
	new_user_email = "minniemouse@example.com"
	new_user_ssn = "100-10-1037"
	new_user_first = "Minnie"
	new_user_last = "Mouse"
	new_hbx_id = 10016

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "coverage_selected")







####IN COVERAGE   #############
####

	org = {}
	org, bg_id = add_organization('DC Cupcakes', '000000114', '2017-04-01', '')			##CREATES IN ALL OTHERS

	hbx_enrollment_id = BSON::ObjectId.new

########USER 1
######
	new_user_email = "flashgordon@example.com"
	new_user_ssn = "100-10-1038"
	new_user_first = "Flash"
	new_user_last = "Gordon"
	new_hbx_id = 10017

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "coverage_selected")


########USER 2
######
	new_user_email = "greenlantern@example.com"
	new_user_ssn = "100-10-1039"
	new_user_first = "Alan"
	new_user_last = "Scott"
	new_hbx_id = 10018

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "inactive")

########USER 3
######
	new_user_email = "wonderwoman@example.com"
	new_user_ssn = "100-10-1040"
	new_user_first = "Diana"
	new_user_last = "Prince"
	new_hbx_id = 10019

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, "coverage_selected")

#######USER 4
######
	new_user_email = "cyborg@example.com"
	new_user_ssn = "100-10-1041"
	new_user_first = "Victor"
	new_user_last = "Stone"
#	new_hbx_id = 10019

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
#	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, true)

#!/usr/bin/ruby

$i = 0
$num = 20

while $i < $num  do
   #puts("Inside the loop i = #$i" )
   	new_user_email = "Test#{$i}@example.com"

   	 last_four = 1042 + $i

	new_user_ssn = "100-10-#{last_four}"
	new_user_first = "Test#{$i}"
	new_user_last = "Test#{$i}"
	new_hbx_id = 10100 + $i

	user_id = create_user(new_user_email)
	census_id, census_benefit_group_assignment_id = create_census(new_user_first, new_user_last, new_user_email, new_user_ssn, org, "coverage_selected", bg_id, hbx_enrollment_id)
	people_id, people_employee_role_id = create_people(new_user_first, new_user_last, org, user_id, new_user_email, new_user_ssn, census_id) 
	create_family(people_id, people_employee_role_id, bg_id, census_benefit_group_assignment_id, new_hbx_id, hbx_enrollment_id, choose_weighted(aasm_state).to_s)

   $i +=1
end
#test_method()
end


