describe HubEdos::Affiliations do
  context 'mock proxy' do
    before do
      allow(CalnetLdap::UserAttributes).to receive(:new).and_return double(get_feed: {campus_solutions_id: '11667051'})
    end
    let(:proxy) { HubEdos::Affiliations.new(fake: true, user_id: '61889') }
    subject { proxy.get }

    it_should_behave_like 'a simple proxy that returns errors'

    it 'returns data with the expected structure' do
      expect(subject[:feed]['student']).to be
      expect(subject[:feed]['student']['affiliations'].length).to eq 2
      expect(subject[:feed]['student']['identifiers'].length).to eq 1
    end
  end
end
