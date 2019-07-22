module User
  class Photo

    def self.fetch(uid, opts={})
      photo_feed = Cal1card::Photo.new(uid).get_feed
      photo_feed[:photo] ? photo_feed : nil
    end

  end
end
