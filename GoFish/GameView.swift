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
    @State var cards: [Card]
    @ObservedObject var viewModel: GoFishGame
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var players: [Player]
//    @State var cards:[Card]
    var body: some View {
        NavigationView{
//            ZStack{
//                Image("background").ignoresSafeArea()
//                VStack {
                    
                    ScrollView(.horizontal){
                        HStack{
                                                        ForEach(players[0].cards){card in
                                                            CardView(cardName: card.filename)
                                                                .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 2:4, spacing: 16)

                                                        }
 
                        }
                        .scrollTargetLayout()

 
                        //                    LazyVGrid(columns: [.init(.flexible(minimum:50), spacing: 10)]){
                        //                        HStack{
                        //                            ForEach(players[0].cards){card in
                        //                                CardView(cardName: card.filename)
                        //                            }
                        //                        }
                        //
                        //                    }
                    }
                    .contentMargins(50, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)

//                    .frame(maxHeight: 100)
//                    .scrollTargetBehavior(.viewAligned)
                }
//                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: -67)]){
//                            ForEach(players[0].cards){card in
//                                CardView(cardName: card.filename)
//                            }
// 
//                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: -76)]){
//                            ForEach(player[0].cards){card in
//                                CardView(cardName: card.fileName)
//                            }
//                        }
//                        .frame(width: 500)
//                        .scaleEffect(0.75)
                        
                 //   }
                
         //   }
        //}
        .onAppear(){
            
            printTest()
            
            //            deckInit()
            //            initializeHand()
        }
    }
    struct CardView: View{
        let cardName: String
        var body: some View{
            Image(cardName)
                .resizable()
                .scaledToFit()
//                .aspectRatio(2/3, contentMode: .fit)
            
        }
    }
    func printTest(){
        for element in players[0].cards {
            print("\(element)")
                }

    }
}
 
//    func initializeHand(){
//         for _ in 1...7{
//            deck.shuffle()
//            playerHand.append(deck.last ?? "")
//            deck.removeLast()
//            computerHand.append(deck.last ?? "")
//            deck.removeLast()
//        }
//        for element in playerHand {
//            print("\(element)")
//        }
//    }
     //initializes deck
//      func deckInit(){
//        let suitNum = 1...4
//        let rankNum = 1...10
//        for num in suitNum{
//            for numbers in rankNum{
//                deck.append("\(num)-\(numbers)")
//            }
//        }
//        for element in deck {
//            print("\(element)")
//        }
//    }
//         func shuffleDeck(){
//            
//        }
    //    struct CardView: View{
    //        let cardName: String
    //        var body: some View{
    //            Image(cardName)
    //                .resizable()
    //                .aspectRatio(2/3, contentMode: .fit)
    //
    //        }
    //    }

 
    //}
#Preview{

    GameView(cards: testData, players: playerTest)
    //struct ContentView_Previews: PreviewProvider{
//    static var previews: some View{
//        let deck = Deck()
//        
//        GameView(players: testData)
//    }
}
