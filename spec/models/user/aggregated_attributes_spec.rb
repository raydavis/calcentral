describe User::AggregatedAttributes do
  let(:uid) { random_id }
  let(:campus_solutions_id) { random_cs_id }
  let(:legacy_student_id) { random_id }
  let(:preferred_name) { 'Grigori Rasputin' }
  let(:bmail_from_edo) { 'rasputin@berkeley.edu' }
  let(:edo_attributes) do
    {
      ldap_uid: uid,
      person_name: preferred_name,
      student_id: campus_solutions_id,
      campus_solutions_id: campus_solutions_id,
      is_legacy_student: false,
      official_bmail_address: bmail_from_edo,
      roles: {
        student: true
      }
    }
  end
  let(:ldap_attributes) do
    {
      roles: {
        recentStudent: true
      }
    }
  end

  subject { User::AggregatedAttributes.new(uid).get_feed }

  before(:each) do
    allow(HubEdos::UserAttributes).to receive(:new).with(user_id: uid).and_return double get: edo_attributes
    allow(CalnetLdap::UserAttributes).to receive(:new).with(user_id: uid).and_return double get_feed: ldap_attributes
    allow(CampusOracle::UserAttributes).to receive(:new).with(user_id: uid).and_return double(get_feed: {})
  end

  describe 'all systems available' do
    context 'Hub feed' do
      it 'should return edo user attributes' do
        expect(subject[:isLegacyStudent]).to be false
        expect(subject[:sisProfileVisible]).to be true
        expect(subject[:officialBmailAddress]).to eq bmail_from_edo
        expect(subject[:campusSolutionsId]).to eq campus_solutions_id
        expect(subject[:studentId]).to eq campus_solutions_id
        expect(subject[:ldapUid]).to eq uid
        expect(subject[:roles][:recentStudent]).to be_falsey
        expect(subject[:unknown]).to be_falsey
      end
    end
  end

  describe 'LDAP is fallback' do
    let(:bmail_from_ldap) { 'raspy@berkeley.edu' }
    let(:ldap_attributes) do
      {
        ldap_uid: uid,
        official_bmail_address: bmail_from_ldap,
        roles: {
          student: is_active_student,
          exStudent: !is_active_student,
          recentStudent: !is_active_student,
          faculty: false,
          staff: true
        }
      }
    end
    context 'active student' do
      let(:is_active_student) { true }
      it 'should prefer EDO' do
        expect(subject[:officialBmailAddress]).to eq bmail_from_edo
        expect(subject[:roles][:student]).to be true
        expect(subject[:roles][:recentStudent]).to be_falsey
        expect(subject[:roles][:exStudent]).to be_falsey
        expect(subject[:unknown]).to be_falsey
      end
    end
    context 'former student according to LDAP' do
      let(:is_active_student) { false }
      it 'should still prefer EDO when EDO claims active student status' do
        expect(subject[:officialBmailAddress]).to eq bmail_from_edo
        expect(subject[:roles][:student]).to be true
        expect(subject[:roles][:recentStudent]).to be_falsey
        expect(subject[:roles][:exStudent]).to be_falsey
        expect(subject[:unknown]).to be_falsey
      end
      context 'EDO does not know about former student status' do
        let(:edo_attributes) do
          {
            ldap_uid: uid,
            person_name: preferred_name,
            student_id: campus_solutions_id,
            campus_solutions_id: campus_solutions_id,
            is_legacy_student: false,
            official_bmail_address: bmail_from_edo,
            roles: {
              advisor: true
            }
          }
        end
        it 'fills in former student status and other attributes from LDAP' do
          expect(subject[:officialBmailAddress]).to eq bmail_from_ldap
          expect(subject[:roles][:student]).to be false
          expect(subject[:roles][:recentStudent]).to be true
          expect(subject[:roles][:exStudent]).to be true
          expect(subject[:roles][:advisor]).to be true
          expect(subject[:unknown]).to be_falsey
        end
      end
    end
    context 'applicant' do
      let(:edo_attributes) do
        {
          ldap_uid: uid,
          person_name: preferred_name,
          student_id: campus_solutions_id,
          campus_solutions_id: campus_solutions_id,
          official_bmail_address: bmail_from_edo,
          roles: {
            staff: true,
            applicant: true
          }
        }
      end
      let(:is_active_student) { false }
      it 'should prefer EDO' do
        expect(subject[:officialBmailAddress]).to eq bmail_from_edo
        expect(subject[:roles][:recentStudent]).to be true
        expect(subject[:unknown]).to be_falsey
      end
    end
    context 'graduate' do
      let(:edo_attributes) do
        {
          ldap_uid: uid,
          person_name: preferred_name,
          student_id: campus_solutions_id,
          campus_solutions_id: campus_solutions_id,
          official_bmail_address: bmail_from_edo,
          roles: {
            staff: true,
            graduate: true
          }
        }
      end
      let(:is_active_student) { true }
      it 'picks up EDO role' do
        expect(subject[:roles][:graduate]).to be true
        expect(subject[:unknown]).to be_falsey
      end
    end
    context 'unknown UID' do
      let(:edo_attributes) do
        {
          ldap_uid: uid
        }
      end
      let(:ldap_attributes) do
        {}
      end
      it 'succeeds but delivers the bad news' do
        expect(subject[:ldapUid]).to eq uid
        expect(subject[:unknown]).to be_truthy
      end
    end
    context 'broken Hub API' do
      let(:is_active_student) { true }
      let(:edo_attributes) do
        {
          body: 'An unknown server error occurred',
          statusCode: 503
        }
      end
      it 'relies on LDAP and Oracle' do
        expect(subject[:officialBmailAddress]).to eq bmail_from_ldap
        expect(subject[:roles][:student]).to be true
        expect(subject[:roles][:recentStudent]).to be false
        expect(subject[:ldapUid]).to eq uid
      end
    end
  end

end
