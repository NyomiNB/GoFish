//
//  GameView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI
 
struct GameView: View {
    @ObservedObject var viewModel: GoFishGame

    //Card Model
    //Player Deck Array of Strings
    //Computer Deck Array of Strings
    //Shuffle Class
    //Class keeps track of what cards can be asked for
    //  @State var cards: [Card]
@State var chosenCard = "..."
    //let vowels: [Character] = ["a", "e", "i", "o","u"]
     @State var playerTurn: Bool
 
    @Environment(\.verticalSizeClass) var verticalSizeClass
    // @State var players: [Player]
    //    @State var cards:[Card]
    var body: some View {
 
        //        Text("Computer Books \(viewModel.players[0].books)")
        //        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: -75)]){
        //            ForEach(viewModel.players[0].cards){card in
        //                CardView(cardName: "back")
        //            }
        //        }
        //                    .frame(maxHeight: 100)
        //                    .scrollTargetBehavior(.viewAligned)
        //        ZStack{
        //            Image("background").ignoresSafeArea()
        
        //                Rectangle()
        //                    .foregroundColor(.yellow)
        //        Text(handStr)
        //            .font(.title)
        //CardView(cardName: "back")
        var hand = viewModel.evaluateHand(of: viewModel.players[1])
         var handStr = "\(hand)"
        Text(handStr)
            .font(.title)
        Text("User Books \(viewModel.players[1].books)")
        ScrollView(.horizontal){
            HStack{
                ForEach($viewModel.players[1].cards){$card in
                    CardView(cardName: card.filename)
                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 2:4, spacing: 5)
                    
                        .onTapGesture{
                            if playerTurn{
                                card.selected.toggle()
                                //                                viewModel.select(card, in: viewModel.players[0])
                                chosenCard = card.suit.name
                                
                             }
                            
                            
                        }
                        .offset(y: card.selected ? -30 : 0)

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
            print(viewModel.players[1].cards.count)
            printTest()
            let startingPlayer = viewModel.chooseStartingPlayer()
            playerTurn = startingPlayer.playerName == "User"
print(startingPlayer.playerName)
            
//            if viewModel.chooseStartingPlayer().playerName == "User"{
//               print(viewModel.chooseStartingPlayer().playerName)
//                playerTurn = true
////
//            } else {
//                playerTurn = false
//            }
//            print("Player name is \(startPlayer().playerName)")
           print(playerTurn) //            deckInit()
            //            initializeHand()
        }
        VStack{
            Button(action: {
                print("Go fish")
             goFish()
             }, label: {
                Text("Go Fish")        })
            .disabled(!playerTurn)

            HStack{
//                Button(action: {
//                    print("Dra Card")
//                }, label: {
//                    Text("Play Card")  })
//                .disabled(playerTurn)
                
                Button(action: {
                    print("Create book")
                    createUserBook(book: handStr)
                     viewModel.players[1].cards = viewModel.players[1].cards
                    hand = viewModel.evaluateHand(of: viewModel.players[1])

                 }, label: {
                    Text("Create Book")        })
                .disabled(!playerTurn)

                
                Button(action: {
                    print("Ask")
                }, label: {
                    Text("Ask for a \(chosenCard)")
                }
                       //   .disabled(<#T##disabled: Bool##Bool#>)
                )
                .disabled(!playerTurn)

            }
        }
        .onChange(of: playerTurn) {
            print("on change works!")

             if !playerTurn{
                 print("Compjter going")

                computerTurn()
            } else {
                print("Compjter not going")

            }
        }

    }

//    struct computerView: View{
//        var body: some View{
//
// 
//                }
//            }
//        }
//
//    }
    
    struct CardView: View{
        let cardName: String
        var body: some View{
            Image(cardName)
                .resizable()
                .scaledToFit()
            //                .aspectRatio(2/3, contentMode: .fit)
            
        }
    }
    func goFish(){
        let card = viewModel.drawCard()
        viewModel.players[1].cards.append(card)
        viewModel.players[1].cards = viewModel.players[1].cards
      //force refresh
        viewModel.players = viewModel.players
        playerTurn = !playerTurn
    }
    func createUserBook(book: String){
        print(book)
        var valid = false
            if book == "Book" {
                viewModel.players[1].books = viewModel.players[1].books + 1
                  valid = true
 
            }
            //remove elements
        if valid {
            
            print("working")
            viewModel.players[1].cards = viewModel.players[1].cards.filter{ !$0.selected }
             printTest()
            for i in 0..<viewModel.players[1].cards.count {
                viewModel.players[1].cards[i].selected = false
            }
                //refreshes view
            viewModel.players = viewModel.players
            playerTurn = !playerTurn

                //var count = 0
////
//            viewModel.players[1].cards = viewModel.players[1].cards.filter { _ in
//                if viewModel.players[1].cards[count].selected {
//                    count += 1
//                    return false
//                } else {
//                    return true
//                }
          //  }
            //            var count = 0...viewModel.players[1].cards.count
//          print(count)
//            for number in count {
//                
//                if viewModel.players[1].cards[number].selected{
//                    viewModel.players[1].cards.remove(at: number)
//                } else{
//                    print("element \(viewModel.players[1].cards[number]) not selected")
//                }
//                
//            }
//            let newCount = 0...viewModel.players[1].cards.count
//            
//            for number in newCount {
//                
//                print("new array \(viewModel.players[1].cards[number]) ")
//            }
//        }
//        for element in viewModel.players[1].cards {
//            if viewModel.players[1].cards[element]
}
        }
    //computerTurn
    func computerTurn(){
        print("computer went")
        //look through hand
        if !playerTurn {
            viewModel.gotAny(from: 0, to: 1, suit: viewModel.players[1].cards.randomElement()!.suit)
            playerTurn = !playerTurn
        } else {
            
        }
    }

//    func handleTurns(){
//        if playerTurn{
//            
//        } else {
//            var request = viewModel.players[1].cards.randomElement()?.rank
//            viewModel.gotAny(from: 0, to: 1, rank: request)
//        }
//        
//    }
     func printTest(){
        for element in viewModel.players[0].cards {
            print("\(element)")
                }
        print("user hand")
        for element in viewModel.players[1].cards {
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

    let game = GoFishGame()
    
    GameView(viewModel: game, playerTurn:  true)
    //struct ContentView_Previews: PreviewProvider{
//    static var previews: some View{
//        let deck = Deck()
//        
//        GameView(players: testData)
//    }
}
