#!/usr/bin/ruby

require 'yaml'

class Game

    def initialize
        # load YAML
        file = File.read 'yard.yml'
        y = YAML.load file

        @possible_locations = y['starting_locations']
        @previous_locations = Array.new
        @map = y['map']
    end

    def possible_locations turn = 0
        locations = Hash.new 0
        @possible_locations.each do |loc|
            locations[loc] += 1
        end

        chances = locations.values.inject :+

        locations.each { |location, chance| locations[location] = chance / chances.to_f }

        locations
    end

    def remove possibility
        @possible_locations.delete possibility
    end

    def at location
        @possible_locations = [location]
    end

    def take method
        new_locations = Array.new
        @possible_locations.each do |loc|
            unless @map[loc][method] == nil
                new_locations += @map[loc][method]
            end
        end
        @possible_locations = new_locations
    end
end

def print_locations locations
    puts 'Possible Locations:'
    locations = locations.sort_by { |loc, prob| -prob }
    locations.each { |loc, prob| printf "   %3d: %6.2f\%\n", loc, prob*100 }
end

g = Game.new
start = 196
g.at start
print_locations g.possible_locations
g.take 'taxi'
g.take 'taxi'
g.take 'taxi'
g.take 'underground'
g.take 'bus'
print_locations g.possible_locations
