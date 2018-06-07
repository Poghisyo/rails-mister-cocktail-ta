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

Cocktail.destroy_all
Dose.destroy_all
Ingredient.destroy_all

puts "planting the seeds (seeding database)"

def get_ingredients_from_api
  url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
  attr_serialized = open(url).string
  attributes = JSON.parse(attr_serialized)

  attributes['drinks'].each {|data|
    Ingredient.create(name: data['strIngredient1'] )
  }
end

def get_cocktails_from_api
  url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail"
  attr_serialized = open(url).read
  attributes = JSON.parse(attr_serialized)

  attributes["drinks"].each do |d|
    puts "making #{d["strDrink"]}"
    cocktail = Cocktail.new(name: d["strDrink"])
    thumb = d["strDrinkThumb"]
    cocktail.remote_photo_url = thumb
    cocktail.save
    id = d["idDrink"]
    get_doses_from_api(id, cocktail)
  end
end

def get_doses_from_api(id, cocktail)
  puts "retrieving doses"
  drink_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{id}"
  drink_serialized = open(drink_url).read
  drink_details = JSON.parse(drink_serialized)


  drink_details["drinks"].each do |detail|
    number = 1
    while number < 15
      if detail["strIngredient#{number}"] != ''
        if Ingredient.find_by(name: detail["strIngredient#{number}"])
          # add dose
          description = detail["strMeasure#{number}"]
          dose = Dose.new(description: description)
          dose.ingredient = Ingredient.find_by(name: detail["strIngredient#{number}"])
          dose.cocktail = cocktail
          dose.save
        end
      else
        break
      end
      number += 1
    end
  end
end

get_ingredients_from_api
puts "seeded #{Ingredient.all.count} ingredients"

get_cocktails_from_api
puts "done"
puts "Cocktails loaded: #{Cocktail.all.count}"
