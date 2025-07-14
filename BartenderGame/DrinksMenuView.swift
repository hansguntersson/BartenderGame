import SwiftUI

struct DrinksMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedStyle: DrinkStyle = .spirits
    @State private var showingRecipe = false
    @State private var selectedDrink: String = ""
    let venueName: String
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    private func iconName(for style: DrinkStyle) -> String {
        switch style {
        case .spirits:
            return "wineglass.fill"
        case .draught:
            return "mug.fill"
        case .spiritMixer:
            return "drop.fill"
        case .wine:
            return "wineglass"
        case .classic:
            return "star.fill"
        case .modern:
            return "sparkles"
        case .party:
            return "party.popper.fill"
        case .obscure:
            return "questionmark.circle.fill"
        case .nonAlcoholic:
            return "cup.and.saucer.fill"
        }
    }
    
    private func getVenueName() -> String {
        return venueName
    }
    
    private func getVenueDrinks(for style: DrinkStyle) -> [VenueDrink] {
        let venueDrinks = VenueDrinkMenu.getDrinksForVenue(getVenueName())
        return venueDrinks.filter { $0.drink.style == style }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header with back button
                    HStack {
                        Text("Menu")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(secondaryColor)
                        
                        Spacer()
                        
                        Button(action: {
                            isShowing = false
                        }) {
                            Image(systemName: "chevron.up.circle.fill")
                                .foregroundColor(secondaryColor)
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(secondaryColor)
                        .padding(.top)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            let sortedDrinks = getVenueDrinks(for: selectedStyle).sorted { $0.drink.name < $1.drink.name }
                            ForEach(sortedDrinks, id: \.id) { venueDrink in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(venueDrink.drink.name)
                                            .font(.headline)
                                            .foregroundColor(secondaryColor)
                                        
                                        Spacer()
                                        
                                        Text("£\(String(format: "%.2f", venueDrink.price))")
                                            .font(.subheadline)
                                            .foregroundColor(secondaryColor)
                                    }
                                    
                                    Text(venueDrink.drink.description)
                                        .font(.subheadline)
                                        .foregroundColor(secondaryColor.opacity(0.8))
                                        .lineLimit(1)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedDrink = venueDrink.drink.name
                                    showingRecipe = true
                                }
                                
                                if venueDrink.id != sortedDrinks.last?.id {
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                }
                            }
                        }
                    }
                    
                    Spacer(minLength: 0)
                    
                    Divider()
                        .background(secondaryColor)
                    
                    // Style Navigation Bar (only show non-empty categories)
                    let availableStyles = DrinkStyle.allCases.filter { !getVenueDrinks(for: $0).isEmpty }
                    HStack(spacing: 0) {
                        ForEach(availableStyles, id: \.self) { style in
                            Button(action: {
                                selectedStyle = style
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: iconName(for: style))
                                        .font(.system(size: 20))
                                        .foregroundColor(selectedStyle == style ? primaryColor : secondaryColor)
                                    Text(style.rawValue)
                                        .font(.caption)
                                        .foregroundColor(selectedStyle == style ? primaryColor : secondaryColor)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .background(Color.white)
                    .onAppear {
                        // If the current selectedStyle is not available, switch to the first available
                        if !availableStyles.contains(selectedStyle), let first = availableStyles.first {
                            selectedStyle = first
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingRecipe) {
            if !selectedDrink.isEmpty {
                RecipeView(drinkName: selectedDrink, isShowing: $showingRecipe)
            }
        }
        .onChange(of: showingRecipe) { oldValue, newValue in
            if !newValue {
                selectedDrink = ""
            }
        }
    }
} 
