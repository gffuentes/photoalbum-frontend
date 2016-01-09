require 'aws-sdk'

class AwsStorage
  attr_reader :bucket, :galleries, :gallery_names

  def initialize(attributes={})
    Aws.config.update({
        region: 'us-east-1',
        credentials: Aws::Credentials.new(ENV['AWS_API_KEY'], ENV['AWS_SECRET_KEY'])
      })

    @bucket = Aws::S3::Bucket.new(:name => 'gabe-storage')
    @galleries = @bucket.objects('images').map(&:key).reject{|i| i.include?('.') || i == 'images/' || i.include?("/small")}
    @gallery_names = @galleries.map{|i| i.gsub("images","").gsub("/","").capitalize }
  end
  def images_for(gallery_name)
    @bucket.objects({prefix: "images/#{gallery_name.downcase.gsub('+',' ')}/"}).select{|i| i.key unless i.key == "images/#{gallery_name}/" || !i.key.include?('.jpg')}.map(&:key)
  end
end
