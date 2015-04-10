 -- Copyright 2015 Google
 -- Licensed under the Apache License, Version 2.0 (the "License");
 -- you may not use this file except in compliance with the License.
 -- You may obtain a copy of the License at

 --      http://www.apache.org/licenses/LICENSE-2.0

 -- Unless required by applicable law or agreed to in writing, software
 -- distributed under the License is distributed on an "AS IS" BASIS,
 -- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 -- See the License for the specific language governing permissions and
 -- limitations under the License.

-- Get possible values for plurality
SELECT
  count(*) as total,
  plurality
FROM
  [publicdata:samples.natality]
GROUP BY
  plurality;

-- Get records with no plurality
SELECT
  count(*) as total,
  year
FROM
  [publicdata:samples.natality]
WHERE
   plurality IS NULL
GROUP BY
  year;

-- Get count of pluralities for 1982
SELECT
  count(*) as total,
  plurality
FROM
  [publicdata:samples.natality]
WHERE
  plurality IS NOT NULL AND
  year = 1982
GROUP BY
  plurality;

-- Get count of all pluralities with year in a single row
SELECT
  year,
  sum(case when plurality = 1 then 1 else 0 end) as singleton,
  sum(case when plurality = 2 then 1 else 0 end) as twins,
  sum(case when plurality = 3 then 1 else 0 end) as triplets,
  sum(case when plurality = 4 then 1 else 0 end) as quads,
  sum(case when plurality = 5 then 1 else 0 end) as quints
FROM
  publicdata:samples.natality
WHERE
  plurality IS NOT NULL
GROUP BY
  year;
