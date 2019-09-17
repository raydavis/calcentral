module DataLoch
  class S3
    include ActiveAttrModel, ClassLogger

    attr_reader :bucket
    attr_reader :prefix
    attr_reader :resource

    def initialize(target=nil)
      settings = Settings.data_loch
      s3_config = settings.targets.find {|c| c.name == target}
      raise ArgumentError, "Could not find data_loch target #{target}" unless s3_config
      @bucket = s3_config.bucket
      @prefix = s3_config.prefix
      @resource = Aws::S3::Resource.new(
        credentials: Aws::Credentials.new(s3_config.aws_key, s3_config.aws_secret),
        region: s3_config.aws_region
      )
    end

    def all_subpaths(subfolder)
      full_path = "#{@prefix}/#{subfolder}"
      @resource.bucket(@bucket).objects({prefix: full_path}).collect(&:key)
    end

    def upload(subfolder, local_path)
      key = "#{@prefix}/#{subfolder}/#{File.basename local_path}"
      begin
        @resource.bucket(@bucket).object(key).upload_file local_path, server_side_encryption: 'AES256'
        logger.info("S3 upload complete (bucket=#{@bucket}, key=#{key}")
        key
      rescue => e
        logger.error("Error on S3 upload (bucket=#{@bucket}, key=#{key}: #{e.message}")
        nil
      end
    end

    def load_advisee_sids()
      key = Settings.data_loch.advisees_key
      begin
        s3obj = @resource.bucket(@bucket).object(key)
        sids = s3obj.get().body.string.split.to_set
        logger.info("Fetched #{sids.length} SIDs from (bucket=#{@bucket}, key=#{key}")
        sids
      rescue => e
        logger.error("Error on S3 SIDs fetch from (bucket=#{@bucket}, key=#{key}: #{e.message}")
        nil
      end
    end

  end
end
