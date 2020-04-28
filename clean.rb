require 'pry-byebug'
require 'json'
require 'date'
require 'csv'

def add_to(hash, key)
  if hash.has_key? key
    hash[key] += 1
  else
    hash[key] = 1
  end
end
countries = {}
outlet_sites = {}
headers = ['source_file','date', 'month_number', 'week_number', 'country','publication', 'publication_site', 'number_of_shares','title', 'content']

files_to_clean = `ls *.json`.split(".json\n").reject {|s| s.include?('cleaned')}
CSV.open("./flattened_news_data.csv", "wb", headers: true) do |csv|
  csv << headers
  files_to_clean.each do |file_name|
    File.open("#{file_name}.json", "r") do |f|
      puts "Process #{file_name}"
      f.each_line do |line|
        begin
          new_line = JSON.parse(line.gsub('=>',':'))
        rescue => exception
          puts 'skipped line'
          `echo #{line} > skipped_exceptions.json`
          binding.pry
        end
        country = new_line.dig('thread','country')
        add_to(countries, country)
        publication = new_line.dig('thread', 'section_title')
        publication_site = new_line.dig('thread','site')
        add_to(outlet_sites, publication_site)
        site_type = new_line.dig('thread','site_type')
        published_date = Date.parse(new_line.dig('published')).strftime('%Y/%m/%d')
        title = new_line.dig('title')
        number_of_shares = new_line['thread']['social'].values.map {|el| el['shares']}.reduce(:+)
        cleaned_text = new_line['text'].gsub(/\n/, ' ').gsub(/\r/, ' ').gsub(/\"/, "'")
        csv_line = [
          file_name,
          published_date,
          country,
          publication,
          publication_site,
          number_of_shares,
          title,
          cleaned_text
        ]
        # Append to CSV
        csv << csv_line
        # put into cleaned JSON
        # new_line['text'] = cleaned_text
        # File.open("#{file_name}_cleaned.json", 'a') do |f|
        #   f.write(new_line.to_s + "\n")
        # end
      end
    end
  end
end

# `echo #{countries} > countries.txt`
# `echo #{outlet_sites} > outlet_sites.txt`

puts "done"
