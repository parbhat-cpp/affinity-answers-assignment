SELECT r.ncbi_id, t.species, r.length FROM rfamseq AS r INNER JOIN taxonomy AS t on r.ncbi_id = t.ncbi_id WHERE t.species LIKE "rice%" ORDER BY r.length DESC;
