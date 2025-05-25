//
//  GameView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI
struct GameView: View {
    @ObservedObject var viewModel: GoFishGame
    @State var continueGame: Bool
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
    @State var failed: Bool = false
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    // @State var players: [Player]
    //    @State var cards:[Card]
    var body: some View {
        if continueGame{
            
            Text(turn)
            Text(computerAction)
            
            Text("Computer Books \(viewModel.players[0].books)")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: -75)]){
                ForEach(viewModel.players[0].cards){card in
                    CardView(cardName: "back")
                }
            }
            .frame(maxHeight: 100)
            .scrollTargetBehavior(.viewAligned)
            
            //                     Image("background").ignoresSafeArea()
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
                checkButtons(handStr: handStr)
                print(viewModel.players[1].cards.count)
                printTest()
                let startingPlayer = viewModel.chooseStartingPlayer()
                playerTurn = startingPlayer.playerName == "User"
                if playerTurn{
                    turn = "Your turn"
                    
                } else{
                    turn = "Computer turn"
                    
                }
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
                            
                            if(result.success == true){
                                if result.matching > 1 {
                                    yourAction = "You took \(result.matching) \(chosenCard)s"
                                    chosenCard = "..."
                                } else {
                                    yourAction = "You took \(result.matching) \(chosenCard)"
                                    chosenCard = "..."
                                    
                                }
                            } else {
                                yourAction = "There weren't any \(chosenCard)s in your opponent's hand :( Go Fish!"
                                chosenCard = "..."
                                failed = true
                            }
                        } else {
                            message = "Select the card in your hand you would like to ask for"
                        }
                    }, label: {
                        Text("Ask for a \(chosenCard)")
                    }
                           //   .disabled()
                    )
                    .disabled(!playerTurn)
                    .disabled(failed)
                    
                }
            }
            .onChange(of: handStr) {
                checkButtons(handStr: handStr)
            }
            .onChange(of: playerTurn) {
                failed = false
                if gameOver(){
                    continueGame = false
                } else{
                    continueGame = true
                    
                }
                
                checkButtons(handStr: handStr)
                print("on change works!")
                
                if !playerTurn{
                    print("Computer going")
                    turn = "Comoputer Turn"
                    
                    computerTurn()
                } else {
                    turn = "Your turn"
                    
                    print("Computer not going")
                    
                }
            }
            
        }else{
            gameOverView()
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
    @ViewBuilder
    func gameOverView() -> some View{
        Text("Game Over")
        var player = chooseWinner()
        Text("The Winner is \(player)")
        Button {
            restart()
        }label:{
            Text("Play Again")
        }
    }
    func restart(){
        viewModel.players[1].books.removeAll()
        viewModel.players[0].books.removeAll()
        chosenCard = "..."
        viewModel.players[1].cards.removeAll()
        viewModel.players[0].cards.removeAll()
        viewModel.createDeck()
        viewModel.dealHands()
        playerTurn = false
        message = ""
        computerAction = ""
        turn = ""
        yourAction = ""
        disableGoFish = true
        disableAsk = true
        disableBookButton = true
        continueGame = true
        
    }
    func goFish(){
        
        let card = viewModel.drawCard()
        print("card\(card)")
        viewModel.players[1].cards.append(card)
        viewModel.players[1].cards = viewModel.players[1].cards
        //force refresh
        //logic compares chosen card to drawn card, continues turn if true
        if chosenCard == card.suit.name {
            yourAction = "You caught a \(card.suit.name)! Continue your turn!"
            failed = false
            viewModel.players = viewModel.players
            
        } else {
            yourAction = "You caught a \(card.suit.name)-Computer's turn!"
            
            playerTurn = !playerTurn
            
        }
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
            // playerTurn = !playerTurn
            
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
        //look through hand
        while(!playerTurn){
            let cardHand = viewModel.evaluateComputerHand(in: viewModel.players[0].cards)
            viewModel.players[0].books.append(contentsOf: cardHand)
            //random decision to draw or go fish maybe make smart later
            print("computer went")
            var thing = viewModel.players[0].cards.randomElement()!.suit
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
                print("computer draws card")
                let card = viewModel.drawCard()
                viewModel.players[0].cards.append(card)
                if thing.name == card.suit.name {
                    computerAction = "Computer caught a \(card.suit.name)!"
                    viewModel.players[0].cards = viewModel.players[0].cards
                    
                } else{
                    computerAction = "Computer caught a \(card.suit.name)-Your Turn!"
                    
                    playerTurn = !playerTurn
                    viewModel.players[0].cards = viewModel.players[0].cards
                    
                }
                
                
            }
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
    func gameOver()->Bool{
        var gameDone = false
        if viewModel.players[0].cards.isEmpty || viewModel.deck.isEmpty || viewModel.players[1].cards.isEmpty {
            gameDone = true
        } else{
            gameDone = false
        }
        return gameDone
    }
    func chooseWinner()->String{
        var player: String = ""
        //user
        if viewModel.players[0].books.count > viewModel.players[1].books.count {
            player = "You Win!"
        }      else if viewModel.players[1].books.count > viewModel.players[0].books.count {
            player = "You Lose!"
            
        }      else if viewModel.players[1].books.count == viewModel.players[0].books.count {
            player = "It's a Tie?"
            
        }
        return player
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
    
    GameView(viewModel: game, continueGame:  true, chosenCard: "...", playerTurn: false)
    //struct ContentView_Previews: PreviewProvider{
    //    static var previews: some View{
    //        let deck = Deck()
    //
    //        GameView(players: testData)
    //    }
}
