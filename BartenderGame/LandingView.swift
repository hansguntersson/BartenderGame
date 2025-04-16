import SwiftUI

struct LandingView: View {
    @State private var showVenueSelection = false
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
        "Master the art of mixology",
        "Cocktails and dreams",
        "Mixologists welcome",
        "Serve it up",
        "Get behind bars",
        "Drunks and poets"
    ]
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()

                // Logo and Title/Subitle stacked tightly, even overlapping
                ZStack(alignment: .top) {
                    VStack(spacing: 0) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 320, height: 320)
                            .padding(.bottom, -40) // negative padding for overlap
                        VStack(spacing: 8) {
                Text("Bartender")
                    .font(.custom("Georgia", size: 60).weight(.bold))
                                .foregroundColor(Color.white.opacity(0.95))
                                .shadow(color: Color.black.opacity(0.25), radius: 2, x: 0, y: 2)
                Text(quotes[currentQuoteIndex])
                    .font(.title2)
                                .foregroundColor(Color.white.opacity(0.75))
                    .onAppear {
                        // Display a random tagline every time the view appears
                        currentQuoteIndex = Int.random(in: 0..<quotes.count)
                    }
                        }
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(darkBackgroundColor.ignoresSafeArea(edges: .horizontal))
                        .padding(.top, 2)
                        .padding(.bottom, 24)
                    }
                }
                .padding(.top, 48)

                Spacer()

                VStack {
                // Start/Continue Game Button
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
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 240, height: 60)
                        .background(primaryColor)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                }
                }
                .padding()
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showVenueSelection) {
            VenueSelectionView(isShowing: $showVenueSelection) {
                // The VenueSelectionView will handle the transition to ContentView
            }
        }
    }
} 
