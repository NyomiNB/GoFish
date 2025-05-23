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
    @State var selectedSuit: GoFishGame.Suit? = nil
    @State var message = ""
    @State var computerAction = ""
    @State var turn = ""
    @State var yourAction = ""
    @State var disableGoFish = true
    @State var disableAsk = true
    @State var disableBookButton = true

    @Environment(\.verticalSizeClass) var verticalSizeClass
    // @State var players: [Player]
    //    @State var cards:[Card]
    class winner: ObservableObject {
        @Published var winnerIs: String = ""
    }
    @ObservedObject var winner = winner()

    var body: some View {
        
        Text(turn)
        Text(computerAction)
        
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
        Text(message)
        Text(yourAction)
        
            .font(.title)
        Text("Your Books: \(viewModel.players[1].books.count)")
        Text("\(viewModel.players[1].books)")
        
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
                                selectedSuit = card.suit
                                checkButtons(handStr: handStr)
                                
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
            self.winner.winnerIs = "ME!!!"
            gameOver()
            checkButtons(handStr: handStr)
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
                    createUserBook(isBook: handStr, bookType: chosenCard)
                    viewModel.players[1].cards = viewModel.players[1].cards
                    hand = viewModel.evaluateHand(of: viewModel.players[1])
                    yourAction = "You just created a book of \(chosenCard)s!"
                }, label: {
                    Text("Create Book")        })
                .disabled(disableBookButton)
                
                
                Button(action: {
                    print("Ask")
                    if chosenCard != "..." {
                        var result = viewModel.gotAny(from: 1, to: 0, suit: (selectedSuit)!)
                        chosenCard = "..."
                        if(result.success == true){
                            if result.matching > 1 {
                                yourAction = "You took \(result.matching) \(chosenCard)s"
                            } else {
                                yourAction = "You took \(result.matching) \(chosenCard)"
                            }
                        } else {
                            yourAction = "There weren't any \(chosenCard)s in your opponent's hand :("
                        }
                    } else {
                        message = "Select the card in your hand you would like to ask for"
                    }
                }, label: {
                    Text("Ask for a \(chosenCard)")
                }
                       //   .disabled(<#T##disabled: Bool##Bool#>)
                )
                .disabled(!playerTurn)
                
            }
        }
        .onChange(of: handStr) {
            checkButtons(handStr: handStr)
        }
        .onChange(of: playerTurn) {
            if viewModel.deck.isEmpty{
                gameOver()
            }
            checkButtons(handStr: handStr)
            print("on change works!")
            
            if !playerTurn{
                
                print("Computer going")
                
                computerTurn()
            } else {
                turn = "Your turn"
                
                print("Computer not going")
                
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
        print("card\(card)")
        viewModel.players[1].cards.append(card)
        viewModel.players[1].cards = viewModel.players[1].cards
        //force refresh
        yourAction = "You caught a \(card.suit.name)"
        viewModel.players = viewModel.players
        playerTurn = !playerTurn
    }
    func createUserBook(isBook: String, bookType: String){
        print(isBook)
        var valid = false
        if isBook == "Book" {
            viewModel.players[1].books.append(bookType)
            viewModel.players[1].books = viewModel.players[1].books
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
    func checkButtons(handStr: String){
        if !playerTurn || handStr != "Book"{
            print(handStr)
            disableBookButton = true
        } else if playerTurn && handStr == "Book"{
            disableBookButton = false
        }
        if !playerTurn {
            
            disableGoFish = true
            disableAsk = true
        } else if playerTurn {
            disableGoFish = false
            disableAsk = false
            
        }
        
    }
    //computerTurn
    
    func computerTurn(){
        turn = "Computer's turn"
        
        print("computer went")
        //look through hand
        var thing = viewModel.players[1].cards.randomElement()!.suit
        print(thing)
        printTest()
        let result = viewModel.gotAny(from: 0, to: 1, suit: thing)
        
        if(result.success == true){
            viewModel.players[1].cards = viewModel.players[1].cards.filter{ !$0.selected }
            if result.matching > 1 {
                computerAction = "Computer took \(result.matching) \(thing)s"
            } else {
                computerAction = "Computer took \(result.matching) \(thing)"
                
            }
        } else {
            computerAction = "Aw, no \(result.matching) \(thing)s? :("
            
        }
        printTest()
        playerTurn = !playerTurn
        
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
    func gameOver(){
        
        //user
//        if viewModel.players[0].books.count > viewModel.players[1].books.count {
//            self.winner.winnerIs = "You Win!"
//        }      else if viewModel.players[1].books.count > viewModel.players[0].books.count {
//            self.winner.winnerIs = "You Lose!"
//
//        }      else if viewModel.players[1].books.count == viewModel.players[0].books.count {
//            self.winner.winnerIs = "It's a Tie?"
//
//        }

    }
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
