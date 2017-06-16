require 'yaml'
require 'rubygems'
require 'sqljdbc4.jar'
require 'active_record'
require 'active_record/connection_adapters/jdbc_adapter'
require 'date'

cfg_str = <<END_CFG
adapter: 'jdbc'
url: 'jdbc:sqlserver://10.92.21.1;databaseName=vwdb'
username: 'webuser'
password: 'N5p@dm1n'
driver: 'com.microsoft.sqlserver.jdbc.SQLServerDriver'
autocommit: true
END_CFG

cfg = YAML::load(cfg_str)
p cfg

ActiveRecord::Base.establish_connection(cfg)

class Test < ActiveRecord::Base
  has_many :test_tags
  has_many :tags, through: :test_tags
end

class Tag < ActiveRecord::Base
  has_many :test_tags
  has_many :tests, through: :test_tags
end

class TestTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :test
end

#a = Tag.create(:client_id => '1671', :name => 'NE')
#b = Tag.create(:client_id => '1671', :name => 'Banking')
#c = Tag.create(:client_id => '1671', :name => 'Checking')

x = Test.last

#TestTag.create(:test_id => x.id, :tag_id => a.id)
#TestTag.create(:test_id => x.id, :tag_id => b.id)
#TestTag.create(:test_id => x.id, :tag_id => c.id)

puts x.tags.pluck(:name)
puts x.tags.pluck(:name).class
p x.tags.pluck(:name).to_a
p x.tags.pluck(:name)