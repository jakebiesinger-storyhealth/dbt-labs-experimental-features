{{
    config(
        materialized='view'
    )
}}

with current_view as (

    select * from {{ ref('page_views_current') }}
    where max_collector_tstamp >= dateadd('hour', -2, '{{ run_started_at }}')

),

historical_table as (

    select * from {{ ref('page_views_historical') }}

    where max_collector_tstamp < dateadd('hour', -2, '{{ run_started_at }}')

),

unioned as (

    select * from current_view

    union all

    select * from historical_table

)

select * from unioned
