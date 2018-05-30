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

sl.h1 "Starting TS * TS checking"
sl.p "Starting at #{t1.utc}"

###############################################################################
#
# Timestamp * Timestamp
#
# 10_000_000_000 = 2286-11-20T17:46:40+00:00

sl.h2 "Timestamp * Timestamp (random)"

sl.p "assert_equal @contract.call.diff_years(ts1, ts2), yy2 - yy1"
sl.p "assert_equal @contract.call.diff_months(ts1, ts2), (yy2 - yy1)*12 + mm2 - mm1"
sl.p "assert_equal @contract.call.diff_days(ts1, ts2), (ts2 - ts1)/86_400"
sl.p "assert_equal @contract.call.diff_hours(ts1, ts2), (ts2 - ts1)/3600"
sl.p "assert_equal @contract.call.diff_minutes(ts1, ts2), (ts2 - ts1)/60"
sl.p "assert_equal @contract.call.diff_seconds(ts1, ts2), ts2 - ts1"
  
imax = 200_000

imax.times do
 
  ts1 = rand(10_000_000_000)
  ts2 = rand(10_000_000_000)
  
  ts1, ts2 = ts2, ts1 if ts1 > ts2
  
  sl.p "#{ts1} - #{ts2}"

  rt1 = Time.at(ts1).utc 
  rt2 = Time.at(ts2).utc 
  
  yy1 = rt1.year
  yy2 = rt2.year

  mm1 = rt1.month
  mm2 = rt2.month
  
  assert_equal @contract.call.diff_years(ts1, ts2), yy2 - yy1
  assert_equal @contract.call.diff_months(ts1, ts2), (yy2 - yy1)*12 + mm2 - mm1
  assert_equal @contract.call.diff_days(ts1, ts2), (ts2 - ts1)/86_400 
  assert_equal @contract.call.diff_hours(ts1, ts2), (ts2 - ts1)/3600
  assert_equal @contract.call.diff_minutes(ts1, ts2), (ts2 - ts1)/60
  assert_equal @contract.call.diff_seconds(ts1, ts2), ts2 - ts1
  
end

#

sl.p
t2 = Time.now()
sl.p "Ending at #{t2.utc} -- it took #{(t2 - t1)/60} minutes"
sl.p "to do #{imax*6} checks at #{imax} time points"

write_to_file(sl.sLog, "BPBDTL_ts2.log")

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