import SwiftUI

extension String {
    var article: String {
        let firstWord = self.components(separatedBy: " ").first ?? ""
        let firstChar = firstWord.lowercased().first ?? " "
        let isVowel = ["a", "e", "i", "o", "u"].contains(String(firstChar))
        return isVowel ? "an" : "a"
    }
}

struct CustomerOrderView: View {
    let drink: Drink
    @State private var isOrderComplete = false
    @State private var isCorrect = false
    
    var body: some View {
        VStack {
            if isOrderComplete {
                Text(isCorrect ? "Here's \(drink.name.article) \(drink.name)!" : "This isn't \(drink.name.article) \(drink.name)!")
                    .font(.title2)
                    .foregroundColor(isCorrect ? .green : .red)
                    .padding()
            } else {
                Text("I'd like \(drink.name.article) \(drink.name), please!")
                    .font(.title2)
                    .padding()
            }
        }
    }
}

#Preview {
    CustomerOrderView(drink: Drink.allDrinks[0])
} 