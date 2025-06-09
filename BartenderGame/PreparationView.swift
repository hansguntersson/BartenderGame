import SwiftUI

// Add this new view before the PreparationView struct
struct PreparationCategoryNavigationView: View {
    let selectedCategory: IngredientCategory
    let onCategorySelect: (IngredientCategory) -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(IngredientCategory.allCases, id: \.self) { category in
                Button(action: {
                    onCategorySelect(category)
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: iconName(for: category))
                            .font(.system(size: 20))
                            .foregroundColor(secondaryColor)
                        Text(category.rawValue)
                            .font(.caption)
                            .foregroundColor(secondaryColor)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
            }
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.gray.opacity(0.2)),
            alignment: .top
        )
    }
    
    private func iconName(for category: IngredientCategory) -> String {
        switch category {
        case .spirits:
            return "drop.fill"
        case .liqueurs:
            return "wineglass.fill"
        case .wine:
            return "wineglass.fill"
        case .beer:
            return "mug.fill"
        case .mixers:
            return "homepod.fill"
        }
    }
}

struct PreparationView: View {
    let drink: Drink
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowing: Bool
    let onContinue: (Glassware, IceType, MethodType, Bool) -> Void
    
    @Binding var customer: Customer
    @Binding var currentCustomerIndex: Int
    
    @State private var selectedGlassware: Glassware?
    @State private var selectedIce: IceType = .none
    @State private var selectedMethod: MethodType = .built
    @State private var showingRecipe = false
    @State private var selectedIngredients: [DrinkIngredient] = []
    @State private var selectedGarnishes: [DrinkIngredient] = []
    @State private var currentPage: Int = 0
    
    init(drink: Drink, isShowing: Binding<Bool>, customer: Binding<Customer>, currentCustomerIndex: Binding<Int>, onContinue: @escaping (Glassware, IceType, MethodType, Bool) -> Void) {
        self.drink = drink
        self._isShowing = isShowing
        self._customer = customer
        self._currentCustomerIndex = currentCustomerIndex
        self.onContinue = onContinue
        
        _selectedGlassware = State(initialValue: customer.wrappedValue.selectedGlassware)
        _selectedIce = State(initialValue: customer.wrappedValue.selectedIce)
        _selectedMethod = State(initialValue: customer.wrappedValue.selectedMethod ?? .built)
        _selectedIngredients = State(initialValue: customer.wrappedValue.selectedIngredients)
    }
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let accentColor = Color(red: 0.9, green: 0.7, blue: 0.2)  // Mustard Yellow
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    private let purpleColor = Color(red: 0.4, green: 0.25, blue: 0.45)  // Muted Purple
    
    private var drinkRecipe: [DrinkIngredient] {
        Drink.allDrinks.first { $0.name == drink.name }?.recipe ?? []
    }
    
    private var drinkArticle: String {
        let firstLetter = drink.name.first?.lowercased() ?? ""
        return ["a", "e", "i", "o", "u"].contains(firstLetter) ? "an" : "a"
    }
    
    private func checkDrink() -> Bool {
        guard let matchedDrink = Drink.allDrinks.first(where: { $0.name == drink.name }),
              let selectedGlassware = selectedGlassware else {
            return false
        }
        
        // Check ingredients
        let ingredientsCorrect = selectedIngredients.count == matchedDrink.recipe.count &&
            selectedIngredients.allSatisfy { selected in
                matchedDrink.recipe.contains { target in
                    target.name == selected.name
                }
            }
        
        // Check ice type
        let iceCorrect = selectedIce == matchedDrink.requiredIce
        
        // Check method
        let methodCorrect = selectedMethod == matchedDrink.requiredMethod
        
        // Check glassware
        let glassCorrect = selectedGlassware == matchedDrink.requiredGlass
        
        return ingredientsCorrect && iceCorrect && methodCorrect && glassCorrect
    }
    
    private func updateCustomerState() {
        customer.selectedGlassware = selectedGlassware
        customer.selectedIce = selectedIce
        customer.selectedMethod = selectedMethod
        customer.selectedIngredients = selectedIngredients
    }
    
    // Add descriptions for MethodType
    private func methodDescription(_ method: MethodType) -> String {
        switch method {
        case .built:
            return "Building a drink involves adding ingredients directly to the glass and stirring gently. This method is ideal for drinks that are meant to be simple and refreshing, allowing the flavors to meld naturally."
        case .stirred:
            return "Stirring is a method where ingredients are mixed with ice in a mixing glass, then strained. This creates a smooth, clear drink that is perfect for spirit-forward cocktails, enhancing the complexity and balance of the flavors."
        case .shaken:
            return "Shaking is better for drinks with fresh ingredients because those cocktails tend to be lighter, citrusy and more refreshing. They benefit from a more vibrant, aerated texture and because they go down easily, we have a propensity to drink them quicker, so the added chill and dilution is a good thing."
        case .blended:
            return "Blending is used to create a smooth, frozen texture by combining ingredients with ice. This method is perfect for tropical and dessert cocktails, providing a refreshing and indulgent experience."
        case .roll:
            return "Rolling involves pouring ingredients back and forth between two vessels to mix gently. This method is ideal for delicate cocktails that require a light touch to maintain their integrity."
        case .layer:
            return "Layering is a technique where ingredients are carefully poured to create distinct layers. This method is used for visually striking cocktails, adding an element of artistry to the drink."
        }
    }
    // Add descriptions for IceType
    private func iceDescription(_ ice: IceType) -> String {
        switch ice {
        case .none:
            return "No Ice: Served without ice, allowing the drink to be enjoyed at room temperature."
        case .cubed:
            return "Cubed Ice: Standard ice cubes provide slow dilution, making them ideal for drinks that are meant to be savored over time."
        case .crushed:
            return "Crushed Ice: Small pieces of ice chill quickly and provide fast dilution, perfect for refreshing cocktails that are meant to be consumed quickly."
        case .sphere:
            return "Ice Sphere: Large round ice provides very slow dilution, making it ideal for premium spirits and cocktails that are meant to be enjoyed slowly."
        case .cracked:
            return "Cracked Ice: Broken cubes offer moderate dilution, suitable for a variety of cocktails that benefit from a balanced chill and dilution."
        case .dry:
            return "Dry Ice: Used for dramatic effect, not for consumption, adding a visual element to the drink."
        }
    }
    
    var body: some View {
        let placeholderIcon = "circle.dashed"
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    let darkBackgroundColor = Color(red: 0.22, green: 0.13, blue: 0.07)
                    HStack {
                        Text("Make \(drinkArticle) \(drink.name)")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.7)
                            .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
                            .padding(.vertical, 18)
                            .padding(.leading, 24)
                        Spacer()
                        Button(action: { isShowing = false }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.15))
                                    .frame(width: 44, height: 44)
                            Image(systemName: "chevron.up.circle.fill")
                                    .foregroundColor(.white)
                                .font(.title)
                                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.trailing, 16)
                    }
                    .background(darkBackgroundColor.edgesIgnoringSafeArea(.top))
                    
                    // Swipable content
                    TabView(selection: $currentPage) {
                        // Page 1: Method
                        ScrollView {
                            VStack(spacing: 20) {
                                // Method Section
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Method")
                                        .font(.headline)
                                        .foregroundColor(secondaryColor)
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                    // Description box
                                    Text(methodDescription(selectedMethod))
                                        .font(.custom("Georgia", size: 16))
                                        .foregroundColor(primaryColor)
                                        .padding(16)
                                        .frame(height: UIScreen.main.bounds.height * 0.2)
                                        .cornerRadius(8)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                        ForEach(MethodType.allCases, id: \ .self) { method in
                                            Button(action: { 
                                                selectedMethod = method
                                                updateCustomerState()
                                            }) {
                                                VStack(spacing: 6) {
                                                    Image(systemName: placeholderIcon)
                                                        .font(.system(size: 28, weight: .medium))
                                                        .foregroundColor(selectedMethod == method ? .white : secondaryColor)
                                                    Text(method.rawValue)
                                                        .font(.subheadline)
                                                        .foregroundColor(selectedMethod == method ? .white : secondaryColor)
                                                }
                                                .padding(.vertical, 12)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedMethod == method ? primaryColor : Color.white)
                                                .cornerRadius(12)
                                                .shadow(color: selectedMethod == method ? primaryColor.opacity(0.18) : Color.clear, radius: 2, x: 0, y: 1)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                        .tag(0)
                                
                        // Page 2: Ice
                        ScrollView {
                            VStack(spacing: 20) {
                                // Ice Selection
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Ice")
                                        .font(.headline)
                                        .foregroundColor(secondaryColor)
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                    // Description box
                                    Text(iceDescription(selectedIce))
                                        .font(.custom("Georgia", size: 16))
                                        .foregroundColor(primaryColor)
                                        .padding(16)
                                        .frame(height: UIScreen.main.bounds.height * 0.3)
                                        .cornerRadius(8)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                        ForEach(IceType.allCases, id: \ .self) { ice in
                                            Button(action: {
                                                selectedIce = ice
                                            }) {
                                                VStack(spacing: 6) {
                                                    Image(systemName: placeholderIcon)
                                                        .font(.system(size: 28, weight: .medium))
                                                        .foregroundColor(selectedIce == ice ? .white : secondaryColor)
                                                    Text(ice.rawValue)
                                                        .font(.subheadline)
                                                        .foregroundColor(selectedIce == ice ? .white : secondaryColor)
                                                }
                                                .padding(.vertical, 12)
                                                .frame(maxWidth: .infinity)
                                                .background(selectedIce == ice ? primaryColor : Color.white)
                                                .cornerRadius(12)
                                                .shadow(color: selectedIce == ice ? primaryColor.opacity(0.18) : Color.clear, radius: 2, x: 0, y: 1)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
                        }
                        .tag(1)
                        
                        // Page 3: Glassware Section
                        ScrollView {
                            VStack(spacing: 20) {
                                // Glassware Selection grouped by category
                                VStack(alignment: .leading, spacing: 8) {
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                    ForEach(GlasswareCategory.allCases, id: \.self) { category in
                                        let glasses = Glassware.allGlassware.filter { $0.category == category }
                                        if !glasses.isEmpty {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text(category.rawValue)
                                                    .font(.headline)
                                                    .foregroundColor(secondaryColor)
                                                Divider()
                                                
                                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                                    ForEach(glasses) { glassware in
                                        Button(action: { 
                                                            selectedGlassware = glassware
                                            updateCustomerState()
                                        }) {
                                                            VStack(spacing: 6) {
                                                                Image(systemName: placeholderIcon)
                                                                    .font(.system(size: 28, weight: .medium))
                                                                    .foregroundColor(selectedGlassware?.name == glassware.name ? .white : secondaryColor)
                                                                Text(glassware.shortName)
                                                                    .font(.subheadline)
                                                                    .foregroundColor(selectedGlassware?.name == glassware.name ? .white : secondaryColor)
                                                            }
                                                            .padding(.vertical, 12)
                                                .frame(maxWidth: .infinity)
                                                            .background(selectedGlassware?.name == glassware.name ? primaryColor : Color.white)
                                                            .cornerRadius(12)
                                                            .shadow(color: selectedGlassware?.name == glassware.name ? primaryColor.opacity(0.18) : Color.clear, radius: 2, x: 0, y: 1)
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.bottom, 16)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .tag(2)
                        // Page 4: Ingredients Section
                        ScrollView {
                            VStack(spacing: 20) {
                                // Empty for now
                            }
                        }
                        .tag(3)
                        // Page 5: Garnish Section
                        ScrollView {
                            VStack(spacing: 20) {
                                // Empty for now
                            }
                            .padding(.vertical)
                        }
                        .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom text-based navigation bar
                    HStack(spacing: 0) {
                        Button(action: { withAnimation { currentPage = 0 } }) {
                            Text("Method")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 0 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(currentPage == 0 ? primaryColor : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { withAnimation { currentPage = 1 } }) {
                            Text("Ice")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 1 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(currentPage == 1 ? primaryColor : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { withAnimation { currentPage = 2 } }) {
                            Text("Glass")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 2 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(currentPage == 2 ? primaryColor : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { withAnimation { currentPage = 3 } }) {
                            Text("Ingredients")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 3 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(currentPage == 3 ? primaryColor : Color.clear)
                                .cornerRadius(8)
                        }

                        Button(action: { withAnimation { currentPage = 4 } }) {
                            Text("Garnish")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 4 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(currentPage == 4 ? primaryColor : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(secondaryColor, lineWidth: 1.2)
                            .opacity(0.7)
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    
                    // Fixed bottom section
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                // Reset all selections
                                selectedGlassware = nil
                                selectedIce = .none
                                selectedMethod = .built
                                selectedIngredients = []
                            }) {
                                Image(systemName: "trash")
                                    .font(.title2)
                                    .foregroundColor(secondaryColor)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingRecipe = true
                            }) {
                                Image(systemName: "book.fill")
                                    .font(.title2)
                                    .foregroundColor(secondaryColor)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Serve button
                        Button(action: {
                            if let glassware = selectedGlassware,
                               !selectedIngredients.isEmpty {
                                let isCorrect = checkDrink()
                                onContinue(glassware, selectedIce, selectedMethod, isCorrect)
                                // Reset all selections regardless of correctness
                                selectedGlassware = nil
                                selectedIce = .none
                                selectedMethod = .built
                                selectedIngredients = []
                                // Reset customer's selections
                                customer.selectedGlassware = nil
                                customer.selectedIce = .none
                                customer.selectedMethod = .built
                                customer.selectedIngredients = []
                                isShowing = false
                            }
                        }) {
                            Text("Serve Drink")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedGlassware != nil && !selectedIngredients.isEmpty ? primaryColor : secondaryColor.opacity(0.3))
                                .cornerRadius(10)
                        }
                        .disabled(selectedGlassware == nil || selectedIngredients.isEmpty)
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 16)
                    .background(backgroundColor)
                }
            }
            .navigationBarHidden(true)
            .onDisappear {
                // Ensure customer state is saved when view disappears
                updateCustomerState()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(isPresented: $showingRecipe) {
            RecipeView(drinkName: drink.name, isShowing: $showingRecipe)
        }
    }
    
    private func iconName(for category: GlasswareCategory) -> String {
        switch category {
        case .tall:
            return "arrow.up.circle.fill"
        case .short:
            return "circle.fill"
        case .beer:
            return "mug.fill"
        case .wine:
            return "wineglass.fill"
        case .specialty:
            return "star.fill"
        case .cocktail:
            return "star.fill"
        }
    }
}

#Preview {
    PreparationView(
        drink: Drink(
            name: "Margarita",
            recipe: [
                DrinkIngredient(name: "Tequila", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Triple Sec", amount: 0.75)
            ],
            description: "A classic tequila cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            requiredGlass: Glassware.allGlassware.first(where: { $0.name == "Margarita Glass" })!,
            category: .cocktail,
            style: .classic,
            family: .margarita
        ),
        isShowing: .constant(true),
        customer: .constant(Customer(
            drinkOrder: "Margarita",
            avatarNumber: 1,
            orderPhrase: "I'd like a Margarita, please!",
            selectedGlassware: Glassware.allGlassware.first(where: { $0.name == "Margarita Glass" })!,
            selectedIce: .none,
            selectedMethod: .shaken,
            selectedIngredients: []
        )),
        currentCustomerIndex: .constant(0)
    ) { _, _, _, _ in
        // Preview action
    }
} 
