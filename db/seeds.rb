# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require "open-uri"
require 'json'
require 'faker'

puts "clearing the field (destroy all records)"

# Dose.destroy_all
Ingredient.destroy_all
# Cocktail.destroy_all

puts "planting the seeds (seeding database)"

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
attr_serialized = open(url).string
attributes = JSON.parse(attr_serialized)

attributes['drinks'].each {|data|
  Ingredient.create(name: data['strIngredient1'] )
}

puts "seeded ingredients"

