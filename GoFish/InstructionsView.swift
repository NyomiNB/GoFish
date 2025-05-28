//
//  InstructionsView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack{
            Text("How To Play")
                .bold()
                .font(.largeTitle)
            Text("Goal:")
                .bold()
                .font(.title2)
            Text("Create as many books as possible")
                .font(.title3)
             Text("How do I create books?")
                .multilineTextAlignment(.center)
                .bold()
                .font(.title2)
            Text("Books can be created by clicking on four matching suits in your hand")
                .multilineTextAlignment(.leading)
                .font(.title3)
            Text("What if I run out of matching cards?")
                .bold()
                .font(.title2)
            Text("You can get new cards by 'fishing', or asking players for a card to complete your book. The player with the most books when the deck runs out, or a player runs out of cards, wins.")
                .multilineTextAlignment(.leading)
                .font(.title3)
            
        }
    }
}

#Preview {
    InstructionsView()
}
