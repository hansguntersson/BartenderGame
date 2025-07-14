import Foundation

enum GarnishCategory: String, CaseIterable, Hashable {
    case citrus = "Citrus"
    case fruit = "Fruit"
    case herb = "Herb"
    case spice = "Spice"
    case rim = "Rim"
    case other = "Other"
}

struct Garnish: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let shortName: String
    let category: GarnishCategory
    let cost: Double
    
    // Implement Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Garnish, rhs: Garnish) -> Bool {
        lhs.id == rhs.id
    }
    
    static let allGarnishes: [Garnish] = [
        // None
        Garnish(name: "None", shortName: "None", category: .other, cost: 0.0),
        
        // Citrus
        Garnish(name: "Lemon Twist", shortName: "Lemon Twist", category: .citrus, cost: 0.25),
        Garnish(name: "Lemon Wedge", shortName: "Lemon Wedge", category: .citrus, cost: 0.25),
        Garnish(name: "Lemon Wheel", shortName: "Lemon Wheel", category: .citrus, cost: 0.25),
        Garnish(name: "Lime Twist", shortName: "Lime Twist", category: .citrus, cost: 0.25),
        Garnish(name: "Lime Wedge", shortName: "Lime Wedge", category: .citrus, cost: 0.25),
        Garnish(name: "Lime Wheel", shortName: "Lime Wheel", category: .citrus, cost: 0.25),
        Garnish(name: "Orange Twist", shortName: "Orange Twist", category: .citrus, cost: 0.25),
        Garnish(name: "Orange Wedge", shortName: "Orange Wedge", category: .citrus, cost: 0.25),
        Garnish(name: "Orange Wheel", shortName: "Orange Wheel", category: .citrus, cost: 0.25),
        Garnish(name: "Grapefruit Twist", shortName: "Grapefruit Twist", category: .citrus, cost: 0.25),
        Garnish(name: "Flaming Orange Zest", shortName: "Flaming Orange", category: .citrus, cost: 0.30),
        
        // Fruit
        Garnish(name: "Maraschino Cherry", shortName: "Cherry", category: .fruit, cost: 0.25),
        Garnish(name: "Raspberry", shortName: "Raspberry", category: .fruit, cost: 0.25),
        Garnish(name: "Strawberry", shortName: "Strawberry", category: .fruit, cost: 0.25),
        Garnish(name: "Lychee", shortName: "Lychee", category: .fruit, cost: 0.25),
        Garnish(name: "Blackberry", shortName: "Blackberry", category: .fruit, cost: 0.25),
        Garnish(name: "Blueberry", shortName: "Blueberry", category: .fruit, cost: 0.25),
        Garnish(name: "White Grape", shortName: "White Grape", category: .fruit, cost: 0.25),
        Garnish(name: "Black Grape", shortName: "Black Grape", category: .fruit, cost: 0.25),
        Garnish(name: "Pineapple Chunk", shortName: "Pineapple", category: .fruit, cost: 0.25),
        Garnish(name: "Pineapple Leaf", shortName: "Pineapple Leaf", category: .fruit, cost: 0.25),
        Garnish(name: "Apple Slice", shortName: "Apple", category: .fruit, cost: 0.25),
        Garnish(name: "Pear Slice", shortName: "Pear Slice", category: .fruit, cost: 0.25),
        Garnish(name: "Watermelon Slice", shortName: "Watermelon", category: .fruit, cost: 0.25),
        
        // Herb
        Garnish(name: "Mint Sprig", shortName: "Mint", category: .herb, cost: 0.25),
        Garnish(name: "Rosemary Sprig", shortName: "Rosemary", category: .herb, cost: 0.25),
        Garnish(name: "Thyme Sprig", shortName: "Thyme", category: .herb, cost: 0.25),
        Garnish(name: "Basil Leaf", shortName: "Basil Leaf", category: .herb, cost: 0.25),
        
        // Spice
        Garnish(name: "Cinnamon Stick", shortName: "Cinnamon", category: .spice, cost: 0.25),
        Garnish(name: "Chocolate Shavings", shortName: "Chocolate", category: .spice, cost: 0.25),
        Garnish(name: "Grated Nutmeg", shortName: "Nutmeg", category: .spice, cost: 0.25),
        Garnish(name: "Star Anise", shortName: "Anise", category: .spice, cost: 0.25),
        Garnish(name: "Black Pepper", shortName: "Pepper", category: .spice, cost: 0.25),
        Garnish(name: "Smoked Paprika", shortName: "Paprika", category: .spice, cost: 0.25),
        
        // Rims
        Garnish(name: "Salt Rim", shortName: "Salt Rim", category: .rim, cost: 0.25),
        Garnish(name: "Sugar Rim", shortName: "Sugar Rim", category: .rim, cost: 0.25),
        Garnish(name: "Celery Salt Rim", shortName: "Celery Salt", category: .rim, cost: 0.25),
        
        // Other
        Garnish(name: "Olive", shortName: "Olive", category: .fruit, cost: 0.25),
        Garnish(name: "Cocktail Onion", shortName: "Onion", category: .other, cost: 0.25),
        Garnish(name: "Cucumber Slice", shortName: "Cucumber", category: .other, cost: 0.25),
        Garnish(name: "Celery Stalk", shortName: "Celery Stalk", category: .other, cost: 0.25),
        Garnish(name: "Jalapeño Slice", shortName: "Jalapeño", category: .other, cost: 0.25),
        Garnish(name: "Coffee Beans", shortName: "Coffee Beans", category: .other, cost: 0.20)
    ]
} 
