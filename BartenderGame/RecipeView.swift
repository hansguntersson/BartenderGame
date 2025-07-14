import SwiftUI

// MARK: - Supporting Views
struct RecipeHeader: View {
    let drink: Drink
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(drink.name)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundColor(secondaryColor)
                .padding(.top, 24)
            
            Text(drink.description)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .foregroundColor(secondaryColor)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 8)
        }
    }
}

struct MethodButton: View {
    let method: MethodType
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(method.rawValue)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(secondaryColor)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct IceButton: View {
    let ice: IceType
    let secondaryColor: Color
    
    private func formatIceType(_ ice: IceType) -> String {
        switch ice {
        case .none: return "No Ice"
        case .crushed: return "Crushed Ice"
        case .cubed: return "Cubed Ice"
        case .sphere: return "Ice Sphere"
        case .cracked: return "Cracked Ice"
        case .dry: return "Dry Ice"
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(formatIceType(ice))
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(secondaryColor)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct GlasswareButton: View {
    let glassware: Glassware
    let secondaryColor: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(glassware.name)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(secondaryColor)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(.horizontal, 8)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct RecipeMethodSection: View {
    let drink: Drink
    let secondaryColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Method")
                .font(.headline)
                .foregroundColor(secondaryColor)
                .padding(.horizontal)
            
            Divider()
                .background(secondaryColor.opacity(0.3))
            
            HStack(spacing: 12) {
                MethodButton(method: drink.requiredMethod, secondaryColor: secondaryColor)
                IceButton(ice: drink.requiredIce, secondaryColor: secondaryColor)
                GlasswareButton(glassware: drink.glassRequirement.ideal.first ?? Glassware.allGlassware.first!, secondaryColor: secondaryColor)
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 24)
    }
}

struct RecipeIngredientsSection: View {
    let drink: Drink
    let secondaryColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ingredients")
                .font(.headline)
                .foregroundColor(secondaryColor)
                .padding(.horizontal)
            
            Divider()
                .background(secondaryColor.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(drink.recipe, id: \.name) { ingredient in
                    Text(ingredient.name)
                        .font(.subheadline)
                        .foregroundColor(secondaryColor)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 24)
    }
}

struct RecipeGarnishSection: View {
    let drink: Drink
    let secondaryColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Garnish")
                .font(.headline)
                .foregroundColor(secondaryColor)
                .padding(.horizontal)
            
            Divider()
                .background(secondaryColor.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 4) {
                if !drink.garnishRequirement.ideal.isEmpty {
                    Text("Ideal: " + drink.garnishRequirement.ideal.map { $0.name }.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(secondaryColor)
                }
                if !drink.garnishRequirement.acceptable.isEmpty {
                    Text("Acceptable: " + drink.garnishRequirement.acceptable.map { $0.name }.joined(separator: ", "))
                        .font(.subheadline)
                        .foregroundColor(secondaryColor)
                }
                if drink.garnishRequirement.ideal.isEmpty && drink.garnishRequirement.acceptable.isEmpty {
                    Text("None")
                        .font(.subheadline)
                        .foregroundColor(secondaryColor)
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Main View
struct RecipeView: View {
    let drinkName: String
    @Binding var isShowing: Bool
    
    // Define consistent colors for 70's modernist palette
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let accentColor = Color(red: 0.9, green: 0.7, blue: 0.2)  // Mustard Yellow
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header with back button
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            isShowing = false
                        }) {
                            Image(systemName: "chevron.up.circle.fill")
                                .foregroundColor(secondaryColor)
                                .font(.title)
                        }
                    }
                    .padding()
                
                    ScrollView {
                        VStack(spacing: 24) {
                            if let drink = Drink.allDrinks.first(where: { $0.name == drinkName }) {
                                RecipeHeader(drink: drink, secondaryColor: secondaryColor)
                                RecipeMethodSection(drink: drink, secondaryColor: secondaryColor)
                                RecipeIngredientsSection(drink: drink, secondaryColor: secondaryColor)
                                RecipeGarnishSection(drink: drink, secondaryColor: secondaryColor)
                            } else {
                                Text("Recipe not found")
                                    .font(.system(size: 16, weight: .regular, design: .serif))
                                    .foregroundColor(secondaryColor)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
    }
} 