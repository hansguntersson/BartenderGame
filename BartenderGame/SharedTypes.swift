import Foundation

enum GlasswareCategory: String, CaseIterable {
    case tall = "Tall"
    case short = "Short"
    case beer = "Beer"
    case wine = "Wine"
    case cocktail = "Cocktail"
    case specialty = "Specialty"
}

enum IceType: String, CaseIterable, Identifiable {
    case none = "None"
    case cubed = "Cubed"
    case crushed = "Crushed"
    case sphere = "Sphere"
    case cracked = "Cracked"
    case dry = "Dry"
    
    var id: String { self.rawValue }
}

enum MethodType: String, CaseIterable, Identifiable {
    case built = "Build"
    case stirred = "Stir"
    case shaken = "Shake"
    case blended = "Blend"
    case roll = "Roll"
    case layer = "Layer"
    
    var id: String { self.rawValue }
} 
