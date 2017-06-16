returned_records = [{"test_id"=>1070, "created_at"=>1426508220, "failed"=>true, "name"=>"6V-Durango - 8557217820"}, 
{"test_id"=>1071, "created_at"=>1426514657, "failed"=>true, "name"=>"7C-St.Paul - 8557218454"}, 
{"test_id"=>1072, "created_at"=>1426528395, "failed"=>true, "name"=>"8B-Boise - 8557218413"}, 
{"test_id"=>1073, "created_at"=>1426518463, "failed"=>true, "name"=>"CE-Cincinnati-8557218471"}, 
{"test_id"=>1074, "created_at"=>1426524172, "failed"=>true, "name"=>"DE-Troy - 855.721.9481"}, 
{"test_id"=>1075, "created_at"=>1426530065, "failed"=>true, "name"=>"DK-Denver - 855.721.8358"}, 
{"test_id"=>1076, "created_at"=>1426509610, "failed"=>true, "name"=>"DL-Tulsa - 855.721.8379"}, 
{"test_id"=>1077, "created_at"=>1426527506, "failed"=>true, "name"=>"FT-Stockton - 8557218419"}, 
{"test_id"=>1070, "created_at"=>1426521128, "failed"=>false, "name"=>"6V-Durango - 8557217820"}, 
{"test_id"=>1071, "created_at"=>1426530857, "failed"=>false, "name"=>"7C-St.Paul - 8557218454"}, 
{"test_id"=>1072, "created_at"=>1426522946, "failed"=>false, "name"=>"8B-Boise - 8557218413"}, 
{"test_id"=>1068, "created_at"=>1426526495, "failed"=>false, "name"=>"BW-Stamford - 8557218436"}, 
{"test_id"=>1073, "created_at"=>1426531064,"failed"=>false, "name"=>"CE-Cincinnati-8557218471"}, 
{"test_id"=>1074, "created_at"=>1426531674, "failed"=>false, "name"=>"DE-Troy - 855.721.9481"},
{"test_id"=>1075, "created_at"=>1426531865, "failed"=>false, "name"=>"DK-Denver - 855.721.8358"}, 
{"test_id"=>1076, "created_at"=>1426531097, "failed"=>false, "name"=>"DL-Tulsa - 855.721.8379"}, 
{"test_id"=>1077, "created_at"=>1426532005, "failed"=>false, "name"=>"FT-Stockton - 8557218419"}]

p returned_records.count

test_ids = []
temp_hash = {}
returned_records.each_with_index{ |val, index|
  if temp_hash.has_key?(val['test_id'])
    if returned_records.at(temp_hash[val['test_id']])['created_at'] < val['created_at']
      test_ids.delete(val['test_id'])
      test_ids << val['test_id']
      temp_hash[val['test_id']] = index
    end
  else
    temp_hash[val['test_id']] = index
    test_ids << val['test_id']
  end
}

p temp_hash
p test_ids
