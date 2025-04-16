import Foundation

enum VenueStyle: String, CaseIterable {
    case classicCocktail = "Classic Cocktail"
    case modernMixology = "Modern Mixology"
    case speakeasy = "Speakeasy"
    case tropical = "Tropical"
    case craftBeer = "Craft Beer"
    case skyline = "Skyline"
    case whiskey = "Whiskey"
    case wine = "Wine"
    case dive = "Dive"
}

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday
    var shortName: String {
        switch self {
        case .monday: return "Mon"
        case .tuesday: return "Tue"
        case .wednesday: return "Wed"
        case .thursday: return "Thu"
        case .friday: return "Fri"
        case .saturday: return "Sat"
        case .sunday: return "Sun"
        }
    }
}

struct Venue: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let style: VenueStyle
    let location: String
    let capacity: Int
    let shiftLengthHours: Int
    let shiftPattern: [(day: Weekday, start: String?, end: String?)] // nil start/end means closed
    
    // Returns opening hours string for a given day (e.g. "4PM - 2AM" or "Closed")
    func openingHours(for day: Weekday) -> String {
        if let pattern = shiftPattern.first(where: { $0.day == day }) {
            if let start = pattern.start, let end = pattern.end {
                return "\(start) - \(end)"
            } else {
                return "Closed"
            }
        }
        return "Closed"
    }
    
    // Returns shift length in hours for a given day
    func shiftLengthHours(for day: Weekday) -> Int {
        guard let pattern = shiftPattern.first(where: { $0.day == day }),
              let start = pattern.start, let end = pattern.end else { return 0 }
        return Venue.calculateShiftLength(from: "\(start) - \(end)")
    }
    
    static func calculateShiftLength(from openingHours: String) -> Int {
        let components = openingHours.replacingOccurrences(of: " ", with: "").split(separator: "-")
        guard components.count == 2 else { return 0 }
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        guard let start = formatter.date(from: String(components[0])),
              let end = formatter.date(from: String(components[1])) else { return 0 }
        let calendar = Calendar.current
        let startHour = calendar.component(.hour, from: start)
        var endHour = calendar.component(.hour, from: end)
        if endHour <= startHour {
            endHour += 24
        }
        return endHour - startHour
    }
    
    static let allVenues: [Venue] = [
        Venue(
            name: "The Classic Cocktail Bar",
            description: "A sophisticated bar for classic cocktail lovers.",
            style: .classicCocktail,
            location: "Downtown",
            capacity: 120,
            shiftLengthHours: 10, // default/legacy, not used
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, "4PM", "12AM"),
                (.wednesday, "4PM", "12AM"),
                (.thursday, "4PM", "2AM"),
                (.friday, "4PM", "2AM"),
                (.saturday, "2PM", "2AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Modern Mixology Lab",
            description: "A creative space for modern, experimental cocktails.",
            style: .modernMixology,
            location: "Arts District",
            capacity: 80,
            shiftLengthHours: 8,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, "5PM", "1AM"),
                (.wednesday, "5PM", "1AM"),
                (.thursday, "5PM", "1AM"),
                (.friday, "5PM", "2AM"),
                (.saturday, "3PM", "2AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Hidden Speakeasy",
            description: "A secret, intimate bar with a prohibition-era vibe.",
            style: .speakeasy,
            location: "Old Town",
            capacity: 60,
            shiftLengthHours: 8,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "6PM", "2AM"),
                (.thursday, "6PM", "2AM"),
                (.friday, "6PM", "2AM"),
                (.saturday, "4PM", "2AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "Tropical Paradise",
            description: "A lively tiki bar with tropical drinks and decor.",
            style: .tropical,
            location: "Beachfront",
            capacity: 150,
            shiftLengthHours: 9,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, "3PM", "12AM"),
                (.wednesday, "3PM", "12AM"),
                (.thursday, "3PM", "12AM"),
                (.friday, "3PM", "1AM"),
                (.saturday, "1PM", "1AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Craft Beer House",
            description: "A beer lover's haven with rotating taps and events.",
            style: .craftBeer,
            location: "Brewery District",
            capacity: 200,
            shiftLengthHours: 12,
            shiftPattern: [
                (.monday, "12PM", "10PM"),
                (.tuesday, "12PM", "12AM"),
                (.wednesday, "12PM", "12AM"),
                (.thursday, "12PM", "12AM"),
                (.friday, "12PM", "1AM"),
                (.saturday, "12PM", "1AM"),
                (.sunday, "12PM", "10PM")
            ]
        ),
        Venue(
            name: "Skyline Lounge",
            description: "A rooftop bar with city views and champagne cocktails.",
            style: .skyline,
            location: "Financial District",
            capacity: 100,
            shiftLengthHours: 8,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, "4PM", "12AM"),
                (.wednesday, "4PM", "12AM"),
                (.thursday, "4PM", "12AM"),
                (.friday, "4PM", "1AM"),
                (.saturday, "2PM", "1AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Whiskey Library",
            description: "A refined bar with a vast whiskey collection.",
            style: .whiskey,
            location: "Historic District",
            capacity: 60,
            shiftLengthHours: 8,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, "4PM", "12AM"),
                (.wednesday, "4PM", "12AM"),
                (.thursday, "4PM", "12AM"),
                (.friday, "4PM", "1AM"),
                (.saturday, "2PM", "1AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Wine Cellar",
            description: "A cozy cellar bar specializing in rare wines.",
            style: .wine,
            location: "Historic District",
            capacity: 50,
            shiftLengthHours: 7,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, "4PM", "11PM"),
                (.wednesday, "4PM", "11PM"),
                (.thursday, "4PM", "11PM"),
                (.friday, "4PM", "12AM"),
                (.saturday, "2PM", "12AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Dive Bar",
            description: "A no-frills bar with cheap drinks and character.",
            style: .dive,
            location: "Industrial District",
            capacity: 50,
            shiftLengthHours: 14,
            shiftPattern: [
                (.monday, "2PM", "2AM"),
                (.tuesday, "2PM", "2AM"),
                (.wednesday, "2PM", "2AM"),
                (.thursday, "2PM", "4AM"),
                (.friday, "2PM", "4AM"),
                (.saturday, "12PM", "4AM"),
                (.sunday, nil, nil)
            ]
        )
    ]
    
    static let nameOptions: [VenueStyle: [String]] = [
        .classicCocktail: [
            "The Classic Cocktail Bar",
            "The Golden Age Lounge",
            "The Heritage Bar",
            "The Timeless Tavern",
            "The Vintage Vault",
            "The Traditional Tipple",
            "The Classic Corner",
            "The Heritage House",
            "The Golden Hour",
            "The Timeless Tasting Room"
        ],
        
        .modernMixology: [
            "The Modern Mixology Lab",
            "The Molecular Bar",
            "The Innovation Lounge",
            "The Future of Flavor",
            "The Experimental Elixir",
            "The Creative Cocktail Lab",
            "The Modern Alchemy",
            "The Innovation Station",
            "The Future Bar",
            "The Creative Chemistry"
        ],
        
        .speakeasy: [
            "The Hidden Speakeasy",
            "The Secret Cellar",
            "The Underground Lounge",
            "The Hidden Gem",
            "The Secret Society",
            "The Underground Vault",
            "The Hidden Door",
            "The Secret Passage",
            "The Underground Hideaway",
            "The Hidden Chamber"
        ],
        
        .tropical: [
            "Tropical Paradise",
            "The Island Oasis",
            "The Beachside Bar",
            "The Palm Tree Lounge",
            "The Paradise Cove",
            "The Island Escape",
            "The Beach Club",
            "The Tropical Hideaway",
            "The Island Breeze",
            "The Paradise Point"
        ],
        
        .craftBeer: [
            "The Craft Beer House",
            "The Hop Haven",
            "The Brewmaster's Bar",
            "The Ale House",
            "The Craft Corner",
            "The Hop House",
            "The Brewery Bar",
            "The Ale Alley",
            "The Craft Cellar",
            "The Hop Hideaway"
        ],
        
        .skyline: [
            "Skyline Lounge",
            "The Rooftop Retreat",
            "The Cloud Nine Bar",
            "The Sky High Lounge",
            "The Penthouse Bar",
            "The Aerial Lounge",
            "The Sky Deck",
            "The Cloud Bar",
            "The Sky View",
            "The Rooftop Bar"
        ],
        
        .whiskey: [
            "The Whiskey Library",
            "The Bourbon Bar",
            "The Scotch Selection",
            "The Whiskey Vault",
            "The Bourbon House",
            "The Scotch Corner",
            "The Whiskey Room",
            "The Bourbon Library",
            "The Scotch Cellar",
            "The Whiskey Collection"
        ],
        
        .wine: [
            "The Wine Cellar",
            "The Grape Escape",
            "The Vintage Vault",
            "The Wine Room",
            "The Grape Gallery",
            "The Vintage Cellar",
            "The Wine Library",
            "The Grape House",
            "The Vintage Room",
            "The Wine Gallery"
        ],
        
        .dive: [
            "The Dive Bar",
            "The Local Watering Hole",
            "The Corner Bar",
            "The Neighborhood Pub",
            "The Local Joint",
            "The Corner Pub",
            "The Neighborhood Bar",
            "The Local Spot",
            "The Corner Spot",
            "The Neighborhood Joint"
        ]
    ]
    
    static func getRandomName(for style: VenueStyle) -> String {
        guard let names = nameOptions[style], !names.isEmpty else {
            return "Unknown Venue"
        }
        return names.randomElement() ?? "Unknown Venue"
    }
} 