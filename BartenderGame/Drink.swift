import Foundation

enum DrinkCategory: String, CaseIterable {
    case cocktail = "Cocktail"
    case regular = "Regular"
}

enum DrinkStyle: String, CaseIterable {
    case regular = "Regular"
    case classic = "Classic"
    case modern = "Modern"
    case party = "Party"
    case obscure = "Obscure"
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
}

struct Drink {
    let name: String
    let recipe: [DrinkIngredient]
    let description: String
    let requiredIce: IceType
    let requiredMethod: MethodType
    let requiredGlass: Glassware
    let category: DrinkCategory
    let style: DrinkStyle
    let family: DrinkFamily
    
    init(name: String, recipe: [DrinkIngredient], description: String, requiredIce: IceType, requiredMethod: MethodType, requiredGlass: Glassware, category: DrinkCategory, style: DrinkStyle, family: DrinkFamily) {
        self.name = name
        self.recipe = recipe
        self.description = description
        self.requiredIce = requiredIce
        self.requiredMethod = requiredMethod
        self.requiredGlass = requiredGlass
        self.category = category
        self.style = style
        self.family = family
    }
    
    var preparationInfo: String {
        """
        Glass: \(requiredGlass.name)
        Ice: \(requiredIce.rawValue)
        Method: \(requiredMethod.rawValue)
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Cosmopolitan Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .tomCollins
        ),
        Drink(
            name: "Mai Tai",
            recipe: [
                DrinkIngredient(name: "White Rum", amount: 1.0),
                DrinkIngredient(name: "Dark Rum", amount: 1.0),
                DrinkIngredient(name: "Triple Sec", amount: 0.5),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5)
            ],
            description: "A tropical rum cocktail",
            requiredIce: .crushed,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .party,
            family: .maiTai
        ),
        Drink(
            name: "Gimlet",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75)
            ],
            description: "A classic gin cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .obscure,
            family: .gimlet
        ),
        Drink(
            name: "Dark 'n' Stormy",
            recipe: [
                DrinkIngredient(name: "Dark Rum", amount: 2.0),
                DrinkIngredient(name: "Ginger Beer", amount: 3.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5)
            ],
            description: "A rum and ginger beer cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .darkNStormy
        ),
        Drink(
            name: "Sazerac",
            recipe: [
                DrinkIngredient(name: "Rye Whiskey", amount: 2.0),
                DrinkIngredient(name: "Sugar Cube", amount: 1.0),
                DrinkIngredient(name: "Peychaud's Bitters", amount: 0.25),
                DrinkIngredient(name: "Angostura Bitters", amount: 0.25)
            ],
            description: "A New Orleans classic cocktail",
            requiredIce: .none,
            requiredMethod: .stirred,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .sazerac
        ),
        Drink(
            name: "Martini",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Dry Vermouth", amount: 0.5)
            ],
            description: "The king of cocktails",
            requiredIce: .none,
            requiredMethod: .stirred,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .classic,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .sidecar
        ),
        Drink(
            name: "Mint Julep",
            recipe: [
                DrinkIngredient(name: "Bourbon Whiskey", amount: 2.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.5),
                DrinkIngredient(name: "Mint", amount: 0.25)
            ],
            description: "A Kentucky Derby classic",
            requiredIce: .crushed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Julep Cup" })!,
            category: .cocktail,
            style: .classic,
            family: .julep
        ),
        Drink(
            name: "Rusty Nail",
            recipe: [
                DrinkIngredient(name: "Blended Scotch", amount: 2.0),
                DrinkIngredient(name: "Drambuie", amount: 1.0)
            ],
            description: "A classic Scotch cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            description: "A Scotch-based variation of the Rob Roy",
            requiredIce: .none,
            requiredMethod: .stirred,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .obscure,
            family: .cloverClub
        ),
        Drink(
            name: "Death in the Afternoon",
            recipe: [
                DrinkIngredient(name: "Champagne", amount: 4.0),
                DrinkIngredient(name: "Absinthe", amount: 1.0)
            ],
            description: "A Hemingway creation",
            requiredIce: .none,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .obscure,
            family: .none
        ),
        // Regular Drinks
        Drink(
            name: "Red Wine",
            recipe: [
                DrinkIngredient(name: "Pinot Noir", amount: 5.0)
            ],
            description: "A glass of red wine",
            requiredIce: .none,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Red Wine Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "White Wine Glass" })!,
            category: .regular,
            style: .regular,
            family: .whiteWine
        ),
        Drink(
            name: "Champagne",
            recipe: [
                DrinkIngredient(name: "Champagne", amount: 5.0)
            ],
            description: "A glass of champagne",
            requiredIce: .none,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .regular,
            style: .regular,
            family: .none
        ),
        Drink(
            name: "Gin & Tonic",
            recipe: [
                DrinkIngredient(name: "Gin", amount: 2.0),
                DrinkIngredient(name: "Tonic Water", amount: 4.0)
            ],
            description: "A classic highball drink",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .regular,
            style: .regular,
            family: .none
        ),
        Drink(
            name: "Old Fashioned",
            recipe: [
                DrinkIngredient(name: "Bourbon", amount: 2.0),
                DrinkIngredient(name: "Sugar Cube", amount: 1.0),
                DrinkIngredient(name: "Angostura Bitters", amount: 2.0)
            ],
            description: "A classic whiskey cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .manhattan
        ),
        Drink(
            name: "Moscow Mule",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Ginger Beer", amount: 3.0),
                DrinkIngredient(name: "Lime Juice", amount: 0.5)
            ],
            description: "A refreshing vodka cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Copper Mug" })!,
            category: .cocktail,
            style: .classic,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Margarita Glass" })!,
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
                DrinkIngredient(name: "Mint", amount: 0.25),
                DrinkIngredient(name: "Soda Water", amount: 2.0)
            ],
            description: "A refreshing rum cocktail",
            requiredIce: .crushed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .mojito
        ),
        Drink(
            name: "Espresso Martini",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Kahlua", amount: 1.0),
                DrinkIngredient(name: "Espresso", amount: 1.0)
            ],
            description: "A coffee-flavored vodka cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Champagne Flute" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Shot Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Grasshopper",
            recipe: [
                DrinkIngredient(name: "Crème de Menthe", amount: 1.0),
                DrinkIngredient(name: "Light Crème de Cacao", amount: 1.0),
                DrinkIngredient(name: "Heavy Cream", amount: 1.0)
            ],
            description: "A minty chocolate cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
            category: .cocktail,
            style: .party,
            family: .none
        ),
        Drink(
            name: "Shirley Temple",
            recipe: [
                DrinkIngredient(name: "Ginger Ale", amount: 4.0),
                DrinkIngredient(name: "Grenadine", amount: 0.5),
                DrinkIngredient(name: "Maraschino Cherry", amount: 1.0)
            ],
            description: "A non-alcoholic classic",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .none
        ),
        Drink(
            name: "White Russian",
            recipe: [
                DrinkIngredient(name: "Vodka", amount: 2.0),
                DrinkIngredient(name: "Kahlua", amount: 1.0),
                DrinkIngredient(name: "Heavy Cream", amount: 1.0)
            ],
            description: "A creamy coffee-flavored cocktail",
            requiredIce: .cubed,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
                DrinkIngredient(name: "Heavy Cream", amount: 0.5)
            ],
            description: "A luxurious coffee cocktail with Amarula cream liqueur",
            requiredIce: .none,
            requiredMethod: .built,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
            category: .cocktail,
            style: .obscure,
            family: .manhattan
        ),
        Drink(
            name: "Sambuca Sour",
            recipe: [
                DrinkIngredient(name: "Sambuca", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Egg White", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75)
            ],
            description: "A unique anise-flavored sour cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Hurricane Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "White Wine Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .spritz
        ),
        Drink(
            name: "Midori Sour",
            recipe: [
                DrinkIngredient(name: "Midori", amount: 2.0),
                DrinkIngredient(name: "Lemon Juice", amount: 1.0),
                DrinkIngredient(name: "Gomme Syrup", amount: 0.75),
                DrinkIngredient(name: "Egg White", amount: 1.0)
            ],
            description: "A vibrant green sour cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Highball Glass" })!,
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
                DrinkIngredient(name: "Mint", amount: 0.25)
            ],
            description: "A herbal, complex swizzle",
            requiredIce: .crushed,
            requiredMethod: .stirred,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Collins Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "White Wine Glass" })!,
            category: .regular,
            style: .regular,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Irish Coffee Glass" })!,
            category: .regular,
            style: .obscure,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Sherry Glass" })!,
            category: .regular,
            style: .obscure,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Martini Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Old Fashioned Glass" })!,
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
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Pint Glass" })!,
            category: .regular,
            style: .regular,
            family: .none
        )
    ]
} 
