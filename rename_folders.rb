require 'fileutils'
require 'date'

dest = "Z:/Probe-Configurator"

Dir.entries(dest).select {|entry| 
if File.directory? File.join(dest,entry) and !(entry =='.' || entry == '..')
  p FileUtils.mv dest+'/'+entry, dest+'/'+DateTime.strptime(entry,'%m-%d-%Y').strftime('%Y-%m-%d') 
end
}