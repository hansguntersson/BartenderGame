import Foundation

enum Weekday: Int, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    var shortName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

struct Venue: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let location: String
    let capacity: Int
    let shiftLengthHours: Int
    let basePayPerHour: Double
    let minimumHoursPerShift: Int
    let minimumBarTake: Double
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
            name: "The Bear & Badger",
            description: "An old man pub with a traditional atmosphere",
            location: "Old Town",
            capacity: 80,
            shiftLengthHours: 12,
            basePayPerHour: 9.00,
            minimumHoursPerShift: 6,
            minimumBarTake: 300.0,
            shiftPattern: [
                (.monday, "11AM", "11PM"),
                (.tuesday, "11AM", "11PM"),
                (.wednesday, "11AM", "11PM"),
                (.thursday, "11AM", "12AM"),
                (.friday, "11AM", "1AM"),
                (.saturday, "10AM", "1AM"),
                (.sunday, "12PM", "10PM")
            ]
        ),
        Venue(
            name: "Mackenzie's",
            description: "A no-frills bar with basic drinks",
            location: "Industrial District",
            capacity: 50,
            shiftLengthHours: 14,
            basePayPerHour: 8.50,
            minimumHoursPerShift: 6,
            minimumBarTake: 200.0,
            shiftPattern: [
                (.monday, "11AM", "2AM"),
                (.tuesday, "11AM", "2AM"),
                (.wednesday, "11AM", "2AM"),
                (.thursday, "11AM", "3AM"),
                (.friday, "11AM", "4AM"),
                (.saturday, "10AM", "4AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "Paradise Cove",
            description: "All your tropical dreams come true",
            location: "Beachfront",
            capacity: 150,
            shiftLengthHours: 9,
            basePayPerHour: 11.00,
            minimumHoursPerShift: 8,
            minimumBarTake: 700.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "2PM", "11PM"),
                (.thursday, "2PM", "12AM"),
                (.friday, "2PM", "2AM"),
                (.saturday, "12PM", "2AM"),
                (.sunday, "12PM", "10PM")
            ]
        ),
        Venue(
            name: "The Mourning Star",
            description: "Themed bar for goths and weirdos",
            location: "Alternative District",
            capacity: 70,
            shiftLengthHours: 8,
            basePayPerHour: 10.00,
            minimumHoursPerShift: 6,
            minimumBarTake: 400.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "6PM", "2AM"),
                (.thursday, "6PM", "2AM"),
                (.friday, "5PM", "3AM"),
                (.saturday, "4PM", "3AM"),
                (.sunday, "5PM", "12AM")
            ]
        ),
        Venue(
            name: "The Golden Lounge",
            description: "Hotel bar with classic cocktails",
            location: "Downtown",
            capacity: 120,
            shiftLengthHours: 10, // default/legacy, not used
            basePayPerHour: 12.00,
            minimumHoursPerShift: 8,
            minimumBarTake: 800.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "5PM", "1AM"),
                (.thursday, "5PM", "2AM"),
                (.friday, "4PM", "2AM"),
                (.saturday, "3PM", "2AM"),
                (.sunday, "4PM", "12AM")
            ]
        ),
        Venue(
            name: "Penthouse",
            description: "Champagne and elegance on the 35th floor",
            location: "Financial District",
            capacity: 100,
            shiftLengthHours: 8,
            basePayPerHour: 16.00,
            minimumHoursPerShift: 8,
            minimumBarTake: 1200.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "5PM", "1AM"),
                (.thursday, "5PM", "1AM"),
                (.friday, "4PM", "2AM"),
                (.saturday, "3PM", "2AM"),
                (.sunday, "4PM", "12AM")
            ]
        ),
        Venue(
            name: "The Secret Society",
            description: "Hidden speakeasy with prohibition era drinks",
            location: "Old Town",
            capacity: 60,
            shiftLengthHours: 8,
            basePayPerHour: 13.00,
            minimumHoursPerShift: 7,
            minimumBarTake: 500.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, nil, nil),
                (.thursday, "7PM", "2AM"),
                (.friday, "7PM", "3AM"),
                (.saturday, "5PM", "3AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Hop House",
            description: "Brewery bar dedicated to real ales",
            location: "Brewery District",
            capacity: 200,
            shiftLengthHours: 12,
            basePayPerHour: 10.50,
            minimumHoursPerShift: 8,
            minimumBarTake: 900.0,
            shiftPattern: [
                (.monday, "11AM", "11PM"),
                (.tuesday, "11AM", "12AM"),
                (.wednesday, "11AM", "12AM"),
                (.thursday, "11AM", "12AM"),
                (.friday, "11AM", "1AM"),
                (.saturday, "10AM", "1AM"),
                (.sunday, nil, nil)
            ]
        ),
        Venue(
            name: "The Dram Library",
            description: "Whisky themed cellar with a big selection",
            location: "Historic District",
            capacity: 60,
            shiftLengthHours: 8,
            basePayPerHour: 15.00,
            minimumHoursPerShift: 8,
            minimumBarTake: 1000.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "6PM", "1AM"),
                (.thursday, "6PM", "1AM"),
                (.friday, "5PM", "2AM"),
                (.saturday, "4PM", "2AM"),
                (.sunday, "5PM", "12AM")
            ]
        ),
        Venue(
            name: "The Grape Escape",
            description: "Wine bar for true connoisseurs",
            location: "Historic District",
            capacity: 50,
            shiftLengthHours: 7,
            basePayPerHour: 14.00,
            minimumHoursPerShift: 6,
            minimumBarTake: 400.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "5PM", "11PM"),
                (.thursday, "5PM", "11PM"),
                (.friday, "4PM", "12AM"),
                (.saturday, "3PM", "12AM"),
                (.sunday, "4PM", "10PM")
            ]
        ),
        Venue(
            name: "Modern Alchemy",
            description: "Mixology studio with innovation as the focus",
            location: "Arts District",
            capacity: 80,
            shiftLengthHours: 8,
            basePayPerHour: 14.50,
            minimumHoursPerShift: 6,
            minimumBarTake: 600.0,
            shiftPattern: [
                (.monday, nil, nil),
                (.tuesday, nil, nil),
                (.wednesday, "6PM", "2AM"),
                (.thursday, "6PM", "2AM"),
                (.friday, "5PM", "3AM"),
                (.saturday, "4PM", "3AM"),
                (.sunday, "5PM", "1AM")
            ]
        )
    ]
} 
