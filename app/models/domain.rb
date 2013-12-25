class Domain < ActiveRecord::Base
  belongs_to :directory_node
  belongs_to :user

  validates :name, presence: true, uniqueness: true

  @@base_domains = if ENV['ECMASH_DOMAINS']
                     ENV['ECMASH_DOMAINS'].split(",").map(&:strip)
                   else
                     [ 'www.ecmash.com', 'localhost' ]
                   end

  @@base_domains += [ 'test.com' ] if Rails.env.test?

  @@base_domain_hash = {}
  @@base_domains.each { |d| @@base_domain_hash[d] = true }

  def self.base_domain?(domain_name)
    @@base_domain_hash[domain_name.to_s.downcase] || false
  end
  
  def self.base_directory(name)
    d = Domain.where(name: name.to_s).first
    d ? d.directory_node : nil
  end
end
