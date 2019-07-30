module User
  class HasStudentHistory < UserSpecificModel

    extend Cache::Cacheable
    include Cache::UserCacheExpiry

    def has_student_history?
      self.class.fetch_from_cache @uid do
        EdoOracle::Queries.has_student_history?(@uid)
      end
    end
  end
end
