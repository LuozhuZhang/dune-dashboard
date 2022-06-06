-- * 1.平均值
with call_data as (
    select "hash", "block_time", "from", "to", data from ethereum.transactions
    where block_time > now() - interval '10day'
    and length(data) > 0
)

-- 一段时间内的平均calldata size
select avg(octet_length(data)) / 1024.0 as avg_calldata_kb from call_data

-- * 2.不同合约的calldata size
-- 比如这个就是Optimism
select "block_time", sum(octet_length(data)) / 1024.0 as calldata_kb from ethereum.transactions
where block_time > now() - interval '10day'
and "to" = '\xbe5dab4a2e9cd0f27300db4ab94bee3a233aeb19'
-- zksync：xabea9132b05a70803a4e85094fd0e1800777fbef
-- arbiturm：x4c6f947ae67f572afa4ae0730947de7c874f95ef
group by block_time
order by "block_time"