select
  id as service_class_id,
  condition as query_conditions,
  case
    when id between 1 and 4 then 'Redshift Reserved Service Class'
    when id = 5 then 'Redshift Superuser Query Queue'
    when id > 5 then 'WLM Query Queue'
    else null
  end as service_class_type
from stv_wlm_classification_config
