import SwiftUI

struct VenueSelectionView: View {
    @Binding var isShowing: Bool
    let onVenueSelected: () -> Void
    
    @State private var selectedVenue: String?
    @State private var selectedVenueGeneratedName: String?
    @State private var selectedVenueStyle: VenueStyle?
    @State private var showCustomerView = false
    @State private var displayedVenues: [(venue: Venue, generatedName: String)] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var hasLoadedVenues = false
    @AppStorage("selectedVenueNames") private var selectedVenueNames: String = ""
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    private func refreshVenues() {
        // Guarantee 3 different styles
        let shuffledStyles = VenueStyle.allCases.shuffled()
        let venuesByStyle = Dictionary(grouping: Venue.allVenues) { $0.style }
        var selectedVenues: [Venue] = []
        for style in shuffledStyles.prefix(3) {
            if let venuesForStyle = venuesByStyle[style], let randomVenue = venuesForStyle.randomElement() {
                selectedVenues.append(randomVenue)
            }
        }
        // Generate display names and store both unique and display names
        let venuePairs = selectedVenues.shuffled().map { venue in
            (venue: venue, generatedName: Venue.getRandomName(for: venue.style))
        }
        displayedVenues = venuePairs
        // Save to AppStorage as VenueName::DisplayName|VenueName2::DisplayName2|...
        let storageString = venuePairs.map { "\($0.venue.name)::\($0.generatedName)" }.joined(separator: "|")
        selectedVenueNames = storageString
        selectedVenue = nil
        selectedVenueGeneratedName = nil
        selectedVenueStyle = nil
        hasLoadedVenues = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                darkBackgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with title and up button
                    HStack {
                        Text("Select Venue")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            isShowing = false
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "chevron.up.circle.fill")
                                    .foregroundColor(Color.white)
                                    .font(.title)
                                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 1)
                            }
                        }
                    }
                    .padding(15)
                    .background(darkBackgroundColor)
                    
                    // Main content area with lighter background
                    VStack(spacing: 0) {
                        // Venue Cards
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(displayedVenues, id: \ .venue.id) { venueData in
                                    VenueCard(
                                        venue: venueData.venue,
                                        name: venueData.generatedName,
                                        description: venueData.venue.description,
                                        venueStyle: venueData.venue.style,
                                        isSelected: selectedVenue == venueData.venue.name,
                                        onStartShift: {
                                            selectedVenue = venueData.venue.name
                                            selectedVenueGeneratedName = venueData.generatedName
                                            selectedVenueStyle = venueData.venue.style
                                            showCustomerView = true
                                        }
                                    )
                                }
                            }
                            .padding(20)
                            .frame(maxWidth: 600)
                        }
                        
                        Spacer()
                        
                        // Refresh Button
                        Button(action: refreshVenues) {
                            Image(systemName: "arrow.clockwise.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(primaryColor)
                        }
                        .padding(.bottom, 20)
                    }
                    .background(backgroundColor)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                if !hasLoadedVenues {
                    // Try to load from AppStorage first
                    let pairs = selectedVenueNames.split(separator: "|").map { String($0) }
                    let venues: [(venue: Venue, generatedName: String)] = pairs.compactMap { pair in
                        let components = pair.split(separator: "::", maxSplits: 1).map { String($0) }
                        guard components.count == 2,
                              let venue = Venue.allVenues.first(where: { $0.name == components[0] }) else { return nil }
                        return (venue: venue, generatedName: components[1])
                    }
                    if venues.count == 3 {
                        displayedVenues = venues
                        hasLoadedVenues = true
                    } else {
                        refreshVenues()
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showCustomerView, onDismiss: {
            selectedVenue = nil
            selectedVenueGeneratedName = nil
            selectedVenueStyle = nil
        }) {
            if let generatedName = selectedVenueGeneratedName,
               let actualName = selectedVenue,
               let style = selectedVenueStyle {
                if !Venue.allVenues.contains(where: { $0.name == actualName }) {
                    //print("[Warning] selectedVenue (\(actualName)) is not a canonical venue name!")
                }
                ContentView(venueName: actualName, venueStyle: style, displayName: generatedName)
            }
        }
    }
}

struct VenueCard: View {
    let venue: Venue
    let name: String
    let description: String
    let venueStyle: VenueStyle
    let isSelected: Bool
    let onStartShift: () -> Void
    
    @State private var showingDrinksMenu = false
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    private func getFontForVenueStyle(_ style: VenueStyle) -> Font {
        switch style {
        case .classicCocktail:
            return .custom("Trajan Pro", size: 24)  // Elegant, timeless serif font perfect for classic venues
        case .modernMixology:
            return .custom("Optima", size: 24)  // Elegant, modern font that combines serif and sans-serif elements
        case .speakeasy:
            return .custom("American Typewriter", size: 24)  // Typewriter style that evokes prohibition era
        case .tropical:
            return .custom("Party LET", size: 28)  // Fun, playful font that captures tropical vibes
        case .craftBeer:
            return .custom("Copperplate", size: 24)  // Industrial, sturdy font that fits craft beer aesthetic
        case .skyline:
            return .custom("Avenir Next Condensed", size: 24)  // Sleek, modern font that matches urban skyline
        case .whiskey:
            return .custom("Garamond", size: 24)  // Classic, sophisticated serif that fits whiskey's heritage
        case .wine:
            return .custom("Bodoni", size: 24)  // Elegant, refined serif that matches wine's sophistication
        case .dive:
            return .custom("Impact", size: 24)  // Bold, no-nonsense font that fits dive bar character
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                Text(name)
                    .font(getFontForVenueStyle(venueStyle))
                    .fontWeight(.medium)
                    .foregroundColor(secondaryColor)
                    .shadow(color: secondaryColor.opacity(0.3), radius: 1, x: 1, y: 1)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(secondaryColor.opacity(0.8))
                    .fixedSize(horizontal: false, vertical: true)
                
                // Show today's opening hours and shift length on the same line as the menu/arrow, but shift is below hours
                let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
                let hours = venue.openingHours(for: today)
                let shift = venue.shiftLengthHours(for: today)
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Opening hours: \(hours)")
                            .font(.caption)
                            .foregroundColor(secondaryColor.opacity(0.7))
                        if hours != "Closed" {
                            Text("\(shift) hour" + (shift == 1 ? "" : "s") + " shift")
                                .font(.caption)
                                .foregroundColor(secondaryColor.opacity(0.7))
                        }
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 0) {
                        Button(action: {
                            showingDrinksMenu = true
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(secondaryColor)
                                .font(.title2)
                                .frame(height: 32) // Match arrow height for centering
                        }
                        .padding(.trailing, 8)
                        Button(action: onStartShift) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(isSelected ? primaryColor.opacity(0.8) : primaryColor)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .scaleEffect(isSelected ? 1.02 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .fullScreenCover(isPresented: $showingDrinksMenu) {
            DrinksMenuView(isShowing: $showingDrinksMenu, venueStyle: venueStyle)
        }
    }
}

#Preview {
    VenueSelectionView(isShowing: .constant(true)) {
        // Preview action
    }
} 
