require 'pry-byebug'
require 'json'
require 'date'
require 'csv'

headers = ['url', 'title', 'bias']
CSV.open("./allsides_bias.csv", "wb", headers: true) do |csv|
  csv << headers
  File.open("biasRatings.json", "r") do |f|
    f.each_line do |line|
      JSON.parse(line).each do |publication|
        url = publication.first
        title = publication.last['title']
        rating = publication.last['rating']
        csv << [url, title, rating]
      end
    end
  end
end
