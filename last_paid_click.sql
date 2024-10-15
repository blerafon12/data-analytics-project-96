with t1 as
(
    select
	    visitor_id,
	    min(visit_date) as visit_date,
	    source as utm_source,
	    medium as utm_medium,
	    campaign as utm_campaign
    from sessions
    group by visitor_id, source, medium, campaign
),
t2 as
(
    select
        t1.visitor_id,
        visit_date,
        utm_source,
	    utm_medium,
	    utm_campaign,
        case
            when created_at >= visit_date then lead_id
            else null
        end as lead_id,
        created_at,
        amount,
        closing_reason,
        status_id
    from t1
    left join leads as l on t1.visitor_id = l.visitor_id
)
select
    visitor_id,
    visit_date,
    utm_source,
	utm_medium,
    utm_campaign,
    lead_id,
    case
        when lead_id is null then null
        else created_at
    end as created_at,
    case
	    when lead_id is null then null
	    else amount
	end as amount,
	case
	    when lead_id is null then null
	    else closing_reason
	end as closing_reason,
    case
	    when lead_id is null then null
	    else status_id
	end as status_id 
from t2
where utm_medium in ('cpc', 'cmp', 'cpa', 'youtube', 'cpp', 'tg', 'social')
order by amount desc nulls last, visit_date asc, utm_source asc, utm_medium asc, utm_campaign asc limit 10;