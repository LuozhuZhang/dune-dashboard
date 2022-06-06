-- * 1.一笔transaction call平均调用了几个合约（递归调用）
-- 最近十天内的平均值
select avg(avg_cnt) from
(
    -- average number of contracts that are called in a transaction
    -- Unit: block
    select block_number, avg(cnt) as avg_cnt
    from 
    (
        -- 一个block里面的每一笔transaction，平均调用了多少个合约（通过这max sub_trace）
        -- 过滤掉了sub trace = 0的交易，没有产生递归调用的交易
        select block_number, tx_hash, max(sub_traces) as cnt, success
        from ethereum."traces"
        where block_number > '14802429'
        -- transaction调用合约（0）、合约调用第一个合约（1）、调用第二个合约（2）
        and sub_traces > 0
        and success = true
        group by tx_hash, block_number, success
    )t0
    group by block_number
    order by block_number
)t1
-- 这里的数字是4，所有txCall的交易平均递归调用了四个合约（可以把这个数据理解为depth吗？）