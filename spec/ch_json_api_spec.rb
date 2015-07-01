require 'spec_helper'
require 'json'

describe CHJsonAPI do
  it 'has a version number' do
    expect(CHJsonAPI::VERSION).not_to be nil
  end

  describe '#key_validation' do

    it 'should not work if an API key is not passed to the class' do
      expect{CHJsonAPI::Company.profile '0'}.to raise_error(Exception)
    end

  end

  describe 'Company#profile' do

    before :each do
      CHJsonAPI.init '***REMOVED***'
    end

    it 'should search for a company and return correct data ' do
      company = CHJsonAPI::Company.profile '00000006'

      expect(company['company_number']).to eq '00000006'
      expect(company['date_of_creation']).to eq '1862-10-25'
      expect(company['last_full_members_list_date']).to eq '1986-07-02'
      expect(company['type']).to eq 'private-unlimited-nsc'
      expect(company['jurisdiction']).to eq 'england-wales'
      expect(company['company_name']).to eq 'MARINE AND GENERAL MUTUAL LIFE ASSURANCE SOCIETY'
      expect(company['registered_office_address']['locality']).to eq 'London'
      expect(company['registered_office_address']['address_line_2']).to eq 'Aldersgate Street'
      expect(company['registered_office_address']['care_of_name']).to eq 'CMS CAMERON MCKENNA LLP'
      expect(company['registered_office_address']['country']).to eq 'England'
      expect(company['registered_office_address']['address_line_1']).to eq 'Mitre House'
      expect(company['annual_return']['last_made_up_to']).to eq '2015-04-03'
      expect(company['annual_return']['next_made_up_to']).to eq '2016-04-03'
      expect(company['annual_return']['next_due']).to eq '2016-05-01'
      expect(company['accounts']['last_accounts']['type']).to eq 'full'
      expect(company['accounts']['last_accounts']['made_up_to']).to eq '2014-12-31'
      expect(company['accounts']['next_made_up_to']).to eq '2015-12-31'
      expect(company['accounts']['accounting_reference_date']['month']).to eq '12'
      expect(company['accounts']['accounting_reference_date']['day']).to eq '31'
      expect(company['sic_codes']).to eq ['65110']
      expect(company['undeliverable_registered_office_address']).to eq false
      expect(company['has_insolvency_history']).to eq false
      expect(company['company_status']).to eq 'active'
      expect(company['etag']).to eq 'b5461a641de939d0c983397755625b3f643e98d2'
      expect(company['officer_summary']['officers'][0]['appointed_on']).to eq "2015-06-01"
      expect(company['officer_summary']['officers'][0]['officer_role']).to eq "secretary"
      expect(company['officer_summary']['officers'][0]['name']).to eq "ELSTON, David Aiken"
      expect(company['officer_summary']['officers'][1]['appointed_on']).to eq "2015-03-01"
      expect(company['officer_summary']['officers'][1]['officer_role']).to eq "director"
      expect(company['officer_summary']['officers'][1]['name']).to eq "GALBRAITH, James"
      expect(company['officer_summary']['officers'][1]['date_of_birth']['year']).to eq 1963
      expect(company['officer_summary']['officers'][1]['date_of_birth']['month']).to eq 3
      expect(company['officer_summary']['officers'][2]['appointed_on']).to eq "2015-06-01"
      expect(company['officer_summary']['officers'][2]['officer_role']).to eq "director"
      expect(company['officer_summary']['officers'][2]['name']).to eq "MCBAIN, Fiona Catherine"
      expect(company['officer_summary']['officers'][2]['date_of_birth']['year']).to eq 1961
      expect(company['officer_summary']['officers'][2]['date_of_birth']['month']).to eq 3
      expect(company['officer_summary']['officers'][3]['appointed_on']).to eq "2015-06-01"
      expect(company['officer_summary']['officers'][3]['officer_role']).to eq "director"
      expect(company['officer_summary']['officers'][3]['name']).to eq "WALKER, Michael John"
      expect(company['officer_summary']['officers'][3]['date_of_birth']['year']).to eq 1952
      expect(company['officer_summary']['officers'][3]['date_of_birth']['month']).to eq 10
      expect(company['officer_summary']['active_count']).to eq 4
      expect(company['officer_summary']['resigned_count']).to eq 46
      expect(company['has_charges']).to eq true
      expect(company['can_file']).to eq true

    end

    it 'should handle injections and invalid data' do
      company = CHJsonAPI::Company.profile '00000006/registered-office-address'
      expect(company).to eq({})

      company = CHJsonAPI::Company.profile "' ; ls -la"
      expect(company).to eq({})
    end

    it 'should return an empty object if the company number does not exist' do
      company = CHJsonAPI::Company.profile '99999999'
      expect(company).to eq({})
    end

  end


  describe 'Company#registered_address' do

    before :each do
      CHJsonAPI.init '***REMOVED***'
    end

    it 'should search for the registered office and return correct data ' do
      reg_off = CHJsonAPI::Company.registered_office '00000006'

      expect(reg_off['locality']).to eq 'London'
      expect(reg_off['address_line_2']).to eq 'Aldersgate Street'
      expect(reg_off['care_of_name']).to eq 'CMS CAMERON MCKENNA LLP'
      expect(reg_off['country']).to eq 'England'
      expect(reg_off['address_line_1']).to eq 'Mitre House'
    end

    it 'should handle injections and invalid data' do
      company = CHJsonAPI::Company.registered_office '00000006/registered-office-address'
      expect(company).to eq({})

      company = CHJsonAPI::Company.registered_office "' ; ls -la"
      expect(company).to eq({})
    end

    it 'should return an empty object if the company number does not exist' do
      company = CHJsonAPI::Company.profile '99999999'
      expect(company).to eq({})
    end

  end


  describe 'Company#officers' do

    before :each do
      CHJsonAPI.init '***REMOVED***'
    end

    it 'should search for the officers and return correct data ' do
      off = CHJsonAPI::Company.officers '00000006'

      expect(off['active_count']).to eq(4)
      expect(off['resigned_count']).to eq(46)

      expect(off['items'][0]['address']['premises']).to eq 'Mitre House'
      expect(off['items'][0]['address']['locality']).to eq 'London'
      expect(off['items'][0]['address']['postal_code']).to eq 'EC1A 4DD'
      expect(off['items'][0]['address']['country']).to eq 'England'
      expect(off['items'][0]['address']['address_line_1']).to eq 'Aldersgate Street'
      expect(off['items'][0]['address']['care_of']).to eq 'CMS CAMERON MCKENNA LLP'
      expect(off['items'][0]['officer_role']).to eq 'secretary'
      expect(off['items'][0]['appointed_on']).to eq '2015-06-01'
      expect(off['items'][0]['name']).to eq 'ELSTON, David Aiken'

    end

    it 'should handle injections and invalid data' do
      off = CHJsonAPI::Company.officers '00000006/registered-office-address'
      expect(off).to eq({})

      off = CHJsonAPI::Company.officers "' ; ls -la"
      expect(off).to eq({})
    end

    it 'should return an empty object if the company number does not exist' do
      company = CHJsonAPI::Company.profile '99999999'
      expect(company).to eq({})
    end

  end

end
