import SwiftUI

struct LivingSituation: Identifiable {
    let id = UUID()
    let name: String
    let dailyCost: Double
    let oneOffCost: Double
    let description: String
}

struct Transport: Identifiable {
    let id = UUID()
    let name: String
    let purchaseCost: Double
    let perShiftCost: Double
    let description: String
}

struct PlayerProfileView: View {
    @Binding var isShowing: Bool
    
    // Player data - in a real app these would be stored in UserDefaults or a database
    @AppStorage("playerUsername") private var username = "Hans Guntersson"
    @AppStorage("playerMoney") private var currentMoney = 100.0
    @AppStorage("playerLivingSituation") private var livingSituation = "Living with Parents"
    @AppStorage("playerEquipment") private var equipmentString = "Basic Shaker,Strainer,Jigger"
    @AppStorage("playerClothing") private var clothingString = "White Shirt,Black Trousers,Apron"
    @AppStorage("playerTransport") private var transport = "Walking"
    
    // Track purchased options
    @AppStorage("purchasedLivingSituations") private var purchasedLivingSituationsString = "Living with Parents"
    @AppStorage("purchasedTransportOptions") private var purchasedTransportOptionsString = "Walking"
    
    // Reset confirmation state
    @State private var showResetConfirmation = false
    @State private var showLivingSituationSheet = false
    @State private var showTransportSheet = false
    
    // Purchase confirmation state
    @State private var showPurchaseConfirmation = false
    @State private var pendingPurchase: (type: String, name: String, cost: Double)?
    
    // Living situation options
    private let livingSituations = [
        LivingSituation(name: "Living with Parents", dailyCost: 0.0, oneOffCost: 0.0, description: "Staying with family at home"),
        LivingSituation(name: "Shared Flat", dailyCost: 15.0, oneOffCost: 100.0, description: "Shared accommodation with other people"),
        LivingSituation(name: "Studio Flat", dailyCost: 25.0, oneOffCost: 1000.0, description: "Small self-contained apartment"),
        LivingSituation(name: "One Bedroom Flat", dailyCost: 35.0, oneOffCost: 1500.0, description: "Comfortable single bedroom apartment"),
        LivingSituation(name: "Two Bedroom Flat", dailyCost: 45.0, oneOffCost: 2000.0, description: "Spacious two bedroom apartment"),
        LivingSituation(name: "House Share", dailyCost: 20.0, oneOffCost: 300.0, description: "Sharing a house with housemates"),
        LivingSituation(name: "Luxury Apartment", dailyCost: 60.0, oneOffCost: 5000.0, description: "High-end apartment with amenities")
    ]
    
    // Transport options
    private let transportOptions = [
        Transport(name: "Walking", purchaseCost: 0.0, perShiftCost: 0.0, description: "Walking to work"),
        Transport(name: "Bus", purchaseCost: 0.0, perShiftCost: 3.0, description: "Public bus transport"),
        Transport(name: "Bike", purchaseCost: 100.0, perShiftCost: 0.5, description: "Bicycle for commuting"),
        Transport(name: "Scooter", purchaseCost: 800.0, perShiftCost: 1.0, description: "Motor scooter"),
        Transport(name: "Car", purchaseCost: 3000.0, perShiftCost: 5.0, description: "Personal vehicle"),
        Transport(name: "Luxury Car", purchaseCost: 15000.0, perShiftCost: 8.0, description: "High-end vehicle")
    ]
    
    // Computed property to get current living situation object
    private var currentLivingSituation: LivingSituation {
        livingSituations.first { $0.name == livingSituation } ?? livingSituations[0] // Default to Living with Parents
    }
    
    // Computed property to get current transport object
    private var currentTransport: Transport {
        transportOptions.first { $0.name == transport } ?? transportOptions[0] // Default to Walking
    }
    
    // Computed properties for purchased options
    private var purchasedLivingSituations: [String] {
        purchasedLivingSituationsString.split(separator: ",").map(String.init)
    }
    
    private var purchasedTransportOptions: [String] {
        purchasedTransportOptionsString.split(separator: ",").map(String.init)
    }
    
    // Migration function to update old values
    private func migrateOldValues() {
        // Migrate "Homeless" to "Living with Parents"
        if livingSituation == "Homeless" {
            livingSituation = "Living with Parents"
        }
    }
    
    // Computed properties to convert strings to arrays
    private var equipment: [String] {
        equipmentString.split(separator: ",").map(String.init)
    }
    
    private var clothing: [String] {
        clothingString.split(separator: ",").map(String.init)
    }
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Profile")
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
                    
                    // Main content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Profile Image and Money Section
                            HStack(spacing: 20) {
                                    // Profile Image
                                    ZStack {
                                        Circle()
                                            .fill(primaryColor.opacity(0.2))
                                            .frame(width: 120, height: 120)
                                        
                                        Image(systemName: "person.circle.fill")
                                            .font(.system(size: 80))
                                            .foregroundColor(primaryColor)
                                    }.frame(width: 140)
                            VStack() {
                                // Username and Current Money
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(username)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(secondaryColor)
                                    Spacer()
                                    Text("£\(String(format: "%.2f", currentMoney))")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(primaryColor)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    }
                                }
                            }.padding(20)
                            
                            // Living Situation
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Living Situation")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(secondaryColor)
                                
                                Button(action: {
                                    showLivingSituationSheet = true
                                }) {
                                    HStack {
                                        Image(systemName: "house.fill")
                                            .foregroundColor(primaryColor)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(livingSituation)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(secondaryColor)
                                            HStack(spacing: 8) {
                                                let isPurchased = purchasedLivingSituations.contains(livingSituation)
                                                let displayCost = isPurchased ? 0.0 : currentLivingSituation.oneOffCost
                                                Text("£\(String(format: "%.0f", displayCost)) one-off")
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor.opacity(0.7))
                                                Text("£\(String(format: "%.2f", currentLivingSituation.dailyCost))/day")
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor.opacity(0.7))
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(secondaryColor.opacity(0.5))
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            
                            // Transport
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Transport")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(secondaryColor)
                                
                                Button(action: {
                                    showTransportSheet = true
                                }) {
                                    HStack {
                                        Image(systemName: "car.fill")
                                            .foregroundColor(primaryColor)
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(transport)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(secondaryColor)
                                            HStack(spacing: 8) {
                                                let isPurchased = purchasedTransportOptions.contains(transport)
                                                let displayCost = isPurchased ? 0.0 : currentTransport.purchaseCost
                                                Text("£\(String(format: "%.0f", displayCost)) one-off")
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor.opacity(0.7))
                                                Text("£\(String(format: "%.2f", currentTransport.perShiftCost))/shift")
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor.opacity(0.7))
                                            }
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(secondaryColor.opacity(0.5))
                                            .font(.caption)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 20)
                            
                            // Equipment
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Equipment")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(secondaryColor)
                                
                                VStack(spacing: 8) {
                                    ForEach(equipment, id: \.self) { item in
                                        HStack {
                                            Image(systemName: "wrench.and.screwdriver.fill")
                                                .foregroundColor(primaryColor)
                                            Text(item)
                                                .font(.subheadline)
                                                .foregroundColor(secondaryColor)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            .padding(.horizontal, 20)
                            
                            // Clothing
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Clothing")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(secondaryColor)
                                
                                VStack(spacing: 8) {
                                    ForEach(clothing, id: \.self) { item in
                                        HStack {
                                            Image(systemName: "tshirt.fill")
                                                .foregroundColor(primaryColor)
                                            Text(item)
                                                .font(.subheadline)
                                                .foregroundColor(secondaryColor)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(8)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            .padding(.horizontal, 20)
                            
                            // Reset Progress Button
                            VStack(spacing: 8) {
                                Button(action: {
                                    showResetConfirmation = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.white)
                                        Text("Reset All Progress")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 2)
                                }
                                .padding(.horizontal, 20)
                                
                                Text("This will reset all money, shift progress, and game data")
                                    .font(.caption)
                                    .foregroundColor(secondaryColor.opacity(0.7))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                            }
                            
                            // Bottom padding
                            .padding(.bottom, 20)
                        }
                        .frame(maxWidth: 600)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            migrateOldValues()
            // Check for daily transition when profile is viewed
            DailyTransitionManager.shared.checkAndProcessDailyTransition()
        }
        .alert("Reset All Progress?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllProgress()
            }
        } message: {
            Text("This will permanently delete all your money, shift progress, and game data. This action cannot be undone.")
        }
        .sheet(isPresented: $showLivingSituationSheet) {
            LivingSituationSelectionView(
                isShowing: $showLivingSituationSheet,
                currentSituation: livingSituation,
                currentMoney: currentMoney,
                livingSituations: livingSituations,
                purchasedSituations: purchasedLivingSituations,
                onSelection: { newSituation in
                    handleLivingSituationSelection(newSituation)
                }
            )
        }
        .sheet(isPresented: $showTransportSheet) {
            TransportSelectionView(
                isShowing: $showTransportSheet,
                currentTransport: transport,
                currentMoney: currentMoney,
                transportOptions: transportOptions,
                purchasedOptions: purchasedTransportOptions,
                onSelection: { newTransport in
                    handleTransportSelection(newTransport)
                }
            )
        }
        .alert("Confirm Purchase", isPresented: $showPurchaseConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Purchase", role: .destructive) {
                confirmPurchase()
            }
        } message: {
            if let purchase = pendingPurchase {
                Text("Purchase \(purchase.name) for £\(String(format: "%.0f", purchase.cost))?")
            } else {
                Text("Confirm purchase?")
            }
        }
    }
    
    private func handleLivingSituationSelection(_ newSituation: String) {
        let newSituationObj = livingSituations.first { $0.name == newSituation } ?? livingSituations[0]
        let isAlreadyPurchased = purchasedLivingSituations.contains(newSituation)
        
        // If already purchased or free, select immediately
        if isAlreadyPurchased || newSituationObj.oneOffCost == 0 {
            livingSituation = newSituation
        } else {
            // Show purchase confirmation
            pendingPurchase = ("accommodation", newSituation, newSituationObj.oneOffCost)
            showPurchaseConfirmation = true
        }
    }
    
    private func handleTransportSelection(_ newTransport: String) {
        let newTransportObj = transportOptions.first { $0.name == newTransport } ?? transportOptions[0]
        let isAlreadyPurchased = purchasedTransportOptions.contains(newTransport)
        
        // If already purchased or free, select immediately
        if isAlreadyPurchased || newTransportObj.purchaseCost == 0 {
            transport = newTransport
        } else {
            // Show purchase confirmation
            pendingPurchase = ("transport", newTransport, newTransportObj.purchaseCost)
            showPurchaseConfirmation = true
        }
    }
    
    private func confirmPurchase() {
        guard let purchase = pendingPurchase else { return }
        
        if purchase.type == "accommodation" {
            selectLivingSituation(purchase.name)
        } else if purchase.type == "transport" {
            selectTransport(purchase.name)
        }
        
        pendingPurchase = nil
    }
    
    private func selectLivingSituation(_ newSituation: String) {
        let newSituationObj = livingSituations.first { $0.name == newSituation } ?? livingSituations[0]
        let isAlreadyPurchased = purchasedLivingSituations.contains(newSituation)
        
        // Only deduct money if not already purchased
        if !isAlreadyPurchased && newSituationObj.oneOffCost > 0 {
            currentMoney -= newSituationObj.oneOffCost
            
            // Add to purchased list
            var updatedPurchased = purchasedLivingSituations
            if !updatedPurchased.contains(newSituation) {
                updatedPurchased.append(newSituation)
                purchasedLivingSituationsString = updatedPurchased.joined(separator: ",")
            }
        }
        
        livingSituation = newSituation
    }
    
    private func selectTransport(_ newTransport: String) {
        let newTransportObj = transportOptions.first { $0.name == newTransport } ?? transportOptions[0]
        let isAlreadyPurchased = purchasedTransportOptions.contains(newTransport)
        
        // Only deduct money if not already purchased
        if !isAlreadyPurchased && newTransportObj.purchaseCost > 0 {
            currentMoney -= newTransportObj.purchaseCost
            
            // Add to purchased list
            var updatedPurchased = purchasedTransportOptions
            if !updatedPurchased.contains(newTransport) {
                updatedPurchased.append(newTransport)
                purchasedTransportOptionsString = updatedPurchased.joined(separator: ",")
            }
        }
        
        transport = newTransport
    }
    
    private func resetAllProgress() {
        // Reset player money to starting amount
        currentMoney = 100.0
        
        // Reset transport to default
        transport = "Walking"
        
        // Reset purchased options
        purchasedLivingSituationsString = "Living with Parents"
        purchasedTransportOptionsString = "Walking"
        
        // Clear all venue-specific game data
        for venue in Venue.allVenues {
            let venueName = venue.name
            let keys = [
                "gameSales_\(venueName)",
                "gameTips_\(venueName)",
                "gameWastage_\(venueName)",
                "gameSuccessfulDrinks_\(venueName)",
                "gameFailedDrinks_\(venueName)",
                "gameTimeRemaining_\(venueName)",
                "gameCurrentCustomerIndex_\(venueName)",
                "lastGameDate_\(venueName)"
            ]
            
            for key in keys {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        
        // Clear all customer screen time data
        let todayString = getCurrentDateString()
        for venue in Venue.allVenues {
            let key = "customerScreenTime_\(venue.name)_\(todayString)"
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        // Clear shift tracking data
        UserDefaults.standard.removeObject(forKey: "startedShifts")
        UserDefaults.standard.removeObject(forKey: "lastShiftDate")
        
        // Force UserDefaults to save
        UserDefaults.standard.synchronize()
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

struct LivingSituationSelectionView: View {
    @Binding var isShowing: Bool
    let currentSituation: String
    let currentMoney: Double
    let livingSituations: [LivingSituation]
    let purchasedSituations: [String]
    let onSelection: (String) -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Choose Living Situation")
                            .font(.system(size: 28, weight: .bold, design: .serif))
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
                    
                    // Living situation options
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(livingSituations) { situation in
                                LivingSituationCard(
                                    situation: situation,
                                    currentMoney: currentMoney,
                                    isSelected: situation.name == currentSituation,
                                    isPurchased: purchasedSituations.contains(situation.name),
                                    onTap: {
                                        onSelection(situation.name)
                                        isShowing = false
                                    }
                                )
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: 600)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct LivingSituationCard: View {
    let situation: LivingSituation
    let currentMoney: Double
    let isSelected: Bool
    let isPurchased: Bool
    let onTap: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    var body: some View {
        let effectiveCost = isPurchased ? 0.0 : situation.oneOffCost
        let canAfford = currentMoney >= effectiveCost
        
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(situation.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(canAfford ? secondaryColor : secondaryColor.opacity(0.4))
                    
                    Text(situation.description)
                        .font(.subheadline)
                        .foregroundColor(canAfford ? secondaryColor.opacity(0.7) : secondaryColor.opacity(0.3))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("£\(String(format: "%.0f", effectiveCost))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(canAfford ? primaryColor : Color.red.opacity(0.6))
                    
                    Text("£\(String(format: "%.2f", situation.dailyCost))/day")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(canAfford ? secondaryColor : secondaryColor.opacity(0.4))
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(primaryColor)
                        .font(.title2)
                }
            }
            .padding()
            .background(canAfford ? Color.white : Color.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(canAfford ? 0.1 : 0.05), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!canAfford)
    }
}

struct TransportSelectionView: View {
    @Binding var isShowing: Bool
    let currentTransport: String
    let currentMoney: Double
    let transportOptions: [Transport]
    let purchasedOptions: [String]
    let onSelection: (String) -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Choose Transport")
                            .font(.system(size: 28, weight: .bold, design: .serif))
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
                    
                    // Transport options
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(transportOptions) { transport in
                                TransportCard(
                                    transport: transport,
                                    currentMoney: currentMoney,
                                    isSelected: transport.name == currentTransport,
                                    isPurchased: purchasedOptions.contains(transport.name),
                                    onTap: {
                                        onSelection(transport.name)
                                        isShowing = false
                                    }
                                )
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: 600)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct TransportCard: View {
    let transport: Transport
    let currentMoney: Double
    let isSelected: Bool
    let isPurchased: Bool
    let onTap: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    var body: some View {
        let effectiveCost = isPurchased ? 0.0 : transport.purchaseCost
        let canAfford = currentMoney >= effectiveCost
        
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(transport.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(canAfford ? secondaryColor : secondaryColor.opacity(0.4))
                    
                    Text(transport.description)
                        .font(.subheadline)
                        .foregroundColor(canAfford ? secondaryColor.opacity(0.7) : secondaryColor.opacity(0.3))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("£\(String(format: "%.0f", effectiveCost))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(canAfford ? primaryColor : Color.red.opacity(0.6))
                    
                    Text("one-off")
                        .font(.caption)
                        .foregroundColor(canAfford ? secondaryColor.opacity(0.6) : secondaryColor.opacity(0.3))
                    
                    Text("£\(String(format: "%.2f", transport.perShiftCost))/shift")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(canAfford ? secondaryColor : secondaryColor.opacity(0.4))
                }
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(primaryColor)
                        .font(.title2)
                }
            }
            .padding()
            .background(canAfford ? Color.white : Color.white.opacity(0.5))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(canAfford ? 0.1 : 0.05), radius: 3, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!canAfford)
    }
}

#Preview {
    PlayerProfileView(isShowing: .constant(true))
} 
