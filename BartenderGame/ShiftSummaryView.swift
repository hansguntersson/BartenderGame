import SwiftUI

struct ShiftSummaryView: View {
    @Binding var isShowing: Bool
    let sales: Double
    let tips: Double
    let wastage: Double
    let successfulDrinks: Int
    let failedDrinks: Int
    let onStartNewShift: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Shift Complete!")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(secondaryColor)
                
                VStack(spacing: 20) {
                    MetricRow(title: "Total Sales", value: String(format: "£%.2f", sales))
                    MetricRow(title: "Tips Earned", value: String(format: "£%.2f", tips))
                    MetricRow(title: "Wastage", value: String(format: "£%.2f", wastage))
                    MetricRow(title: "Successful Drinks", value: "\(successfulDrinks)")
                    MetricRow(title: "Failed Drinks", value: "\(failedDrinks)")
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