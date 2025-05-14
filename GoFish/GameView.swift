//
//  GameView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI

struct GameView: View {
    //Card Model
    //Player Deck Array of Strings
    //Computer Deck Array of Strings
    //Shuffle Class
    //Class keeps track of what cards can be asked for
    let playerHand: [Card] = []
    let computerHand: [Card] = []
    var body: some View {
         ZStack{
            Image("background").ignoresSafeArea()
             Button("Start Game", action: startGame)
             ForEach(playerHand, id: \.self){ card in
                CardView(cardName: card.fileName)
            }
        }
    }
      func initializeHand(){
          for(int i = 0; i ++; i < 8){
              playerHand.append(Card.randomElement())
    }

    func shuffleDeck(){
        
    }
   func startGame(){
    initializeHand()
    }
}
struct CardView: View{
    let cardName: String
    var body: some View{
        Image(cardName)
            .resizable()
            .aspectRatio(2/3, contentMode: .fit)
    }
}
#Preview {
    GameView()
}
