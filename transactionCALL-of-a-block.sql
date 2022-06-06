-- * 1.每个block中，call tx的占比，默认展示为series数据，也可以展示为平均占比
-- 具体到每个block中，execute contract的transaction占比有多少
-- 一段时间内的平均数据可以参考：https://dune.com/queries/861719
with complex as(
select count(tx_hash) as complex_num, block_number as block_number_c from
(
select  block_number, tx_hash , max(sub_traces) as internal_tx , success from ethereum."traces"
where sub_traces>0  and success = true and block_number >= 14865643
group by tx_hash,block_number,success
)t_c
group by block_number_c
)
,
alls as (
select count(distinct tx_hash) as all_num , block_number as block_number_a from ethereum."traces"
where success = true and block_number >= 14865643
group by block_number_a)
,

t_all as (
select complex_num , all_num ,block_number_c as block_number from(
select * from complex Inner Join alls on complex.block_number_c=alls.block_number_a
)t_a
)

select block_number, CONCAT(CAST((CAST(complex_num as int)/CAST(all_num as float))* 100 as int),'%') as percent from t_all

-- * 还可以求出平均占比（%）。floor去小数点，concat换算为%
-- select CONCAT(floor(avg(percent)), '%') from (select block_number, CAST((CAST(complex_num as int)/CAST(all_num as float))* 100 as int) as percent from t_all)t_f


