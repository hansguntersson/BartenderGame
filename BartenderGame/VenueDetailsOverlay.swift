import SwiftUI

struct VenueDetailsOverlay: View {
    let venue: Venue
    @Binding var isShowing: Bool
    let onStartShift: () -> Void
    
    @State private var showingDrinksMenu = false
    
    // Track started shifts for each venue and day with date tracking
    @AppStorage("startedShifts") private var startedShiftsString = ""
    @AppStorage("lastShiftDate") private var lastShiftDateString = ""
    
    private var startedShifts: Set<String> {
        Set(startedShiftsString.split(separator: ",").map(String.init))
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func isShiftStarted() -> Bool {
        let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
        let currentDate = getCurrentDateString()
        
        // Check if we're on a new day - if so, clear old shift data
        if lastShiftDateString != currentDate {
            clearOldShiftData()
            return false
        }
        
        let shiftKey = "\(venue.name)_\(today.rawValue)"
        return startedShifts.contains(shiftKey)
    }
    
    private func markShiftAsStarted() {
        let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
        let currentDate = getCurrentDateString()
        let shiftKey = "\(venue.name)_\(today.rawValue)"
        
        var currentShifts = startedShifts
        currentShifts.insert(shiftKey)
        startedShiftsString = currentShifts.joined(separator: ",")
        lastShiftDateString = currentDate
    }
    
    private func clearOldShiftData() {
        // Clear all shift data when it's a new day
        startedShiftsString = ""
        lastShiftDateString = getCurrentDateString()
        
        // Also clear any saved game state for this venue to reset timers and progress
        let keys = [
            "gameSales_\(venue.name)",
            "gameTips_\(venue.name)",
            "gameWastage_\(venue.name)",
            "gameSuccessfulDrinks_\(venue.name)",
            "gameFailedDrinks_\(venue.name)",
            "gameTimeRemaining_\(venue.name)",
            "gameCurrentCustomerIndex_\(venue.name)"
        ]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    private func getFontForVenue(_ venueName: String, size: CGFloat = 28) -> Font {
        switch venueName {
        case "The Bear & Badger":
            return .custom("Copperplate", size: size - 4)  // Traditional, sturdy font for old man pub
        case "Mackenzie's":
            return .custom("Impact", size: size)  // Bold, no-nonsense font for drinks factory
        case "Paradise Cove":
            return .custom("Party LET", size: size + 8)  // Fun, playful font for tropical nonsense
        case "The Mourning Star":
            return .custom("Gothic", size: size)  // Gothic font for goth pub
        case "The Golden Lounge":
            return .custom("Trajan Pro", size: size)  // Elegant, timeless serif for classic hotel bar
        case "Penthouse":
            return .custom("Avenir Next Condensed", size: size)  // Sleek, modern font for champagne elegance
        case "The Secret Society":
            return .custom("American Typewriter", size: size)  // Typewriter style for speakeasy
        case "The Hop House":
            return .custom("Copperplate", size: size)  // Industrial, sturdy font for real ale
        case "The Dram Library":
            return .custom("Didot", size: size)  // Elegant, refined serif for whiskies
        case "The Grape Escape":
            return .custom("Baskerville", size: size)  // Classic, elegant serif for wines
        case "Modern Alchemy":
            return .custom("Optima", size: size)  // Elegant, modern font for pretentious and unique
        default:
            return .system(size: size, weight: .medium, design: .serif)
        }
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowing = false
                }
            
            // Main content card
            VStack(spacing: 0) {
                // Header with venue name and close button
                HStack {
                    Text(venue.name)
                        .font(getFontForVenue(venue.name))
                        .fontWeight(.medium)
                        .foregroundColor(secondaryColor)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "chevron.up.circle.fill")
                            .foregroundColor(secondaryColor)
                            .font(.title)
                    }
                }
                .padding(20)
                
                // Description box
                VStack(alignment: .leading, spacing: 10) {
                    Text(venue.description)
                        .font(.subheadline)
                        .foregroundColor(secondaryColor)
                        .multilineTextAlignment(.leading)
                }
                
                // Opening hours section
                VStack(alignment: .leading, spacing: 0) {
                    Text("Opening Hours")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(secondaryColor)
                        .padding(.horizontal, 20)
                        .padding(.top, 25)
                    Rectangle()
                        .fill(secondaryColor.opacity(0.3))
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        VStack(spacing: 5) {
                            ForEach(Weekday.allCases, id: \.self) { day in
                                HStack {
                                    Text(day.shortName)
                                        .font(.subheadline)
                                        .foregroundColor(secondaryColor)
                                        .frame(width: 80, alignment: .leading)
                                    Spacer()
                                    Text(venue.openingHours(for: day))
                                        .font(.subheadline)
                                        .foregroundColor(venue.openingHours(for: day) == "Closed" ?
                                                         secondaryColor.opacity(0.5) : secondaryColor)
                                        .frame(width: 120, alignment: .trailing)
                                }
                                .padding(.horizontal, 40)
                            }
                        }
                    }
                
                // Today's shift length
                let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
                let todayHours = venue.openingHours(for: today)
                let shiftLength = venue.shiftLengthHours(for: today)
                
                if todayHours != "Closed" {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Today's Shift")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(secondaryColor)
                            .padding(.horizontal, 20)
                            .padding(.top, 25)
                        // Divider
                        Rectangle()
                            .fill(secondaryColor.opacity(0.3))
                            .frame(height: 1)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        VStack(alignment: .leading, spacing: 4) {
                            // Table structure for all shift details
                            HStack {
                                Text("Shift hours:")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 140, alignment: .leading)
                                Spacer()
                                Text(todayHours)
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 100, alignment: .trailing)
                            }
                            HStack {
                                Text("Shift Length:")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 140, alignment: .leading)
                                Spacer()
                                Text("\(shiftLength) hour\(shiftLength == 1 ? "" : "s")")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 100, alignment: .trailing)
                            }
                            HStack {
                                Text("Base Pay:")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 140, alignment: .leading)
                                Spacer()
                                Text("£\(String(format: "%.2f", venue.basePayPerHour))/hour")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 100, alignment: .trailing)
                            }
                            HStack {
                                Text("Minimum Hours:")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 140, alignment: .leading)
                                Spacer()
                                Text("\(venue.minimumHoursPerShift) hours")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 100, alignment: .trailing)
                            }
                            HStack {
                                Text("Minimum Bar Take:")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 140, alignment: .leading)
                                Spacer()
                                Text("£\(String(format: "%.0f", venue.minimumBarTake))")
                                    .font(.subheadline)
                                    .foregroundColor(secondaryColor)
                                    .frame(width: 100, alignment: .trailing)
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                }
                let isVenueOpen = todayHours != "Closed"
                
                HStack{
                    Button(action: {
                        showingDrinksMenu = true
                    }) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Drinks Menu")
                        }
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(secondaryColor)
                        .cornerRadius(8)
                    }
                    Spacer()
                    // Start/Continue Shift button
                        Button(action: {
                            if isVenueOpen {
                                if !isShiftStarted() {
                                    markShiftAsStarted()
                                }
                                isShowing = false
                                onStartShift()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.right")
                                Text(isShiftStarted() ? "Continue" : "Start Shift")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(isVenueOpen ? primaryColor : primaryColor.opacity(0.3))
                            .cornerRadius(8)
                    }
                    .disabled(!isVenueOpen)
                    .opacity(isVenueOpen ? 1.0 : 0.5)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
            .frame(maxWidth: 400)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.3), value: isShowing)
        .fullScreenCover(isPresented: $showingDrinksMenu) {
                            DrinksMenuView(isShowing: $showingDrinksMenu, venueName: venue.name)
        }
    }
}

#Preview {
    VenueDetailsOverlay(
        venue: Venue.allVenues[0],
        isShowing: .constant(true)
    ) {
        // Preview action
    }
} 
