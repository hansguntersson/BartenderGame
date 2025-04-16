import Foundation

struct DrinksMenuData {
    static let drinkPrices: [String: Double] = [
        // Cocktails
        "Old Fashioned": 12.99,
        "Manhattan": 11.99,
        "Gin & Tonic": 8.99,
        "Moscow Mule": 10.99,
        "Brandy Sidecar": 11.99,
        "Margarita": 10.99,
        "Mojito": 9.99,
        "Espresso Martini": 12.99,
        "Long Island Iced Tea": 13.99,
        "Cosmopolitan": 10.99,
        "Champagne Cocktail": 14.99,
        "French 75": 13.99,
        "Pina Colada": 11.99,
        "Negroni": 11.99,
        "Daiquiri": 10.99,
        "Whiskey Sour": 11.99,
        "Tom Collins": 9.99,
        "Mai Tai": 12.99,
        "Gimlet": 10.99,
        "Dark 'n' Stormy": 10.99,
        "Sazerac": 12.99,
        "Martini": 11.99,
        "Rob Roy": 12.99,
        "Sidecar": 11.99,
        "Mint Julep": 11.99,
        "Rusty Nail": 12.99,
        "White Lady": 11.99,
        "Bobby Burns": 12.99,
        "Clover Club": 11.99,
        "Death in the Afternoon": 14.99,
        "El Presidente": 11.99,
        "Hemingway Daiquiri": 11.99,
        "Monkey Gland": 10.99,
        "Remember the Maine": 12.99,
        "Saturn": 12.99,
        "Ti' Punch": 10.99,
        "Vieux Mot": 11.99,
        "Wardays": 10.99,
        "French Martini": 11.99,
        "Brain Haemorrhage": 8.99,
        "Tequila Sunrise": 10.99,
        "Blue Lagoon": 10.99,
        "Grasshopper": 10.99,
        "Bloody Mary": 11.99,
        "Sex on the Beach": 10.99,
        "New York Flip": 12.99,
        "Godfather": 11.99,
        "White Russian": 10.99,
        "Black Russian": 9.99,
        "Amarula Espresso": 12.99,
        "Armagnac Sidecar": 13.99,
        "Canadian Manhattan": 12.99,
        "Sambuca Sour": 11.99,
        "Pernod Fizz": 11.99,
        "Cherry Marnier Old Fashioned": 13.99,
        "Frangelico Flip": 12.99,
        "Tia Maria Colada": 12.99,
        "Midori Sour": 11.99,
        "Lychee Martini": 12.99,
        "Crème Pêche Fizz": 10.99,
        "Yellow Chartreuse Swizzle": 13.99,
        "Ruby Port Flip": 12.99,
        "Crème de Violette Aviation": 13.99,
        "Benedictine Sazerac": 13.99,
        "Aperol Spritz": 10.99,
        "Warday's": 12.99,
        "Warday's Sour": 11.99,
        
        // Regular Drinks
        "Red Wine": 7.99,
        "White Wine": 7.99,
        "Champagne": 12.99,
        "Stout": 6.99,
        "Ale": 6.99,
        "IPA": 6.99,
        "Cider": 6.99,
        "Bourbon Neat": 8.99,
        "Scotch Neat": 9.99,
        "Bourbon on the Rocks": 8.99,
        "Scotch on the Rocks": 9.99,
        "Vodka & Soda": 7.99,
        "Rum & Cola": 7.99,
        "Shirley Temple": 4.99,
        "Black Velvet": 8.99,
        "Snakebite and Black": 7.99,
        "Brown Ale Shandy": 7.99,
        "Sauvignon Blanc Spritzer": 8.99,
        "Tawny Port Toddy": 9.99,
        "Dry Sherry Cobbler": 8.99
    ]
    
    static func calculateIngredientCost(for drinkName: String) -> Double {
        guard let drink = Drink.allDrinks.first(where: { $0.name == drinkName }) else { return 0 }
        var totalCost: Double = 0
        for ingredient in drink.recipe {
            if let availableIngredient = DrinkIngredient.availableIngredients.first(where: { $0.name == ingredient.name }) {
                totalCost += availableIngredient.cost * ingredient.amount
            }
        }
        return totalCost
    }
    
    static func calculateMarkup(for drinkName: String) -> Double {
        let cost = calculateIngredientCost(for: drinkName)
        let price = drinkPrices[drinkName] ?? 0
        return ((price - cost) / cost) * 100
    }
    
    static func checkAllMargins() {
        print("\nChecking margins for all drinks:")
        print("--------------------------------")
        
        for drink in Drink.allDrinks {
            let cost = calculateIngredientCost(for: drink.name)
            let price = drinkPrices[drink.name] ?? 0
            let markup = calculateMarkup(for: drink.name)
            
            if markup <= 0 {
                print("⚠️ \(drink.name):")
                print("   Price: £\(String(format: "%.2f", price))")
                print("   Cost: £\(String(format: "%.2f", cost))")
                print("   Markup: \(String(format: "%.1f", markup))%")
                print("--------------------------------")
            }
        }
    }
} 