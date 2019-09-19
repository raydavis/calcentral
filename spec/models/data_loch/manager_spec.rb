describe DataLoch::Manager do
  let(:fake_now) { '2018-11-24 04:20:00' }
  let(:target) { 's3_test' }
  let(:fake_paths) do
    [
      'sis-data/daily/06a0108380ebae68856f40b4b44ee65f-2019-09-13/courses/courses-2185.gz',
      'sis-data/daily/06a0108380ebae68856f40b4b44ee65f-2019-09-13/courses/courses-2188.gz',
      'sis-data/daily/06a0108380ebae68856f40b4b44ee65f-2019-09-13/courses/courses-2192.gz',
      'sis-data/daily/06a0108380ebae68856f40b4b44ee65f-2019-09-13/enrollments/enrollments-2185.gz',
      'sis-data/daily/06a0108380ebae68856f40b4b44ee65f-2019-09-13/enrollments/enrollments-2188.gz',
      'sis-data/daily/06a0108380ebae68856f40b4b44ee65f-2019-09-13/enrollments/enrollments-2192.gz',
      'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
      'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2188.gz',
      'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2192.gz',
      'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz',
      'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2188.gz',
      'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2192.gz',
      'sis-data/daily/99ba34f9934f074fc73305975449195b-2019-09-09/courses/courses-2185.gz',
      'sis-data/daily/99ba34f9934f074fc73305975449195b-2019-09-09/courses/courses-2188.gz',
      'sis-data/daily/99ba34f9934f074fc73305975449195b-2019-09-09/courses/courses-2192.gz',
      'sis-data/daily/99ba34f9934f074fc73305975449195b-2019-09-09/enrollments/enrollments-2185.gz',
      'sis-data/daily/99ba34f9934f074fc73305975449195b-2019-09-09/enrollments/enrollments-2188.gz',
      'sis-data/daily/99ba34f9934f074fc73305975449195b-2019-09-09/enrollments/enrollments-2192.gz',
      'sis-data/daily/d74706d9cb3066fabad278e3ee12b79b-2019-09-14/courses/courses-2185.gz',
      'sis-data/daily/d74706d9cb3066fabad278e3ee12b79b-2019-09-14/courses/courses-2188.gz',
      'sis-data/daily/d74706d9cb3066fabad278e3ee12b79b-2019-09-14/courses/courses-2192.gz',
      'sis-data/daily/d74706d9cb3066fabad278e3ee12b79b-2019-09-14/enrollments/enrollments-2185.gz',
      'sis-data/daily/d74706d9cb3066fabad278e3ee12b79b-2019-09-14/enrollments/enrollments-2188.gz',
      'sis-data/daily/d74706d9cb3066fabad278e3ee12b79b-2019-09-14/enrollments/enrollments-2192.gz'
    ]
  end
  let(:mock_s3) do
    allow(DataLoch::S3).to receive(:new).with(target).and_return (mock_s3 = double)
    mock_s3
  end
  before do
    allow(Settings.terms).to receive(:fake_now).and_return(fake_now.to_datetime)
    allow(Settings.features).to receive(:hub_term_api).and_return false
    allow(mock_s3).to receive(:all_subpaths).with('daily').and_return fake_paths
  end

  describe '#manage_terms_data' do
    context 'with one term moving from daily' do
      it 'uploads term GPAs, moves courses/enrollments snapshots, and then does usual refresh' do
        expect(DataLoch::Stocker).to receive(:new).and_return (mock_stocker = double)
        expect(mock_stocker).to receive(:upload_term_gpas).with('2185', [target])
        expect(mock_s3).to receive(:move).with(
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
          'historical/courses/courses-2185.gz'
        )
        expect(mock_s3).to receive(:move).with(
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz',
          'historical/enrollments/enrollments-2185.gz'
        )
        expect(mock_stocker).to receive(:upload_term_data).with(['2188', '2192'], [target])
        subject.manage_terms_data([target])
      end
    end
    context 'with no term transition duties' do
      let(:fake_now) { '2018-08-10 04:20:00' }
      it 'only does the usual refresh' do
        expect(DataLoch::Stocker).to receive(:new).and_return (mock_stocker = double)
        expect(mock_stocker).to receive(:upload_term_data).with(['2185', '2188'], [target])
        subject.manage_terms_data([target])
      end
    end
  end

  describe '#find_pending_transitions' do
    context 'S3 target with one obsolete term' do
      it 'describes the situation' do
        moving_term_id, moving_targets = subject.find_pending_transitions([target], ['2188', '2192'])
        expect(moving_term_id).to eq '2185'
        expect(moving_targets.keys.first)
      end
    end
    context 'S3 target with two obsolete terms' do
      let(:fake_paths) do
        [
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2182.gz',
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz',
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2182.gz',
        ]
      end
      it 'throws an exception rather than mucking around' do
        expect { subject.manage_terms_data([target]) }.to raise_error(RuntimeError)
      end
    end
    context 'clashing obsolete terms across S3 targets' do
      let(:other_target) { 'another_loch' }
      let(:other_fake_paths) do
        [
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2182.gz',
          'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2182.gz',
        ]
      end
      before do
        allow(DataLoch::S3).to receive(:new).with(other_target).and_return (other_mock_s3 = double)
        allow(other_mock_s3).to receive(:all_subpaths).with('daily').and_return other_fake_paths
      end
      it 'throws an exception rather than mucking around' do
        expect { subject.manage_terms_data([target, other_target]) }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#get_daily_terms' do
    context 'middle of normal term' do
      let(:fake_now) { '2018-09-25 04:20:00' }
      it 'updates only the current term' do
        expect(subject.get_daily_terms).to eq ['2188']
      end
    end
    context 'middle of Summer term' do
      let(:fake_now) { '2018-07-04 04:20:00' }
      it 'updates Fall as well' do
        expect(subject.get_daily_terms).to eq ['2185', '2188']
      end
    end
    context 'one month before Fall term end' do
      let(:fake_now) { '2018-11-24 04:20:00' }
      it 'updates Fall and Spring' do
        expect(subject.get_daily_terms).to eq ['2188', '2192']
      end
    end
    context 'one month before Spring term end' do
      let(:fake_now) { '2018-04-21 04:20:00' }
      it 'updates Spring, Summer, and Fall' do
        expect(subject.get_daily_terms).to eq ['2182', '2185', '2188']
      end
    end
    context 'less than two weeks after term start' do
      let(:fake_now) { '2018-01-19 04:20:00' }
      it 'updates the previous term as well the current' do
        expect(subject.get_daily_terms).to eq ['2178', '2182']
      end
    end
  end

  describe '#get_retiring_term_snapshots' do
    it 'finds one term which is no longer current' do
      retiring_terms = subject.get_retiring_term_snapshots(target, ['2188', '2192'])
      expect(retiring_terms).to eq(
        {
          '2185' => [
            'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
            'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz'
          ]
        }
      )
    end
    it 'suggests no changes when terms are stable' do
      retiring_terms = subject.get_retiring_term_snapshots(target, ['2185', '2188', '2192'])
      expect(retiring_terms).to be_blank
    end
    it 'reports multiple non-current snapshots if they exist' do
      retiring_terms = subject.get_retiring_term_snapshots(target, ['2192'])
      expect(retiring_terms.length).to eq 2
      expect(retiring_terms.keys[1]).to eq '2188'
    end
  end

  describe '#get_newest_s3_snaphots' do
    it 'parses S3 storage locations' do
      newest_snapshots = subject.get_newest_s3_snapshots(target)
      expect(newest_snapshots.length).to eq 6
      expect(newest_snapshots).to include(
        'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
        'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz'
      )
    end
  end
end
