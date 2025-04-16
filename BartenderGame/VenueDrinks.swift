import Foundation

struct VenueDrink: Identifiable {
    let id = UUID()
    let drink: Drink
    let price: Double
    let isSignature: Bool
}

struct VenueDrinkMenu {
    static let menus: [String: [VenueDrink]] = [
        "The Classic Cocktail Bar": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Old Fashioned" })!, price: 14.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Martini" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Negroni" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Whiskey Sour" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Rob Roy" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sidecar" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Lady" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bobby Burns" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Clover Club" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Benedictine Sazerac" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Crème de Violette Aviation" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "New York Flip" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Godfather" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon on the Rocks" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch on the Rocks" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 10.00, isSignature: false)
        ],
        
        "The Modern Mixology Lab": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Espresso Martini" })!, price: 16.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "French Martini" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Lychee Martini" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Midori Sour" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Blue Lagoon" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Brain Haemorrhage" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Tequila Sunrise" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Grasshopper" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sex on the Beach" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Black Velvet" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Snakebite and Black" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Amarula Espresso" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sambuca Sour" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Pernod Fizz" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Cherry Marnier Old Fashioned" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Frangelico Flip" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Tia Maria Colada" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Crème Pêche Fizz" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Ruby Port Flip" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Shirley Temple" })!, price: 8.00, isSignature: false)
        ],
        
        "The Hidden Speakeasy": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Remember the Maine" })!, price: 16.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Monkey Gland" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Death in the Afternoon" })!, price: 17.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bobby Burns" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Clover Club" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "El Presidente" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Hemingway Daiquiri" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Saturn" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Ti' Punch" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vieux Mot" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Warday's" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Warday's Sour" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Armagnac Sidecar" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Canadian Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Benedictine Sazerac" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Crème de Violette Aviation" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "New York Flip" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Godfather" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 14.00, isSignature: false)
        ],
        
        "Tropical Paradise": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Mai Tai" })!, price: 15.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Pina Colada" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Mojito" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Dark 'n' Stormy" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Saturn" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Blue Lagoon" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Tequila Sunrise" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sex on the Beach" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Tia Maria Colada" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Long Island Iced Tea" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Moscow Mule" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Rum & Cola" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Russian" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Black Russian" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Shirley Temple" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Pernod Fizz" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Crème Pêche Fizz" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Yellow Chartreuse Swizzle" })!, price: 15.00, isSignature: false)
        ],
        
        "The Craft Beer House": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "IPA" })!, price: 8.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Stout" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Ale" })!, price: 7.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Cider" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bitter" })!, price: 7.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Brown Ale Shandy" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Black Velvet" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Snakebite and Black" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Rum & Cola" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon on the Rocks" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch on the Rocks" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Old Fashioned" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Whiskey Sour" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Godfather" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "IPA" })!, price: 25.00, isSignature: false)
        ],
        
        "Skyline Lounge": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "French 75" })!, price: 16.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Champagne Cocktail" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Aperol Spritz" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Champagne" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Russian" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Black Russian" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Espresso Martini" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "French Martini" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Lychee Martini" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Martini" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Old Fashioned" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Negroni" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Red Wine" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Wine" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sauvignon Blanc Spritzer" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 14.00, isSignature: false)
        ],
        
        "The Whiskey Library": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Old Fashioned" })!, price: 16.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Godfather" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Rob Roy" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Rusty Nail" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Whiskey Sour" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bobby Burns" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Remember the Maine" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Canadian Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Benedictine Sazerac" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "New York Flip" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon on the Rocks" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch on the Rocks" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Red Wine" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Wine" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Champagne" })!, price: 15.00, isSignature: false)
        ],
        
        "The Wine Cellar": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Red Wine" })!, price: 12.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Wine" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Champagne" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sauvignon Blanc Spritzer" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Dry Sherry Cobbler" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Tawny Port Toddy" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Ruby Port Flip" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Champagne Cocktail" })!, price: 16.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "French 75" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Aperol Spritz" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 12.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 11.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Old Fashioned" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Manhattan" })!, price: 15.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Negroni" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Martini" })!, price: 14.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Russian" })!, price: 13.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Black Russian" })!, price: 12.00, isSignature: false)
        ],
        
        "The Dive Bar": [
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Ale" })!, price: 4.00, isSignature: true),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Vodka & Soda" })!, price: 6.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Rum & Cola" })!, price: 6.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Gin & Tonic" })!, price: 6.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon Neat" })!, price: 7.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch Neat" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Bourbon on the Rocks" })!, price: 7.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Scotch on the Rocks" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Old Fashioned" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Manhattan" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Whiskey Sour" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Godfather" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "White Russian" })!, price: 8.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Black Russian" })!, price: 7.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Long Island Iced Tea" })!, price: 10.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Moscow Mule" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Tequila Sunrise" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Sex on the Beach" })!, price: 9.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Shirley Temple" })!, price: 5.00, isSignature: false),
            VenueDrink(drink: Drink.allDrinks.first(where: { $0.name == "Stout" })!, price: 4.00, isSignature: false)
        ]
    ]
    
    static func getDrinksForVenue(_ venueName: String) -> [VenueDrink] {
        return menus[venueName] ?? []
    }
} 