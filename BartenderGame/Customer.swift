import Foundation

struct Customer: Identifiable {
    let id = UUID()
    let drinkOrder: String
    let avatarNumber: Int
    let orderPhrase: String
    
    // Add preparation state
    var selectedGlassware: Glassware?
    var selectedIce: IceType = .none
    var selectedMethod: MethodType?
    var selectedIngredients: [DrinkIngredient] = []
    var selectedGarnishes: [DrinkIngredient] = []
    
    static var activeCustomers: [Customer] = []
    static var currentVenue: String = ""
    
    private static let orderPhrases = [
        "I'd like %@, please!",
        "I'd like to try %@.",
        "Could I have %@?",
        "I'll take %@.",
        "Make me %@."
    ]
    
    var orderText: String {
        let article = drinkOrder.article
        let formattedDrink = "\(article) \(drinkOrder)"
        return String(format: Self.orderPhrases.randomElement() ?? "I'd like %@, please!", formattedDrink)
    }
    
    static func getOrderText(for drink: String) -> String {
        let article = drink.article
        let formattedDrink = "\(article) \(drink)"
        return String(format: orderPhrases.randomElement() ?? "I'd like %@, please!", formattedDrink)
    }
    
    static func initializeActiveCustomers() {
        // Get venue-specific drinks
        let venueDrinks = VenueDrinkMenu.getDrinksForVenue(currentVenue)
        let availableDrinks = venueDrinks.map { $0.drink.name }
        
        if availableDrinks.isEmpty {
            print("[Warning] No drinks found for venue: \(currentVenue). No customers will be generated.")
        }
        
        // Get all available avatar numbers (assuming they start from 1)
        let allAvatars = Array(1...10) // Adjust this number based on your available avatars
        
        // Shuffle and take first 5 of each
        let shuffledDrinks = availableDrinks.shuffled().prefix(5)
        let shuffledAvatars = allAvatars.shuffled().prefix(5)
        
        // Create 5 unique customers
        activeCustomers = zip(shuffledDrinks, shuffledAvatars).map { drink, avatar in
            Customer(
                drinkOrder: drink,
                avatarNumber: avatar,
                orderPhrase: getOrderText(for: drink)
            )
        }
    }
    
    static func generateNewCustomerSet() {
        // Clear existing customers first
        activeCustomers.removeAll()
        
        // Get venue-specific drinks
        let venueDrinks = VenueDrinkMenu.getDrinksForVenue(currentVenue)
        let availableDrinks = venueDrinks.map { $0.drink.name }
        
        // Get all available avatar numbers (assuming they start from 1)
        let allAvatars = Array(1...10) // Adjust this number based on your available avatars
        
        // Shuffle and take first 5 of each
        let shuffledDrinks = availableDrinks.shuffled().prefix(5)
        let shuffledAvatars = allAvatars.shuffled().prefix(5)
        
        // Create 5 unique customers
        activeCustomers = zip(shuffledDrinks, shuffledAvatars).map { drink, avatar in
            Customer(
                drinkOrder: drink,
                avatarNumber: avatar,
                orderPhrase: getOrderText(for: drink)
            )
        }
    }
    
    init(drinkOrder: String, avatarNumber: Int, orderPhrase: String, selectedGlassware: Glassware? = nil, selectedIce: IceType = .none, selectedMethod: MethodType? = nil, selectedIngredients: [DrinkIngredient] = []) {
        self.drinkOrder = drinkOrder
        self.avatarNumber = avatarNumber
        self.orderPhrase = orderPhrase
        self.selectedGlassware = selectedGlassware
        self.selectedIce = selectedIce
        self.selectedMethod = selectedMethod
        self.selectedIngredients = selectedIngredients
    }
} 