import SwiftUI

struct ShiftSummaryView: View {
    @Binding var isShowing: Bool
    let sales: Double
    let tips: Double
    let wastage: Double
    let successfulDrinks: Int
    let failedDrinks: Int
    let venueName: String
    let onStartNewShift: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    // Calculate base pay and hours worked
    private var basePayCalculation: (basePay: Double, hoursWorked: Double, minimumMet: Bool) {
        let venue = Venue.allVenues.first(where: { $0.name == venueName })
        let basePayPerHour = venue?.basePayPerHour ?? 0.0
        let minimumHours = venue?.minimumHoursPerShift ?? 0.0
        
        // Get total time worked from UserDefaults
        let todayString = getCurrentDateString()
        let key = "customerScreenTime_\(venueName)_\(todayString)"
        let totalSeconds = UserDefaults.standard.integer(forKey: key)
        let hoursWorked = Double(totalSeconds) / 3600.0 // Convert seconds to hours
        
        // Only pay base pay if minimum hours were met
        let minimumMet = hoursWorked >= minimumHours
        let basePay = minimumMet ? (basePayPerHour * hoursWorked) : 0.0
        
        return (basePay: basePay, hoursWorked: hoursWorked, minimumMet: minimumMet)
    }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Shift Complete!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(secondaryColor)
                
                VStack(spacing: 20) {
                    MetricRow(title: "Hours Worked", value: String(format: "%.1f hours", basePayCalculation.hoursWorked))
                    MetricRow(title: "Base Pay", value: String(format: "£%.2f", basePayCalculation.basePay))
                    MetricRow(title: "Tips Earned", value: String(format: "£%.2f", tips))
                    MetricRow(title: "Total Sales", value: String(format: "£%.2f", sales))
                    MetricRow(title: "Wastage", value: String(format: "£%.2f", wastage))
                    MetricRow(title: "Successful Drinks", value: "\(successfulDrinks)")
                    MetricRow(title: "Failed Drinks", value: "\(failedDrinks)")
                    
                    // Show warning if minimum hours not met
                    if !basePayCalculation.minimumMet {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            Text("Minimum hours not met - no base pay earned")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                Button(action: {
                    onStartNewShift()
                    isShowing = false
                }) {
                    Text("Start New Shift")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(primaryColor)
                        .cornerRadius(25)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
        .onAppear {
            // Add tips and base pay to player's money when shift summary appears
            addEarningsToPlayerMoney()
        }
    }
    
    private func addEarningsToPlayerMoney() {
        // Get current player money
        let currentMoney = UserDefaults.standard.double(forKey: "playerMoney")
        
        // Add tips and base pay to player's money
        let totalEarnings = tips + basePayCalculation.basePay
        let newMoney = currentMoney + totalEarnings
        
        // Save updated money
        UserDefaults.standard.set(newMoney, forKey: "playerMoney")
        UserDefaults.standard.synchronize()
        
        print("Added £\(String(format: "%.2f", tips)) in tips and £\(String(format: "%.2f", basePayCalculation.basePay)) in base pay to player money. New total: £\(String(format: "%.2f", newMoney))")
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
}

struct MetricRow: View {
    let title: String
    let value: String
    
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .foregroundColor(secondaryColor)
            Spacer()
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(secondaryColor)
        }
    }
} 