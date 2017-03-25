#!/usr/bin/ruby
# -*- coding: UTF-8 -*-
#

require "xcodeproj"

arg0 = ARGV[0]
xcodeproj_path = File.join(arg0)

project = Xcodeproj::Project.open(xcodeproj_path)
project.targets.each do |target|
	puts target
end
