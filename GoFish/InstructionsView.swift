//
//  InstructionsView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        Text("How To Play!")
            .bold()
            .font(.largeTitle)
        Text("Goal")
            .bold()
        Text("How To Play")
        Text("The player with the most books when the deck runs out, or a player runs out of cards, wins")

        Text("Get four cards with the same number in order to create 'books'")
        Text("You can get new cards by 'fishing', or asking players for a card to complete your book")
        Text("The player with the most books when the deck runs out, or a player runs out of cards, wins")
     }
}

#Preview {
    InstructionsView()
}
