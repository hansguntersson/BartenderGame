import Foundation

// Ingredient Categories
enum IngredientCategory: String, CaseIterable, Hashable {
    // Main Categories
    case spirits = "Spirits"
    case liqueurs = "Liqueurs"
    case aromatics = "Aromatics"
    case beer = "Beer"
    case wine = "Wine"
    case mixers = "Mixers"
    case fruit = "Fruit"
    case sweeteners = "Sweeteners"
    case other = "Other"
    
    var subcategories: [String] {
        switch self {
        case .spirits:
            return ["Whiskey", "Rum", "Vodka", "Gin", "Tequila", "Brandy"]
        case .liqueurs:
            return ["Citrus", "Coffee", "Nut", "Anise", "Cherry", "Chocolate", "Fruit", "Cream", "Other"]
        case .aromatics:
            return ["Bitters", "Vermouth", "Other"]
        case .beer:
            return ["Ale", "Stout", "Beer", "Cider"]
        case .wine:
            return ["Red Wine", "White Wine", "Rosé Wine", "Sparkling Wine", "Fortified"]
        case .mixers:
            return ["Carbonated", "Juice", "Dairy"]
        case .sweeteners:
            return ["Syrups", "Other"]
        case .fruit:
            return ["Citrus", "Berries", "Other"]
        case .other:
            return ["Eggs", "Herbs", "Other"]
        }
    }
}

// Drink Ingredient
struct DrinkIngredient: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let shortName: String
    let category: IngredientCategory
    let subcategory: String
    let cost: Double  // Cost per unit in pounds
    let amount: Double // in oz
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: DrinkIngredient, rhs: DrinkIngredient) -> Bool {
        lhs.id == rhs.id
    }
    
    init(name: String, amount: Double) {
        self.name = name
        self.amount = amount
        if let availableIngredient = DrinkIngredient.availableIngredients.first(where: { $0.name == name }) {
            self.shortName = availableIngredient.shortName
            self.category = availableIngredient.category
            self.subcategory = availableIngredient.subcategory
            self.cost = availableIngredient.cost
        } else {
            self.shortName = name
            self.category = .spirits
            self.subcategory = "Whiskey"
            self.cost = 2.50
        }
    }
    
    init(name: String, shortName: String, category: IngredientCategory, subcategory: String, cost: Double, amount: Double = 1.0) {
        self.name = name
        self.shortName = shortName
        self.category = category
        self.subcategory = subcategory
        self.cost = cost
        self.amount = amount
    }
    
    static func getIngredientsByCategory() -> [IngredientCategory: [String: [String]]] {
        var categorized: [IngredientCategory: [String: [String]]] = [:]
        
        // Initialize all categories and their subcategories
        for category in IngredientCategory.allCases {
            categorized[category] = [:]
            for subcategory in category.subcategories {
                categorized[category]?[subcategory] = []
            }
        }
        
        // Add ingredients to their respective categories and subcategories
        for ingredient in availableIngredients {
            if var categoryDict = categorized[ingredient.category] {
                if var subcategoryList = categoryDict[ingredient.subcategory] {
                    subcategoryList.append(ingredient.name)
                    categoryDict[ingredient.subcategory] = subcategoryList
                    categorized[ingredient.category] = categoryDict
                }
            }
        }
        
        return categorized
    }
    
    static let availableIngredients: [DrinkIngredient] = [
        //------------SPIRITS---------
        // Whiskey
        DrinkIngredient(name: "Bourbon Whiskey", shortName: "Bourbon", category: .spirits, subcategory: "Whiskey", cost: 2.50),
        DrinkIngredient(name: "Rye Whiskey", shortName: "Rye", category: .spirits, subcategory: "Whiskey", cost: 2.75),
        DrinkIngredient(name: "Blended Scotch", shortName: "Blended", category: .spirits, subcategory: "Whiskey", cost: 2.75),
        DrinkIngredient(name: "Single Malt Scotch", shortName: "Single Malt", category: .spirits, subcategory: "Whiskey", cost: 3.25),
        DrinkIngredient(name: "Canadian Whiskey", shortName: "Canadian", category: .spirits, subcategory: "Whiskey", cost: 2.50),
        DrinkIngredient(name: "Irish Whiskey", shortName: "Irish", category: .spirits, subcategory: "Whiskey", cost: 2.75),
        
        // Rum
        DrinkIngredient(name: "Golden Rum", shortName: "Golden", category: .spirits, subcategory: "Rum", cost: 2.25),
        DrinkIngredient(name: "Dark Rum", shortName: "Dark", category: .spirits, subcategory: "Rum", cost: 2.50),
        DrinkIngredient(name: "Spiced Rum", shortName: "Spiced", category: .spirits, subcategory: "Rum", cost: 2.75),
        DrinkIngredient(name: "White Rum", shortName: "White", category: .spirits, subcategory: "Rum", cost: 2.25),
        DrinkIngredient(name: "Rhum Agricole", shortName: "Agricole", category: .spirits, subcategory: "Rum", cost: 2.75),
        
        // Vodka
        DrinkIngredient(name: "Vodka", shortName: "Vodka", category: .spirits, subcategory: "Vodka", cost: 2.00),
        DrinkIngredient(name: "Vanilla Vodka", shortName: "Vanilla", category: .spirits, subcategory: "Vodka", cost: 2.25),
        DrinkIngredient(name: "Black Vodka", shortName: "Black", category: .spirits, subcategory: "Vodka", cost: 2.25),
        
        // Gin
        DrinkIngredient(name: "Gin", shortName: "Gin", category: .spirits, subcategory: "Gin", cost: 2.25),
        
        // Tequila
        DrinkIngredient(name: "Blanco Tequila", shortName: "Blanco", category: .spirits, subcategory: "Tequila", cost: 2.25),
        DrinkIngredient(name: "Reposado Tequila", shortName: "Reposado", category: .spirits, subcategory: "Tequila", cost: 2.50),
        DrinkIngredient(name: "Añejo Tequila", shortName: "Añejo", category: .spirits, subcategory: "Tequila", cost: 2.75),
        
        // Brandy
        DrinkIngredient(name: "Cognac", shortName: "Cognac", category: .spirits, subcategory: "Brandy", cost: 3.00),
        DrinkIngredient(name: "Armagnac", shortName: "Armagnac", category: .spirits, subcategory: "Brandy", cost: 3.00),
        DrinkIngredient(name: "Calvados", shortName: "Calvados", category: .spirits, subcategory: "Brandy", cost: 2.75),
        
        //------------LIQUEURS---------
        // Citrus
        DrinkIngredient(name: "Triple Sec", shortName: "Triple Sec", category: .liqueurs, subcategory: "Citrus", cost: 1.75),
        DrinkIngredient(name: "Cointreau", shortName: "Cointreau", category: .liqueurs, subcategory: "Citrus", cost: 2.00),
        DrinkIngredient(name: "Grand Marnier", shortName: "Grand Marnier", category: .liqueurs, subcategory: "Citrus", cost: 2.25),
        DrinkIngredient(name: "Blue Curaçao", shortName: "Blue Curaçao", category: .liqueurs, subcategory: "Citrus", cost: 1.75),
        DrinkIngredient(name: "Limoncello", shortName: "Limoncello", category: .liqueurs, subcategory: "Citrus", cost: 2.00),
        
        // Coffee
        DrinkIngredient(name: "Tia Maria", shortName: "Tia Maria", category: .liqueurs, subcategory: "Coffee", cost: 1.75),
        DrinkIngredient(name: "Kahlua", shortName: "Kahlua", category: .liqueurs, subcategory: "Coffee", cost: 1.75),
        
        // Nut
        DrinkIngredient(name: "Frangelico", shortName: "Frangelico", category: .liqueurs, subcategory: "Nut", cost: 2.00),
        DrinkIngredient(name: "Amaretto", shortName: "Amaretto", category: .liqueurs, subcategory: "Nut", cost: 1.75),
        
        // Anise
        DrinkIngredient(name: "Absinthe", shortName: "Absinthe", category: .liqueurs, subcategory: "Anise", cost: 2.50),
        DrinkIngredient(name: "White Sambuca", shortName: "White Sambuca", category: .liqueurs, subcategory: "Anise", cost: 2.00),
        DrinkIngredient(name: "Black Sambuca", shortName: "Black Sambuca", category: .liqueurs, subcategory: "Anise", cost: 2.00),
        DrinkIngredient(name: "Pernod", shortName: "Pernod", category: .liqueurs, subcategory: "Anise", cost: 2.00),
        
        // Cherry
        DrinkIngredient(name: "Cherry Marnier", shortName: "Cherry Marnier", category: .liqueurs, subcategory: "Cherry", cost: 2.25),
        DrinkIngredient(name: "Maraschino Liqueur", shortName: "Maraschino", category: .liqueurs, subcategory: "Cherry", cost: 2.00),
        DrinkIngredient(name: "Cherry Heering", shortName: "Heering", category: .liqueurs, subcategory: "Cherry", cost: 1.75),

        // Chocolate
        DrinkIngredient(name: "Light Crème de Cacao", shortName: "Light Cacao", category: .liqueurs, subcategory: "Chocolate", cost: 1.75),
        DrinkIngredient(name: "Dark Crème de Cacao", shortName: "Dark Cacao", category: .liqueurs, subcategory: "Chocolate", cost: 1.75),
        
        // Fruit
        DrinkIngredient(name: "Peach Schnapps", shortName: "Peach", category: .liqueurs, subcategory: "Fruit", cost: 1.75),
        DrinkIngredient(name: "Chambord", shortName: "Chambord", category: .liqueurs, subcategory: "Fruit", cost: 2.25),
        DrinkIngredient(name: "Melon Liqueur", shortName: "Melon", category: .liqueurs, subcategory: "Fruit", cost: 2.00),
        DrinkIngredient(name: "Crème Pêche", shortName: "Pêche", category: .liqueurs, subcategory: "Fruit", cost: 1.75),
        DrinkIngredient(name: "Lychee Liqueur", shortName: "Lychee", category: .liqueurs, subcategory: "Fruit", cost: 2.00),
        DrinkIngredient(name: "St. Germain", shortName: "St. Germain", category: .liqueurs, subcategory: "Fruit", cost: 2.25),
                
        // Cream
        DrinkIngredient(name: "Baileys", shortName: "Baileys", category: .liqueurs, subcategory: "Cream", cost: 2.00),
        DrinkIngredient(name: "Amarula", shortName: "Amarula", category: .liqueurs, subcategory: "Cream", cost: 2.25),
        
        // Other
        DrinkIngredient(name: "Crème de Menthe", shortName: "Menthe", category: .liqueurs, subcategory: "Other", cost: 1.75),
        DrinkIngredient(name: "Drambuie", shortName: "Drambuie", category: .liqueurs, subcategory: "Other", cost: 2.25),
        DrinkIngredient(name: "Crème de Violette", shortName: "Violette", category: .liqueurs, subcategory: "Other", cost: 1.75),
        
        //------------AROMATICS---------
        // Bitters
        DrinkIngredient(name: "Angostura Bitters", shortName: "Angostura", category: .aromatics, subcategory: "Bitters", cost: 0.30),
        DrinkIngredient(name: "Peychaud's Bitters", shortName: "Peychaud's", category: .aromatics, subcategory: "Bitters", cost: 0.30),
        DrinkIngredient(name: "Orange Bitters", shortName: "Orange", category: .aromatics, subcategory: "Bitters", cost: 0.30),
        DrinkIngredient(name: "Campari", shortName: "Campari", category: .aromatics, subcategory: "Bitters", cost: 2.00),
        DrinkIngredient(name: "Aperol", shortName: "Aperol", category: .aromatics, subcategory: "Bitters", cost: 1.75),
        
        // Vermouth
        DrinkIngredient(name: "Sweet Vermouth", shortName: "Sweet", category: .aromatics, subcategory: "Vermouth", cost: 0.40),
        DrinkIngredient(name: "Dry Vermouth", shortName: "Dry", category: .aromatics, subcategory: "Vermouth", cost: 0.40),
        DrinkIngredient(name: "Semi-Dry Vermouth", shortName: "Semi-Dry", category: .aromatics, subcategory: "Vermouth", cost: 0.40),
        DrinkIngredient(name: "Lillet Blanc", shortName: "Lillet", category: .aromatics, subcategory: "Vermouth", cost: 1.75),
        
        DrinkIngredient(name: "Benedictine", shortName: "Benedictine", category: .aromatics, subcategory: "Other", cost: 2.00),
        DrinkIngredient(name: "Yellow Chartreuse", shortName: "Yellow Chartreuse", category: .aromatics, subcategory: "Other", cost: 2.50),
        DrinkIngredient(name: "Green Chartreuse", shortName: "Green Chartreuse", category: .aromatics, subcategory: "Other", cost: 2.50),
        
        //------------WINE---------
        // Red Wine
        DrinkIngredient(name: "Pinot Noir", shortName: "Pinot Noir", category: .wine, subcategory: "Red Wine", cost: 0.40),
        DrinkIngredient(name: "Cabernet Sauvignon", shortName: "Cab Sav", category: .wine, subcategory: "Red Wine", cost: 0.45),
        DrinkIngredient(name: "Rioja", shortName: "Rioja", category: .wine, subcategory: "Red Wine", cost: 0.40),
        
        // White Wine
        DrinkIngredient(name: "Chardonnay", shortName: "Chardonnay", category: .wine, subcategory: "White Wine", cost: 0.40),
        DrinkIngredient(name: "Pinot Grigio", shortName: "Pinot Grigio", category: .wine, subcategory: "White Wine", cost: 0.40),
        DrinkIngredient(name: "Sauvignon Blanc", shortName: "Sauv Blanc", category: .wine, subcategory: "White Wine", cost: 0.40),
        
        // Rosé Wine
        DrinkIngredient(name: "Tempranillo Rosé", shortName: "Tempranillo Rosé", category: .wine, subcategory: "Rosé Wine", cost: 0.45),
        
        // Sparkling Wine
        DrinkIngredient(name: "Champagne", shortName: "Champagne", category: .wine, subcategory: "Sparkling Wine", cost: 0.75),
        DrinkIngredient(name: "Prosecco", shortName: "Prosecco", category: .wine, subcategory: "Sparkling Wine", cost: 0.60),
        
        // Fortified
        DrinkIngredient(name: "Ruby Port", shortName: "Ruby Port", category: .wine, subcategory: "Fortified", cost: 0.50),
        DrinkIngredient(name: "Tawny Port", shortName: "Tawny Port", category: .wine, subcategory: "Fortified", cost: 0.55),
        DrinkIngredient(name: "Dry Sherry", shortName: "Dry Sherry", category: .wine, subcategory: "Fortified", cost: 0.45),
        DrinkIngredient(name: "Sweet Sherry", shortName: "Sweet Sherry", category: .wine, subcategory: "Fortified", cost: 0.45),
        DrinkIngredient(name: "Ginger Wine", shortName: "Ginger Wine", category: .wine, subcategory: "Fortified", cost: 0.60),
        
        //------------BEER---------
        // Ale
        DrinkIngredient(name: "Ale", shortName: "Ale", category: .beer, subcategory: "Ale", cost: 0.28),
        DrinkIngredient(name: "Brown Ale", shortName: "Brown Ale", category: .beer, subcategory: "Ale", cost: 0.28),
        DrinkIngredient(name: "India Pale Ale", shortName: "IPA", category: .beer, subcategory: "Ale", cost: 0.30),
        
        // Stout
        DrinkIngredient(name: "Stout", shortName: "Stout", category: .beer, subcategory: "Stout", cost: 0.30),
        
        // Beer
        DrinkIngredient(name: "Bitter", shortName: "Bitter", category: .beer, subcategory: "Beer", cost: 0.28),
        DrinkIngredient(name: "Lager", shortName: "Lager", category: .beer, subcategory: "Beer", cost: 0.28),
        
        // Cider
        DrinkIngredient(name: "Cider", shortName: "Cider", category: .beer, subcategory: "Cider", cost: 0.28),
        
        //------------MIXERS---------
        // Carbonated
        DrinkIngredient(name: "Tonic Water", shortName: "Tonic", category: .mixers, subcategory: "Carbonated", cost: 0.50),
        DrinkIngredient(name: "Soda Water", shortName: "Soda Water", category: .mixers, subcategory: "Carbonated", cost: 0.25),
        DrinkIngredient(name: "Lemonade", shortName: "Lemonade", category: .mixers, subcategory: "Carbonated", cost: 0.50),
        DrinkIngredient(name: "Cola", shortName: "Cola", category: .mixers, subcategory: "Carbonated", cost: 0.50),
        DrinkIngredient(name: "Ginger Beer", shortName: "Ginger Beer", category: .mixers, subcategory: "Carbonated", cost: 0.75),
        DrinkIngredient(name: "Ginger Ale", shortName: "Ginger Ale", category: .mixers, subcategory: "Carbonated", cost: 0.50),
        
        // Juice
        DrinkIngredient(name: "Lime Juice", shortName: "Lime", category: .mixers, subcategory: "Juice", cost: 0.50),
        DrinkIngredient(name: "Lemon Juice", shortName: "Lemon", category: .mixers, subcategory: "Juice", cost: 0.50),
        DrinkIngredient(name: "Grapefruit Juice", shortName: "Grapefruit", category: .mixers, subcategory: "Juice", cost: 0.75),
        DrinkIngredient(name: "Orange Juice", shortName: "Orange", category: .mixers, subcategory: "Juice", cost: 0.75),
        DrinkIngredient(name: "Cranberry Juice", shortName: "Cranberry", category: .mixers, subcategory: "Juice", cost: 0.75),
        DrinkIngredient(name: "Pineapple Juice", shortName: "Pineapple Juice", category: .mixers, subcategory: "Juice", cost: 0.75),
        DrinkIngredient(name: "Tomato Juice", shortName: "Tomato", category: .mixers, subcategory: "Juice", cost: 0.75),
        
        // Dairy
        DrinkIngredient(name: "Cream", shortName: "Cream", category: .mixers, subcategory: "Dairy", cost: 0.75),
        DrinkIngredient(name: "Half and Half", shortName: "Half & Half", category: .mixers, subcategory: "Dairy", cost: 0.75),
        DrinkIngredient(name: "Milk", shortName: "Milk", category: .mixers, subcategory: "Dairy", cost: 0.50),
        DrinkIngredient(name: "Vanilla Ice Cream", shortName: "Vanilla Ice Cream", category: .mixers, subcategory: "Dairy", cost: 1.00),
        DrinkIngredient(name: "Chocolate Ice Cream", shortName: "Chocolate Ice Cream", category: .mixers, subcategory: "Dairy", cost: 1.00),
        
        // Other
        DrinkIngredient(name: "Espresso", shortName: "Espresso", category: .mixers, subcategory: "Other", cost: 1.00),
        DrinkIngredient(name: "Earl Grey Tea", shortName: "Earl Grey", category: .mixers, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Coconut Cream", shortName: "Coconut Cream", category: .mixers, subcategory: "Other", cost: 0.75),
        DrinkIngredient(name: "Coffee", shortName: "Coffee", category: .mixers, subcategory: "Other", cost: 0.75),
        DrinkIngredient(name: "Tea", shortName: "Tea", category: .mixers, subcategory: "Other", cost: 0.25),
        
        //------------FRUIT---------
        // Citrus
        DrinkIngredient(name: "Lemon Wedge", shortName: "Lemon Wedge", category: .fruit, subcategory: "Citrus", cost: 0.25),
        DrinkIngredient(name: "Lime Wedge", shortName: "Lime Wedge", category: .fruit, subcategory: "Citrus", cost: 0.25),
        DrinkIngredient(name: "Orange Wedge", shortName: "Orange Wedge", category: .fruit, subcategory: "Citrus", cost: 0.25),
        DrinkIngredient(name: "Grapefruit Wedge", shortName: "Grapefruit Wedge", category: .fruit, subcategory: "Citrus", cost: 0.25),
        
        //Berries
        DrinkIngredient(name: "Raspberry", shortName: "Raspberry", category: .fruit, subcategory: "Berries", cost: 0.25),
        DrinkIngredient(name: "Strawberry", shortName: "Strawberry", category: .fruit, subcategory: "Berries", cost: 0.25),
        DrinkIngredient(name: "Blackberry", shortName: "Blackberry", category: .fruit, subcategory: "Berries", cost: 0.25),
        DrinkIngredient(name: "Blueberry", shortName: "Blueberry", category: .fruit, subcategory: "Berries", cost: 0.25),
        
        //Other
        DrinkIngredient(name: "Apple Slice", shortName: "Apple Slice", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Pear Slice", shortName: "Pear Slice", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "White Grape", shortName: "White Grape", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Black Grape", shortName: "Black Grape", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Melon Chunk", shortName: "Melon Chunk", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Lychee", shortName: "Lychee", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Pineapple Chunk", shortName: "Pineapple Chunk", category: .fruit, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Watermelon Slice", shortName: "Watermelon Slice", category: .fruit, subcategory: "Other", cost: 0.25),
        
        //------------SWEETENERS---------
        // Syrups
        DrinkIngredient(name: "Gomme Syrup", shortName: "Gomme", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        DrinkIngredient(name: "Grenadine", shortName: "Grenadine", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        DrinkIngredient(name: "Lime Cordial", shortName: "Lime Cordial", category: .sweeteners, subcategory: "Syrups", cost: 0.25),
        DrinkIngredient(name: "Blackcurrant Cordial", shortName: "Blackcurrant", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        DrinkIngredient(name: "Raspberry Syrup", shortName: "Raspberry Syrup", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        DrinkIngredient(name: "Passion Fruit Syrup", shortName: "Passion Fruit", category: .sweeteners, subcategory: "Syrups", cost: 0.75),
        DrinkIngredient(name: "Orgeat", shortName: "Orgeat", category: .sweeteners, subcategory: "Syrups", cost: 0.75),
        DrinkIngredient(name: "Vanilla Syrup", shortName: "Vanilla Syrup", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        DrinkIngredient(name: "Chocolate Syrup", shortName: "Chocolate Syrup", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        DrinkIngredient(name: "Strawberry Syrup", shortName: "Strawberry Syrup", category: .sweeteners, subcategory: "Syrups", cost: 0.50),
        
        // Other
        DrinkIngredient(name: "Sugar Cube", shortName: "Sugar Cube", category: .sweeteners, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Honey", shortName: "Honey", category: .sweeteners, subcategory: "Other", cost: 0.75),
        DrinkIngredient(name: "Maple Syrup", shortName: "Maple Syrup", category: .sweeteners, subcategory: "Other", cost: 0.75),
        
        //------------OTHER---------
        // Eggs
        DrinkIngredient(name: "Egg White", shortName: "Egg White", category: .other, subcategory: "Eggs", cost: 0.25),
        DrinkIngredient(name: "Egg Yolk", shortName: "Egg Yolk", category: .other, subcategory: "Eggs", cost: 0.25),
        DrinkIngredient(name: "Whole Egg", shortName: "Whole Egg", category: .other, subcategory: "Eggs", cost: 0.25),
        
        // Herbs
        DrinkIngredient(name: "Mint Leaf", shortName: "Mint Leaf", category: .other, subcategory: "Herbs", cost: 0.25),
        DrinkIngredient(name: "Rosemary Sprig", shortName: "Rosemary Sprig", category: .other, subcategory: "Herbs", cost: 0.25),
        DrinkIngredient(name: "Thyme Sprig", shortName: "Thyme Sprig", category: .other, subcategory: "Herbs", cost: 0.25),
        DrinkIngredient(name: "Basil Leaf", shortName: "Basil Leaf", category: .other, subcategory: "Herbs", cost: 0.25),
        
        // Other
        DrinkIngredient(name: "Worcestershire Sauce", shortName: "Worcestershire", category: .other, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Tabasco Sauce", shortName: "Tabasco", category: .other, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Olive Brine", shortName: "Olive Brine", category: .other, subcategory: "Other", cost: 0.25),
        DrinkIngredient(name: "Green Food Coloring", shortName: "Green Food", category: .other, subcategory: "Other", cost: 0.10),
        DrinkIngredient(name: "Black Food Coloring", shortName: "Black Food", category: .other, subcategory: "Other", cost: 0.10),
        DrinkIngredient(name: "Celery Salt", shortName: "Celery Salt", category: .other, subcategory: "Other", cost: 0.25)
    ]
} 
