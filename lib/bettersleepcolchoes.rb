# frozen_string_literal: true

require_relative 'bettersleepcolchoes/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'
require 'f1sales_helpers'

module Bettersleepcolchoes
  class Error < StandardError; end

  class F1SalesCustom::Email::Source
    def self.all
      [
        {
          email_id: 'website',
          name: 'Simmons Colchões Fortaleza'
        }
      ]
    end
  end

  class F1SalesCustom::Email::Parser
    def parse
      {
        source: source,
        customer: customer,
        product: product,
        message: lead_message
      }
    end

    def parsed_email
      @email.body.colons_to_hash(/(#{regular_expression}).*? /, false)
    end

    def regular_expression
      'Nome|Telefone|E-mail|Escolha seu local de atendimento|Políticas de privacidade'
    end

    def source
      {
        name: F1SalesCustom::Email::Source.all[0][:name]
      }
    end

    def customer
      {
        name: customer_name,
        phone: customer_phone,
        email: customer_email
      }
    end

    def customer_name
      parsed_email['nome']
    end

    def customer_phone
      parsed_email['telefone'] || parsed_email['celular']
    end

    def customer_email
      parsed_email['email']&.split&.first || ''
    end

    def product
      {
        name: ''
      }
    end

    def lead_message
      "Local de atendimento: #{parsed_email['escolha_seu_local_de_atendimento']}"
    end
  end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead

        return simmons_leads if simmons? || lead_de_empresas?

        source_name['Widgrid'] ? "#{source_name}#{add_store} - Exclusivo" : "#{source_name}#{add_store}"
      end

      private

      def source_name
        @lead.source.name
      end

      def lead_message
        @lead.message || ''
      end

      def description
        @lead.description || ''
      end

      def simmons?
        source_name['Simmons']
      end

      def lead_de_empresas?
        source_name['Lead de empresas']
      end

      def aldeota?
        lead_message['padre_antônio_tomás']
      end

      def sales?
        lead_message['antônio_sales']
      end

      def cambeba?
        lead_message['washington_soares']
      end

      def add_store
        return ' - Aldeota' if aldeota?
        return ' - Sales' if sales?
        return ' - Cambeba' if cambeba?
      end

      def simmons_leads
        source = "#{source_name} - #{description.delete_prefix('Better Sleep ')}"
        source_name['Widgrid'] ? "#{source} - Exclusivo" : source
      end
    end
  end
end
