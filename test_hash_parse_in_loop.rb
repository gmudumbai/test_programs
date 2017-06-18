script_hash = {
"first_step"=>{"id"=>20, "name"=>"Place Call", "label"=>"Place Call", "error"=>"false", 
  "parameters"=>{"number_to_call"=>{"type"=>"t", "value"=>"18003130001", "param_label"=>"numbertocall", "is_parameter"=>true}}}, 
"steps"=>[
  {"id"=>169, "name"=>"Hear voice", "label"=>"Hear voice 1", "error"=>"false", 
    "parameters"=>{"phrase"=>{"type"=>"ta", "value"=>"@test_variable_1 ", "is_parameter"=>true, "param_label"=>"Test"}, 
      "max_silence"=>{"type"=>"t", "value"=>"1000", "is_parameter"=>false, "param_label"=>""}}, "index"=>0}, 
  {"id"=>23, "name"=>"Press", "label"=>"Press", "error"=>"false", 
    "parameters"=>{"digits"=>{"type"=>"t", "value"=>"1234", "is_parameter"=>false, "param_label"=>""}}, "index"=>1}, 
  {"id"=>169, "name"=>"Hear voice", "label"=>"Hear voice 2", "error"=>"false", 
    "parameters"=>{"phrase"=>{"type"=>"ta", "value"=>"@test_variable_1 @test_variable_1 ", "is_parameter"=>false, "param_label"=>""}, 
      "max_silence"=>{"type"=>"t", "value"=>"1000", "is_parameter"=>false, "param_label"=>""}}, "index"=>2}], 
  "last_step"=>{"id"=>2, "name"=>"Release Call", "label"=>"Release Call", "error"=>"false", "parameters"=>[]}, "name"=>"After_Upgrade", "description"=>"", "isCopyScript"=>false}


#puts script_hash
#puts script_hash['steps']

script_hash['steps'].each do |step|
  #puts step
  #puts step['parameters']
  #puts step['parameters'].values
  step['parameters'].values.each do |param|
    #puts param['value']
    param['value'] = 'replaced'
  end
end

puts script_hash