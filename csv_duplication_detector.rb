# -*- coding:utf-8 -*-

# CSV duplication detector

unless ARGV.size == 2
    puts "usage: ruby csv_duplication_detector.rb <filename1.csv> <fileanme2.csv>"
    exit 1
end

def read_csv2hash filename 
    outhash = {}
    open(filename,"r:sjis") do |io|
        io.each_with_index do |line,i|
            next if 0 == i
            arr = line.split(",")
            outhash[arr[0]] = {index: i + 1, contents: arr, file: filename}
        end
    end
    return outhash
end

def get_dup_from_map map1, map2
    duparr = []
    map1.each do |key,val|
        if map2[key]
            val2 = map2[key]
            duparr << "dup! key:#{key} #{val[:file]}:L#{val[:index]} - #{val2[:file]}:L#{val2[:index]}"
        end
    end
    return duparr
end

def output outarr
    open("duplication.txt","w:sjis") do |io|
        outarr.each do |line|
            io.puts line
        end
    end
end

##############################
# main
##############################

target1hash = read_csv2hash ARGV[0]
target2hash = read_csv2hash ARGV[1]

outarr = get_dup_from_map(target1hash, target2hash)

output(outarr)

puts "end of script"

