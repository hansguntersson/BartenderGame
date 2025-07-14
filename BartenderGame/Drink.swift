import Foundation

// Glass Requirements Structure
struct GlassRequirement {
    let ideal: [Glassware]      // Primary/preferred glasses
    let acceptable: [Glassware] // Alternative valid glasses
    let minimum: Glassware?     // Minimum size requirement (optional)
    
    init(ideal: [Glassware], acceptable: [Glassware] = [], minimum: Glassware? = nil) {
        self.ideal = ideal
        self.acceptable = acceptable
        self.minimum = minimum
    }
    
    // Helper method to check if a glass is valid
    func isValidGlass(_ glass: Glassware) -> Bool {
        return ideal.contains(glass) || acceptable.contains(glass)
    }
    
    // Helper method to get tip multiplier based on glass quality
    func getTipMultiplier(for glass: Glassware) -> Double {
        if ideal.contains(glass) {
            return 1.0  // Full tip for ideal glass
        } else if acceptable.contains(glass) {
            return 0.8  // 80% tip for acceptable glass
        } else {
            return 0.2  // 20% tip for wrong glass
        }
    }
}

// Garnish Requirements Structure
struct GarnishRequirement {
    let ideal: [Garnish]        // Primary/preferred garnishes
    let acceptable: [Garnish]   // Alternative valid garnishes
    let required: Bool          // Whether garnish is required
    
    init(ideal: [Garnish], acceptable: [Garnish] = [], required: Bool = true) {
        self.ideal = ideal
        self.acceptable = acceptable
        self.required = required
    }
    
    // Helper method to check if a garnish is valid
    func isValidGarnish(_ garnish: Garnish) -> Bool {
        return ideal.contains(garnish) || acceptable.contains(garnish)
    }
    
    // Helper method to get tip multiplier based on garnish quality
    func getTipMultiplier(for garnish: Garnish) -> Double {
        if ideal.contains(garnish) {
            return 1.0  // Full tip for ideal garnish
        } else if acceptable.contains(garnish) {
            return 0.8  // 80% tip for acceptable garnish
        } else {
            return 0.2  // 20% tip for wrong garnish
        }
    }
    
    // Helper method to check if no garnish is acceptable
    func allowsNoGarnish() -> Bool {
        return !required || ideal.contains(where: { $0.name == "None" }) || acceptable.contains(where: { $0.name == "None" })
    }
}

enum DrinkCategory: String, CaseIterable {
    case cocktail = "Cocktail"
    case regular = "Regular"
}

enum DrinkStyle: String, CaseIterable {
    case draught = "Draught"
    case wine = "Wine"
    case spirits = "Spirits"
    case spiritMixer = "Spirit Mixer"
    case classic = "Classic"
    case modern = "Modern"
    case party = "Party"
    case obscure = "Obscure"
    case nonAlcoholic = "Non-Alcoholic"
}

enum DrinkFamily: String, CaseIterable {
    case none = "None"
    case oldFashioned = "Old Fashioned"
    case manhattan = "Manhattan"
    case martini = "Martini"
    case daiquiri = "Daiquiri"
    case margarita = "Margarita"
    case negroni = "Negroni"
    case gimlet = "Gimlet"
    case collins = "Collins"
    case fizz = "Fizz"
    case sour = "Sour"
    case julep = "Julep"
    case smash = "Smash"
    case cobbler = "Cobbler"
    case toddy = "Toddy"
    case swizzle = "Swizzle"
    case fix = "Fix"
    case rickey = "Rickey"
    case buck = "Buck"
    case spritz = "Spritz"
    case sling = "Sling"
    case cooler = "Cooler"
    case robRoy = "Rob Roy"
    case sidecar = "Sidecar"
    case whiteLady = "White Lady"
    case cloverClub = "Clover Club"
    case hemingway = "Hemingway"
    case elPresidente = "El Presidente"
    case monkeyGland = "Monkey Gland"
    case rememberTheMaine = "Remember the Maine"
    case saturn = "Saturn"
    case tiPunch = "Ti' Punch"
    case vieuxMot = "Vieux Mot"
    case wardays = "Warday's"
    // Beer and Wine families
    case ale = "Ale"
    case stout = "Stout"
    case ipa = "IPA"
    case cider = "Cider"
    case redWine = "Red Wine"
    case whiteWine = "White Wine"
    case champagne = "Champagne"
    // Cocktail families
    case cosmopolitan = "Cosmopolitan"
    case whiskeySour = "Whiskey Sour"
    case tomCollins = "Tom Collins"
    case maiTai = "Mai Tai"
    case darkNStormy = "Dark 'n' Stormy"
    case sazerac = "Sazerac"
    case rustyNail = "Rusty Nail"
    case deathInTheAfternoon = "Death in the Afternoon"
    case bobbyBurns = "Bobby Burns"
    case espressoMartini = "Espresso Martini"
    case longIslandIcedTea = "Long Island Iced Tea"
    case champagneCocktail = "Champagne Cocktail"
    case french75 = "French 75"
    case pinaColada = "Pina Colada"
    case mojito = "Mojito"
    case hocusPocus = "Hocus Pocus"
    case vampiresKiss = "Vampires Kiss"
    case foolishMortal = "Foolish Mortal"
    case allHallowsEve = "All Hallow's Eve"
    case lovePotion = "Love Potion"
    case irishCoffee = "Irish Coffee"
    case pornstarMartini = "Pornstar Martini"
    case ginRickey = "Gin Rickey"
    case whiskeyHighball = "Whiskey Highball"
}

struct Drink {
    let name: String
    let recipe: [DrinkIngredient]
    let description: String
    let requiredIce: IceType
    let requiredMethod: MethodType
    let glassRequirement: GlassRequirement
    let garnishRequirement: GarnishRequirement
    let category: DrinkCategory
    let style: DrinkStyle
    let family: DrinkFamily
    
    init(name: String, recipe: [DrinkIngredient], description: String, requiredIce: IceType, requiredMethod: MethodType, glassRequirement: GlassRequirement, garnishRequirement: GarnishRequirement, category: DrinkCategory, style: DrinkStyle, family: DrinkFamily) {
        self.name = name
        self.recipe = recipe
        self.description = description
        self.requiredIce = requiredIce
        self.requiredMethod = requiredMethod
        self.glassRequirement = glassRequirement
        self.garnishRequirement = garnishRequirement
        self.category = category
        self.style = style
        self.family = family
    }
    
    var preparationInfo: String {
        """
        Glass: \(glassRequirement.ideal.first?.name ?? "Multiple options")
        Ice: \(requiredIce.rawValue)
        Method: \(requiredMethod.rawValue)
        Garnish: \(garnishRequirement.ideal.first?.name ?? "Multiple options")
        """
    }
    
    static let allDrinks: [Drink] = [
        Drink(
            name: "Cosmopolitan",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 1.5),
                DrinkIngredient(name: "Triple Sec", amount: 0.5),
                DrinkIngredient(name: "Cranberry Juice", amount: 1.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5)
            ],
            description: "A modern classic vodka cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Cosmopolitan Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Flaming Orange Zest" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Orange Twist" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .cosmopolitan
        ),
        Drink(
            name: "Negroni",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.0),
                DrinkIngredient(name: "Campari", amount: 1.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 1.0)
            ],
            description: "A classic Italian aperitif cocktail",
            requiredIce: .cubed,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Orange Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Orange Wheel" })!, Garnish.allGarnishes.first(where: { $0.name == "Orange Wedge" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .negroni
        ),
        Drink(
            name: "Daiquiri",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75)
            ],
            description: "A classic Cuban rum cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Twist" })!, Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .daiquiri
        ),
        Drink(
            name: "Whiskey Sour",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75)
            ],
            description: "A classic whiskey cocktail with citrus",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Wedge" })!, Garnish.allGarnishes.first(where: { $0.name == "Maraschino Cherry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!, Garnish.allGarnishes.first(where: { $0.name == "Lemon Wheel" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .whiskeySour
        ),
        Drink(
            name: "Tom Collins",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Soda Water", amount: 2.0)
            ],
            description: "A refreshing gin highball cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!],
                acceptable: [
                    Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
                    Glassware.allGlassware.first(where: { $0.name == "Milkshake Glass" })!
                ]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .tomCollins
        ),
        Drink(
            name: "Mai Tai",
            recipe: [
                DrinkIngredient(name: "Dark Rum", amount: 1.5),
                DrinkIngredient(name: "Golden Rum", amount: 0.5),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Orgeat", amount: 0.75),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Orange Bitters", amount: 0.25)
            ],
            description: "A classic tiki cocktail",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Mint Sprig" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Leaf" })!]
            ),
            category: .cocktail,
            style: .party,
            family: .maiTai
        ),
        Drink(
            name: "Gimlet",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.75),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A classic gin and lime cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .gimlet
        ),
        Drink(
            name: "Dark 'n' Stormy",
            recipe: [
                DrinkIngredient(name: "Dark Rum", amount: 2.0),
                DrinkIngredient(name: "Ginger Beer", amount: 4.0)
            ],
            description: "A classic rum and ginger beer cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .darkNStormy
        ),
        Drink(
            name: "Sazerac",
            recipe: [
                DrinkIngredient(name: "Rye Whiskey", amount: 2.0),
                DrinkIngredient(name: "Peychaud's Bitters", amount: 0.25),
                DrinkIngredient(name: "Absinthe", amount: 0.25),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.25)
            ],
            description: "A classic New Orleans cocktail",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .sazerac
        ),
        Drink(
            name: "Gin Martini",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.5),
                DrinkIngredient(name: "Dry Vermouth", amount: 0.5)
            ],
            description: "The classic gin cocktail",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Olive" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .martini
        ),
        Drink(
            name: "Vodka Martini",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.5),
                DrinkIngredient(name: "Dry Vermouth", amount: 0.5)
            ],
            description: "A vodka-based martini variation",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Olive" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .martini
        ),
        Drink(
            name: "Dirty Martini",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Dry Vermouth", amount: 0.5),
                DrinkIngredient(name: "Olive Brine", amount: 0.5)
            ],
            description: "A martini with olive brine for a savory twist",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Olive" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .martini
        ),
        Drink(
            name: "Vesper",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 3.0),
                DrinkIngredient(name: "Vodka", amount: 1.0),
                DrinkIngredient(name: "Lillet Blanc", amount: 0.5)
            ],
            description: "James Bond's signature cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .martini
        ),
        Drink(
            name: "Rob Roy",
            recipe: [
                DrinkIngredient(name: "Blended Scotch", amount: 2.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 1.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A Scotch-based Manhattan variation",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .cocktail,
            style: .obscure,
            family: .robRoy
        ),
        Drink(
            name: "Sidecar",
            recipe: [
                DrinkIngredient(name: "Cognac", amount: 2.0),
                DrinkIngredient(name: "Cointreau", amount: 1.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0)
            ],
            description: "A classic brandy cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Sugar Rim" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!, Garnish.allGarnishes.first(where: { $0.name == "Orange Twist" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .sidecar
        ),
        Drink(
            name: "Mint Julep",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Mint Leaf", amount: 0.25)
            ],
            description: "A classic Kentucky Derby cocktail",
            requiredIce: .crushed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Julep Cup" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Mint Sprig" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .julep
        ),
        Drink(
            name: "Rusty Nail",
            recipe: [
                DrinkIngredient(name: "Blended Scotch", amount: 2.0),
                DrinkIngredient(name: "Drambuie", amount: 0.75)
            ],
            description: "A classic scotch and honey liqueur cocktail",
            requiredIce: .cubed,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .rustyNail
        ),
        Drink(
            name: "White Lady",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Cointreau", amount: 0.75),
                DrinkIngredient(name: "Lemon Juice", amount: 0.75),
                DrinkIngredient(name: "Egg White", amount: 1.0)
            ],
            description: "A classic gin cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!, Garnish.allGarnishes.first(where: { $0.name == "Orange Twist" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .whiteLady
        ),
        Drink(
            name: "Bobby Burns",
            recipe: [
                DrinkIngredient(name: "Blended Scotch", amount: 2.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 0.75),
                DrinkIngredient(name: "Benedictine", amount: 0.5)
            ],
            description: "A classic scotch and vermouth cocktail",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .obscure,
            family: .bobbyBurns
        ),
        Drink(
            name: "Clover Club",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 0.75),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Raspberry Syrup", amount: 0.5),
                DrinkIngredient(name: "Egg White", amount: 1.0)
            ],
            description: "A classic gin cocktail with raspberry",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Raspberry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .obscure,
            family: .cloverClub
        ),
        Drink(
            name: "Death in the Afternoon",
            recipe: [
                DrinkIngredient(name: "Absinthe", amount: 1.0),
                DrinkIngredient(name: "Champagne", amount: 4.0)
            ],
            description: "A classic Hemingway cocktail",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .deathInTheAfternoon
        ),
        Drink(
            name: "El Presidente",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 1.5),
                DrinkIngredient(name: "Dry Vermouth", amount: 0.75),
                DrinkIngredient(name: "Cointreau", amount: 0.75),
                DrinkIngredient(name: "Grenadine", amount: 0.25)
            ],
            description: "A Cuban classic cocktail",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .elPresidente
        ),
        Drink(
            name: "Hemingway Daiquiri",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.75),
                DrinkIngredient(name: "Grapefruit Juice", amount: 0.5),
                DrinkIngredient(name: "Maraschino Liqueur", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.25)
            ],
            description: "A variation of the classic Daiquiri",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Grapefruit Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Twist" })!, Garnish.allGarnishes.first(where: { $0.name == "Maraschino Cherry" })!]
            ),
            category: .cocktail,
            style: .obscure,
            family: .daiquiri
        ),
        Drink(
            name: "Monkey Gland",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Orange Juice", amount: 1.0),
                DrinkIngredient(name: "Absinthe", amount: 0.25),
                DrinkIngredient(name: "Grenadine", amount: 0.25)
            ],
            description: "A classic gin cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .monkeyGland
        ),
        Drink(
            name: "Remember the Maine",
            recipe: [
                DrinkIngredient(name: "Rye Whiskey", amount: 2.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 0.75),
                DrinkIngredient(name: "Cherry Heering", amount: 0.25),
                DrinkIngredient(name: "Absinthe", amount: 0.25)
            ],
            description: "A variation of the Manhattan",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .manhattan
        ),
        Drink(
            name: "Saturn",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.0),
                DrinkIngredient(name: "Passion Fruit Syrup", amount: 0.5),
                DrinkIngredient(name: "Orgeat", amount: 0.5),
                DrinkIngredient(name: "Lemon Juice", amount: 0.5),
                DrinkIngredient(name: "Lime Juice", amount: 0.5)
            ],
            description: "A tiki-style gin cocktail",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .saturn
        ),
        Drink(
            name: "Ti' Punch",
            recipe: [
                DrinkIngredient(name: "Rhum Agricole", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.25)
            ],
            description: "A classic Caribbean cocktail",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .tiPunch
        ),
        Drink(
            name: "Vieux Mot",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.0),
                DrinkIngredient(name: "Lillet Blanc", amount: 1.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A variation of the Corpse Reviver No. 2",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .vieuxMot
        ),
        Drink(
            name: "Warday's Sour",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.5),
                DrinkIngredient(name: "Lemon Juice", amount: 0.75),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A variation of the Gin Sour with bitters",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .sour
        ),
        Drink(
            name: "Warday's",
            recipe: [
                DrinkIngredient(name: "Calvados", amount: 1.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 1.0),
                DrinkIngredient(name: "Gin", amount: 1.0),
                DrinkIngredient(name: "Green Chartreuse", amount: 0.25)
            ],
            description: "A balanced cocktail with Calvados, vermouth, and gin, finished with Chartreuse",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        // Regular Drinks
        Drink(
            name: "Red Wine",
            recipe: [
                DrinkIngredient(name: "Pinot Noir", amount: 6.0)
            ],
            description: "A glass of red wine",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Red Wine Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Wine Goblet" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .wine,
            family: .redWine
        ),
        Drink(
            name: "White Wine",
            recipe: [
                DrinkIngredient(name: "Chardonnay", amount: 5.0)
            ],
            description: "A glass of white wine",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "White Wine Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Wine Goblet" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .wine,
            family: .whiteWine
        ),
        Drink(
            name: "Champagne",
            recipe: [
                DrinkIngredient(name: "Champagne", amount: 6.0)
            ],
            description: "A glass of champagne",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .wine,
            family: .champagne
        ),
        Drink(
            name: "Stout",
            recipe: [
                DrinkIngredient(name: "Stout", amount: 12.0)
            ],
            description: "A pint of stout",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .draught,
            family: .stout
        ),
        Drink(
            name: "Ale",
            recipe: [
                DrinkIngredient(name: "Ale", amount: 12.0)
            ],
            description: "A pint of ale",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .draught,
            family: .ale
        ),
        Drink(
            name: "IPA",
            recipe: [
                DrinkIngredient(name: "India Pale Ale", amount: 12.0)
            ],
            description: "A pint of IPA",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .draught,
            family: .ipa
        ),
        Drink(
            name: "Cider",
            recipe: [
                DrinkIngredient(name: "Cider", amount: 12.0)
            ],
            description: "A pint of cider",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .draught,
            family: .cider
        ),
        Drink(
            name: "Bourbon Neat",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0)
            ],
            description: "Bourbon whiskey served neat",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Scotch Neat",
            recipe: [
                DrinkIngredient(name: "Single Malt Scotch", amount: 2.0)
            ],
            description: "Single malt scotch served neat",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Bourbon on the Rocks",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0)
            ],
            description: "Bourbon whiskey served over ice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Scotch on the Rocks",
            recipe: [
                DrinkIngredient(name: "Single Malt Scotch", amount: 2.0)
            ],
            description: "Single malt scotch served over ice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Absinthe",
            recipe: [
                DrinkIngredient(name: "Absinthe", amount: 2.0)
            ],
            description: "Traditional absinthe served with water",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Absinthe Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Pernod",
            recipe: [
                DrinkIngredient(name: "Pernod", amount: 2.0)
            ],
            description: "French anise liqueur served with water",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Sambuca",
            recipe: [
                DrinkIngredient(name: "White Sambuca", amount: 2.0)
            ],
            description: "Italian anise liqueur served with coffee beans",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Coffee Beans" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                required: false
            ),
            category: .regular,
            style: .spirits,
            family: .none
        ),
        Drink(
            name: "Gin and Tonic",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Tonic Water", amount: 4.0)
            ],
            description: "A classic gin highball",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Vodka & Soda",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Soda Water", amount: 4.0)
            ],
            description: "A simple highball drink",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Rum & Cola",
            recipe: [
                DrinkIngredient(name: "Golden Rum", amount: 2.0),
                DrinkIngredient(name: "Cola", amount: 4.0)
            ],
            description: "A classic highball drink",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Rum and Ginger Ale",
            recipe: [
                DrinkIngredient(name: "Golden Rum", amount: 2.0),
                DrinkIngredient(name: "Ginger Ale", amount: 4.0)
            ],
            description: "A refreshing rum highball with ginger ale",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Vodka and Tonic",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Tonic Water", amount: 4.0)
            ],
            description: "A simple vodka highball with tonic",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Whisky and Coke",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0),
                DrinkIngredient(name: "Cola", amount: 4.0)
            ],
            description: "A classic whiskey highball with cola",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Brandy and Coke",
            recipe: [
                DrinkIngredient(name: "Cognac", amount: 2.0),
                DrinkIngredient(name: "Cola", amount: 4.0)
            ],
            description: "A smooth brandy highball with cola",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Brandy and Ginger",
            recipe: [
                DrinkIngredient(name: "Cognac", amount: 2.0),
                DrinkIngredient(name: "Ginger Ale", amount: 4.0)
            ],
            description: "A warming brandy highball with ginger ale",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Gin and Orange Juice",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Orange Juice", amount: 4.0)
            ],
            description: "A refreshing gin highball with orange juice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Orange Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Orange Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Vodka Cranberry",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Cranberry Juice", amount: 4.0)
            ],
            description: "A tart vodka highball with cranberry juice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Vodka Lemonade",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Lemonade", amount: 4.0)
            ],
            description: "A refreshing vodka highball with lemonade",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Wheel" })!]
            ),
            category: .regular,
            style: .spiritMixer,
            family: .none
        ),
        Drink(
            name: "Old Fashioned",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.25),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "The original cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Orange Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Orange Wheel" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .oldFashioned
        ),
        Drink(
            name: "Manhattan",
            recipe: [
                DrinkIngredient(name: "Rye Whiskey", amount: 2.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 1.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A classic whiskey cocktail",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Orange Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Maraschino Cherry" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .manhattan
        ),
        Drink(
            name: "Moscow Mule",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Ginger Beer", amount: 4.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5)
            ],
            description: "A classic vodka and ginger beer cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Copper Mug" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!]
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Brandy Sidecar",
            recipe: [
                DrinkIngredient(name: "Cognac", amount: 2.0),
                DrinkIngredient(name: "Cointreau", amount: 1.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0)
            ],
            description: "A classic brandy cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .cocktail,
            style: .classic,
            family: .sidecar
        ),
        Drink(
            name: "Margarita",
            recipe: [
                DrinkIngredient(name: "Blanco Tequila", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Triple Sec", amount: 0.75)
            ],
            description: "A classic tequila cocktail",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Margarita Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Salt Rim" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .margarita
        ),
        Drink(
            name: "Mojito",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Mint Leaf", amount: 0.25),
                DrinkIngredient(name: "Soda Water", amount: 2.0)
            ],
            description: "A refreshing rum cocktail",
            requiredIce: .crushed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Mint Sprig" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .mojito
        ),
        Drink(
            name: "Espresso Martini",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 1.5),
                DrinkIngredient(name: "Kahlua", amount: 0.5),
                DrinkIngredient(name: "Espresso", amount: 1.0)
            ],
            description: "A modern coffee cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Coffee Beans" })!],
                acceptable: [],
                required: false
            ),
            category: .cocktail,
            style: .modern,
            family: .espressoMartini
        ),
        Drink(
            name: "Long Island Iced Tea",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 0.5),
                DrinkIngredient(name: "Gin", amount: 0.5),
                DrinkIngredient(name: "White Rum", amount: 0.5),
                DrinkIngredient(name: "Blanco Tequila", amount: 0.5),
                DrinkIngredient(name: "Triple Sec", amount: 0.5),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Cola", amount: 2.0)
            ],
            description: "A strong mixed drink",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .cocktail,
            style: .party,
            family: .longIslandIcedTea
        ),
        Drink(
            name: "Champagne Cocktail",
            recipe: [
                DrinkIngredient(name: "Champagne", amount: 4.0),
                DrinkIngredient(name: "Sugar Cube", amount: 1.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A classic champagne cocktail",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .cocktail,
            style: .classic,
            family: .champagneCocktail
        ),
        Drink(
            name: "French 75",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.0),
                DrinkIngredient(name: "Lemon Juice", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Champagne", amount: 2.0)
            ],
            description: "A champagne and gin cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: [],
                required: false
            ),
            category: .cocktail,
            style: .classic,
            family: .french75
        ),
        Drink(
            name: "Pina Colada",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 2.0),
                DrinkIngredient(name: "Coconut Cream", amount: 2.0),
                DrinkIngredient(name: "Pineapple Juice", amount: 2.0)
            ],
            description: "A tropical rum cocktail",
            requiredIce: .crushed,
            requiredMethod: .blended,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Leaf" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Chunk" })!]
            ),
            category: .cocktail,
            style: .party,
            family: .pinaColada
        ),
        // New Drinks
        Drink(
            name: "French Martini",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Chambord", amount: 0.5),
                DrinkIngredient(name: "Pineapple Juice", amount: 1.0)
            ],
            description: "A modern vodka cocktail with raspberry liqueur",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Raspberry" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .modern,
            family: .martini
        ),
        Drink(
            name: "Brain Haemorrhage",
            recipe: [
                DrinkIngredient(name: "Peach Schnapps", amount: 1.0),
                DrinkIngredient(name: "Baileys", amount: 0.5),
                DrinkIngredient(name: "Grenadine", amount: 0.25)
            ],
            description: "A layered shot with a dramatic appearance",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Shot Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Tequila Sunrise",
            recipe: [
                DrinkIngredient(name: "Blanco Tequila", amount: 2.0),
                DrinkIngredient(name: "Orange Juice", amount: 4.0),
                DrinkIngredient(name: "Grenadine", amount: 0.5)
            ],
            description: "A layered cocktail with a sunrise effect",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Blue Lagoon",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 1.5),
                DrinkIngredient(name: "Blue Curaçao", amount: 1.0),
                DrinkIngredient(name: "Lemonade", amount: 3.0)
            ],
            description: "A refreshing blue cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Grasshopper",
            recipe: [
                DrinkIngredient(name: "Crème de Menthe", amount: 1.0),
                DrinkIngredient(name: "Light Crème de Cacao", amount: 1.0),
                DrinkIngredient(name: "Cream", amount: 1.0)
            ],
            description: "A minty chocolate cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Bloody Mary",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Tomato Juice", amount: 4.0),
                DrinkIngredient(name: "Lemon Juice", amount: 0.5),
                DrinkIngredient(name: "Worcestershire Sauce", amount: 0.25),
                DrinkIngredient(name: "Tabasco Sauce", amount: 0.25),
                DrinkIngredient(name: "Celery Salt", amount: 0.25)
            ],
            description: "A savory cocktail with a spicy kick",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Celery Salt Rim" })!, Garnish.allGarnishes.first(where: { $0.name == "Celery Stalk" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        Drink(
            name: "Sex on the Beach",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 1.5),
                DrinkIngredient(name: "Peach Schnapps", amount: 0.75),
                DrinkIngredient(name: "Orange Juice", amount: 2.0),
                DrinkIngredient(name: "Cranberry Juice", amount: 2.0)
            ],
            description: "A fruity vodka cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Shirley Temple",
            recipe: [
                DrinkIngredient(name: "Ginger Ale", amount: 4.0),
                DrinkIngredient(name: "Grenadine", amount: 0.5)
            ],
            description: "A non-alcoholic classic",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Maraschino Cherry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Black Velvet",
            recipe: [
                DrinkIngredient(name: "Stout", amount: 6.0),
                DrinkIngredient(name: "Champagne", amount: 6.0)
            ],
            description: "A mix of stout and champagne",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Snakebite and Black",
            recipe: [
                DrinkIngredient(name: "Lager", amount: 6.0),
                DrinkIngredient(name: "Cider", amount: 6.0),
                DrinkIngredient(name: "Blackcurrant Cordial", amount: 0.5)
            ],
            description: "A mix of lager, cider, and blackcurrant",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .party,
            family: .none
        ),
        Drink(
            name: "New York Flip",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 0.75),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Whole Egg", amount: 1.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A rich and creamy bourbon cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Godfather",
            recipe: [
                DrinkIngredient(name: "Blended Scotch", amount: 1.5),
                DrinkIngredient(name: "Amaretto", amount: 0.75)
            ],
            description: "A simple but sophisticated Scotch cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        Drink(
            name: "White Russian",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Kahlua", amount: 1.0),
                DrinkIngredient(name: "Cream", amount: 1.0)
            ],
            description: "A creamy coffee-flavored cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Coffee Beans" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        Drink(
            name: "Black Russian",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Kahlua", amount: 1.0)
            ],
            description: "A simple coffee-flavored cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        // New Cocktails
        Drink(
            name: "Amarula Espresso",
            recipe: [
                DrinkIngredient(name: "Amarula", amount: 2.0),
                DrinkIngredient(name: "Espresso", amount: 1.0),
                DrinkIngredient(name: "Cream", amount: 0.5)
            ],
            description: "A luxurious coffee cocktail with Amarula cream liqueur",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .modern,
            family: .none
        ),
        Drink(
            name: "Armagnac Sidecar",
            recipe: [
                DrinkIngredient(name: "Armagnac", amount: 2.0),
                DrinkIngredient(name: "Cointreau", amount: 1.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0)
            ],
            description: "A sophisticated brandy cocktail using Armagnac",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .sidecar
        ),
        Drink(
            name: "Canadian Manhattan",
            recipe: [
                DrinkIngredient(name: "Canadian Whiskey", amount: 2.0),
                DrinkIngredient(name: "Sweet Vermouth", amount: 1.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A smooth variation of the Manhattan using Canadian Whiskey",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .manhattan
        ),
        Drink(
            name: "Sambuca Sour",
            recipe: [
                DrinkIngredient(name: "White Sambuca", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Egg White", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75)
            ],
            description: "A unique anise-flavored sour cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .sour
        ),
        Drink(
            name: "Pernod Fizz",
            recipe: [
                DrinkIngredient(name: "Pernod", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Soda Water", amount: 2.0),
                DrinkIngredient(name: "Egg White", amount: 1.0)
            ],
            description: "A refreshing anise-flavored fizz",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .fizz
        ),
        Drink(
            name: "Cherry Marnier Old Fashioned",
            recipe: [
                DrinkIngredient(name: "Cherry Marnier", amount: 2.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25),
                DrinkIngredient(name: "Sugar Cube", amount: 1.0)
            ],
            description: "A fruity twist on the classic Old Fashioned",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .modern,
            family: .oldFashioned
        ),
        Drink(
            name: "Frangelico Flip",
            recipe: [
                DrinkIngredient(name: "Frangelico", amount: 2.0),
                DrinkIngredient(name: "Whole Egg", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A rich, nutty dessert cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Tia Maria Colada",
            recipe: [
                DrinkIngredient(name: "Tia Maria", amount: 2.0),
                DrinkIngredient(name: "Coconut Cream", amount: 2.0),
                DrinkIngredient(name: "Pineapple Juice", amount: 2.0)
            ],
            description: "A coffee-flavored take on the Piña Colada",
            requiredIce: .crushed,
            requiredMethod: .blended,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .pinaColada
        ),
        Drink(
            name: "Aperol Spritz",
            recipe: [
                DrinkIngredient(name: "Aperol", amount: 2.0),
                DrinkIngredient(name: "Champagne", amount: 3.0),
                DrinkIngredient(name: "Soda Water", amount: 1.0)
            ],
            description: "A classic Italian aperitif",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "White Wine Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Wine Goblet" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .spritz
        ),
        Drink(
            name: "Melon Sour",
            recipe: [
                DrinkIngredient(name: "Melon Liqueur", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Egg White", amount: 1.0)
            ],
            description: "A vibrant green sour cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .sour
        ),
        Drink(
            name: "Lychee Martini",
            recipe: [
                DrinkIngredient(name: "Lychee Liqueur", amount: 2.0),
                DrinkIngredient(name: "Vodka", amount: 1.0),
                DrinkIngredient(name: "Dry Vermouth", amount: 0.5)
            ],
            description: "A floral, exotic martini variation",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .modern,
            family: .martini
        ),
        Drink(
            name: "Crème Pêche Fizz",
            recipe: [
                DrinkIngredient(name: "Crème Pêche", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Soda Water", amount: 2.0)
            ],
            description: "A refreshing peach cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .party,
            family: .fizz
        ),
        Drink(
            name: "Yellow Chartreuse Swizzle",
            recipe: [
                DrinkIngredient(name: "Yellow Chartreuse", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Mint Leaf", amount: 0.25)
            ],
            description: "A herbal, complex swizzle",
            requiredIce: .crushed,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .swizzle
        ),
        Drink(
            name: "Ruby Port Flip",
            recipe: [
                DrinkIngredient(name: "Ruby Port", amount: 2.0),
                DrinkIngredient(name: "Whole Egg", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A rich, fortified wine cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Brown Ale Shandy",
            recipe: [
                DrinkIngredient(name: "Brown Ale", amount: 6.0),
                DrinkIngredient(name: "Lemonade", amount: 6.0)
            ],
            description: "A refreshing beer cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Sauvignon Blanc Spritzer",
            recipe: [
                DrinkIngredient(name: "Sauvignon Blanc", amount: 4.0),
                DrinkIngredient(name: "Soda Water", amount: 2.0)
            ],
            description: "A light, refreshing wine cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "White Wine Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Wine Goblet" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .wine,
            family: .none
        ),
        Drink(
            name: "Tawny Port Toddy",
            recipe: [
                DrinkIngredient(name: "Tawny Port", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A warming winter drink",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Irish Coffee Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Copper Mug" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .wine,
            family: .toddy
        ),
        Drink(
            name: "Dry Sherry Cobbler",
            recipe: [
                DrinkIngredient(name: "Dry Sherry", amount: 3.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A refreshing wine-based cobbler",
            requiredIce: .crushed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Sherry Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Wine Goblet" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .wine,
            family: .cobbler
        ),
        Drink(
            name: "Crème de Violette Aviation",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Crème de Violette", amount: 0.5),
                DrinkIngredient(name: "Maraschino Liqueur", amount: 0.5),
                DrinkIngredient(name: "Lemon Juice", amount: 0.75)
            ],
            description: "A classic Aviation cocktail with violet liqueur",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Benedictine Sazerac",
            recipe: [
                DrinkIngredient(name: "Rye Whiskey", amount: 1.5),
                DrinkIngredient(name: "Benedictine", amount: 0.5),
                DrinkIngredient(name: "Peychaud's Bitters", amount: 0.25),
                DrinkIngredient(name: "Absinthe", amount: 0.25)
            ],
            description: "A herbal variation on the Sazerac",
            requiredIce: .none,
            requiredMethod: .stirred,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .sazerac
        ),
        Drink(
            name: "Bitter",
            recipe: [
                DrinkIngredient(name: "Bitter", amount: 12.0)
            ],
            description: "A pint of bitter",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        // Halloween and Themed Cocktails
        Drink(
            name: "Hocus Pocus",
            recipe: [
                DrinkIngredient(name: "Vanilla Vodka", amount: 1.5),
                DrinkIngredient(name: "St. Germain", amount: 0.75),
                DrinkIngredient(name: "Lemon Juice", amount: 0.75),
                DrinkIngredient(name: "Vanilla Syrup", amount: 0.5),
                DrinkIngredient(name: "Soda Water", amount: 1.0)
            ],
            description: "A magical vanilla and elderflower cocktail",
            requiredIce: .cubed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .hocusPocus
        ),
        Drink(
            name: "Vampires Kiss Martini",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Chambord", amount: 0.5),
                DrinkIngredient(name: "Cranberry Juice", amount: 0.5),
                DrinkIngredient(name: "Grenadine", amount: 0.25)
            ],
            description: "A blood-red martini with raspberry and cranberry",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Raspberry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .vampiresKiss
        ),
        Drink(
            name: "Foolish Mortal",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.5),
                DrinkIngredient(name: "Melon Liqueur", amount: 0.75),
                DrinkIngredient(name: "Lime Juice", amount: 0.75),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Green Food Coloring", amount: 0.1)
            ],
            description: "A bright green cocktail with melon and citrus",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .foolishMortal
        ),
        Drink(
            name: "All Hallow's Eve Martini",
            recipe: [
                DrinkIngredient(name: "Black Vodka", amount: 2.0),
                DrinkIngredient(name: "Blackcurrant Cordial", amount: 0.75),
                DrinkIngredient(name: "Lemon Juice", amount: 0.5),
                DrinkIngredient(name: "Black Food Coloring", amount: 0.1)
            ],
            description: "A mysterious black martini with blackcurrant",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Blackberry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .allHallowsEve
        ),
        Drink(
            name: "Love Potion Cocktail",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 1.5),
                DrinkIngredient(name: "St. Germain", amount: 0.75),
                DrinkIngredient(name: "Crème Pêche", amount: 0.75),
                DrinkIngredient(name: "Lemon Juice", amount: 0.5),
                DrinkIngredient(name: "Grenadine", amount: 0.25)
            ],
            description: "A romantic pink cocktail with elderflower and peach",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Strawberry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .lovePotion
        ),
        Drink(
            name: "Irish Coffee",
            recipe: [
                DrinkIngredient(name: "Irish Whiskey", amount: 1.5),
                DrinkIngredient(name: "Espresso", amount: 1.0),
                DrinkIngredient(name: "Cream", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.25)
            ],
            description: "A classic Irish coffee with whiskey and cream",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Irish Coffee Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Copper Mug" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .classic,
            family: .irishCoffee
        ),
        Drink(
            name: "Pornstar Martini",
            recipe: [
                DrinkIngredient(name: "Vanilla Vodka", amount: 1.5),
                DrinkIngredient(name: "Passion Fruit Syrup", amount: 0.75),
                DrinkIngredient(name: "Lime Juice", amount: 0.5),
                DrinkIngredient(name: "Vanilla Syrup", amount: 0.25),
                DrinkIngredient(name: "Champagne", amount: 0.5)
            ],
            description: "A modern martini with passion fruit and vanilla",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Chunk" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .modern,
            family: .pornstarMartini
        ),
        Drink(
            name: "Gin Rickey",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.75),
                DrinkIngredient(name: "Soda Water", amount: 3.0)
            ],
            description: "A refreshing gin highball with lime and soda",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [
                    Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!,
                    Glassware.allGlassware.first(where: { $0.name == "Milkshake Glass" })!
                ]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .ginRickey
        ),
        Drink(
            name: "Whiskey Highball",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0),
                DrinkIngredient(name: "Soda Water", amount: 4.0)
            ],
            description: "A simple whiskey and soda highball",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [
                    Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!,
                    Glassware.allGlassware.first(where: { $0.name == "Rocks Glass" })!
                ]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lemon Twist" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .whiskeyHighball
        ),
        Drink(
            name: "Aviation",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Maraschino Liqueur", amount: 0.5),
                DrinkIngredient(name: "Lemon Juice", amount: 0.75),
                DrinkIngredient(name: "Crème de Violette", amount: 0.25)
            ],
            description: "A classic gin cocktail with violet liqueur",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Lager",
            recipe: [
                DrinkIngredient(name: "Lager", amount: 16.0)
            ],
            description: "A pint of lager",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Brown Ale",
            recipe: [
                DrinkIngredient(name: "Brown Ale", amount: 12.0)
            ],
            description: "A pint of smooth brown ale",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Lager Shandy",
            recipe: [
                DrinkIngredient(name: "Lager", amount: 6.0),
                DrinkIngredient(name: "Lemonade", amount: 6.0)
            ],
            description: "A refreshing lager mixed with lemonade",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Lager Top",
            recipe: [
                DrinkIngredient(name: "Lager", amount: 10.0),
                DrinkIngredient(name: "Lemonade", amount: 2.0)
            ],
            description: "A lager with a splash of lemonade on top",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Weizen Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Victorian Shandy",
            recipe: [
                DrinkIngredient(name: "Stout", amount: 6.0),
                DrinkIngredient(name: "Ginger Ale", amount: 6.0)
            ],
            description: "A classic Victorian-era beer cocktail with stout and ginger ale",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        Drink(
            name: "Half of Ale",
            recipe: [
                DrinkIngredient(name: "Ale", amount: 8.0)
            ],
            description: "A half pint of traditional ale",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of Stout",
            recipe: [
                DrinkIngredient(name: "Stout", amount: 8.0)
            ],
            description: "A half pint of rich, dark stout",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of Bitter",
            recipe: [
                DrinkIngredient(name: "Bitter", amount: 8.0)
            ],
            description: "A half pint of traditional English bitter",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of Lager",
            recipe: [
                DrinkIngredient(name: "Lager", amount: 8.0)
            ],
            description: "A half pint of crisp lager",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of Brown Ale",
            recipe: [
                DrinkIngredient(name: "Brown Ale", amount: 8.0)
            ],
            description: "A half pint of smooth brown ale",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of IPA",
            recipe: [
                DrinkIngredient(name: "India Pale Ale", amount: 8.0)
            ],
            description: "A half pint of hoppy India Pale Ale",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of Cider",
            recipe: [
                DrinkIngredient(name: "Cider", amount: 8.0)
            ],
            description: "A half pint of refreshing cider",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        Drink(
            name: "Half of Lager Shandy",
            recipe: [
                DrinkIngredient(name: "Lager", amount: 4.0),
                DrinkIngredient(name: "Lemonade", amount: 4.0)
            ],
            description: "A half pint of refreshing lager mixed with lemonade",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Half Pint Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Pilsner Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .draught,
            family: .none
        ),
        // Additional Classic Cocktails
        Drink(
            name: "Zombie",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 1.5),
                DrinkIngredient(name: "Golden Rum", amount: 1.5),
                DrinkIngredient(name: "Dark Rum", amount: 1.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Pineapple Juice", amount: 1.0),
                DrinkIngredient(name: "Passion Fruit Syrup", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25),
                DrinkIngredient(name: "Absinthe", amount: 0.25)
            ],
            description: "A complex tiki cocktail with multiple rums and tropical flavors",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Leaf" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Mint Sprig" })!]
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Hurricane",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 2.0),
                DrinkIngredient(name: "Dark Rum", amount: 2.0),
                DrinkIngredient(name: "Passion Fruit Syrup", amount: 1.0),
                DrinkIngredient(name: "Orange Juice", amount: 1.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A New Orleans classic with rum and passion fruit",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Orange Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Leaf" })!]
            ),
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Salty Dog",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Grapefruit Juice", amount: 4.0)
            ],
            description: "A gin highball with grapefruit juice and salt rim",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Salt Rim" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Grapefruit Twist" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        Drink(
            name: "Sea Breeze",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Cranberry Juice", amount: 3.0),
                DrinkIngredient(name: "Grapefruit Juice", amount: 1.0)
            ],
            description: "A refreshing vodka cocktail with cranberry and grapefruit",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Grapefruit Twist" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        Drink(
            name: "Strawberry Daiquiri",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Strawberry Syrup", amount: 0.5)
            ],
            description: "A fruity variation of the classic Daiquiri",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Champagne Coupe" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Strawberry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
            ),
            category: .cocktail,
            style: .party,
            family: .daiquiri
        ),
        Drink(
            name: "Singapore Sling",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 1.5),
                DrinkIngredient(name: "Cherry Heering", amount: 0.5),
                DrinkIngredient(name: "Benedictine", amount: 0.25),
                DrinkIngredient(name: "Cointreau", amount: 0.25),
                DrinkIngredient(name: "Pineapple Juice", amount: 1.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.25),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A complex gin cocktail with multiple liqueurs and tropical flavors",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Leaf" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Maraschino Cherry" })!]
            ),
            category: .cocktail,
            style: .classic,
            family: .sling
        ),
        // Non-Alcoholic Drinks
        Drink(
            name: "Vanilla Milkshake",
            recipe: [
                DrinkIngredient(name: "Vanilla Ice Cream", amount: 4.0),
                DrinkIngredient(name: "Milk", amount: 2.0),
                DrinkIngredient(name: "Vanilla Syrup", amount: 0.5)
            ],
            description: "A creamy vanilla milkshake",
            requiredIce: .none,
            requiredMethod: .blended,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Milkshake Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Chocolate Milkshake",
            recipe: [
                DrinkIngredient(name: "Chocolate Ice Cream", amount: 4.0),
                DrinkIngredient(name: "Milk", amount: 2.0),
                DrinkIngredient(name: "Chocolate Syrup", amount: 0.5)
            ],
            description: "A rich chocolate milkshake",
            requiredIce: .none,
            requiredMethod: .blended,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Milkshake Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Chocolate Shavings" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Strawberry Milkshake",
            recipe: [
                DrinkIngredient(name: "Vanilla Ice Cream", amount: 4.0),
                DrinkIngredient(name: "Milk", amount: 2.0),
                DrinkIngredient(name: "Strawberry Syrup", amount: 0.5)
            ],
            description: "A fruity strawberry milkshake",
            requiredIce: .none,
            requiredMethod: .blended,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Milkshake Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Strawberry" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Pineapple Juice",
            recipe: [
                DrinkIngredient(name: "Pineapple Juice", amount: 6.0)
            ],
            description: "A glass of fresh pineapple juice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Pineapple Chunk" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Orange Juice",
            recipe: [
                DrinkIngredient(name: "Orange Juice", amount: 6.0)
            ],
            description: "A glass of fresh orange juice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Orange Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Cranberry Juice",
            recipe: [
                DrinkIngredient(name: "Cranberry Juice", amount: 6.0)
            ],
            description: "A glass of tart cranberry juice",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Cranberry and Soda",
            recipe: [
                DrinkIngredient(name: "Cranberry Juice", amount: 3.0),
                DrinkIngredient(name: "Soda Water", amount: 3.0)
            ],
            description: "A refreshing cranberry spritzer",
            requiredIce: .cubed,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wedge" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "None" })!]
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Coffee",
            recipe: [
                DrinkIngredient(name: "Coffee", amount: 8.0)
            ],
            description: "A hot cup of coffee",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Irish Coffee Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Copper Mug" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        ),
        Drink(
            name: "Tea",
            recipe: [
                DrinkIngredient(name: "Tea", amount: 8.0)
            ],
            description: "A hot cup of tea",
            requiredIce: .none,
            requiredMethod: .built,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Irish Coffee Glass" })!],
                acceptable: [Glassware.allGlassware.first(where: { $0.name == "Copper Mug" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "None" })!],
                acceptable: []
            ),
            category: .regular,
            style: .nonAlcoholic,
            family: .none
        )
    ]
} 
