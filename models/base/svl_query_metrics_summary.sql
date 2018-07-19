select
  userid as user_id,
  query as query_id,
  service_class as service_class_id,
  query_cpu_time as query_cpu_time_seconds,
  query_blocks_read,
  query_execution_time as query_execution_time_seconds,
  query_cpu_usage_percent,
  query_temp_blocks_to_disk,
  segment_execution_time as segment_execution_time_seconds,
  cpu_skew,
  io_skew,
  scan_row_count,
  join_row_count,
  nested_loop_join_row_count,
  return_row_count,
  spectrum_scan_row_count,
  spectrum_scan_size_mb
from svl_query_metrics_summary
