module CampusSolutions
  module ChecklistDataExpiry
    def self.expire(uid=nil)
      [CampusSolutions::MyChecklist, CampusSolutions::Sir::SirStatuses].each do |klass|
        klass.expire uid
      end
    end
  end
end
