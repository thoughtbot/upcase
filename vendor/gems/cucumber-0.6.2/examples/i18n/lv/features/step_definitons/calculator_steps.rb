# encoding: utf-8
require 'spec/expectations'
require 'cucumber/formatter/unicode'
$:.unshift(File.dirname(__FILE__) + '/../../lib') 
require 'calculator'

Before do
  @calc = Calculator.new
end

After do
end

Given /esmu ievadījis kalkulatorā (\d+)/ do |n|
  @calc.push n.to_i
end

When /nospiežu pogu (\w+)/ do |op|
  @result = @calc.send op
end

Then /rezultātam uz ekrāna ir jābūt (.*)/ do |result|
  @result.should == result.to_f
end
