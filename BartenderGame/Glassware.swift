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
        // Tall Glasses
        Glassware(name: "Highball Glass", shortName: "Highball", category: .tall),
        Glassware(name: "Collins Glass", shortName: "Collins", category: .tall),
        Glassware(name: "Sling Glass", shortName: "Sling", category: .tall),
        
        // Short Glasses
        Glassware(name: "Rocks Glass", shortName: "Rocks", category: .short),
        Glassware(name: "Shot Glass", shortName: "Shot", category: .short),
        Glassware(name: "Old Fashioned Glass", shortName: "Old Fashioned", category: .short),
        
        // Beer Glasses
        Glassware(name: "Pint Glass", shortName: "Pint", category: .beer),
        Glassware(name: "Half Pint Glass", shortName: "Half Pint", category: .beer),
        Glassware(name: "Pilsner Glass", shortName: "Pilsner", category: .beer),
        
        // Wine Glasses
        Glassware(name: "Red Wine Glass", shortName: "Red Wine", category: .wine),
        Glassware(name: "White Wine Glass", shortName: "White Wine", category: .wine),
        Glassware(name: "Champagne Flute", shortName: "Flute", category: .wine),
        
        // Cocktail Glasses
        Glassware(name: "Martini Glass", shortName: "Martini", category: .cocktail),
        Glassware(name: "Margarita Glass", shortName: "Margarita", category: .cocktail),
        Glassware(name: "Cosmopolitan Glass", shortName: "Cosmo", category: .cocktail),
        
        // Specialty Glasses
        Glassware(name: "Hurricane Glass", shortName: "Hurricane", category: .specialty),
        Glassware(name: "Julep Cup", shortName: "Julep", category: .specialty),
        Glassware(name: "Poco Grande Glass", shortName: "Poco Grande", category: .specialty),
        Glassware(name: "Tulip Whisky Glass", shortName: "Tulip Whisky", category: .specialty),
        Glassware(name: "Cordial Glass", shortName: "Cordial", category: .specialty),
        Glassware(name: "Vodka Glass", shortName: "Vodka", category: .specialty),
        Glassware(name: "Grappa Glass", shortName: "Grappa", category: .specialty),
        Glassware(name: "Pousse Cafe Glass", shortName: "Pousse Cafe", category: .specialty),
        Glassware(name: "Absinthe Glass", shortName: "Absinthe", category: .specialty),
        Glassware(name: "Copper Mug", shortName: "Copper Mug", category: .specialty),
        Glassware(name: "Irish Coffee Glass", shortName: "Irish Coffee", category: .specialty),
        Glassware(name: "Goblet", shortName: "Goblet", category: .specialty),
        Glassware(name: "Tulip Glass", shortName: "Tulip", category: .specialty),
        Glassware(name: "Brandy Snifter", shortName: "Snifter", category: .specialty),
        Glassware(name: "Milkshake Glass", shortName: "Milkshake", category: .specialty),
        Glassware(name: "Shooter Glass", shortName: "Shooter", category: .specialty),
        Glassware(name: "Weizen Glass", shortName: "Weizen", category: .specialty),
        Glassware(name: "Zombie Glass", shortName: "Zombie", category: .specialty),
        Glassware(name: "Sherry Glass", shortName: "Sherry", category: .specialty),
        Glassware(name: "Champagne Coupe", shortName: "Coupe", category: .specialty)
    ]
} 
 