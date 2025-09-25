-- query for types of tiger
SELECT COUNT(*) FROM taxonomy WHERE species LIKE "%tiger%";

-- ncbi_id for Sumatran tiger
SELECT ncbi_id FROM taxonomy WHERE species LIKE "%Sumatran tiger%";
