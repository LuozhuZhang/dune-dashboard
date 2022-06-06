-- * 1.平均值
with call_data as (
    select "hash", "block_time", "from", "to", data from ethereum.transactions
    where block_time > now() - interval '10day'
    and length(data) > 0
)

-- 一段时间内的平均calldata size
select avg(octet_length(data)) / 1024.0 as avg_calldata_kb from call_data