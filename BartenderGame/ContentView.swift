//
//  ContentView.swift
//  BartenderGame
//
//  Created by Daniel Harlos on 16/04/2025.
//

import SwiftUI
import SwiftData

// Add extension at the top of the file, after imports
extension Array {
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < count else { return nil }
        return self[index]
    }
}

// Add enum after the Array extension
enum SwipeDirection {
    case left
    case right
}

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Environment(\.presentationMode) var presentationMode
    
    @State private var currentCustomerIndex: Int
    @State private var showingDrinkMaker = false
    @State private var orderText = ""
    @State private var slideOffset: CGFloat = 0
    @State private var isShowingFeedback = false
    @State private var successfulDrinks: Int
    @State private var failedDrinks: Int
    
    @State private var showingPreparationView = false
    @State private var showingDrinksMenu = false
    @State private var showingShiftSummary = false
    
    // Timer states
    @State private var timeRemaining: Int
    @State private var timer: Timer?
    
    // Metrics
    @State private var sales: Double
    @State private var tips: Double
    @State private var wastage: Double
    @State private var mood = "😊"
    
    @State private var showMoneyPopover = false
    
    // Sales popup states
    @State private var showSalesPopup = false
    @State private var lastSaleAmount: Double = 0.0
    @State private var lastTipAmount: Double = 0.0
    @State private var salesPopupOffset: CGFloat = -100
    
    @State private var sessionStartTime: Date? = nil
    @State private var totalElapsedTime: Int = 0 // in seconds
    @State private var showMinimumHoursAlert: Bool = false
    
    // --- Add new state for in-game session time ---
    @State private var sessionInGameSeconds: Int = 0
    @State private var clockTimer: Timer? = nil
    @State private var persistedInGameSeconds: Int = 0
    
    // Customer generation timer
    @State private var customerGenerationTimer: Timer? = nil
    @State private var lastCustomerGenerationTime: Date = Date()
    
    // Add state for venue mood and timer
    @State private var venueMood: Int = 3
    @State private var venueMoodTimer: Timer? = nil
    
    // Customer patience timers
    @State private var customerPatienceTimers: [UUID: Timer] = [:]
    
    let venueName: String
    let displayName: String
    
    // Define consistent colors for 70's modernist palette
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let accentColor = Color(red: 0.9, green: 0.7, blue: 0.2)  // Mustard Yellow
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    // Add the dark background color used in VenueSelectionView
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    // Positive feedback responses for successful drinks
    private static let positiveFeedbackResponses = [
        "Perfect! Just what I wanted!",
        "Spot on! This is exactly right!",
        "You nailed it!",
        "Delicious! Thank you!",
        "That's just how I like it!",
        "Amazing! Couldn't be better!",
        "Wow, you really know your stuff!",
        "This is fantastic!",
        "You make the best drinks!",
        "Absolutely perfect!"
    ]
    
    init(venueName: String,
         displayName: String,
         initialSales: Double = 0.0,
         initialTips: Double = 0.0,
         initialWastage: Double = 0.0,
         initialSuccessfulDrinks: Int = 0,
         initialFailedDrinks: Int = 0,
         initialTimeRemaining: Int? = nil,
         initialCustomerIndex: Int = 0) {
        
        self.venueName = venueName
        self.displayName = displayName
        
        // Check if we're on a new day - if so, reset all game state
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: Date())
        let lastGameDate = UserDefaults.standard.string(forKey: "lastGameDate_\(venueName)") ?? ""
        
        let shouldResetForNewDay = currentDate != lastGameDate
        
        if shouldResetForNewDay {
            // It's a new day, clear all saved game state
            let keys = [
                "gameSales_\(venueName)",
                "gameTips_\(venueName)",
                "gameWastage_\(venueName)",
                "gameSuccessfulDrinks_\(venueName)",
                "gameFailedDrinks_\(venueName)",
                "gameTimeRemaining_\(venueName)",
                "gameCurrentCustomerIndex_\(venueName)"
            ]
            for key in keys {
                UserDefaults.standard.removeObject(forKey: key)
            }
            UserDefaults.standard.set(currentDate, forKey: "lastGameDate_\(venueName)")
        }
        
        // Load saved state for this venue if it exists, otherwise use defaults
        let savedSales = UserDefaults.standard.object(forKey: "gameSales_\(venueName)") as? Double ?? initialSales
        let savedTips = UserDefaults.standard.object(forKey: "gameTips_\(venueName)") as? Double ?? initialTips
        let savedWastage = UserDefaults.standard.object(forKey: "gameWastage_\(venueName)") as? Double ?? initialWastage
        let savedSuccessfulDrinks = UserDefaults.standard.object(forKey: "gameSuccessfulDrinks_\(venueName)") as? Int ?? initialSuccessfulDrinks
        let savedFailedDrinks = UserDefaults.standard.object(forKey: "gameFailedDrinks_\(venueName)") as? Int ?? initialFailedDrinks
        
        // Calculate time based on shift length for today if not provided
        let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
        let venue = Venue.allVenues.first(where: { $0.name == venueName })
        let shiftLength = venue?.shiftLengthHours(for: today) ?? 8
        let defaultTime = shiftLength * 60
        let savedTimeRemaining = initialTimeRemaining ?? defaultTime
        let savedCurrentCustomerIndex = UserDefaults.standard.object(forKey: "gameCurrentCustomerIndex_\(venueName)") as? Int ?? initialCustomerIndex
        
        // Load persisted time for clock immediately
        let todayString = formatter.string(from: Date())
        let timeKey = "customerScreenTime_\(venueName)_\(todayString)"
        let savedPersistedTime = UserDefaults.standard.integer(forKey: timeKey)
        
        _sales = State(initialValue: savedSales)
        _tips = State(initialValue: savedTips)
        _wastage = State(initialValue: savedWastage)
        _successfulDrinks = State(initialValue: savedSuccessfulDrinks)
        _failedDrinks = State(initialValue: savedFailedDrinks)
        _timeRemaining = State(initialValue: savedTimeRemaining)
        _currentCustomerIndex = State(initialValue: savedCurrentCustomerIndex)
        
        // Initialize clock-related state
        _persistedInGameSeconds = State(initialValue: savedPersistedTime)
        _sessionInGameSeconds = State(initialValue: 0)
        
        // Set the current venue for customer generation
        Customer.currentVenue = venueName
        Customer.initializeActiveCustomers()
        
        // Start with 2-3 initial customers
        if Customer.activeCustomers.isEmpty {
            Customer.generateInitialCustomers()
        }
    }
    
    private var currentCustomer: Customer {
        guard !Customer.activeCustomers.isEmpty else {
            Customer.initializeActiveCustomers()
            return Customer.activeCustomers[0]
        }
        return Customer.activeCustomers[min(currentCustomerIndex, Customer.activeCustomers.count - 1)]
    }
    
    private var canSwipeLeft: Bool {
        guard !Customer.activeCustomers.isEmpty else { return false }
        return currentCustomerIndex < Customer.activeCustomers.count - 1
    }
    
    private var canSwipeRight: Bool {
        guard !Customer.activeCustomers.isEmpty else { return false }
        return currentCustomerIndex > 0
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(displayName)
                    .font(getFontForVenue(venueName, size: 38))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
        }
        .padding(10)
        .background(darkBackgroundColor)
    }
    
    // --- Update timerBar to use the new ticking logic ---
    private var timerBar: some View {
        let venue = Venue.allVenues.first(where: { $0.name == venueName })
        let today = Weekday(rawValue: Calendar.current.component(.weekday, from: Date())) ?? .monday
        let parseFormatter = DateFormatter()
        parseFormatter.dateFormat = "ha"
        parseFormatter.locale = Locale(identifier: "en_US_POSIX")
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "h:mma"
        displayFormatter.amSymbol = "am"
        displayFormatter.pmSymbol = "pm"
        return HStack {
            if let venue = venue {
                let hours = venue.openingHours(for: today)
                Text("Opening hours: \(hours)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            if let venue = venue {
                if let pattern = venue.shiftPattern.first(where: { $0.day == today }),
                   let startString = pattern.start, pattern.end != nil {
                    if let startDate = parseFormatter.date(from: startString) {
                        let totalInGameSeconds = persistedInGameSeconds + sessionInGameSeconds
                        let totalInGameMinutes = totalInGameSeconds // 1 real second = 1 in-game minute
                        let displayDate = startDate.addingTimeInterval(TimeInterval(totalInGameMinutes * 60)) // Convert minutes to seconds
                        Text(displayFormatter.string(from: displayDate).lowercased())
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .onAppear {
                            }
                    } else {
                        Text("-")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                } else {
                    Text("Closed")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
            } else {
                Text("-")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .padding(.bottom, 8)
        .background(darkBackgroundColor)
    }
    
    private var customerView: some View {
        VStack(spacing: 0) {
            // Avatar and order
            VStack(spacing: 15) {
                if let currentCustomer = Customer.activeCustomers[safe: currentCustomerIndex] {
                    Image("avatar\(currentCustomer.avatarNumber)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .offset(x: slideOffset)
                    
                    Text(orderText.isEmpty ? "\"\(currentCustomer.orderPhrase)\"" : orderText)
                        .font(.title2)
                        .italic()
                        .foregroundColor(secondaryColor)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(backgroundColor)
                        .offset(x: slideOffset)
                }
            }
            .frame(height: 400)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        let threshold: CGFloat = 50
                        if gesture.translation.width > threshold && canSwipeRight {
                            handleSwipe(direction: .right)
                        } else if gesture.translation.width < -threshold && canSwipeLeft {
                            handleSwipe(direction: .left)
                        }
                    }
            )
            
            // Navigation buttons
            HStack(spacing: 24) {
                Button(action: {
                    if canSwipeRight {
                        handleSwipe(direction: .right)
                    }
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .foregroundColor(canSwipeRight ? secondaryColor : secondaryColor.opacity(0.3))
                        .font(.system(size: 44))
                }
                .disabled(!canSwipeRight)
                
                // Mood emoticon
                if let currentCustomer = Customer.activeCustomers[safe: currentCustomerIndex] {
                    Text(moodEmoticon(for: currentCustomer.mood))
                        .font(.system(size: 44))
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                }
                
                Button(action: {
                    if canSwipeLeft {
                        handleSwipe(direction: .left)
                    }
                }) {
                    Image(systemName: "chevron.right.circle.fill")
                        .foregroundColor(canSwipeLeft ? secondaryColor : secondaryColor.opacity(0.3))
                        .font(.system(size: 44))
                }
                .disabled(!canSwipeLeft)
            }
            Spacer()
        }
    }
    
    private var makeDrinkButton: some View {
        Button(action: {
            withAnimation {
                showingPreparationView = true
            }
        }) {
            Text("Make Drink")
                .font(.title2)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(primaryColor)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 0) {
                    headerView
                    timerBar
                }
                Spacer().frame(height: 40)
                customerView
                Spacer()
                HStack {
                    Button(action: {
                        showMoneyPopover.toggle()
                    }) {
                        Text("£")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(secondaryColor)
                    }
                    .sheet(isPresented: $showMoneyPopover) {
                        MoneyPopoverView(sales: sales, tips: tips, wastage: wastage, venueName: venueName)
                            .presentationDetents([.fraction(0.5)])
                    }
                    .overlay(
                        // Sales popup
                        Group {
                            if showSalesPopup {
                                HStack(spacing: 16) {
                                    VStack(spacing: 2) {
                                        Text("Sale")
                                            .font(.caption2)
                                            .foregroundColor(secondaryColor.opacity(0.7))
                                        Text(String(format: "£%.2f", lastSaleAmount))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(secondaryColor)
                                    }
                                    VStack(spacing: 2) {
                                        Text("Tip")
                                            .font(.caption2)
                                            .foregroundColor(secondaryColor.opacity(0.7))
                                        Text(String(format: "£%.2f", lastTipAmount))
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(accentColor)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .frame(width: 140, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.white)
                                )
                                .offset(y: showSalesPopup ? 0 : 20)
                                .opacity(showSalesPopup ? 1 : 0)
                                .scaleEffect(showSalesPopup ? 1.1 : 0.9)
                                .animation(.easeInOut(duration: 0.3), value: showSalesPopup)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .bottom).combined(with: .opacity)
                                ))
                                .offset(x: 50, y: -10)
                            }
                        }
                        , alignment: .leading
                    )
                    Spacer()
                    Button(action: {
                        showingDrinksMenu = true
                    }) {
                        Image(systemName: "list.bullet")
                            .foregroundColor(secondaryColor)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
                makeDrinkButton
            }
        }
        .fullScreenCover(isPresented: $showingPreparationView) {
            if let currentCustomer = Customer.activeCustomers[safe: currentCustomerIndex],
               let drink = Drink.allDrinks.first(where: { $0.name == currentCustomer.drinkOrder }) {
                let customerIndex = currentCustomerIndex
                PreparationView(
                    drink: drink,
                    isShowing: $showingPreparationView,
                    customer: Binding(
                        get: { Customer.activeCustomers[customerIndex] },
                        set: { Customer.activeCustomers[customerIndex] = $0 }
                    ),
                    currentCustomerIndex: $currentCustomerIndex,
                    onContinue: { glassware, ice, method, isCorrect, tipMultiplier in
                        if isCorrect {
                            // Stop patience timer for this customer
                            let currentCustomer = Customer.activeCustomers[currentCustomerIndex]
                            stopPatienceTimer(for: currentCustomer)
                            
                            // Show positive feedback from current customer
                            orderText = "\"" + getRandomPositiveFeedback() + "\""
                            successfulDrinks += 1
                            
                            // Add to sales
                            let drinkPrice = getDrinkPrice(for: currentCustomer.drinkOrder)
                            sales = (sales + drinkPrice).rounded(to: 2)
                            
                            // Add tip based on glass quality (tipMultiplier affects the percentage)
                            let tip: Double
                            switch currentCustomer.mood {
                            case 5:
                                tip = (drinkPrice * Double.random(in: 0.20...0.25) * tipMultiplier).rounded(to: 2)
                            case 4:
                                tip = (drinkPrice * Double.random(in: 0.15...0.20) * tipMultiplier).rounded(to: 2)
                            case 3:
                                if Double.random(in: 0...1) < 0.8 {
                                    tip = (drinkPrice * Double.random(in: 0.10...0.15) * tipMultiplier).rounded(to: 2)
                                } else {
                                    tip = 0.0
                                }
                            case 2:
                                if Double.random(in: 0...1) < 0.4 {
                                    tip = (drinkPrice * Double.random(in: 0.05...0.10) * tipMultiplier).rounded(to: 2)
                                } else {
                                    tip = 0.0
                                }
                            case 1:
                                if Double.random(in: 0...1) < 0.1 {
                                    tip = (drinkPrice * Double.random(in: 0.00...0.05) * tipMultiplier).rounded(to: 2)
                                } else {
                                    tip = 0.0
                                }
                            default:
                                tip = 0.0
                            }
                            tips = (tips + tip).rounded(to: 2)
                            
                            // Show sales popup
                            lastSaleAmount = drinkPrice
                            lastTipAmount = tip
                            
                            // Delay the popup appearance for better timing
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showSalesPopup = true
                            }
                            
                            // Hide popup after delay with fade out
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showSalesPopup = false
                                }
                            }
                            
                            // Update mood based on success
                            mood = "😊"
                            
                            // Wait for feedback to be shown, then remove customer
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                // Remove the current customer
                                Customer.activeCustomers.remove(at: currentCustomerIndex)
                                
                                // If we've removed the last customer, generate a new set
                                if Customer.activeCustomers.isEmpty {
                                    Customer.generateNewCustomerSet()
                                    currentCustomerIndex = 0
                                } else if currentCustomerIndex >= Customer.activeCustomers.count {
                                    currentCustomerIndex = Customer.activeCustomers.count - 1
                                }
                                
                                // Reset order text
                                orderText = ""
                            }
                        } else {
                            // Show negative feedback
                            orderText = "\"That's not what I ordered...\""
                            failedDrinks += 1
                            
                            // Add to wastage
                            let drinkCost = calculateDrinkCost(for: currentCustomer.drinkOrder)
                            wastage = (wastage + drinkCost).rounded(to: 2)
                            
                            // Update mood based on failure
                            mood = "😔"
                            
                            // Reset order text after a delay
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                orderText = ""
                            }
                        }
                    }
                )
            }
        }
        .fullScreenCover(isPresented: $showingDrinksMenu) {
                            DrinksMenuView(isShowing: $showingDrinksMenu, venueName: venueName)
        }
        .onChange(of: currentCustomerIndex) { oldIndex, newIndex in
            // Ensure we're not out of bounds
            if newIndex >= Customer.activeCustomers.count {
                currentCustomerIndex = Customer.activeCustomers.count - 1
            } else if newIndex < 0 {
                currentCustomerIndex = 0
            }
        }
        .onAppear {
            if Customer.activeCustomers.isEmpty {
                Customer.generateInitialCustomers()
            }
            
            // Start patience timers for existing customers
            for customer in Customer.activeCustomers {
                startPatienceTimer(for: customer)
            }
            
            // Persistent time tracking setup
            let todayString = getCurrentDateString()
            let key = "customerScreenTime_\(venueName)_\(todayString)"
            let storedElapsed = UserDefaults.standard.integer(forKey: key)
            totalElapsedTime = storedElapsed
            sessionStartTime = Date()
            startTimer()
            // --- For the clock ---
            // persistedInGameSeconds is already loaded in init, don't override it
            // sessionInGameSeconds is already initialized to 0 in init
            startClockTimer()
            startCustomerGenerationTimer()
            // In onAppear, reset venueMood and start timer
            venueMood = 3
            startVenueMoodTimer()
        }
        .onDisappear {
            timer?.invalidate()
            customerGenerationTimer?.invalidate()
            
            // Stop all patience timers
            for timer in customerPatienceTimers.values {
                timer.invalidate()
            }
            customerPatienceTimers.removeAll()
            
            saveSessionElapsedTime()
            // --- For the clock ---
            stopClockTimer()
            venueMoodTimer?.invalidate()
        }
        .fullScreenCover(isPresented: $showingShiftSummary) {
            ShiftSummaryView(
                isShowing: $showingShiftSummary,
                sales: sales,
                tips: tips,
                wastage: wastage,
                successfulDrinks: successfulDrinks,
                failedDrinks: failedDrinks,
                venueName: venueName,
                onStartNewShift: resetGameState
            )
        }
        .alert(isPresented: $showMinimumHoursAlert) {
            Alert(
                title: Text("Minimum Hours Not Met"),
                message: Text("You must work at least the minimum hours for this shift before finishing."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onChange(of: sales) { _, _ in updateStoredGameState() }
        .onChange(of: tips) { _, _ in updateStoredGameState() }
        .onChange(of: wastage) { _, _ in updateStoredGameState() }
        .onChange(of: successfulDrinks) { _, _ in updateStoredGameState() }
        .onChange(of: failedDrinks) { _, _ in updateStoredGameState() }
        .onChange(of: currentCustomerIndex) { _, _ in updateStoredGameState() }
    }
    
    private func handleSwipe(direction: SwipeDirection) {
        // First check if we can actually swipe in the requested direction
        if (direction == .left && !canSwipeLeft) || (direction == .right && !canSwipeRight) {
            // Just bounce back if we can't swipe
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                slideOffset = 0
            }
            return
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            // Slide out in the direction of the swipe
            slideOffset = direction == .left ? -400 : 400
        }
        
        // Update index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            let newIndex: Int
            if direction == .left {
                newIndex = self.currentCustomerIndex + 1  // Swipe left = next customer
            } else {
                newIndex = self.currentCustomerIndex - 1  // Swipe right = previous customer
            }
            
            // Verify the new index is valid
            guard newIndex >= 0 && newIndex < Customer.activeCustomers.count else {
                // If invalid, reset the slide offset without changing the index
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    self.slideOffset = 0
                }
                return
            }
            
            // Update the index
            self.currentCustomerIndex = newIndex
            
            // Reset position and slide in from the opposite direction
            self.slideOffset = direction == .left ? 400 : -400
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                self.slideOffset = 0
            }
        }
    }
    
    private func calculateDrinkCost(for drinkName: String) -> Double {
        guard let drink = Drink.allDrinks.first(where: { $0.name == drinkName }) else { return 0 }
        var totalCost: Double = 0
        for ingredient in drink.recipe {
            if let availableIngredient = DrinkIngredient.availableIngredients.first(where: { $0.name == ingredient.name }) {
                totalCost += availableIngredient.cost * ingredient.amount
            }
        }
        return totalCost
    }
    
    private func getDrinkPrice(for drinkName: String) -> Double {
        let venueDrinks = VenueDrinkMenu.getDrinksForVenue(venueName)
        return venueDrinks.first(where: { $0.drink.name == drinkName })?.price ?? 0
    }
    
    private func updateStoredGameState() {
        // Save current game state
        UserDefaults.standard.set(sales, forKey: "gameSales_\(venueName)")
        UserDefaults.standard.set(tips, forKey: "gameTips_\(venueName)")
        UserDefaults.standard.set(wastage, forKey: "gameWastage_\(venueName)")
        UserDefaults.standard.set(successfulDrinks, forKey: "gameSuccessfulDrinks_\(venueName)")
        UserDefaults.standard.set(failedDrinks, forKey: "gameFailedDrinks_\(venueName)")
        UserDefaults.standard.set(timeRemaining, forKey: "gameTimeRemaining_\(venueName)")
        UserDefaults.standard.set(currentCustomerIndex, forKey: "gameCurrentCustomerIndex_\(venueName)")
        UserDefaults.standard.set(getCurrentDateString(), forKey: "lastGameDate_\(venueName)")
        UserDefaults.standard.synchronize()  // Force immediate save
    }
    
    private func resetGameState() {
        // Reset metrics
        sales = 0.0
        tips = 0.0
        wastage = 0.0
        mood = "😊"
        successfulDrinks = 0
        failedDrinks = 0
        // Reset customer state
        Customer.activeCustomers.removeAll()
        Customer.initializeActiveCustomers()
        currentCustomerIndex = 0
        orderText = ""
        slideOffset = 0
        // Close any open views
        showingPreparationView = false
        showingDrinksMenu = false
        showingDrinkMaker = false
        isShowingFeedback = false
        // Reset ingredient selections for all customers
        for index in Customer.activeCustomers.indices {
            Customer.activeCustomers[index].selectedGlassware = nil
            Customer.activeCustomers[index].selectedIce = .none
            Customer.activeCustomers[index].selectedMethod = nil
            Customer.activeCustomers[index].selectedIngredients = []
        }
        // Start new timer
        timeRemaining = 300
        // Remove saved state for this venue
        let keys = [
            "gameSales_\(venueName)",
            "gameTips_\(venueName)",
            "gameWastage_\(venueName)",
            "gameSuccessfulDrinks_\(venueName)",
            "gameFailedDrinks_\(venueName)",
            "gameTimeRemaining_\(venueName)",
            "gameCurrentCustomerIndex_\(venueName)"
        ]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        startTimer()
        // Update stored game state
        updateStoredGameState()
    }
    
    private func saveSessionElapsedTime() {
        guard let start = sessionStartTime else { return }
        let sessionElapsed = Int(Date().timeIntervalSince(start))
        let todayString = getCurrentDateString()
        let key = "customerScreenTime_\(venueName)_\(todayString)"
        let previous = UserDefaults.standard.integer(forKey: key)
        let newTotal = previous + sessionElapsed
        UserDefaults.standard.set(newTotal, forKey: key)
        totalElapsedTime = newTotal
    }

    private func getTotalElapsedTime() -> Int {
        // Returns total time spent in seconds (persisted + current session)
        guard let start = sessionStartTime else { return totalElapsedTime }
        return totalElapsedTime + Int(Date().timeIntervalSince(start))
    }

    private func canEndShift() -> Bool {
        let venue = Venue.allVenues.first(where: { $0.name == venueName })
        let minHours = venue?.minimumHoursPerShift ?? 0
        let minSeconds = minHours * 60 * 60
        return getTotalElapsedTime() >= minSeconds
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                updateStoredGameState()
            } else {
                timer?.invalidate()
                saveSessionElapsedTime()
                // Close any open views before showing summary
                showingPreparationView = false
                showingDrinksMenu = false
                showingDrinkMaker = false
                isShowingFeedback = false
                
                // Small delay to ensure views are closed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showingShiftSummary = true
                }
            }
        }
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    

    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    private func getFontForVenue(_ venueName: String, size: CGFloat = 24) -> Font {
        switch venueName {
        case "The Bear and Badger":
            return .custom("Copperplate", size: size)  // Traditional, sturdy font for old man pub
        case "Mackenzie's":
            return .custom("Impact", size: size)  // Bold, no-nonsense font for drinks factory
        case "Paradise Cove":
            return .custom("Party LET", size: size + 4)  // Fun, playful font for tropical nonsense
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
    
    private func getRandomPositiveFeedback() -> String {
        return ContentView.positiveFeedbackResponses.randomElement() ?? "Perfect! Just what I wanted!"
    }

    // --- Add helpers for clock timer ---
    private func startClockTimer() {
        clockTimer?.invalidate()
        clockTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            sessionInGameSeconds += 1 // 1 real second = 1 in-game minute
        }
    }
    private func stopClockTimer() {
        clockTimer?.invalidate()
        clockTimer = nil
    }

#Preview {
    ContentView(venueName: "BoHo Lounge", displayName: "BoHo Lounge")
        .modelContainer(for: Item.self, inMemory: true)
}

// Add this struct at the bottom of the file
struct MetricView: View {
    let title: String
    let value: String
    
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(secondaryColor)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(secondaryColor)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.8))
        .cornerRadius(8)
    }
}

struct MoneyPopoverView: View {
    let sales: Double
    let tips: Double
    let wastage: Double
    let venueName: String
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading, spacing: 0) {
                // Header with title and close button on the same line
                HStack {
                    Text("Takings")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundColor(secondaryColor)
                        .padding(.vertical, 16)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.up.circle.fill")
                            .foregroundColor(secondaryColor)
                            .font(.title)
                    }
                }
                .padding(.horizontal)
                Divider().background(secondaryColor.opacity(0.3))
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Sales:")
                            .font(.headline)
                            .foregroundColor(secondaryColor)
                        Spacer()
                        Text(String(format: "£%.2f", sales))
                            .font(.headline)
                            .foregroundColor(secondaryColor)
                    }
                    HStack {
                        Text("Tips:")
                            .font(.headline)
                            .foregroundColor(secondaryColor)
                        Spacer()
                        Text(String(format: "£%.2f", tips))
                            .font(.headline)
                            .foregroundColor(secondaryColor)
                    }
                    HStack {
                        Text("Wastage:")
                            .font(.headline)
                            .foregroundColor(secondaryColor)
                        Spacer()
                        Text(String(format: "£%.2f", wastage))
                            .font(.headline)
                            .foregroundColor(secondaryColor)
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(secondaryColor.opacity(0.3))
                        .frame(height: 1)
                        .padding(.vertical, 10)
                    
                    // Minimum takings information
                    if let venue = Venue.allVenues.first(where: { $0.name == venueName }) {
                        HStack {
                            Text("Minimum Bar Take:")
                                .font(.subheadline)
                                .foregroundColor(secondaryColor.opacity(0.8))
                            Spacer()
                            Text(String(format: "£%.0f", venue.minimumBarTake))
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(secondaryColor)
                        }
                    }
                }
                .padding(24)
                Spacer()
            }
        }
    }
    }
    
    private func moodEmoticon(for mood: Int) -> String {
        switch mood {
        case 1: return "😠"
        case 2: return "🙁"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😀"
        default: return "😐"
        }
    }
    
    // Customer generation functions
    private func startCustomerGenerationTimer() {
        customerGenerationTimer?.invalidate()
        scheduleNextCustomerGeneration()
    }
    
    private func scheduleNextCustomerGeneration() {
        // Generate customer every 60 seconds ± up to 30 seconds variation
        let baseInterval: TimeInterval = 60.0
        let variation: TimeInterval = Double.random(in: -30...30)
        let nextInterval = baseInterval + variation
        
        customerGenerationTimer = Timer.scheduledTimer(withTimeInterval: nextInterval, repeats: false) { _ in
            self.generateNewCustomer()
            self.scheduleNextCustomerGeneration() // Schedule the next one
        }
        
        print("Next customer will be generated in \(String(format: "%.1f", nextInterval)) seconds")
    }
    
    private func generateNewCustomer() {
        // Don't generate if we already have too many customers
        if Customer.activeCustomers.count >= 8 {
            return
        }
        // 30% chance to pick a returning customer
        let useReturning = !Customer.previousCustomers.isEmpty && Double.random(in: 0...1) < 0.3
        var newCustomer: Customer
        if useReturning {
            // Pick a previous customer not currently active
            let available = Customer.previousCustomers.filter { prev in
                !Customer.activeCustomers.contains(where: { $0.avatarNumber == prev.avatarNumber })
            }
            if let returning = available.randomElement() {
                var copy = returning
                // Reset patience and mood (influenced by venue mood)
                let basePatience: TimeInterval = 5 * 60
                let variation: TimeInterval = Double.random(in: -30...30)
                copy.patienceRemaining = basePatience + variation
                copy.mood = generateMoodInfluencedByVenue()
                copy.hasLeft = false
                newCustomer = copy
                print("Returning customer: \(copy.drinkOrder) (Avatar \(copy.avatarNumber), Mood: \(copy.mood))")
            } else {
                newCustomer = createRandomCustomer()
            }
        } else {
            newCustomer = createRandomCustomer()
        }
        // Add to active customers
        Customer.activeCustomers.append(newCustomer)
        // Start patience timer for the new customer
        startPatienceTimer(for: newCustomer)
        print("Generated new customer: \(newCustomer.drinkOrder) (Avatar \(newCustomer.avatarNumber), Mood: \(newCustomer.mood))")
    }
    
    private func handleCustomerLeft(_ customer: Customer) {
        // Remove the customer from active customers
        if let index = Customer.activeCustomers.firstIndex(where: { $0.id == customer.id }) {
            Customer.activeCustomers.remove(at: index)
            // Add to previousCustomers if not already present (by id)
            if !Customer.previousCustomers.contains(where: { $0.id == customer.id }) {
                var returning = customer
                returning.hasLeft = false
                // Reset patience and mood for next time
                let basePatience: TimeInterval = 5 * 60
                let variation: TimeInterval = Double.random(in: -30...30)
                returning.patienceRemaining = basePatience + variation
                returning.mood = Int.random(in: 1...5)
                Customer.previousCustomers.append(returning)
            }
            // Adjust current customer index if needed
            if currentCustomerIndex >= Customer.activeCustomers.count && !Customer.activeCustomers.isEmpty {
                currentCustomerIndex = Customer.activeCustomers.count - 1
            }
            print("Customer removed from active customers. Remaining: \(Customer.activeCustomers.count)")
        }
    }
    
    // Helper to create a random new customer
    private func createRandomCustomer() -> Customer {
        let venueDrinks = VenueDrinkMenu.getDrinksForVenue(venueName)
        let availableDrinks = venueDrinks.map { $0.drink.name }
        if availableDrinks.isEmpty { fatalError("No drinks available") }
        let allAvatars = Array(1...10)
        let usedAvatars = Set(Customer.activeCustomers.map { $0.avatarNumber })
        let availableAvatars = allAvatars.filter { !usedAvatars.contains($0) }
        let randomDrink = availableDrinks.randomElement() ?? availableDrinks[0]
        let randomAvatar = availableAvatars.randomElement() ?? availableAvatars[0]
        
        // Generate mood influenced by venue mood
        let customerMood = generateMoodInfluencedByVenue()
        
        return Customer(
            drinkOrder: randomDrink,
            avatarNumber: randomAvatar,
            orderPhrase: Customer.getOrderText(for: randomDrink),
            mood: customerMood
        )
    }
    
    private func generateMoodInfluencedByVenue() -> Int {
        // Create weighted probabilities based on venue mood
        var moodWeights: [Double] = [0.1, 0.1, 0.1, 0.1, 0.1] // Default equal weights
        
        switch venueMood {
        case 5: // Very happy venue
            moodWeights = [0.05, 0.10, 0.20, 0.30, 0.35] // Heavily biased toward 4-5
        case 4: // Happy venue
            moodWeights = [0.08, 0.15, 0.25, 0.30, 0.22] // Biased toward 3-5
        case 3: // Neutral venue
            moodWeights = [0.15, 0.20, 0.30, 0.20, 0.15] // Slight bias toward middle
        case 2: // Unhappy venue
            moodWeights = [0.25, 0.30, 0.25, 0.15, 0.05] // Biased toward 1-3
        case 1: // Very unhappy venue
            moodWeights = [0.40, 0.30, 0.20, 0.08, 0.02] // Heavily biased toward 1-2
        default:
            moodWeights = [0.1, 0.1, 0.1, 0.1, 0.1]
        }
        
        // Generate random number and use weights to determine mood
        let random = Double.random(in: 0...1)
        var cumulativeWeight = 0.0
        
        for (index, weight) in moodWeights.enumerated() {
            cumulativeWeight += weight
            if random <= cumulativeWeight {
                return index + 1 // Convert to 1-5 range
            }
        }
        
        return 3 // Fallback to neutral
    }
    
    // Add venue mood timer functions at the end of ContentView
    private func startVenueMoodTimer() {
        venueMoodTimer?.invalidate()
        venueMoodTimer = Timer.scheduledTimer(withTimeInterval: 120.0, repeats: true) { _ in
            self.updateVenueMood()
        }
    }
    
    private func updateVenueMood() {
        guard !Customer.previousCustomers.isEmpty else { return }
        let avgMood = Customer.previousCustomers.map { Double($0.mood) }.reduce(0, +) / Double(Customer.previousCustomers.count)
        let roundedAvg = Int(round(avgMood))
        if roundedAvg > venueMood {
            venueMood = min(venueMood + 1, 5)
        } else if roundedAvg < venueMood {
            venueMood = max(venueMood - 1, 1)
        }
        print("Venue mood updated to \(venueMood) (avg previous customer mood: \(String(format: "%.2f", avgMood)))")
    }
    
    // Customer patience timer functions
    private func startPatienceTimer(for customer: Customer) {
        // Stop any existing timer for this customer
        stopPatienceTimer(for: customer)
        
        // Create a timer that will call the timeout callback when patience runs out
        let timer = Timer.scheduledTimer(withTimeInterval: customer.patienceRemaining, repeats: false) { _ in
            self.handleCustomerLeft(customer)
        }
        
        // Store the timer reference
        customerPatienceTimers[customer.id] = timer
    }
    
    private func stopPatienceTimer(for customer: Customer) {
        if let timer = customerPatienceTimers[customer.id] {
            timer.invalidate()
            customerPatienceTimers.removeValue(forKey: customer.id)
        }
    }
}

