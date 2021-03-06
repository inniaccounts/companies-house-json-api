require 'spec_helper'
require 'json'

describe ChJsonApi do

  let(:key) {
    f = File.open(File.dirname(__FILE__)+'/../api_key.txt','r')
    key = f.read
    raise 'Create a file api_key.txt on the project root with your key in it.' if key.nil? || key.empty?
    key
  }

  it 'has a version number' do
    expect(ChJsonApi::VERSION).not_to be nil
  end

  context 'key_validation' do

    it 'does not work if an API key is not passed to the class' do
      expect{ChJsonApi::Company.profile company_number:'0'}.to raise_error(Exception)
    end

    it 'does not work if an empty API key is passed to the class' do
      ChJsonApi.init('')
      expect{ChJsonApi::Company.profile company_number:'00000006'}.to raise_error(RuntimeError)
    end

    it 'does not work if an invalid API key is passed to the class' do
      ChJsonApi.init('INVALID_KEY')
      expect {ChJsonApi::Company.profile company_number:'00000006'}.to raise_error(RuntimeError)
    end

    it 'does work with an array' do
      ChJsonApi.init([key])
      expect {ChJsonApi::Company.profile company_number:'00000006'}.to_not raise_error
    end

    it 'does work with a string' do
      ChJsonApi.init(key)
      expect {ChJsonApi::Company.profile company_number:'00000006'}.to_not raise_error
    end

  end

  describe '#api_call' do

    before :each do
      ChJsonApi.init key
    end

    context 'successful' do
      it 'returns a json object' do
        json = ChJsonApi.api_call('company/00000006', nil)
        expect(json).to_not be_nil
      end

    end

  end

  describe 'Company#profile' do

    before :each do
      ChJsonApi.init key
    end

    it 'searches for a company and return correct data ' do
      company = ChJsonApi::Company.profile company_number:'00000006'

      expect(company['company_number']).to eq '00000006'
      expect(company['date_of_creation']).to eq '1862-10-25'
      expect(company['last_full_members_list_date']).to eq '1986-07-02'
      expect(company['type']).to eq 'private-unlimited-nsc'
      expect(company['jurisdiction']).to eq 'england-wales'
      expect(company['company_name']).to eq 'MARINE AND GENERAL MUTUAL LIFE ASSURANCE SOCIETY'
      expect(company['registered_office_address']['locality']).to eq 'London'
      expect(company['registered_office_address']['address_line_2']).to eq '78 Cannon Street'
      expect(company['registered_office_address']['country']).to eq 'United Kingdom'
      expect(company['registered_office_address']['address_line_1']).to eq 'Cms Cameron Mckenna Llp Cannon Place, 78 Cannon St Cannon Place'
      expect(company['registered_office_address']['postal_code']).to eq 'EC4N 6AF'
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
      expect(company['etag']).to_not be_nil
      expect(company['has_charges']).to eq true
      expect(company['can_file']).to eq true
    end

    it 'handles injections and invalid data' do
      expect{ChJsonApi::Company.profile company_number:'00000006/registered-office-address'}.to raise_error(Exception)
      expect{ChJsonApi::Company.profile company_number:"' ; ls -la"}.to raise_error(Exception)
    end

    it 'raises an exception if the company number does not exist' do
      expect{ChJsonApi::Company.profile company_number:'99999999'}.to raise_error(Exception)
    end

  end

  describe 'Company#registered_address' do

    before :each do
      ChJsonApi.init key
    end

    it 'searches for the registered office and return correct data ' do
      reg_off = ChJsonApi::Company.registered_office company_number:'00000006'

      expect(reg_off['locality']).to eq 'London'
      expect(reg_off['address_line_2']).to eq '78 Cannon Street'
      expect(reg_off['care_of_name']).to eq 'CMS CAMERON MCKENNA LLP'
      expect(reg_off['country']).to eq 'United Kingdom'
      expect(reg_off['address_line_1']).to eq 'Cms Cameron Mckenna Llp Cannon Place, 78 Cannon St Cannon Place'
    end

    it 'handles injections and invalid data' do
      expect{ChJsonApi::Company.registered_office company_number:'00000006/registered-office-address'}.to raise_error(Exception)
      expect{ChJsonApi::Company.registered_office company_number:"' ; ls -la"}.to raise_error(Exception)
    end

    it 'raises an exception if the company number does not exist' do
      expect{ChJsonApi::Company.registered_office company_number:'99999999'}.to raise_exception(Exception)
    end

  end

  describe 'Company#officers' do

    before :each do
      ChJsonApi.init key
    end

    it 'searches for the officers and return correct data ' do
      off = ChJsonApi::Company.officers company_number:'00000006'

      expect(off['active_count']).to eq(4)
      expect(off['resigned_count']).to eq(46)

      expect(off['items'][0]['address']['premises']).to eq 'Cms Cameron Mckenna Llp Cannon Place, 78 Cannon St'
      expect(off['items'][0]['address']['locality']).to eq 'London'
      expect(off['items'][0]['address']['postal_code']).to eq 'EC4N 6AF'
      expect(off['items'][0]['address']['country']).to eq 'United Kingdom'
      expect(off['items'][0]['address']['address_line_1']).to eq 'Cannon Place'
      expect(off['items'][0]['address']['care_of']).to eq 'CMS CAMERON MCKENNA LLP'
      expect(off['items'][0]['officer_role']).to eq 'secretary'
      expect(off['items'][0]['appointed_on']).to eq '2015-06-01'
      expect(off['items'][0]['name']).to eq 'ELSTON, David Aiken'

    end

    it 'handles injections and invalid data' do
      expect{ChJsonApi::Company.officers company_number:'00000006/registered-office-address'}.to raise_error(Exception)
      expect{ChJsonApi::Company.officers company_number:"' ; ls -la"}.to raise_error(Exception)
    end

    it 'returns an empty object if the company number does not exist' do
      company = ChJsonApi::Company.officers company_number:'99999999'
      expect(company).to eq({})
    end

    it 'accepts items_per_page parameter and use it on the request' do

      off = ChJsonApi::Company.officers company_number: '00000006', items_per_page: 2

      expect(off).not_to be_nil
      expect(off['items'].count).to eq 2
      expect(off['items_per_page']).to eq 2

    end

    it 'accepts start_index parameter and use it on the request' do

      off = ChJsonApi::Company.officers company_number: '00000006', start_index: 2

      expect(off).not_to be_nil
      expect(off['items'].count).to_not be 0
      expect(off['start_index']).to eq 2

    end

    it 'accepts order_by parameter and use it on the request' do

      off = ChJsonApi::Company.officers company_number: '00000006', order_by: 'appointed_on'

      expect(off).not_to be_nil
      expect(off['items'].count).to_not be 0

    end

    it 'accepts all parameters and use them on the request' do

      off = ChJsonApi::Company.officers company_number: '00000006', items_per_page: 2, start_index: 2, order_by: 'appointed_on'

      expect(off).not_to be_nil
      expect(off['items'].count).to_not be 0
      expect(off['start_index']).to eq 2
      expect(off['items_per_page']).to eq 2

    end


  end

  describe 'Company#filing_list' do

    before :each do
      ChJsonApi.init key
    end

    it 'lists the filing history of a single company' do
      off = ChJsonApi::Company.filing_list company_number:'00000006'

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['items'].count).not_to be 0

    end

    it 'accepts the category parameter and use it on the query' do
      off = ChJsonApi::Company.filing_list company_number:'00000006', category: 'address'

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['items'].count).not_to be 0
      expect(off['items'][0]['category']).to eq 'address'

    end

    it 'accepts the category parameter as a comma separated list and use it on the query' do
      off = ChJsonApi::Company.filing_list company_number:'00000006', category: 'resolution,address'

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['items'].count).not_to be 0
      expect(%w{address resolution}).to include off['items'][0]['category']

    end

    it 'accepts the items_per_page parameter and use it on the query' do
      off = ChJsonApi::Company.filing_list company_number:'00000006', items_per_page: 2

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['items'].count).to be 2
      expect(off['items_per_page']).to be 2

    end

    it 'accepts the start_index parameter and use it on the query' do
      off = ChJsonApi::Company.filing_list company_number:'00000006', start_index: 2

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['start_index']).to eq '2'

    end

    it 'accepts all parameters and use them on the query' do
      off = ChJsonApi::Company.filing_list company_number:'00000006', start_index: 2, items_per_page: 2, category: 'resolution,address'

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['start_index']).to eq '2'
      expect(off['items'].count).to be 2
      expect(off['items_per_page']).to be 2
      expect(off['items'][0]['category']).to eq 'address'

    end


  end

  describe 'Company#filing_item' do
    it 'lists a specific file of a company' do
      off = ChJsonApi::Company.filing_item company_number:'00000006', transaction_id: 'MzEyNjIzODI3NmFkaXF6a2N4'

      expect(off).not_to be_nil
      expect(off).not_to eq Hash.new
      expect(off['transaction_id']).to eq 'MzEyNjIzODI3NmFkaXF6a2N4'

    end

    it 'handles injections and invalid data' do
      expect{ChJsonApi::Company.filing_item company_number:'00000006/registered-office-address'}.to raise_error(Exception)
      expect{ChJsonApi::Company.filing_item company_number:"' ; ls -la"}.to raise_error(Exception)
    end
  end


  context 'Too Many Requests' do


    describe '#api_call' do
      it 'throws exception when reaching too many requests' do

        ChJsonApi.init key

        allow_any_instance_of(Curl::Easy).to receive(:response_code).and_return(429)

        expect {ChJsonApi::Company.profile company_number: '00000006'}.to raise_error RuntimeError, /too many/i

      end

      it 'works if first keys are exhausted but other ones are not' do
        ChJsonApi.init([key+'too_many_requests_1', key+'too_many_requests_2', key])
        expect {ChJsonApi::Company.profile company_number: '00000006'}.to_not raise_error Exception
      end

      it 'throws exception if no keys are suitable' do
        allow_any_instance_of(Curl::Easy).to receive(:response_code).and_return(429)

        ChJsonApi.init([key+'too_many_requests', key + 'too_many'])
        expect {ChJsonApi::Company.profile company_number: '00000006'}.to raise_error RuntimeError, /too many/i
      end
    end

  end

end
