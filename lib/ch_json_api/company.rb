class CHJsonAPI
  class Company
    def self.profile(company_number)

      return {} unless company_number.scan(/[^0-9a-zA-Z]/).empty?

      CHJsonAPI.api_call("company/#{company_number}",'XGET')
    end

    def self.registered_office(company_number)

      return {} unless company_number.scan(/[^0-9a-zA-Z]/).empty?

      CHJsonAPI.api_call("company/#{company_number}/registered-office-address",'XGET')
    end

    def self.officers(company_number)

      return {} unless company_number.scan(/[^0-9a-zA-Z]/).empty?

      CHJsonAPI.api_call("company/#{company_number}/officers",'XGET')
    end
  end
end