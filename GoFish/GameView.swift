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
    @State var playerHand = [String]()
    @State var computerHand = [String]()
    @State var deck = [String]()
      func startGame(){
     }
    var body: some View {
        NavigationView{
            ZStack{
                Image("background").ignoresSafeArea()
                HStack{
                    ForEach(playerHand, id: \.self){ card in
                        
                        Image(card)
                            .resizable()
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                 }
             }
        }
        .onAppear(){
            deckInit()
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

    func initializeHand(){
         for _ in 1...7{
            deck.shuffle()
            playerHand.append(deck.last ?? "")
            deck.removeLast()
            computerHand.append(deck.last ?? "")
            deck.removeLast()
        }
        for element in playerHand {
            print("\(element)")
        }
    }
     //initializes deck
      func deckInit(){
        let suitNum = 1...4
        let rankNum = 1...10
        for num in suitNum{
            for numbers in rankNum{
                deck.append("\(num)-\(numbers)")
            }
        }
        for element in deck {
            print("\(element)")
        }
    }
         func shuffleDeck(){
            
        }
 
 
    }
#Preview {
    GameView()
}
