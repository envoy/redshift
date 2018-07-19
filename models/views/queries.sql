with queries as (
select *
from {{ref('stl_query')}}
),

users as (
select *
from {{ref('pg_user')}}
),

cost as (
select *
from {{ref('redshift_cost')}}
),

timings as (
select *
from {{ref('stl_wlm_query')}}
),

service_class_classification as (
select *
from {{ ref('stv_wlm_classification_config') }}
),

service_class_config as (
select *
from {{ ref('stv_wlm_service_class_config') }}
),

query_metrics as (
select *
from {{ ref('svl_query_metrics_summary') }}
)

select
  queries.query_id,
  queries.transaction_id,
  users.username::varchar,

  cost.starting_cost,
  cost.total_cost,

  queries.aborted,
  queries.started_at,
  queries.finished_at,

  timings.queue_start_time,
  timings.queue_end_time,
  (timings.total_queue_time::float / 1000000.0) as total_queue_time_seconds,

  timings.exec_start_time,
  timings.exec_end_time,
  (timings.total_exec_time::float / 1000000.0) as total_exec_time_seconds,

  timings.service_class_id,
  service_class_config.name as service_class_name,
  service_class_config.service_class_type as wlm_service_class_type,
  service_class_classification.query_conditions as wlm_service_class_query_conditions,
  service_class_config.concurrency_allocation,
  service_class_config.memory_allocation,
  service_class_config.max_execution_time_seconds,

  query_metrics.query_cpu_time_seconds,
  query_metrics.query_blocks_read,
  query_metrics.query_cpu_usage_percent,
  query_metrics.query_temp_blocks_to_disk,
  query_metrics.cpu_skew,
  query_metrics.io_skew,
  query_metrics.scan_row_count,
  query_metrics.join_row_count,
  query_metrics.nested_loop_join_row_count,
  query_metrics.return_row_count,
  query_metrics.spectrum_scan_row_count,
  query_metrics.spectrum_scan_size_mb
from queries
left join users
on queries.user_id = users.user_id
left join cost
on queries.query_id = cost.query_id
left join timings
on queries.query_id = timings.query_id
left join service_class_classification
on timings.service_class_id = service_class_classification.service_class_id
left join service_class_config
on timings.service_class_id = service_class_config.service_class_id
left join query_metrics
on queries.query_id = query_metrics.query_id
