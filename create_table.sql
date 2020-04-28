CREATE TABLE articles (
  index serial NOT NULL,
  published_date date,
  country CHAR(2),
  publication VARCHAR,
  publication_site VARCHAR,
  number_of_shares INTEGER,
  title VARCHAR
);

CREATE INDEX CONCURRENTLY ON articles (publication_site);

COPY articles (published_date, country, publication, publication_site, number_of_shares, title, content)
FROM '/Users/arielfogel/Downloads/data_challenge/flattened_news_data.csv' CSV HEADER;
ALTER TABLE articles ADD COLUMN content VARCHAR;
ALTER TABLE articles ADD COLUMN month date;
ALTER TABLE articles ADD COLUMN week date;
UPDATE articles SET week = date_trunc('week', published_date);
UPDATE articles SET month = date_trunc('month', published_date);


CREATE TABLE bias (
  index serial NOT NULL,
  url VARCHAR,
  title VARCHAR,
  bias VARCHAR
);

COPY bias (url, title, bias)
FROM '/Users/arielfogel/Downloads/data_challenge/allsides_bias.csv' CSV HEADER;

-- Check to see whether merge works correctly
SELECT bias.title, bias.bias, count(*) FROM articles LEFT JOIN bias ON bias.url = articles.publication_site WHERE articles.country = 'US' AND articles.title!='' AND bias.url IS NOT NULL GROUP BY bias.title, bias.bias ORDER BY count DESC;

-- query run for # publications by site
-- "SELECT publication_site, count(*) FROM articles WHERE country = 'US' GROUP BY publication_site HAVING count(*) > 500 ORDER BY count DESC;"

-- query to subset the data by country
\COPY (SELECT articles.month, articles.week, articles.published_date, articles.country, bias.title, bias.bias, articles.number_of_shares, articles.title, articles.content FROM articles LEFT JOIN bias ON bias.url = articles.publication_site WHERE articles.country = 'US' AND articles.title!='' AND bias.url IS NOT NULL) TO './full_us_dataset.csv' WITH CSV DELIMITER ',' HEADER;


-- data pull for another team
-- \COPY (SELECT month, week, published_date, country, publication, publication_site, number_of_shares, title, content From articles WHERE country IN ('DK', 'SE', 'NO')) TO './data_pull_scandanavian_countries.csv' WITH CSV DELIMITER ',' HEADER;
