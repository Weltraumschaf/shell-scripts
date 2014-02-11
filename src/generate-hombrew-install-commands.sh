#!/usr/bin/env ruby

# https://github.com/Homebrew/homebrew/wiki/C++-Standard-Libraries

brews = []
out = IO.popen("brew list", "r") do |io|
    brews = io.read.split "\n"
end
 
def parse(brew, brew_info)
    in_options = false
    print "brew reinstall -v #{brew} "
    brew_info.split("\n").each do |m|   
        #puts m.inspect
        if in_options
            m.scan(/(--[a-zA-Z-]+)/).each do |x|
                print x[0] + " "
            end
 
            #puts matchdata.inspect
            in_options = false
        end
 
        if /\*$/.match m
            in_options = true
        end
    end
    
    puts
 end
  
brews.each do |brew|
    #puts "brew info #{brew}"
    IO.popen("brew info #{brew}", "r") do |info|
        parse(brew, info.read)
    end
end
