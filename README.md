# test_BokkyPooBahsDateTimeLibrary

Testing https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary using:

Parity 1.11.1 testnet (parity --no-persistent-txqueue --chain dev)
Ruby 2.4.2p198 on Windows 10, using the Ethereum.rb gem

Running a local Parity node on a Windows computer, the number of requests per second is usually below 100.

== exhaustive tests (5 functions)

[1] BPBDTL_ymd.rb -- 4 functions

  functions exhaustively tested from 1970 to 2286:

  _isLeapYear
  _getDaysInMonth
  _days_from_date
  timestampFromDate

[2] BPBDTL_days_to_date.rb -- 1 function

  function exhaustively tested from 1970-01-01 to 2298-07-20:

  _days_to_date

== tests using random data

[1] BPBDTL_ts.rb - 13 functions

  timestamp_to_date
  timestamp_to_date_time
  is_leap_year
  is_week_day
  is_week_end
  get_days_in_month
  get_day_of_week
  get_year
  get_month
  get_day
  get_hour
  get_minute
  get_seconds
  
  first pass: 2_600_000 checks at 200_000 time points
  
[2] BPBDTL_ts2.rb - 6 functions

  diff_years
  diff_months
  diff_days
  diff_hours
  diff_minutes
  diff_seconds
  
  first_pass: 1_200_000 checks at 200_000 time points