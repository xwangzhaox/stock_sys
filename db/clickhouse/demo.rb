CREATE DATABASE iot;

CREATE TABLE survey_data
 (
   `log_date` Date,
   `timestamp` UInt64,
   `device_id` UInt64,
   `quotum_id` UInt64,
   `quotum_name` String,
   `node_id` UInt64,
   `space_quotum_id` UInt64,
   `space_id` UInt64,
   `stream_name` String,
   `value` Float64,
   `created_at` DateTime
 )
ENGINE = MergeTree(log_date, (timestamp, device_id), 8192);