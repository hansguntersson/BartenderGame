import SwiftUI

struct VenueSelectionView: View {
    @Binding var isShowing: Bool
    let onVenueSelected: () -> Void
    
    @State private var selectedVenue: String?
    @State private var showCustomerView = false
    @State private var showVenueDetails = false
    @State private var selectedVenueForDetails: Venue?
    @Environment(\.presentationMode) var presentationMode
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
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
                    .padding(20)
                    .background(darkBackgroundColor)
                    
                    // Main content area with lighter background
                    VStack(spacing: 0) {
                        // Venue Cards
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(Venue.allVenues, id: \.id) { venue in
                                    VenueCard(
                                        venue: venue,
                                        name: venue.name,
                                        isSelected: selectedVenue == venue.name,
                                        onStartShift: {
                                            selectedVenueForDetails = venue
                                            showVenueDetails = true
                                        }
                                    )
                                }
                            }
                            .padding(15)
                            .frame(maxWidth: 600)
                        }
                    }
                    .background(backgroundColor)
                }
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showCustomerView, onDismiss: {
            selectedVenue = nil
        }) {
            if let actualName = selectedVenue {
                ContentView(venueName: actualName, displayName: actualName)
            }
        }
        .overlay(
            Group {
                if showVenueDetails, let venue = selectedVenueForDetails {
                    VenueDetailsOverlay(
                        venue: venue,
                        isShowing: $showVenueDetails
                    ) {
                        selectedVenue = venue.name
                        showCustomerView = true
                    }
                }
            }
        )
    }
}

struct VenueCard: View {
    let venue: Venue
    let name: String
    let isSelected: Bool
    let onStartShift: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    private func getFontForVenue(_ venueName: String, size: CGFloat = 30) -> Font {
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
        ZStack(alignment: .topLeading) {
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        // Open/Closed indicator
                        let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
                        let todayHours = venue.openingHours(for: today)
                        let isOpen = todayHours != "Closed"
                        
                        Text(name)
                            .font(getFontForVenue(name))
                            .fontWeight(.medium)
                            .foregroundColor(secondaryColor.opacity(isOpen ? 1.0 : 0.4))
                        
                        Text(isOpen ? "Open" : "Closed")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(isOpen ? primaryColor : secondaryColor.opacity(0.4))
                    }
                    
                    Spacer()
                    Button(action: onStartShift) {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(isSelected ? primaryColor.opacity(0.8) : primaryColor)
                    }
                    .padding(.trailing, 5)
                }
            }
        }
        .padding()
        .background(Color.white.opacity({ let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday; let todayHours = venue.openingHours(for: today); let isOpen = todayHours != "Closed"; return isOpen ? 1.0 : 0.4 }()))
        .cornerRadius(10)
    }
}

#Preview {
    VenueSelectionView(isShowing: .constant(true)) {
        // Preview action
    }
} 
