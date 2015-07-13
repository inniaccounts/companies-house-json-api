class CHJsonAPI
  class Company

    def self.profile(param_hash)
      req, _ = validate_param_hash param_hash, [:company_number]
      CHJsonAPI.api_call("company/#{req[:company_number]}", nil, 'XGET')
    end

    def self.registered_office(param_hash)
      req, _ = validate_param_hash param_hash, [:company_number]
      CHJsonAPI.api_call("company/#{req[:company_number]}/registered-office-address", nil, 'XGET')
    end

    def self.officers(param_hash)
      req, opt = validate_param_hash param_hash, [:company_number], [:items_per_page,:start_index,:order_by]
      CHJsonAPI.api_call("company/#{req[:company_number]}/officers", opt, 'XGET')
    end

    def self.filing_item(param_hash)
      req, _ = validate_param_hash param_hash, [:company_number, :transaction_id]
      CHJsonAPI.api_call("company/#{req[:company_number]}/filing-history/#{req[:transaction_id]}", nil, 'XGET')
    end

    def self.filing_list(param_hash)
      req, opt = validate_param_hash param_hash, [:company_number], [:items_per_page,:start_index,:category]
      CHJsonAPI.api_call("company/#{req[:company_number]}/filing-history", opt, 'XGET')
    end



    def self.validate_param_hash(param_hash, required, optional=[])
      if param_hash.kind_of? Hash

        required_fields = {}
        optional_fields = []
        param_hash.each do |key, value|

          if (required.include? key) && value.to_s.scan(/[^0-9a-zA-Z_\-=,]/).empty?
            required_fields[key] = value
            required.delete key
          elsif (optional.include? key) && value.to_s.scan(/[^0-9a-zA-Z_\-=,]/).empty?
            optional_fields << "#{key}=#{value}"
            optional.delete key
          end

        end

        raise "Required fields not provided: #{required.to_s}" unless required.empty?

        [required_fields, optional_fields]

      end
    end

  end
end