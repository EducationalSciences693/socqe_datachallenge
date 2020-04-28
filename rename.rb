require 'pry-byebug'

hash = {}
json_files = `ls -a`.split(/\n/).reject { |el| el[-5..-1] != '.json' }.map do |file|
  date = file[14..20]
  partition = file[-8..-1]
  hash[file] = "#{date}_#{partition}"
end
# binding.pry
# puts  "#{date}_#{partition}"
hash.each do |key, value|
  puts 'renaming: ' + key
  puts 'to: ' + value
  `mv #{key} #{value}`
end
