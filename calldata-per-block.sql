WITH calldata_per_block AS (
    -- octet_length：返回字节数。比如'ABC'，return 3
    -- 1024byte = 1kb
    SELECT SUM(octet_length(t.data)) / 1024.0 AS calldata_kb
    FROM ethereum.transactions AS t
    GROUP BY block_number
    ORDER BY block_number DESC
    LIMIT 10000
)

-- floor取整、count计算block number
SELECT floor(calldata_kb / 10) * 10, COUNT(*) FROM calldata_per_block GROUP BY 1 ORDER BY 1;
