require 'nokogiri'

def get_xml(xml)
  xml.SpeechRecInit(:label => '') {
      xml.parameter('speechrec.empirix.com', :name => 'Speech Server Address')
      xml.parameter('65', :name => 'Confidence Threshold')
      xml.parameter('0', :name => 'No Input Timeout (ms)')
      xml.parameter('0', :name => 'Recognition Timeout (ms)')
    }
end

builder = Nokogiri::XML::Builder.new do |xml|
  xml.send(:'test-case',:xmlns => 'http://www.empirix.com', :name => 'blahblah', :combine_prompts => 'false') {
    get_xml(xml)
  }
end

puts builder.to_xml

