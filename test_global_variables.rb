orig_parameter = "@bl_ah dhdkjdkask @abc.hshjshjdshj @xyzd > dhdkjskj @bl_ah."
orig_parameter.scan(/@[\w]*/).each do |param|
  puts param[/@(.+)/, 1]
end
parameter = orig_parameter
y = {'abc' => 'hello', 'xyz' => 'bye', 'bl_ah' => 'ok'}

puts parameter
parameter.gsub!(/@[\w]*/) {|g_var_match| 
  global_variable = g_var_match[/@(.+)/, 1]
  puts y[global_variable]
  y[global_variable] || g_var_match
}

puts parameter

