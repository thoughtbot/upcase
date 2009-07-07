#!/usr/bin/env ruby

puts "Creating documentation."
system "rdoc --line-numbers --inline-source --title Term::ANSIColor -d #{Dir['lib/**/*.rb'] * ' '}"
  # vim: set et sw=2 ts=2:
