describe CanvasCsv::Synchronization do
  before { CanvasCsv::Synchronization.create(last_guest_user_sync: 1.weeks.ago.utc) }

  describe '.get' do
    it 'raises exception if more than one record exists' do
      CanvasCsv::Synchronization.create(last_guest_user_sync: 2.weeks.ago.utc)
      expect { CanvasCsv::Synchronization.get }.to raise_error(RuntimeError, 'Canvas synchronization data has more than one record!')
    end

    it 'returns primary synchronization record' do
      result = CanvasCsv::Synchronization.get
      expect(result).to be_an_instance_of CanvasCsv::Synchronization
      expect(result.last_guest_user_sync).to be_an_instance_of ActiveSupport::TimeWithZone
    end

    it 'initializes the synchronization record if necessary' do
      CanvasCsv::Synchronization.delete_all
      expect(CanvasCsv::Synchronization.count).to eq 0
      result = CanvasCsv::Synchronization.get
      expect(result).to be_an_instance_of CanvasCsv::Synchronization
      expect(result.last_guest_user_sync).to be_an_instance_of ActiveSupport::TimeWithZone
    end
  end
end
