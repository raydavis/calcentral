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
  before do
    allow(Settings.terms).to receive(:fake_now).and_return(fake_now.to_datetime)
    allow(Settings.features).to receive(:hub_term_api).and_return false
    allow(DataLoch::S3).to receive(:new).with(target).and_return (mock_s3 = double)
    allow(mock_s3).to receive(:all_subpaths).with('daily').and_return fake_paths
  end

  describe '#get_daily_terms' do
    context 'middle of term' do
      let(:fake_now) { '2018-09-25 04:20:00' }
      it 'updates only the current term' do
        expect(subject.get_daily_terms).to eq ['2188']
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
    context 'less than one month after term start' do
      let(:fake_now) { '2018-01-09 04:20:00' }
      it 'updates the previous term as well the current' do
        expect(subject.get_daily_terms).to eq ['2178', '2182']
      end
    end
  end

  describe '#get_retiring_term_snapshots' do
    it 'finds one term which is no longer current' do
      retiring_terms = subject.get_retiring_term_snapshots(target, ['2188', '2192'])
      expect(retiring_terms).to eq [
        {
          term_id: '2185',
          paths: [
            'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
            'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz'
          ]
        }
      ]
    end
    it 'suggests no changes when terms are stable' do
      retiring_terms = subject.get_retiring_term_snapshots(target, ['2185', '2188', '2192'])
      expect(retiring_terms).to be_blank
    end
    it 'reports multiple non-current snapshots if they exist' do
      retiring_terms = subject.get_retiring_term_snapshots(target, ['2192'])
      expect(retiring_terms.length).to eq 2
      expect(retiring_terms[1][:term_id]).to eq '2188'
    end
  end

  describe '#get_newest_s3_snaphots' do
    it 'parses S3 storage locations' do
      location_hash = subject.get_newest_s3_snapshots(target)
      expect(location_hash.keys()).to eq ['2185', '2188', '2192']
      expect(location_hash['2185']).to eq [
        'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/courses/courses-2185.gz',
        'sis-data/daily/6aeb9b3242ce1f3f51bd6df21e173993-2019-09-16/enrollments/enrollments-2185.gz'
      ]
    end
  end

    # Check for S3 moves:
    #   - If one month or more after the start of the current term, check S3 storage locations.
    #     - If previous term's courses/enrollments data is in 'daily', move it to 'historical'.
    #     - If previous term's GPA data is not in s3://la-nessie-*/sis-data/historical/gpa,
    #       run upload_term_gpas.
    # Decide which terms get the usual daily treatment:
    #   - If one month or less before the end of the current term, add the future term (or terms, for Spring)
    #   - If one month or less after the start of the current term, continue to include the previous term

end
