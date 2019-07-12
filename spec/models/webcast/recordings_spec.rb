describe Webcast::Recordings do

  let(:use_legacy_ccns) { true }
  before do
    allow(Settings.features).to receive(:allow_legacy_fallback).and_return(use_legacy_ccns)
  end

  context 'a fake proxy' do
    let(:recordings) { Webcast::Recordings.new(fake: true).get }
    context 'when integrating with an SIS source which understands legacy CCNs' do
      it 'should return many playlists' do
        expect(recordings[:courses]).to have(25).items
        law_2723 = recordings[:courses]['2008-D-49688']
        expect(law_2723).to_not be_nil
        expect(law_2723[:youtube_playlist]).to eq 'EC8DA9DAD111EAAD28'
        expect(law_2723[:recordings]).to have(12).items
      end
    end
  end
end
