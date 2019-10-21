module EdoOracle
  class Connection < OracleBase

    # WARNING: Default Rails SQL query caching (done for the lifetime of a controller action) apparently does not apply
    # to anything but the primary DB connection. Any Oracle query caching needs to be handled explicitly.
    establish_connection :edodb

    def self.settings
      Settings.edodb
    end

    def self.query(sql, opts={})
      result = use_pooled_connection do
        Rails.logger.debug("#{self.name} working with connection #{connection}, object_id #{connection.object_id}, from pool #{connection_pool}")
        inner_query(sql)
      end
      opts[:do_not_stringify] ? result : stringify_ints!(result)
    end

    def self.inner_query(sql)
      if Rails.logger.debug?
        pool_connections = connection_pool.connections
        Rails.logger.debug("Current pool size #{pool_connections.size}")
        pool_desc = pool_connections.map {|c| {
          id: c.object_id,
          owner: (c.owner && c.owner.to_s),
          conn_in_use: !!c.in_use?,
          thread_status: (c.owner && c.owner.status)
        }}
        Rails.logger.debug("Connections = #{pool_desc}")
      end
      connection.select_all sql
    end

    def self.safe_query(sql, opts={})
      query(sql, opts)
    rescue => e
      logger.error "Query failed: #{e.class}: #{e.message}\n #{e.backtrace.join("\n ")}"
      []
    end

    def self.fallible_query(sql, opts={})
      query(sql, opts)
    rescue => e
      logger.fatal "Query failed: #{e.class}: #{e.message}\n #{e.backtrace.join("\n ")}"
      raise RuntimeError, "Fatal database failure"
    end

    def self.stringified_columns
      %w(campus-uid meeting_num section_id ldap_uid student_id)
    end

    def self.terms_query_list(terms = nil)
      terms.try :compact!
      return '' unless terms.present?
      terms.map { |term| "'#{term.campus_solutions_id}'" }.join ','
    end
  end
end
