     
a = []
b = []
(1..10).each do |x|
  
  a << ['sjj'+x.to_s, x]
end

p a
p Hash[a]