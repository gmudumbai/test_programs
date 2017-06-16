x = nil;
y = [{:first => "sjjs"},{:last => "sjkjwo"}]
z = [{:first => "wwee"},{:last => "tyyuui"}]

x = x.to_s + y.join(',') + ";"
puts x # result: {:first=>"sjjs"},{:last=>"sjkjwo"};

x = x.to_s + z.join(',') + ";"
puts x # result: {:first=>"sjjs"},{:last=>"sjkjwo"};{:first=>"wwee"},{:last=>"tyyuui"};