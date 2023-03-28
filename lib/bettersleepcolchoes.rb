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
      description = lead.description

      return "#{source_name} - #{description.delete_prefix('Better Sleep ')}" if source_name['Simmons']

      return "#{source_name} - #{description.delete_prefix('Better Sleep ')}" if source_name['Lead de empresas']

      source_name
    end
  end
end
