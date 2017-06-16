require 'yaml'

class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.empty? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

$config = YAML.load_file('config.yml')

def test_default(x=false)
  print "This is true" if x
    
  p x
end

#test_default(nil)
#test_default
#test_default(true)
#test_default(false)
#test_default('true'.to_bool)
#test_default('false'.to_bool)
#test_default(''.to_bool)
if $config['use_proxy_for_cm']
  p "Log to SQL"
else
  p "Do not Log to SQL"
end  
  