# frozen_string_literal: true

require_relative 'bettersleepcolchoes/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'

module Bettersleepcolchoes
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      source_name = lead.source.name
      description = lead.description || ''
      lead_message = lead.message || ''

      return "#{source_name} - #{description.delete_prefix('Better Sleep ')}" if source_name['Simmons']

      return "#{source_name} - #{description.delete_prefix('Better Sleep ')}" if source_name['Lead de empresas']

      return "#{source_name} - Aldeota" if lead_message['padre_antônio_tomás']

      return "#{source_name} - Sales" if lead_message['antônio_sales']

      return "#{source_name} - Cambeba" if lead_message['washington_soares']

      source_name
    end
  end
end
