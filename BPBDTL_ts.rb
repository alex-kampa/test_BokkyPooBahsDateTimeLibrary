require "Ethereum.rb"
require "eth"
require "test/unit"
extend Test::Unit::Assertions

require_relative "lib/utils.rb"

##

@client = Ethereum::HttpClient.new('http://127.0.0.1:8545')
@name = "BokkyPooBahsDateTimeLibrary"
@contract_address = "0x731a10897d267e19B34503aD902d0A29173Ba4B1"
@contract_abi = File.read('abi/abi.txt')

@contract = Ethereum::Contract.create(client: @client, name: @name, address: @contract_address, abi: @contract_abi)

#

sl = SimpleLog.new({:verbose => true})
t1 = Time.now()
i = 0

sl.h1 "Starting TS checking"
sl.p "Starting at #{t1.utc}"

###############################################################################
#
# Timestamp
#
# 10_000_000_000 = 2286-11-20T17:46:40+00:00

sl.h2 "Timestamp (random)"

sl.p "assert_equal @contract.call.timestamp_to_date(ts),      [yy, mm, dd]"
sl.p "assert_equal @contract.call.timestamp_to_date_time(ts), [yy, mm, dd, h, m, s]"
sl.p "assert_equal @contract.call.is_leap_year(ts),           Date.leap?(rt.year)"
sl.p "assert_equal @contract.call.is_week_day(ts),            [1,2,3,4,5].include?(wday)"
sl.p "assert_equal @contract.call.is_week_end(ts),            [6,7].include?(wday)"
sl.p "assert_equal @contract.call.get_days_in_month(ts),      days_in_month"
sl.p "assert_equal @contract.call.get_day_of_week(ts),        wday"
sl.p "assert_equal @contract.call.get_year(ts),               yy"
sl.p "assert_equal @contract.call.get_month(ts),              mm"
sl.p "assert_equal @contract.call.get_day(ts),                dd"
sl.p "assert_equal @contract.call.get_hour(ts),               h"
sl.p "assert_equal @contract.call.get_minute(ts),             m"
sl.p "assert_equal @contract.call.get_second(ts),             s"

imax = 200_000

imax.times do
 
  ts = rand(10_000_000_000)
  
  sl.p ts

  rt = Time.at(ts).utc 
  yy = rt.year
  mm = rt.month
  dd = rt.mday
  h  = rt.hour
  m  = rt.min
  s  = rt.sec
  
  wday = rt.wday
  wday = 7 if wday == 0 # Sunday is 0 in Ruby, 7 in Bokky
  
  days_in_month = days_in_month(yy, mm)

  assert_equal @contract.call.timestamp_to_date(ts),      [yy, mm, dd]
  assert_equal @contract.call.timestamp_to_date_time(ts), [yy, mm, dd, h, m, s]
  assert_equal @contract.call.is_leap_year(ts),           Date.leap?(rt.year)
  assert_equal @contract.call.is_week_day(ts),            [1,2,3,4,5].include?(wday)
  assert_equal @contract.call.is_week_end(ts),            [6,7].include?(wday)
  assert_equal @contract.call.get_days_in_month(ts),      days_in_month
  assert_equal @contract.call.get_day_of_week(ts),        wday
  assert_equal @contract.call.get_year(ts),               yy
  assert_equal @contract.call.get_month(ts),              mm
  assert_equal @contract.call.get_day(ts),                dd
  assert_equal @contract.call.get_hour(ts),               h
  assert_equal @contract.call.get_minute(ts),             m
  assert_equal @contract.call.get_second(ts),             s
 
  
  puts ts if ts % 100 == 0
  
end

#

sl.p
t2 = Time.now()
sl.p "Ending at #{t2.utc} -- it took #{(t2 - t1)/60} minutes"
sl.p "to do #{imax*13} checks at #{imax} time points"

write_to_file(sl.sLog, "BPBDTL_ts.log")

# -----------------------------------------------------------------------------

BEGIN {

  def days_in_month(yy, mm)  
    case mm  
    when 4,6,9,11 then 30  
    when 2 then (yy%4==0 && yy%100!=0 || yy%400==0) ? 29 : 28  
    else 31  
    end  
  end

}