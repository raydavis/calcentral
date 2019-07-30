describe HubEdos::V2StudentsApi do

  context 'mock proxy' do
    let(:proxy) { HubEdos::V2StudentsApi.new(fake: true, sid: '11667051') }
    subject { proxy.get }

    it_should_behave_like 'a simple proxy that returns errors'

    it 'returns data with the expected structure' do
      feed = subject[:feed]
      expect(feed['identifiers'][0]['type']).to eq 'student-id'
      expect(feed['identifiers'][0]['id']).to eq '11667051'
      expect(feed['identifiers'][1]['type']).to eq 'campus-uid'
      expect(feed['identifiers'][1]['id']).to eq '61889'
      expect(feed['affiliations'].length).to eq 2
      expect(feed['names'].length).to eq 2
      expect(feed['names'][0]['type']['code']).to eq 'PRF'
      expect(feed['names'][0]['givenName']).to eq 'Ziggy'
      expect(feed['names'][0]['familyName']).to eq 'Stardust'
      expect(feed['names'][1]['type']['code']).to eq 'PRI'
      expect(feed['names'][1]['givenName']).to eq 'Oski'
      expect(feed['names'][1]['familyName']).to eq 'Bear'
      expect(feed['emails'].length).to eq 2
      expect(feed['emails'][0]['type']['code']).to eq 'OTHR'
      expect(feed['emails'][0]['primary']).to be_truthy
      expect(feed['emails'][0]['emailAddress']).to eq 'oski@gmail.com'
      expect(feed['emails'][1]['type']['code']).to eq 'CAMP'
      expect(feed['emails'][1]['primary']).to be_falsey
      expect(feed['emails'][1]['emailAddress']).to eq 'oski@berkeley.edu'
    end
  end
end
