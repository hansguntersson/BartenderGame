import Foundation

struct Glassware: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let shortName: String
    let category: GlasswareCategory
    
    static func == (lhs: Glassware, rhs: Glassware) -> Bool {
        lhs.name == rhs.name
    }
    
    static let allGlassware: [Glassware] = [
        // Beer Glasses
        Glassware(name: "Pint Glass", shortName: "Pint", category: .beer),
        Glassware(name: "Half Pint Glass", shortName: "Half Pint", category: .beer),
        Glassware(name: "Pilsner Glass", shortName: "Pilsner", category: .beer),
        Glassware(name: "Weizen Glass", shortName: "Weizen", category: .beer),
        
        // Wine Glasses
        Glassware(name: "Red Wine Glass", shortName: "Red Wine", category: .wine),
        Glassware(name: "White Wine Glass", shortName: "White Wine", category: .wine),
        Glassware(name: "Wine Goblet", shortName: "Wine Goblet", category: .wine),
        Glassware(name: "Champagne Flute", shortName: "Flute", category: .wine),
        Glassware(name: "Champagne Coupe", shortName: "Coupe", category: .wine),
        Glassware(name: "Sherry Glass", shortName: "Sherry", category: .wine),
        
        // Specialty Glasses
        Glassware(name: "Irish Coffee Glass", shortName: "Irish Coffee", category: .specialty),
        Glassware(name: "Copper Mug", shortName: "Copper Mug", category: .specialty),
        Glassware(name: "Julep Cup", shortName: "Julep", category: .specialty),
        Glassware(name: "Tulip Whisky Glass", shortName: "Tulip Whisky", category: .specialty),
        Glassware(name: "Absinthe Glass", shortName: "Absinthe", category: .specialty),
        
        // Tall Glasses
        Glassware(name: "Highball Glass", shortName: "Highball", category: .tall),
        Glassware(name: "Collins Glass", shortName: "Collins", category: .tall),
        Glassware(name: "Milkshake Glass", shortName: "Milkshake", category: .tall),
        
        // Short Glasses
        Glassware(name: "Shot Glass", shortName: "Shot", category: .short),
        Glassware(name: "Shooter Glass", shortName: "Shooter", category: .short),
        Glassware(name: "Vodka Glass", shortName: "Vodka", category: .short),
        Glassware(name: "Rocks Glass", shortName: "Rocks", category: .short),
        Glassware(name: "Old Fashioned Glass", shortName: "Old Fashioned", category: .short),
        Glassware(name: "Brandy Snifter", shortName: "Snifter", category: .short),
        
        // Cocktail Glasses
        Glassware(name: "Martini Glass", shortName: "Martini", category: .cocktail),
        Glassware(name: "Margarita Glass", shortName: "Margarita", category: .cocktail),
        Glassware(name: "Cosmopolitan Glass", shortName: "Cosmo", category: .cocktail),
        Glassware(name: "Hurricane Glass", shortName: "Hurricane", category: .cocktail),
        Glassware(name: "Zombie Glass", shortName: "Zombie", category: .cocktail),
        Glassware(name: "Sling Glass", shortName: "Sling", category: .cocktail) ]
}
 
