j = 0
(1..101).each do |test|
  x = []
  x << (j%12)+13
  j = j+1
  x << (j%12)+13
  j = j+1
  x << (j%12)+13
  j = j+1
  temp = <<-EOS
    #{x}
  EOS
  puts temp
end