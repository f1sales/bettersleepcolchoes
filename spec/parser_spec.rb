require 'ostruct'
require 'byebug'

RSpec.describe F1SalesCustom::Email::Parser do
  context 'when came from the website' do
    let(:email) do
      email = OpenStruct.new
      email.to = [email: 'teste@lojateste.f1sales.net']
      email.subject = 'NOVO LEAD INTERESSADO EM COMPRAR CARRO'
      email.body = "Parabéns! Você acaba de receber um novo lead.\nInformações sobre o lead\nNome Luiz felix de carvalho\nE-mail luizfelixdecarvalho76@gmail.com\nTelefone (88) 9925-01434\nEscolha seu local de atendimento Av. Washington Soares, 4527\nPolíticas de privacidade Sim\nReferral source https://www.google.com/\nDispositivo Mobile\nURL\nhttps://simmonscolchoesfortaleza.com.br/?utm_source=google&utm_medium=cpc&utm_campaign=sitelink&utm_term=conhecaanossaloja&utm_source=google&utm_medium=search::cpc&utm_campaign=20217418313&utm_term=b_comprar%20colch%C3%A3o&gclid=CjwKCAjwpuajBhBpEiwA_ZtfhSwaHOPxGcuAxEwMMXzEh4pda0VGTN2NXsTLiO0avxjoe4NBnMVpvRoCGVQQAvD_BwE\nIP do Usuario 179.48.125.1\nData de conversão 02/06/2023 13:09:57"

      email
    end

    let(:parsed_email) { described_class.new(email).parse }

    it 'contains lead website a source name' do
      expect(parsed_email[:source][:name]).to eq('Simmons Colchões Fortaleza')
    end

    it 'contains name' do
      expect(parsed_email[:customer][:name]).to eq('Luiz felix de carvalho')
    end

    it 'contains phone' do
      expect(parsed_email[:customer][:phone]).to eq('(88) 9925-01434')
    end

    it 'contains email' do
      expect(parsed_email[:customer][:email]).to eq('luizfelixdecarvalho76@gmail.com')
    end

    it 'contains message' do
      expect(parsed_email[:message]).to eq('Local de atendimento: Av. Washington Soares, 4527')
    end

    it 'contains product name' do
      expect(parsed_email[:product][:name]).to eq('')
    end
  end
end
