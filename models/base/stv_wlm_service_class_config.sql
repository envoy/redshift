select
  service_class as service_class_id,
  num_query_tasks as concurrency_allocation,
  query_working_mem as memory_allocation,
  name,
  max_execution_time/1000.0 as max_execution_time_seconds,
  case
    when service_class between 1 and 4 then 'Redshift Reserved Service Class'
    when service_class = 5 then 'Redshift Superuser Query Queue'
    when service_class > 5 then 'WLM Query Queue'
    else null
  end as service_class_type
from stv_wlm_service_class_config
