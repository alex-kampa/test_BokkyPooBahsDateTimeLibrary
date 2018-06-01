# test_BokkyPooBahsDateTimeLibrary

Testing https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary using:

Parity 1.11.1 testnet (parity --no-persistent-txqueue --chain dev)

Ruby 2.4.2p198 on Windows 10, using the Ethereum.rb gem

Note that the number of requests handled by the Parity node was less than 100 per second, which limits the extent of testing possible.

== exhaustive tests (5 functions)

[1] BPBDTL_ymd.rb -- 4 functions

Functions exhaustively tested from 1970 to 2286:

* [x] _isLeapYear
* [x] _getDaysInMonth
* [x] _daysFromDate
* [x] timestampFromDate

[2] BPBDTL_days_to_date.rb -- 1 function

Function exhaustively tested from 1970-01-01 to 2298-07-20:

* [x] _daysToDate

== tests using random data

[1] BPBDTL_ts.rb - 13 functions

Random time points between 1970-01-01 (0) and 2298-07-20 (10_000_000_000).

* [x] timestampToDate
* [x] timestamp_to_date_time
* [x] isLeapYear
* [x] isWeekDay
* [x] isWeekEnd
* [x] getDaysInMonth
* [x] getDayOfWeek
* [x] getYear
* [x] getMonth
* [x] getDay
* [x] getHour
* [x] getMinute
* [x] getSecond
  
First pass: checked each function 200_000 times
  
[2] BPBDTL_ts2.rb - 6 functions

Random time points between 1970-01-01 (0) and 2298-07-20 (10_000_000_000).

* [x] diffYears
* [x] diffMonths
* [x] diffDays
* [x] diffHours
* [x] diffMinutes
* [x] diffSeconds
  
First pass: checked each function 200_000 times

[4] BPDTL_timestamp_from_date_time.rb - 1 function

Random DateTime points between 1970-01-01 and 2299-12-31 23:59:59

* [x] timestampFromDateTime

First pass: checked 120_000 times

[4] BPBDTL_add_sub.rb - 12 functions

Adding to / subtracting from random time points between 1970-01-01 (0) and 2298-07-20 (10_000_000_000).

Adding / subtracting time periods of approximately 0-299 years

* [x] addYears
* [x] addMonths
* [x] addDays
* [x] addHours
* [x] addMinutes
* [x] addSeconds
* [x] subYears
* [x] subMonths
* [x] subDays
* [x] subHours
* [x] subMinutes
* [x] subSeconds

First pass: ongoing, checked each function at >60k random time points

Note: also checking that subtractions resulting in a date before 1970-01-01 00:00:00
