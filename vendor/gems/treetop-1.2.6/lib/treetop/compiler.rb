dir = File.dirname(__FILE__)
require File.join(dir, *%w[compiler lexical_address_space])
require File.join(dir, *%w[compiler ruby_builder])
require File.join(dir, *%w[compiler node_classes])
require File.join(dir, *%w[compiler metagrammar]) unless $exclude_metagrammar
require File.join(dir, *%w[compiler grammar_compiler])
