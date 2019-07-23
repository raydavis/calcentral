describe HubEdos::Contacts do

  context 'mock proxy' do
    before(:each) do
      allow(Settings.terms).to receive(:fake_now).and_return('2017-11-07 00:00:00')
      allow(CalnetLdap::UserAttributes).to receive(:new).and_return double(get_feed: {campus_solutions_id: '11667051'})
    end
    let(:proxy) { HubEdos::Contacts.new(fake: true, user_id: '61889') }
    subject { proxy.get }

    it_should_behave_like 'a simple proxy that returns errors'

    it 'returns data with the expected structure' do
      expect(subject[:feed]['student']).to be
      expect(subject[:feed]['student']['identifiers'][0]['type']).to be
      expect(subject[:feed]['student']['addresses'][0]['state']).to eq 'CA'
      expect(subject[:feed]['student']['addresses'][0]['postal']).to eq '94708'
      expect(subject[:feed]['student']['addresses'][0]['country']).to eq 'USA'
      expect(subject[:feed]['student']['addresses'][0]['formattedAddress']).to eq "1234 56TH ST\nAPT 789, BOX 101112\nBERKELEY, California 94708"
      expect(subject[:feed]['student']['phones'].length).to eq 1
    end

    it 'properly removes inactive addresses' do
      expect(subject[:feed]['student']['addresses'].length).to eq 2
    end
  end
end