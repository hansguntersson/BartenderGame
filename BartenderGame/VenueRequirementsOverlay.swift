import SwiftUI

struct VenueRequirement: Identifiable {
    let id = UUID()
    let category: String
    let name: String
    let description: String
    let isOwned: Bool
    let cost: String
}

struct VenueRequirementsOverlay: View {
    let venue: Venue
    @Binding var isShowing: Bool
    
    // Player data
    @AppStorage("playerLivingSituation") private var livingSituation = "Living with Parents"
    @AppStorage("playerTransport") private var transport = "Walking"
    @AppStorage("playerEquipment") private var equipmentString = "Basic Shaker,Strainer,Jigger"
    @AppStorage("playerClothing") private var clothingString = "White Shirt,Black Trousers,Apron"
    @AppStorage("purchasedLivingSituations") private var purchasedLivingSituationsString = "Living with Parents"
    @AppStorage("purchasedTransportOptions") private var purchasedTransportOptionsString = "Walking"
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07) // Rich dark brown
    
    // Computed properties
    private var purchasedLivingSituations: [String] {
        purchasedLivingSituationsString.split(separator: ",").map(String.init)
    }
    
    private var purchasedTransportOptions: [String] {
        purchasedTransportOptionsString.split(separator: ",").map(String.init)
    }
    
    private var equipment: [String] {
        equipmentString.split(separator: ",").map(String.init)
    }
    
    private var clothing: [String] {
        clothingString.split(separator: ",").map(String.init)
    }
    
    // Venue requirements based on venue type
    private var venueRequirements: [VenueRequirement] {
        var requirements: [VenueRequirement] = []
        
        // Accommodation requirements
        let accommodationRequirement = getAccommodationRequirement()
        requirements.append(accommodationRequirement)
        
        // Transport requirements
        let transportRequirement = getTransportRequirement()
        requirements.append(transportRequirement)
        
        // Equipment requirements
        let equipmentRequirements = getEquipmentRequirements()
        requirements.append(contentsOf: equipmentRequirements)
        
        // Clothing requirements
        let clothingRequirements = getClothingRequirements()
        requirements.append(contentsOf: clothingRequirements)
        
        return requirements
    }
    
    private func getAccommodationRequirement() -> VenueRequirement {
        let isOwned = purchasedLivingSituations.contains(livingSituation)
        let livingSituations = [
            LivingSituation(name: "Living with Parents", dailyCost: 0.0, oneOffCost: 0.0, description: "Staying with family at home"),
            LivingSituation(name: "Shared Flat", dailyCost: 15.0, oneOffCost: 100.0, description: "Shared accommodation with other people"),
            LivingSituation(name: "Studio Flat", dailyCost: 25.0, oneOffCost: 1000.0, description: "Small self-contained apartment"),
            LivingSituation(name: "One Bedroom Flat", dailyCost: 35.0, oneOffCost: 1500.0, description: "Comfortable single bedroom apartment"),
            LivingSituation(name: "Two Bedroom Flat", dailyCost: 45.0, oneOffCost: 2000.0, description: "Spacious two bedroom apartment"),
            LivingSituation(name: "House Share", dailyCost: 20.0, oneOffCost: 300.0, description: "Sharing a house with housemates"),
            LivingSituation(name: "Luxury Apartment", dailyCost: 60.0, oneOffCost: 5000.0, description: "High-end apartment with amenities")
        ]
        
        let currentSituation = livingSituations.first { $0.name == livingSituation } ?? livingSituations[0]
        let cost = currentSituation.oneOffCost > 0 ? "£\(String(format: "%.0f", currentSituation.oneOffCost))" : "Free"
        
        return VenueRequirement(
            category: "Accommodation",
            name: livingSituation,
            description: currentSituation.description,
            isOwned: isOwned,
            cost: cost
        )
    }
    
    private func getTransportRequirement() -> VenueRequirement {
        let isOwned = purchasedTransportOptions.contains(transport)
        let transportOptions = [
            Transport(name: "Walking", purchaseCost: 0.0, perShiftCost: 0.0, description: "Walking to work"),
            Transport(name: "Bus", purchaseCost: 0.0, perShiftCost: 3.0, description: "Public bus transport"),
            Transport(name: "Bike", purchaseCost: 100.0, perShiftCost: 0.5, description: "Bicycle for commuting"),
            Transport(name: "Scooter", purchaseCost: 800.0, perShiftCost: 1.0, description: "Motor scooter"),
            Transport(name: "Car", purchaseCost: 3000.0, perShiftCost: 5.0, description: "Personal vehicle"),
            Transport(name: "Luxury Car", purchaseCost: 15000.0, perShiftCost: 8.0, description: "High-end vehicle")
        ]
        
        let currentTransport = transportOptions.first { $0.name == transport } ?? transportOptions[0]
        let cost = currentTransport.purchaseCost > 0 ? "£\(String(format: "%.0f", currentTransport.purchaseCost))" : "Free"
        
        return VenueRequirement(
            category: "Transport",
            name: transport,
            description: currentTransport.description,
            isOwned: isOwned,
            cost: cost
        )
    }
    
    private func getEquipmentRequirements() -> [VenueRequirement] {
        let requiredEquipment = ["Basic Shaker", "Strainer", "Jigger"]
        return requiredEquipment.map { equipmentName in
            let isOwned = equipment.contains(equipmentName)
            return VenueRequirement(
                category: "Equipment",
                name: equipmentName,
                description: "Essential bartending tool",
                isOwned: isOwned,
                cost: "Free"
            )
        }
    }
    
    private func getClothingRequirements() -> [VenueRequirement] {
        let requiredClothing = ["White Shirt", "Black Trousers", "Apron"]
        return requiredClothing.map { clothingName in
            let isOwned = clothing.contains(clothingName)
            return VenueRequirement(
                category: "Clothing",
                name: clothingName,
                description: "Professional bartender attire",
                isOwned: isOwned,
                cost: "Free"
            )
        }
    }
    
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
                // Header
                HStack {
                    Text("Requirements")
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
                
                // Requirements list
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(venueRequirements) { requirement in
                            RequirementCard(requirement: requirement)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: 600)
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

struct RequirementCard: View {
    let requirement: VenueRequirement
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(requirement.category)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(secondaryColor.opacity(0.7))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(secondaryColor.opacity(0.1))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    // Status indicator
                    HStack(spacing: 4) {
                        Image(systemName: requirement.isOwned ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(requirement.isOwned ? .green : .red)
                            .font(.caption)
                        Text(requirement.isOwned ? "Owned" : "Missing")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(requirement.isOwned ? .green : .red)
                    }
                }
                
                Text(requirement.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(secondaryColor)
                
                Text(requirement.description)
                    .font(.subheadline)
                    .foregroundColor(secondaryColor.opacity(0.7))
                    .multilineTextAlignment(.leading)
                
                Text(requirement.cost)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(primaryColor)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    VenueRequirementsOverlay(
        venue: Venue.allVenues[0],
        isShowing: .constant(true)
    )
} 