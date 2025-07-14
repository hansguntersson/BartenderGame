import Foundation

class DailyTransitionManager: ObservableObject {
    static let shared = DailyTransitionManager()
    
    private init() {}
    
    // Check if we need to process a daily transition
    func checkAndProcessDailyTransition() {
        let currentDateString = getCurrentDateString()
        let lastProcessedDate = UserDefaults.standard.string(forKey: "lastProcessedDate") ?? ""
        
        if lastProcessedDate != currentDateString {
            processDailyTransition(from: lastProcessedDate, to: currentDateString)
            UserDefaults.standard.set(currentDateString, forKey: "lastProcessedDate")
        }
    }
    
    private func processDailyTransition(from oldDate: String, to newDate: String) {
        print("Processing daily transition from \(oldDate) to \(newDate)")
        
        // Only process if we have a valid old date (not first launch)
        guard !oldDate.isEmpty else {
            print("First launch - skipping daily transition")
            return
        }
        
        // End all open shifts and calculate pay
        let totalEarnings = endAllOpenShifts()
        
        // Deduct daily living costs
        let livingCosts = deductDailyLivingCosts()
        
        // Deduct transport costs for shifts worked
        let transportCosts = deductTransportCosts()
        
        // Update player money
        let netChange = totalEarnings - livingCosts - transportCosts
        let currentMoney = UserDefaults.standard.double(forKey: "playerMoney")
        let newMoney = currentMoney + netChange
        
        UserDefaults.standard.set(newMoney, forKey: "playerMoney")
        
        // Log the daily transition
        logDailyTransition(
            earnings: totalEarnings,
            livingCosts: livingCosts,
            transportCosts: transportCosts,
            netChange: netChange,
            newBalance: newMoney
        )
        
        // Clear old shift data
        clearOldShiftData()
    }
    
    private func endAllOpenShifts() -> Double {
        var totalEarnings: Double = 0.0
        
        // Get all started shifts
        let startedShiftsString = UserDefaults.standard.string(forKey: "startedShifts") ?? ""
        let startedShifts = Set(startedShiftsString.split(separator: ",").map(String.init))
        
        for shiftKey in startedShifts {
            let components = shiftKey.split(separator: "_")
            if components.count >= 2 {
                let venueName = String(components[0])
                
                // Calculate earnings for this shift
                let shiftEarnings = calculateShiftEarnings(for: venueName)
                totalEarnings += shiftEarnings
                
                print("Ended shift at \(venueName): £\(String(format: "%.2f", shiftEarnings))")
            }
        }
        
        return totalEarnings
    }
    
    private func calculateShiftEarnings(for venueName: String) -> Double {
        let venue = Venue.allVenues.first { $0.name == venueName }
        guard let venue = venue else { return 0.0 }
        
        // Get shift data
        let sales = UserDefaults.standard.double(forKey: "gameSales_\(venueName)")
        let tips = UserDefaults.standard.double(forKey: "gameTips_\(venueName)")
        let wastage = UserDefaults.standard.double(forKey: "gameWastage_\(venueName)")
        
        // Calculate base pay based on time worked
        let basePay = calculateBasePay(for: venue, venueName: venueName)
        
        // Calculate base earnings
        var totalEarnings = basePay + tips - wastage
        
        // Check if sales meet minimum bar take requirement
        if sales < venue.minimumBarTake {
            // Apply 10% wage penalty only to base pay
            let penalty = basePay * 0.10
            totalEarnings -= penalty
            
            print("Daily transition: Sales (£\(String(format: "%.2f", sales))) below minimum bar take (£\(String(format: "%.0f", venue.minimumBarTake))) for \(venueName) - 10% wage penalty applied to base pay: -£\(String(format: "%.2f", penalty))")
        } else if sales >= venue.minimumBarTake * 1.5 {
            // Apply 15% bonus to base pay for significantly exceeding target
            let bonus = basePay * 0.15
            totalEarnings += bonus
            
            print("Daily transition: Sales (£\(String(format: "%.2f", sales))) significantly above minimum bar take (£\(String(format: "%.0f", venue.minimumBarTake))) for \(venueName) - 15% bonus applied to base pay: +£\(String(format: "%.2f", bonus))")
        }
        
        return totalEarnings
    }
    
    private func calculateBasePay(for venue: Venue, venueName: String) -> Double {
        // Get total time worked from UserDefaults
        let todayString = getCurrentDateString()
        let key = "customerScreenTime_\(venueName)_\(todayString)"
        let totalSeconds = UserDefaults.standard.integer(forKey: key)
        let hoursWorked = Double(totalSeconds) / 3600.0 // Convert seconds to hours
        
        // Only pay base pay if minimum hours were met
        let minimumHours = Double(venue.minimumHoursPerShift)
        let minimumMet = hoursWorked >= minimumHours
        let basePay = minimumMet ? (venue.basePayPerHour * hoursWorked) : 0.0
        
        return basePay
    }
    
    private func deductDailyLivingCosts() -> Double {
        let livingSituation = UserDefaults.standard.string(forKey: "playerLivingSituation") ?? "Living with Parents"
        
        // Define living situations and their daily costs
        let livingSituations = [
            "Living with Parents": 0.0,
            "Shared Flat": 15.0,
            "Studio Flat": 25.0,
            "One Bedroom Flat": 35.0,
            "Two Bedroom Flat": 45.0,
            "House Share": 20.0,
            "Luxury Apartment": 60.0
        ]
        
        let dailyCost = livingSituations[livingSituation] ?? 0.0
        
        if dailyCost > 0 {
            print("Deducted daily living costs for \(livingSituation): £\(String(format: "%.2f", dailyCost))")
        }
        
        return dailyCost
    }
    
    private func deductTransportCosts() -> Double {
        let transport = UserDefaults.standard.string(forKey: "playerTransport") ?? "Walking"
        
        // Define transport options and their per-shift costs
        let transportOptions = [
            "Walking": 0.0,
            "Bus": 3.0,
            "Bike": 0.5,
            "Scooter": 1.0,
            "Car": 5.0,
            "Luxury Car": 8.0
        ]
        
        let perShiftCost = transportOptions[transport] ?? 0.0
        
        // Count how many shifts were worked today
        let startedShiftsString = UserDefaults.standard.string(forKey: "startedShifts") ?? ""
        let startedShifts = Set(startedShiftsString.split(separator: ",").map(String.init))
        let shiftsWorked = startedShifts.count
        
        let totalTransportCost = perShiftCost * Double(shiftsWorked)
        
        if totalTransportCost > 0 {
            print("Deducted transport costs for \(transport) (\(shiftsWorked) shifts): £\(String(format: "%.2f", totalTransportCost))")
        }
        
        return totalTransportCost
    }
    
    private func clearOldShiftData() {
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
        
        print("Cleared all old shift data")
    }
    
    private func logDailyTransition(earnings: Double, livingCosts: Double, transportCosts: Double, netChange: Double, newBalance: Double) {
        print("=== DAILY TRANSITION COMPLETE ===")
        print("Total Earnings: £\(String(format: "%.2f", earnings))")
        print("Living Costs: £\(String(format: "%.2f", livingCosts))")
        print("Transport Costs: £\(String(format: "%.2f", transportCosts))")
        print("Net Change: £\(String(format: "%.2f", netChange))")
        print("New Balance: £\(String(format: "%.2f", newBalance))")
        print("================================")
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
} 