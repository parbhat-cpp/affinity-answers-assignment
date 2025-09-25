-- to paginate use (PAGE_NO - 1) * 15 as offset
SELECT r.accession, t.species, r.length FROM rfamseq as r INNER JOIN taxonomy AS t ON r.ncbi_id = t.ncbi_id WHERE r.length >= 1000000 ORDER BY r.length DESC LIMIT 15 OFFSET 0;
