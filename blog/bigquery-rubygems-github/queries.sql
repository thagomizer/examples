SELECT name, count
FROM [rubygems.downloads]
JOIN rubygems.gems ON rubygems.gems.id = rubygems.downloads.rubygem_id
ORDER BY count DESC 
LIMIT 5

SELECT name, sum(count) as total
FROM [rubygems.downloads]
JOIN rubygems.gems ON rubygems.gems.id = rubygems.downloads.rubygem_id
GROUP BY name
ORDER BY total DESC
LIMIT 5

SELECT name, sum(count) as total
FROM [rubygems.downloads]
JOIN rubygems.gems ON rubygems.gems.id = rubygems.downloads.rubygem_id
GROUP BY name
HAVING name IN ('minitest', 'rspec')

SELECT 
 name,
 REGEXP_EXTRACT(number,r'(\d)\.') AS major,
 sum(rubygems.downloads.count) AS total
FROM [rubygems.versions]
JOIN rubygems.gems ON
 rubygems.gems.id =
 rubygems.versions.rubygem_id
JOIN rubygems.downloads ON
 rubygems.versions.rubygem_id =
 rubygems.downloads.rubygem_id
WHERE rubygems.gems.name = 'rails'
GROUP BY name, major
ORDER BY major
