import SwiftUI

struct LandingView: View {
    @State private var showVenueSelection = false
    @State private var showInfoOverlay = false
    @State private var showProfile = false
    @State private var currentQuoteIndex = 0
    @State private var opacity = 1.0
    @AppStorage("hasStartedGame") private var hasStartedGame = false
    @AppStorage("gameSales") private var gameSales = 0.0
    @AppStorage("gameTips") private var gameTips = 0.0
    @AppStorage("gameWastage") private var gameWastage = 0.0
    @AppStorage("gameSuccessfulDrinks") private var gameSuccessfulDrinks = 0
    @AppStorage("gameFailedDrinks") private var gameFailedDrinks = 0
    @AppStorage("gameTimeRemaining") private var gameTimeRemaining = 300
    @AppStorage("gameCurrentCustomerIndex") private var gameCurrentCustomerIndex = 0
    
    private let quotes = [
        "You belong behind bars",
        "Cocktails and dreams",
        "Get hammered",
        "Drunks and poets"
    ]
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    private let logoColour = Color(red: 0.28, green: 0.2, blue: 0.08) // Logo grab
    
    var body: some View {
        ZStack {
            VStack {
                // Top navigation bar
                HStack {
                    // Info button on top left
                    Button(action: {
                        showInfoOverlay = true
                    }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(primaryColor)
                                .font(.title)
                    }
                    
                    Spacer()
                    
                    // Profile button on top right
                    Button(action: {
                        showProfile = true
                                          }) {
                          Image(systemName: "person.circle")
                              .foregroundColor(primaryColor)
                              .font(.title)
                      }
                      .onTapGesture {
                          showProfile = true
                      }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // First vertical stack: Title and Subtitle
                VStack(spacing: 0) {
                    Text("Bartender")
                        .font(.custom("Georgia", size: 60).weight(.bold))
                        .foregroundColor(primaryColor)
                    Text(quotes[currentQuoteIndex])
                        .font(.title2)
                        .foregroundColor(logoColour.opacity(0.75))
                        .onAppear {
                            // Display a random tagline every time the view appears
                            currentQuoteIndex = Int.random(in: 0..<quotes.count)
                        }
                }
                .padding(.top, 60)
                .frame(maxWidth: .infinity)
            Spacer()
            VStack(spacing: 0) {
                // Second vertical stack: Logo
                VStack {
                    Image("App_logo_tightly_cropped")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400, height: 340)
                    
                }
                .padding(.bottom, -38)
                
                // Third vertical stack: Button
                VStack {
                    Button(action: {
                        if !hasStartedGame {
                            // Reset game state for new game
                            gameSales = 0.0
                            gameTips = 0.0
                            gameWastage = 0.0
                            gameSuccessfulDrinks = 0
                            gameFailedDrinks = 0
                            gameTimeRemaining = 300
                            gameCurrentCustomerIndex = 0
                            hasStartedGame = true
                        }
                        showVenueSelection = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(primaryColor)
                                .frame(width: 240, height: 60)
                                .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 1)
                            Text("Start Game")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                }
                .padding(.vertical, 70)
                .frame(maxWidth: .infinity)
                .background(logoColour.ignoresSafeArea(edges: .all))
            }
        }
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $showVenueSelection) {
            VenueSelectionView(isShowing: $showVenueSelection) {
                // The VenueSelectionView will handle the transition to ContentView
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            PlayerProfileView(isShowing: $showProfile)
        }
        .overlay(
            Group {
                if showInfoOverlay {
                    InfoOverlay(isShowing: $showInfoOverlay)
                }
            }
        )
    }
}

// Info Overlay
struct InfoOverlay: View {
    @Binding var isShowing: Bool
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
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
                // Header with title and close button
                HStack {
                    Text("About Bartender")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(secondaryColor)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowing = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(secondaryColor.opacity(0.7))
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 15)
                
                // Divider
                Rectangle()
                    .fill(secondaryColor.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                
                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How to Play")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(secondaryColor)
                            
                            Text("• Select a venue to work at\n• Take customer orders and make drinks\n• Use the correct ingredients, glassware, and techniques\n• Earn money through sales and tips\n• Meet venue minimums to succeed")
                                .font(.subheadline)
                                .foregroundColor(secondaryColor.opacity(0.8))
                                .lineSpacing(4)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Game Features")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(secondaryColor)
                            
                            Text("• 9 unique venues with different styles\n• Realistic cocktail recipes\n• Dynamic customer system\n• Progress tracking and statistics\n• Multiple difficulty levels")
                                .font(.subheadline)
                                .foregroundColor(secondaryColor.opacity(0.8))
                                .lineSpacing(4)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tips for Success")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(secondaryColor)
                            
                            Text("• Pay attention to customer preferences\n• Use high-quality ingredients for better tips\n• Manage your time efficiently\n• Learn from mistakes and improve\n• Build your reputation at each venue")
                                .font(.subheadline)
                                .foregroundColor(secondaryColor.opacity(0.8))
                                .lineSpacing(4)
                        }
                    }
                    .padding(20)
                }
            }
            .frame(maxWidth: 400)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 20)
        }
        .transition(.opacity.combined(with: .scale))
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}
