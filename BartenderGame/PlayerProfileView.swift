import SwiftUI

struct PlayerProfileView: View {
    @Binding var isShowing: Bool
    
    // Player data - in a real app these would be stored in UserDefaults or a database
    @AppStorage("playerUsername") private var username = "Hans Guntersson"
    @AppStorage("playerMoney") private var currentMoney = 100.0
    @AppStorage("playerLivingSituation") private var livingSituation = "Shared Flat"
    @AppStorage("playerEquipment") private var equipmentString = "Basic Shaker,Strainer,Jigger"
    @AppStorage("playerClothing") private var clothingString = "White Shirt,Black Trousers,Apron"
    
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
                                
                                HStack {
                                    Image(systemName: "house.fill")
                                        .foregroundColor(primaryColor)
                                    Text(livingSituation)
                                        .font(.subheadline)
                                        .foregroundColor(secondaryColor)
                                    Spacer()
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
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
                            
                            // Bottom padding
                            .padding(.bottom, 20)
                        }
                        .frame(maxWidth: 600)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    PlayerProfileView(isShowing: .constant(true))
} 
