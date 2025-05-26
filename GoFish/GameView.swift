//
//  GameView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//
import SwiftUI
import AVKit

 class SoundManager {
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    func shuffleSound(){
        guard let url = Bundle.main.url(forResource: "CardDeal", withExtension: ".wav") else { return }
        
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print("Error plaing osund. \(error.localizedDescription)")
        }
    }
}
struct GameView: View {
    @ObservedObject var viewModel: GoFishGame
    @State var continueGame: Bool
    @State var chosenCard = "..."
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
    var body: some View {
        Group {
                 if continueGame{
                mainGameView()
            } else {
                gameOverView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.bouncy(), value: continueGame)
            }
        }
    }
    
    @ViewBuilder
    func mainGameView() -> some View{
        
        if turn != ""{
            Text(turn)
                .foregroundColor(playerTurn ? .purple : .white)
                .font(.largeTitle)
        }
        
        Text("Computer Books \(viewModel.players[0].books)")
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: -75)]){
            ForEach(viewModel.players[0].cards){card in
                CardView(cardName: "back")
            }
        }
        .frame(maxHeight: 100)
        .scrollTargetBehavior(.viewAligned)
//        VStack{
//            Button {
//                goFish()
//            } label: {
//                Image("back")
//                    .resizable()
//                    .frame(width: 200, height: 200)
//            }
//        }

        //                     Image("background").ignoresSafeArea()
        var hand = viewModel.evaluateHand(of: viewModel.players[1])
        var handStr = "\(hand)"
        //Text(handStr)
        
        
        if yourAction != ""{
            withAnimation(.easeIn(duration: 0.3)){
                
                Text(yourAction)
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
        } else if computerAction != ""{
            withAnimation(.easeIn(duration: 0.3)){
                
                Text(computerAction)
                    .foregroundColor(.purple)
                    .font(.subheadline)
            }
        }

  if viewModel.dealing{
      withAnimation(.easeIn(duration: 0.3)){
          
          Text(message)
              .foregroundColor(.yellow)
              .font(.title)
      }
        } else  if message != "" {
            withAnimation(.easeIn(duration: 0.3)){
                
                Text(message)
                    .foregroundColor(.red)
            }
        }
 

        ScrollView(.horizontal){
            HStack{
                ForEach($viewModel.players[1].cards){$card in
                    CardView(cardName: card.filename)
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 2:4, spacing: 5)
                        .background(card.selected ? Color.white : Color.clear)
                        .cornerRadius(8)
                        .onTapGesture{
                            if playerTurn{
                                SoundManager.instance.shuffleSound()
                                card.selected.toggle()
                                printTest()

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
 
         }
        .contentMargins(50, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        buttons

        .onAppear(){
            checkButtons(handStr: handStr)
            print(viewModel.players[1].cards.count)
             let startingPlayer = viewModel.chooseStartingPlayer()
                 viewModel.dealHands()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){

                playerTurn = startingPlayer.playerName == "User"
                turn = (playerTurn ? "Your Turn" : "Compter Turn")
             }
        }
        .onChange(of: viewModel.dealing) { dealing in
            if !dealing && !playerTurn {
                computerTurn()
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
                turn = "Computer Turn"
                
                computerTurn()
            } else {
                turn = "Your turn"
                
                print("Computer not going")
             }
        }
     }//end of gameView struct
    //    private var controlButtons: some View {
//    VStack(spacing: 12) {
//        Button("Go Fish") {
//            goFish()
//        }
//        .buttonStyle(StyledButton(color: .blue))
//        .disabled(!playerTurn)
//
//        HStack(spacing: 10) {
//            Button("Create Book") {
//                createUserBook()
//            }
//            .buttonStyle(StyledButton(color: .green))
//            .disabled(disableBookButton)
//
//            Button("Ask for a \(chosenCard)") {
//                askForCard()
//            }
//            .buttonStyle(StyledButton(color: .purple))
//            .disabled(!playerTurn || failed)
//        }
//    }
//}

    private var buttons: some View {
        VStack(spacing: 3){
            Button("Go Fish"){
                goFish()
            }
            .buttonStyle(StyledButton(color: .cyan))
            .disabled(!playerTurn || viewModel.dealing)
            
            
            HStack(spacing: 7){
                Button("Create book"){
                    createUserBook()
                }
                .buttonStyle(StyledButton(color: .green))
                .disabled(disableBookButton || viewModel.dealing)
                
                Button("Ask for a \(chosenCard)"){
                    askForCard()
                }
                .buttonStyle(StyledButton(color: .blue))
                .disabled(!playerTurn || failed || viewModel.dealing)
                
            }
            Text("Your Books: \(viewModel.players[1].books.count)")
            Text(viewModel.players[1].books.joined(separator: ", "))
        }
    }
    struct CardView: View{
        let cardName: String
        var body: some View{
            Image(cardName)
                .resizable()
                .scaledToFit()
        }
    }
    struct StyledButton: ButtonStyle {
        var color: Color
        func makeBody(configuration: Configuration) -> some View{
            configuration.label
                .background(color)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding()
                .shadow(radius: configuration.isPressed ? 0.95 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
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

    
    func askForCard(){
        guard chosenCard != "..." && !viewModel.dealing else {
            message = "Select the card in your hand you would like to ask for"
            return
        }
        
        if let selectedSuit{
        
            let result = viewModel.gotAny(from: 1, to: 0, suit: selectedSuit)
            
            if(result.success){
                if result.matching > 1 {
                    yourAction = "You took \(result.matching) \(chosenCard)\(result.matching > 1 ? "s" : "")!"
                } else {
                    yourAction = "No \(chosenCard)s found :( Go Fish!"
                    failed = true
                }
                chosenCard = "..."
                
            }
        }
    }
    
    func restart(){
        viewModel.dealingIndex = 0
        viewModel.dealingToStartPlayer = true
         viewModel.players[1].books.removeAll()
        viewModel.players[0].books.removeAll()
        chosenCard = "..."
        viewModel.players[1].cards.removeAll()
        viewModel.players[0].cards.removeAll()
        viewModel.createDeck()
        let startingPlayer = viewModel.chooseStartingPlayer()

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
    
    func createUserBook(){
        var valid = false
        
        var hand = viewModel.evaluateHand(of: viewModel.players[1])
        var handStr = "\(hand)"
 
        if handStr == "Book" {
            //adds book to array of user books
            viewModel.players[1].books.append(chosenCard)
            //refreshes view
            viewModel.players[1].books = viewModel.players[1].books
            yourAction = "You just created a book of \(chosenCard)s!"
            valid = true
        }
        
        //reset cards to !selected
        if valid {
            print("working")
            viewModel.players[1].cards = viewModel.players[1].cards.filter{ !$0.selected }
            printTest()
            for i in 0..<viewModel.players[1].cards.count {
                viewModel.players[1].cards[i].selected = false
            }
            //refreshes view
            viewModel.players = viewModel.players
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
        guard !viewModel.dealing else {
             return
        }

        turn = "Computer's turn"
        //look through hand
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            
            let cardHand = viewModel.evaluateComputerHand(in: viewModel.players[0].cards)
            viewModel.players[0].books.append(contentsOf: cardHand)
        }
        
             print("computer went")
        if viewModel.players[0].cards.isEmpty {
            print("uh oh")
gameOver()
        }else {
            var selectedSuit = viewModel.players[0].cards.randomElement()!.suit
            print(selectedSuit)
            printTest()
            
            let result = viewModel.gotAny(from: 0, to: 1, suit: selectedSuit)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                
                if(result.success == true){
                    viewModel.players[1].cards = viewModel.players[1].cards.filter{ !$0.selected }
                    if result.matching > 1 {
                        computerAction = "Computer took \(result.matching) \(selectedSuit)s"
                    } else {
                        computerAction = "Computer took \(result.matching) \(selectedSuit)"
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        
                        computerTurn()
                    }
                } else {
                    computerAction = "Aw, no \(result.matching) \(selectedSuit)s? :("
                    print("computer draws card")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                        let card = viewModel.drawCard()
                        viewModel.players[0].cards.append(card)
                        
                        if selectedSuit.name == card.suit.name {
                            computerAction = "Computer caught a \(card.suit.name)!"
                            viewModel.players[0].cards = viewModel.players[0].cards
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                computerTurn()
                            }
                        } else{
                            computerAction = "Computer caught a \(card.suit.name)-Your Turn!"
                            
                            playerTurn = !playerTurn
                            viewModel.players[0].cards = viewModel.players[0].cards
                            
                        }
                        
                    }
                }
            }
        }
        }
    
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

#Preview{
    
    let game = GoFishGame()
    
    GameView(viewModel: game, continueGame:  true, chosenCard: "...", playerTurn: false)
}
