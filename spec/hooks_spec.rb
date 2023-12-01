require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Hooks::Lead do
  context 'when come from Simmons' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.description = ''

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = 'Fonte'

      source
    end

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when is not form Simmons' do
      it 'returns source' do
        expect(switch_source).to eq('Fonte')
      end
    end

    context 'when leads come from Simmons - Widgrid ' do
      before do
        source.name = 'Simmons - Widgrid'
        lead.description = 'Better Sleep Aldeota'
      end

      context 'when lead is to Better Sleep Aldeota' do
        it 'returns Simmons - Widgrid - Better Sleep Aldeota' do
          expect(switch_source).to eq('Simmons - Widgrid - Aldeota')
        end
      end
    end

    context 'when leads come form Simmons - Facebook' do
      before do
        source.name = 'Simmons - Facebook'
        lead.description = 'Better Sleep Antonio Sales'
      end

      context 'when lead is to Better Sleep Aldeota' do
        it 'returns Simmons - Facebook - Better Sleep Aldeota' do
          expect(switch_source).to eq('Simmons - Facebook - Antonio Sales')
        end
      end
    end

    context 'when leads come form Lead de empresas' do
      before do
        source.name = 'Lead de empresas'
        lead.description = 'Better Sleep Antonio Sales'
      end

      context 'when lead is to Better Sleep Aldeota' do
        it 'returns Lead de empresas - Better Sleep Aldeota' do
          expect(switch_source).to eq('Lead de empresas - Antonio Sales')
        end
      end
    end

    context 'when leads come from Facebook' do
      context 'when is to Aldeota' do
        before do
          source.name = 'Facebook - Better Sleep Colchões'
          lead.message = 'escolha_seu_local_de_atendimento: av._padre_antônio_tomás,_2749'
        end

        it 'returns Facebook - Better Sleep Colchões - Aldeota' do
          expect(switch_source).to eq('Facebook - Better Sleep Colchões - Aldeota')
        end
      end

      context 'when is to Antonio Sales' do
        before do
          source.name = 'Facebook - Better Sleep Colchões'
          lead.message = 'escolha_seu_local_de_atendimento: av._antônio_sales,_2895'
        end

        it 'returns Facebook - Better Sleep Colchões - Sales' do
          expect(switch_source).to eq('Facebook - Better Sleep Colchões - Sales')
        end
      end

      context 'when is to Cambeba' do
        before do
          source.name = 'Facebook - Better Sleep Colchões'
          lead.message = 'escolha_seu_local_de_atendimento: av._washington_soares,_4527'
        end

        it 'returns Facebook - Better Sleep Colchões - Cambeba' do
          expect(switch_source).to eq('Facebook - Better Sleep Colchões - Cambeba')
        end
      end
    end
  end
end
