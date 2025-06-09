import Foundation

enum GarnishCategory: String, CaseIterable, Hashable {
    case citrus = "Citrus"
    case fruit = "Fruit"
    case herb = "Herb"
    case rim = "Rim"
    case vegetable = "Vegetable"
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
        
        // Herbs
        Garnish(name: "Mint", shortName: "Mint", category: .herb, cost: 0.25),
        Garnish(name: "Rosemary", shortName: "Rosemary", category: .herb, cost: 0.25),
        Garnish(name: "Thyme", shortName: "Thyme", category: .herb, cost: 0.25),
        Garnish(name: "Celery Stalk", shortName: "Celery Stalk", category: .herb, cost: 0.25),
        
        // Fruits
        Garnish(name: "Maraschino Cherry", shortName: "Cherry", category: .fruit, cost: 0.25),
        Garnish(name: "Raspberry", shortName: "Raspberry", category: .fruit, cost: 0.25),
        Garnish(name: "Strawberry", shortName: "Strawberry", category: .fruit, cost: 0.25),
        Garnish(name: "Lychee", shortName: "Lychee", category: .fruit, cost: 0.25),
        Garnish(name: "Blackberry", shortName: "Blackberry", category: .fruit, cost: 0.25),
        Garnish(name: "Olive", shortName: "Olive", category: .fruit, cost: 0.25),
        Garnish(name: "Pineapple Chunk", shortName: "Pineapple", category: .fruit, cost: 0.25),
        Garnish(name: "Apple Slice", shortName: "Apple", category: .fruit, cost: 0.25),
        Garnish(name: "Watermelon Slice", shortName: "Watermelon", category: .fruit, cost: 0.25),
        
        // Rims
        Garnish(name: "Salt Rim", shortName: "Salt Rim", category: .rim, cost: 0.25),
        Garnish(name: "Sugar Rim", shortName: "Sugar Rim", category: .rim, cost: 0.25)
    ]
} 