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
        case .aromatics:
            return "leaf.fill"
        case .beer:
            return "mug.fill"
        case .wine:
            return "wineglass.fill"
        case .mixers:
            return "homepod.fill"
        case .fruit:
            return "applelogo"
        case .sweeteners:
            return "cube.fill"
        case .other:
            return "questionmark.circle.fill"
        }
    }
}

struct PreparationView: View {
    let drink: Drink
    @Environment(\.dismiss) private var dismiss
    @Binding var isShowing: Bool
    let onContinue: (Glassware, IceType, MethodType, Bool, Double) -> Void
    
    @Binding var customer: Customer
    @Binding var currentCustomerIndex: Int
    
    @State private var selectedGlassware: Glassware?
    @State private var selectedIce: IceType = .none
    @State private var selectedMethod: MethodType = .built
    @State private var showingRecipe = false
    @State private var selectedIngredients: [DrinkIngredient] = []
    @State private var selectedGarnishes: [Garnish] = []
    @State private var currentPage: Int = 0
    @State private var showingIngredientSubList = false
    @State private var selectedIngredientCategory: IngredientCategory?
    @State private var showingGarnishSubList = false
    @State private var selectedGarnishCategory: GarnishCategory?
    @State private var showingGlasswareSubList = false
    @State private var selectedGlasswareCategory: GlasswareCategory?
    
    init(drink: Drink, isShowing: Binding<Bool>, customer: Binding<Customer>, currentCustomerIndex: Binding<Int>, onContinue: @escaping (Glassware, IceType, MethodType, Bool, Double) -> Void) {
        self.drink = drink
        self._isShowing = isShowing
        self._customer = customer
        self._currentCustomerIndex = currentCustomerIndex
        self.onContinue = onContinue
        
        _selectedGlassware = State(initialValue: customer.wrappedValue.selectedGlassware)
        _selectedIce = State(initialValue: customer.wrappedValue.selectedIce)
        _selectedMethod = State(initialValue: customer.wrappedValue.selectedMethod ?? .built)
        _selectedIngredients = State(initialValue: customer.wrappedValue.selectedIngredients)
        _selectedGarnishes = State(initialValue: customer.wrappedValue.selectedGarnishes)
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
        
        // Check glassware using new glass requirement system
        let glassCorrect = matchedDrink.glassRequirement.isValidGlass(selectedGlassware)
        
        // Check garnish using new garnish requirement system
        let garnishCorrect: Bool = {
            let req = matchedDrink.garnishRequirement
            if req.ideal.isEmpty && req.acceptable.isEmpty {
                // No garnish required
                return selectedGarnishes.isEmpty || selectedGarnishes.contains(where: { $0.name == "None" })
            }
            // If required, must have at least one garnish
            if req.required && selectedGarnishes.isEmpty {
                return false
            }
            // All selected garnishes must be valid
            return selectedGarnishes.allSatisfy { req.isValidGarnish($0) }
        }()
        
        return ingredientsCorrect && iceCorrect && methodCorrect && glassCorrect && garnishCorrect
    }
    
    private func getTipMultiplier() -> Double {
        guard let matchedDrink = Drink.allDrinks.first(where: { $0.name == drink.name }),
              let selectedGlassware = selectedGlassware else {
            return 0.0
        }
        let glassMultiplier = matchedDrink.glassRequirement.getTipMultiplier(for: selectedGlassware)
        let garnishMultiplier: Double = {
            let req = matchedDrink.garnishRequirement
            if selectedGarnishes.isEmpty {
                return req.allowsNoGarnish() ? 1.0 : 0.2
            }
            // Use the best (highest) multiplier among selected garnishes
            return selectedGarnishes.map { req.getTipMultiplier(for: $0) }.max() ?? 0.2
        }()
        // Combine multipliers (e.g., average)
        return ((glassMultiplier + garnishMultiplier) / 2.0).rounded(to: 2)
    }
    
    private func updateCustomerState() {
        customer.selectedGlassware = selectedGlassware
        customer.selectedIce = selectedIce
        customer.selectedMethod = selectedMethod
        customer.selectedIngredients = selectedIngredients
        customer.selectedGarnishes = selectedGarnishes
    }
    
    // Add descriptions for MethodType
    private func methodDescription(_ method: MethodType) -> String {
        switch method {
        case .built:
            return "Building a drink involves adding ingredients directly to the glass.\n\nThis method is ideal for drinks that are meant to be simple and allows the flavors to meld naturally"
        case .stirred:
            return "Stirring is a method where ingredients are mixed with ice in a mixing glass.\n\nThis creates a smooth, clear drink that is perfect for spirit-forward cocktails"
        case .shaken:
            return "Shaking is better for drinks with fresh ingredients and tend to be lighter.\n\nThey benefit from an aerated texture and they go down easily, so the added dilution is a good thing."
        case .blended:
            return "Blending is used to create a smooth, frozen texture by blitzing ingredients with ice.\n\nThis method is perfect for tropical and dessert cocktails"
        case .roll:
            return "Rolling involves pouring ingredients back and forth between two vessels to mix gently.\n\nThis method is ideal for delicate cocktails to maintain their integrity"
        case .layer:
            return "Layering is a technique where ingredients are carefully poured to create distinct layers.\n\nThis method is used for visually striking cocktails, adding an element of artistry to the drink"
        }
    }
    // Add descriptions for IceType
    private func iceDescription(_ ice: IceType) -> String {
        switch ice {
        case .none:
            return "Served without ice, allowing the drink to be enjoyed at room temperature.\n\nThis method is ideal for spirits that are meant to be sipped slowly"
        case .cubed:
            return "Standard ice cubes provide slow dilution while keeping the drink cold.\n\nThey are perfect for spirit-forward cocktails that are meant to be savored over time"
        case .crushed:
            return "Small pieces of ice chill quickly and provide fast dilution. \n\nThis is most suited to refreshing cocktails that are meant to be consumed quickly"
        case .sphere:
            return "Large round ice provides very slow dilution due to reduced surface area. \n\nOften used for premium spirits and cocktails that are meant to be enjoyed slowly"
        case .cracked:
            return "Broken cubes offer moderate dilution somewhere between ctandard and crushed ice. \n\nSuited to cocktails that benefit from a balance between chill and dilution"
        case .dry:
            return "Used for dramatic effect, not for consumption, adding a visual element to the drink.\n\nIt creates a striking presentation that is perfect for special occasions and themed events."
        }
    }
    
    // Move iconName here for use in ingredients grid and elsewhere
    private func iconName(for category: IngredientCategory) -> String {
        switch category {
        case .spirits:
            return "drop.fill"
        case .liqueurs:
            return "wineglass.fill"
        case .aromatics:
            return "leaf.fill"
        case .beer:
            return "mug.fill"
        case .wine:
            return "wineglass.fill"
        case .mixers:
            return "homepod.fill"
        case .fruit:
            return "applelogo"
        case .sweeteners:
            return "cube.fill"
        case .other:
            return "questionmark.circle.fill"
        }
    }
    
    // Add iconName function for garnish categories
    private func iconName(for category: GarnishCategory) -> String {
        switch category {
        case .citrus:
            return "leaf.fill"
        case .fruit:
            return "applelogo"
        case .herb:
            return "leaf.circle.fill"
        case .spice:
            return "sparkles"
        case .rim:
            return "circle.dashed"
        case .other:
            return "questionmark.circle.fill"
        }
    }
    
    // Add iconName function for glassware categories
    private func iconName(for category: GlasswareCategory) -> String {
        switch category {
        case .beer:
            return "mug.fill"
        case .wine:
            return "wineglass.fill"
        case .specialty:
            return "star.fill"
        case .tall:
            return "rectangle.portrait.fill"
        case .short:
            return "rectangle.fill"
        case .cocktail:
            return "drop.fill"
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
                                    .foregroundColor(Color.white)
                                    .font(.title)
                                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 1)
                            }
                        }
                        .padding(.trailing, 16)
                    }
                    .background(darkBackgroundColor.edgesIgnoringSafeArea(.top))
                    
                    // Custom text-based navigation bar - moved here under header
                    HStack(spacing: 0) {
                        Button(action: { withAnimation { currentPage = 0 } }) {
                            Text("Method")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 0 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(currentPage == 0 ? primaryColor : Color.clear)
                                .cornerRadius(4)
                        }
                        
                        Button(action: { withAnimation { currentPage = 1 } }) {
                            Text("Ice")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 1 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(currentPage == 1 ? primaryColor : Color.clear)
                                .cornerRadius(4)
                        }
                        
                        Button(action: { withAnimation { currentPage = 2 } }) {
                            Text("Glass")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 2 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(currentPage == 2 ? primaryColor : Color.clear)
                                .cornerRadius(4)
                        }
                        
                        Button(action: { withAnimation { currentPage = 3 } }) {
                            Text("Ingredients")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 3 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(currentPage == 3 ? primaryColor : Color.clear)
                                .cornerRadius(4)
                        }

                        Button(action: { withAnimation { currentPage = 4 } }) {
                            Text("Garnish")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(currentPage == 4 ? .white : secondaryColor)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(currentPage == 4 ? primaryColor : Color.clear)
                                .cornerRadius(4)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(secondaryColor, lineWidth: 1.2)
                            .opacity(0.7)
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .padding(.top, 12)
                    
                    // Swipable content
                    TabView(selection: $currentPage) {
                        // Page 1: Method
                        ScrollView {
                            VStack(spacing: 20) {
                                // Method Section
                                VStack(alignment: .leading, spacing: 8) {
                                    // Description box
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 120))
                                        .foregroundColor(primaryColor)
                                        .padding(.top, 10)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text(methodDescription(selectedMethod))
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                        .padding(10)
                                        .frame(height: UIScreen.main.bounds.height * 0.14, alignment: .top)
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
                                    // Description box
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 120))
                                        .foregroundColor(primaryColor)
                                        .padding(.top, 10)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text(iceDescription(selectedIce))
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                        .padding(10)
                                        .frame(height: UIScreen.main.bounds.height * 0.14, alignment: .top)
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
                                // Glassware Selection
                                VStack(alignment: .leading, spacing: 8) {
                                    // Description box
                                    Image(systemName: "questionmark.circle")
                                        .font(.system(size: 120))
                                        .foregroundColor(primaryColor)
                                        .padding(.top, 10)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("Browse the categories to select the glassware you need")
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                        .padding(10)
                                        .frame(height: UIScreen.main.bounds.height * 0.08, alignment: .top)
                                        .cornerRadius(8)
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                        ForEach(GlasswareCategory.allCases, id: \ .self) { category in
                                        Button(action: { 
                                                selectedGlasswareCategory = category
                                                showingGlasswareSubList = true
                                        }) {
                                            VStack(spacing: 6) {
                                                    Image(systemName: iconName(for: category))
                                                    .font(.system(size: 28, weight: .medium))
                                                        .foregroundColor(secondaryColor)
                                                    Text(category.rawValue)
                                                    .font(.subheadline)
                                                        .foregroundColor(secondaryColor)
                                            }
                                            .padding(.vertical, 12)
                                            .frame(maxWidth: .infinity)
                                                .frame(height: 80)
                                                .background(Color.white)
                                            .cornerRadius(12)
                                                .shadow(color: Color.clear, radius: 2, x: 0, y: 1)
                                        }
                                    }
                                }
                                }
                                .padding(.horizontal)
                                
                                // Selected Glassware Box
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Selected Glassware")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(secondaryColor)
                                        
                                        Spacer()
                                        
                                        if selectedGlassware != nil {
                                            Button(action: {
                                                selectedGlassware = nil
                                                updateCustomerState()
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                        .padding(.horizontal)
                                    
                                    if selectedGlassware == nil {
                                        Text("No glassware selected")
                                            .font(.caption)
                                            .foregroundColor(secondaryColor.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.vertical, 20)
                                    } else {
                                        HStack {
                                            Image(systemName: "wineglass.fill")
                                                .font(.caption)
                                                .foregroundColor(secondaryColor)
                                            Text(selectedGlassware?.shortName ?? "")
                                                .font(.caption)
                                                .foregroundColor(secondaryColor)
                                            Spacer()
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .tag(2)
                        // Page 4: Ingredients Section
                        ScrollView {
                            VStack(spacing: 20) {
                                // Ingredients Section
                                VStack(alignment: .leading, spacing: 8) {
                                    // Description box
                                    HStack(alignment: .top, spacing: 12) {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 60))
                                            .foregroundColor(primaryColor)
                                        Text("Browse the categories to select the ingredients you need")
                                            .font(.subheadline)
                                            .foregroundColor(primaryColor)
                                            .padding(10)
                                            .frame(height: UIScreen.main.bounds.height * 0.1, alignment: .top)
                                            .cornerRadius(8)
                                    }
                                    .padding(.top, 10)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                        ForEach(IngredientCategory.allCases, id: \ .self) { category in
                                            Button(action: {
                                                selectedIngredientCategory = category
                                                showingIngredientSubList = true
                                            }) {
                                                VStack(spacing: 6) {
                                                    Image(systemName: iconName(for: category))
                                                        .font(.system(size: 28, weight: .medium))
                                                        .foregroundColor(secondaryColor)
                                                    Text(category.rawValue)
                                                        .font(.subheadline)
                                                        .foregroundColor(secondaryColor)
                                                }
                                                .padding(.vertical, 12)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 80)
                                                .background(Color.white)
                                                .cornerRadius(12)
                                                .shadow(color: Color.clear, radius: 2, x: 0, y: 1)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Selected Ingredients Box
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                    Text("Selected Ingredients")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundColor(secondaryColor)
                                        
                                        Spacer()
                                        
                                        if !selectedIngredients.isEmpty {
                                            Button(action: {
                                                selectedIngredients = []
                                                updateCustomerState()
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor)
                                            }
                                        }
                                    }
                                        .padding(.horizontal)
                                    
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                        .padding(.horizontal)
                                    
                                    if selectedIngredients.isEmpty {
                                        Text("No ingredients selected")
                                            .font(.caption)
                                            .foregroundColor(secondaryColor.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.vertical, 20)
                                    } else {
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                            ForEach(selectedIngredients, id: \.id) { ingredient in
                                                Text(ingredient.shortName)
                                            .font(.caption)
                                            .foregroundColor(secondaryColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                    }
                                    .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .tag(3)
                        // Page 5: Garnish Section
                        ScrollView {
                            VStack(spacing: 20) {
                                // Garnish Selection
                                VStack(alignment: .leading, spacing: 8) {
                                    // Description box
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 120))
                                        .foregroundColor(primaryColor)
                                        .padding(.top, 10)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Text("Browse the categories to select the garnishes you need")
                                        .font(.subheadline)
                                        .foregroundColor(primaryColor)
                                        .padding(10)
                                        .frame(height: UIScreen.main.bounds.height * 0.08, alignment: .top)
                                        .cornerRadius(8)
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                        ForEach(GarnishCategory.allCases, id: \ .self) { category in
                                            Button(action: {
                                                selectedGarnishCategory = category
                                                showingGarnishSubList = true
                                            }) {
                                                VStack(spacing: 6) {
                                                    Image(systemName: iconName(for: category))
                                                        .font(.system(size: 28, weight: .medium))
                                                        .foregroundColor(secondaryColor)
                                                    Text(category.rawValue)
                                                        .font(.subheadline)
                                                        .foregroundColor(secondaryColor)
                                                }
                                                .padding(.vertical, 12)
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 80)
                                                .background(Color.white)
                                                .cornerRadius(12)
                                                .shadow(color: Color.clear, radius: 2, x: 0, y: 1)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                // Selected Garnishes Box
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text("Selected Garnishes")
                                .font(.caption)
                                .fontWeight(.bold)
                                            .foregroundColor(secondaryColor)
                                        
                                        Spacer()
                                        
                                        if !selectedGarnishes.isEmpty {
                                            Button(action: {
                                                selectedGarnishes = []
                                                updateCustomerState()
                                            }) {
                                                Image(systemName: "trash")
                                .font(.caption)
                                                    .foregroundColor(secondaryColor)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    Divider()
                                        .background(secondaryColor.opacity(0.3))
                                        .padding(.horizontal)
                                    
                                    if selectedGarnishes.isEmpty {
                                        Text("No garnishes selected")
                                .font(.caption)
                                            .foregroundColor(secondaryColor.opacity(0.6))
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .padding(.vertical, 20)
                                    } else {
                                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                                            ForEach(selectedGarnishes, id: \.id) { garnish in
                                                Text(garnish.shortName)
                                                    .font(.caption)
                                                    .foregroundColor(secondaryColor)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.vertical)
                        }
                        .tag(4)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Footer
                    VStack(spacing: 16) {
                        HStack {
                            Button(action: {
                                // Reset all selections
                                selectedGlassware = nil
                                selectedIce = .none
                                selectedMethod = .built
                                selectedIngredients = []
                                selectedGarnishes = []
                                updateCustomerState()
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
                                let tipMultiplier = getTipMultiplier()
                                onContinue(glassware, selectedIce, selectedMethod, isCorrect, tipMultiplier)
                                // Reset all selections regardless of correctness
                                selectedGlassware = nil
                                selectedIce = .none
                                selectedMethod = .built
                                selectedIngredients = []
                                selectedGarnishes = []
                                // Reset customer's selections
                                customer.selectedGlassware = nil
                                customer.selectedIce = .none
                                customer.selectedMethod = .built
                                customer.selectedIngredients = []
                                customer.selectedGarnishes = []
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
        .sheet(isPresented: $showingIngredientSubList) {
            if let category = selectedIngredientCategory {
                IngredientSubListView(
                    category: category,
                    isShowing: $showingIngredientSubList,
                    selectedIngredients: $selectedIngredients,
                    onIngredientsChanged: updateCustomerState
                )
            }
        }
        .sheet(isPresented: $showingGarnishSubList) {
            if let category = selectedGarnishCategory {
                GarnishSubListView(
                    category: category,
                    isShowing: $showingGarnishSubList,
                    selectedGarnishes: $selectedGarnishes,
                    onGarnishesChanged: updateCustomerState
                )
            }
        }
        .sheet(isPresented: $showingGlasswareSubList) {
            if let category = selectedGlasswareCategory {
                GlasswareSubListView(
                    category: category,
                    isShowing: $showingGlasswareSubList,
                    selectedGlassware: $selectedGlassware,
                    onGlasswareChanged: updateCustomerState,
                    onGlasswareSelected: {
                        // Automatically navigate to ingredients page when glass is selected
                        withAnimation {
                            currentPage = 3
                        }
                    }
                )
            }
        }
    }
}

struct IngredientSubListView: View {
    let category: IngredientCategory
    @Binding var isShowing: Bool
    @Binding var selectedIngredients: [DrinkIngredient]
    let onIngredientsChanged: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    private var ingredientsBySubcategory: [String: [DrinkIngredient]] {
        let filteredIngredients = DrinkIngredient.availableIngredients.filter { $0.category == category }
        return Dictionary(grouping: filteredIngredients) { $0.subcategory }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text(category.rawValue)
                            .font(.title2)
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
                    .padding()
                    
                    // Ingredients by Subcategory
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(Array(ingredientsBySubcategory.keys.sorted()), id: \.self) { subcategory in
                                VStack(alignment: .leading, spacing: 12) {
                                    // Subcategory Header
                                    Text(subcategory)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(secondaryColor)
                                        .padding(.horizontal)
                                    
                                    // Ingredients Grid for this subcategory
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                                        ForEach(ingredientsBySubcategory[subcategory] ?? [], id: \.id) { ingredient in
                                Button(action: {
                                    if selectedIngredients.contains(ingredient) {
                                        selectedIngredients.removeAll { $0.id == ingredient.id }
                                    } else {
                                        selectedIngredients.append(ingredient)
                                    }
                                                onIngredientsChanged()
                                }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "circle.dashed")
                                            .font(.system(size: 28, weight: .medium))
                                            .foregroundColor(selectedIngredients.contains(ingredient) ? .white : secondaryColor)
                                        Text(ingredient.shortName)
                                                        .font(.subheadline)
                                            .foregroundColor(selectedIngredients.contains(ingredient) ? .white : secondaryColor)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .background(selectedIngredients.contains(ingredient) ? primaryColor : Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: selectedIngredients.contains(ingredient) ? primaryColor.opacity(0.18) : Color.clear, radius: 2, x: 0, y: 1)
                                }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct GarnishSubListView: View {
    let category: GarnishCategory
    @Binding var isShowing: Bool
    @Binding var selectedGarnishes: [Garnish]
    let onGarnishesChanged: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    private var filteredGarnishes: [Garnish] {
        Garnish.allGarnishes.filter { $0.category == category }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text(category.rawValue)
                            .font(.title2)
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
                        .padding()
                    
                    // Garnishes Grid
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(filteredGarnishes, id: \.id) { garnish in
                                Button(action: {
                                    if selectedGarnishes.contains(garnish) {
                                        selectedGarnishes.removeAll { $0.id == garnish.id }
                                    } else {
                                        selectedGarnishes.append(garnish)
                                    }
                                    onGarnishesChanged()
                                }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "circle.dashed")
                                            .font(.system(size: 28, weight: .medium))
                                            .foregroundColor(selectedGarnishes.contains(garnish) ? .white : secondaryColor)
                                        Text(garnish.shortName)
                                            .font(.subheadline)
                                            .foregroundColor(selectedGarnishes.contains(garnish) ? .white : secondaryColor)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .background(selectedGarnishes.contains(garnish) ? primaryColor : Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: selectedGarnishes.contains(garnish) ? primaryColor.opacity(0.18) : Color.clear, radius: 2, x: 0, y: 1)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct GlasswareSubListView: View {
    let category: GlasswareCategory
    @Binding var isShowing: Bool
    @Binding var selectedGlassware: Glassware?
    let onGlasswareChanged: () -> Void
    let onGlasswareSelected: () -> Void
    
    private let primaryColor = Color(red: 0.8, green: 0.4, blue: 0.2)  // Burnt Orange
    private let secondaryColor = Color(red: 0.6, green: 0.3, blue: 0.1)  // Brown
    private let backgroundColor = Color(red: 0.95, green: 0.9, blue: 0.8)  // Cream
    
    private var filteredGlassware: [Glassware] {
        Glassware.allGlassware.filter { $0.category == category }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text(category.rawValue)
                            .font(.title2)
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
                    .padding()
                    
                    // Description box
                    VStack(spacing: 8) {
                        Image(systemName: "wineglass.fill")
                            .font(.system(size: 120))
                            .foregroundColor(primaryColor)
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                        Text("Select the appropriate glassware for your drink")
                            .font(.subheadline)
                            .foregroundColor(primaryColor)
                            .padding(10)
                            .frame(height: UIScreen.main.bounds.height * 0.14, alignment: .top)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Glassware Grid
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                            ForEach(filteredGlassware, id: \.id) { glassware in
                                Button(action: {
                                    selectedGlassware = glassware
                                    onGlasswareChanged()
                                    onGlasswareSelected()
                                    isShowing = false
                                }) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "wineglass.fill")
                                            .font(.system(size: 28, weight: .medium))
                                            .foregroundColor(secondaryColor)
                                        Text(glassware.shortName)
                                            .font(.subheadline)
                                            .foregroundColor(secondaryColor)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 80)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: Color.clear, radius: 2, x: 0, y: 1)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    PreparationView(
        drink: Drink(
            name: "Margarita",
            recipe: [
                DrinkIngredient(name: "Blanco Tequila", amount: 2.0),
                DrinkIngredient(name: "Lime Juice", amount: 1.0),
                DrinkIngredient(name: "Triple Sec", amount: 0.75)
            ],
            description: "A classic tequila cocktail",
            requiredIce: .none,
            requiredMethod: .shaken,
            glassRequirement: GlassRequirement(
                ideal: [Glassware.allGlassware.first(where: { $0.name == "Margarita Glass" })!]
            ),
            garnishRequirement: GarnishRequirement(
                ideal: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!],
                acceptable: [Garnish.allGarnishes.first(where: { $0.name == "Mint Leaf" })!]
            ),
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
            selectedIngredients: [],
            selectedGarnishes: [Garnish.allGarnishes.first(where: { $0.name == "Lime Wheel" })!]
        )),
        currentCustomerIndex: .constant(0)
    ) { _, _, _, _, _ in
        // Preview action
    }
} 
