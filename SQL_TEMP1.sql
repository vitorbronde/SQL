DROP TABLE IF exists temp.estudo_conversao;
CREATE TABLE temp.estudo_conversao AS (
with visu as (
SELECT distinct 
    vo.profile_id ,
    vo.request_id,
    round(eval_distance(er.latitude, er.longitude, par.latitude, par.longitude),2) AS offer_distance,
    er.root_category,
    er.uf,
    er.city,
    er.recurrent_request,
    er.remote_category,
    er.additional_info,
    day(vo.visualized_at)::date - day(ep.first_lead_purchase)::date as temp_ativacao,
    day(vo.visualized_at)::date - day(ep.last_lead_purchase)::date as temp_last_lead, 
    rank() over (partition by vo.profile_id , vo.request_id order by visualized_at  desc ) as ranking,
    last_value(vo.price) over (partition by vo.profile_id , vo.request_id  ROWS UNBOUNDED PRECEDING ) as last_price ,
    last_value(vo.current_credits) over (partition by vo.profile_id , vo.request_id ROWS UNBOUNDED PRECEDING ) as last_credit,
 (case when last_price::float > 0 then last_price::float end) / (case when last_credit::float > 0 then last_credit::float end) as razao_precos
FROM visualized_offers vo
    inner join enriched_requests er on (vo.request_id = er.request_id)
    inner join profiles_address_root AS par ON (par.profile_id = vo.profile_id)
    join enriched_profiles AS ep on (vo.profile_id = ep.profile_id)
    where date between '2022-01-01' and '2022-04-10'
    and ep.visible = 1 
),

views as (
select 
profile_id , 
request_id , 
count(*) as views  
from visualized_offers 
where date between '2022-01-01' and '2022-04-10'
group by 1,2
),

leads as (
select 
    lead_id,
    request_id,
    profile_id,
    price_in_credits,
    rank_real_lead_in_request ,
    lead_created_at as data_compra
from dispatch.enriched_leads el 
where lead_created_at between '2022-01-01' and '2022-04-10'
    and not lead_giveaway 
)

select 
    v.*,
    l.lead_id,
    l.price_in_credits,
    l.rank_real_lead_in_request,
    l.data_compra,
    vi.views 
from visu v
left join leads l on (v.profile_id = l.profile_id and v.request_id = l.request_id) 
left join views vi on (v.profile_id = vi.profile_id and v.request_id = vi.request_id) 
where ranking = 1
)