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
    var musicPlayer: AVAudioPlayer?
    
    var player: AVAudioPlayer?
    
    func shuffleSound(){
        playEffect(named: "CardDeal", type: ".wav")
    }
 
    func goFish(){
        playEffect(named: "goFish", type: ".wav")
    }
    func playEffect(named name: String, type: String){
        guard let url = Bundle.main.url(forResource: name, withExtension: type) else { return }
        do {
            player  = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("error sound effectplaying")
        }
    }
    func playMusic(){
        if let musicURL = Bundle.main.url(forResource: "meow", withExtension: ".wav"){
            do{
                let audioPlayer = try AVAudioPlayer(contentsOf: musicURL)
                musicPlayer = audioPlayer
                musicPlayer?.numberOfLoops = -1
                musicPlayer?.play()
                //}
            } catch {
                print("Error w background music")
            }
        }
    }
    func pauseMusic(){
        musicPlayer?.pause()
    }
    func toggleMusic(){
        if let musicPlayer = musicPlayer {
            if musicPlayer.isPlaying{
                pauseMusic()
            } else{
                playMusic()
            }
        } else {
            playMusic()
        }
    }
}
struct GameView: View {
    
    @ObservedObject var viewModel: GoFishGame
    @State var continueGame: Bool
    @State var isPlayingMusic = true
    @State var showAction = true
    @State var chosenCard = "..."
    @State var playerTurn: Bool
    @State var selectedSuit: GoFishGame.Suit? = nil
    @State var drawOnly = false
    @State var message = ""
    @State var action = ""
    @State var turn = ""
    @State var disableGoFish = true
    @State var disableAll = true
    
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
                    .onAppear(){
                        restart()

                    }
            }
            
        }
    }
    
    @ViewBuilder
    func mainGameView() -> some View{
        if turn != "" && !viewModel.dealing{
            Text(turn)
                .foregroundColor(playerTurn ? .purple : .gray)
                .font(.largeTitle)
                .bold()
        }
        
        Text("Computer Books: \(viewModel.players[0].books.count)")
            .bold()
        Text(viewModel.players[0].books.joined(separator: ", "))
        
        //            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: -75)]){
        //                ForEach(viewModel.players[0].cards){card in
        //                    CardView(cardName: "back")
        //                }
        //            }
        //            .frame(maxHeight: 100)
        //            .scrollTargetBehavior(.viewAligned)
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let cardWidth: CGFloat = 60
            let maxCards = viewModel.players[0].cards.count
            let spacing = max((totalWidth - (CGFloat(maxCards) * cardWidth)) / CGFloat(maxCards - 1), -20)
            HStack(spacing: spacing){
                ForEach(viewModel.players[0].cards) {card in
                    CardView(cardName: "back")
                        .frame(width: cardWidth, height: 90)
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut, value: viewModel.players[0].cards.count)
                    
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 100)
            
            if showAction{
                Text(action)
                    .bold()
                    .animation(.easeInOut(duration: 1.0), value: showAction)
                             }
            
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
            
            if viewModel.dealing{
                
                Text(message)
                    .foregroundColor(.yellow)
                    .font(.title)
            } else if message != "" {
                
                Text(message)
                    .foregroundColor(.red)
            }
            
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal){
                HStack{
                    ForEach($viewModel.players[1].cards){$card in
                        CardView(cardName: card.filename)
                            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
                            .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 2:4, spacing: 5)
                            .background(card.selected ? Color.white : Color.clear)
                            .cornerRadius(8)
                            .onTapGesture{
                                if playerTurn && !viewModel.dealing{
                                    SoundManager.instance.shuffleSound()
                                    card.selected.toggle()
                               //     printTest()
                                    
                                    //                                viewModel.select(card, in: viewModel.players[0])
                                    chosenCard = card.suit.name
                                    selectedSuit = card.suit
                                    checkButtons(handStr: handStr)
                                    
                                }
                                
                                
                            }
                            .offset(y: card.selected ? -30 : 0)
                        
                    }
                }
                .onChange(of: viewModel.players[1].cards.count) { _ in
                    if let lastCard = viewModel.players[1].cards.last {
                        withAnimation {
                            scrollProxy.scrollTo(lastCard.id, anchor: .trailing)
                        }
                    }
                }
            }
                
                 .scrollTargetLayout()
                
            }
            .contentMargins(50, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
            buttons
            
                .onAppear(){
                    SoundManager.instance.playMusic()
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
                    disableAsk = !playerTurn || failed || viewModel.dealing || disableBookButton
                    disableGoFish = !playerTurn  || viewModel.dealing || disableAll
                    disableBookButton = !playerTurn || disableBookButton
                    if !dealing && !playerTurn {
                        computerTurn()
                    }
                }
            
                .onChange(of: handStr) {
                    checkButtons(handStr: handStr)
                }
                .onChange(of: playerTurn) {
                    disableAsk = !playerTurn || failed || viewModel.dealing || disableAll
                    disableGoFish = !playerTurn || failed || viewModel.dealing || disableAll
                    disableBookButton = !playerTurn ||  viewModel.dealing || disableAll
                    
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
 
    private var buttons: some View {
        VStack(spacing: 16){
            Text("Your Books: \(viewModel.players[1].books.count)")
                .bold()
            Text(viewModel.players[1].books.joined(separator: ", "))
            
            Button("Go Fish"){
                goFish()
                
            }
            .buttonStyle(StyledButton(color: !disableAsk || !failed || playerTurn || !viewModel.dealing ? .cyan : .cyan.opacity(0.8)))
            .disabled(!playerTurn || viewModel.dealing || disableGoFish)
            
            
            HStack(spacing: 5){
                Button("Create book"){
                    createUserBook()
                }
                .buttonStyle(StyledButton(color: (!disableAsk || !failed || playerTurn || !viewModel.dealing) ? .green : .gray))
                .disabled(disableBookButton)
                
                Button("Ask for a \(chosenCard)"){
                    askForCard()
                }
                .buttonStyle(StyledButton(color: !disableAsk || !failed || playerTurn || !viewModel.dealing ? .blue : .orange))
                .disabled(disableAsk || failed || !playerTurn || viewModel.dealing)
                
                 
            }
            HStack(spacing: 5){
                Button{
                    SoundManager.instance.toggleMusic()
                    isPlayingMusic.toggle()
                } label: {
                    Image(systemName: isPlayingMusic ?  "speaker.slash.fill" : "speaker.fill")
                }
                .buttonStyle(StyledButton(color: .pink))
                Button("Restart"){
                    restart()
                }
                .buttonStyle(StyledButton(color: .orange))

                
            }
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
        var color : Color
        
        func makeBody(configuration: Configuration) -> some View{
            configuration.label
                .padding()
                .frame(maxWidth: .infinity)
                .background(color)
                .foregroundColor(.white)
            //                 .clipShape(Capsule())
                .cornerRadius(10)
                .shadow(radius: configuration.isPressed ? 0.95 : 1.0)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
    
    @ViewBuilder
    func gameOverView() -> some View{
        Text("Game Over")
            .font(.largeTitle)
            .bold()
        var winnerMessage = chooseWinner()
        Text(winnerMessage)
            .bold()
        
        Button {
            startGame()
        }label:{
            Text("Play Again")
        }
        .buttonStyle(StyledButton(color: !disableAsk || !failed || playerTurn || !viewModel.dealing ? .blue : .orange))

    }
    
    func askForCard(){
         guard chosenCard != "..." && !viewModel.dealing else {
            message = "Select the card in your hand you would like to ask for"
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                message = ""
            }

            return
        }
        message = ""
        if let selectedSuit{
            //   print(selectedSuit)
            
            let result = viewModel.gotAny(from: 1, to: 0, suit: selectedSuit)
                //print(result)
             if result.matching > 0 {
                action = "You took \(result.matching) \(chosenCard)\(result.matching > 1 ? "s" : "")!"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation{
                        showAction = false
                    }
                }

            } else {
                withAnimation{
                    action = "No \(chosenCard)s found :( Go Fish!"
                    showAction = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation{
                        showAction = false
                    }
                }

                failed = true
            }
            chosenCard = "..."
            
        }
    }
    
    
    func restart(){
        viewModel.dealingIndex = 0
         viewModel.players[1].books.removeAll()
        viewModel.players[0].books.removeAll()
        chosenCard = "..."
        viewModel.players[1].cards.removeAll()
        viewModel.players[0].cards.removeAll()
        viewModel.createDeck()
 
        viewModel.dealHands()
         message = ""
        action = ""
        turn = ""
        disableGoFish = true
        disableAsk = true
        disableBookButton = true
        continueGame = true

    }
    func startGame(){
        let start = viewModel.chooseStartingPlayer()
        playerTurn = start.playerName == "User"
        turn = playerTurn ? "Your Turn" : "Computer Turn"
        viewModel.dealingToStartPlayer = true

    }
    func goFish(){
        SoundManager.instance.goFish()
        let card = viewModel.drawCard()
        print("card\(card)")
        viewModel.players[1].cards.append(card)
        viewModel.players[1].cards = viewModel.players[1].cards
        //force refresh
        //logic compares chosen card to drawn card, continues turn if true
        if chosenCard == card.suit.name {
            withAnimation {
                action = "You caught a \(card.suit.name) from the pond! Continue your turn!"
                showAction = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    
                    showAction = true
                }            }
            
            failed = false
            viewModel.players = viewModel.players
            
        } else {
            withAnimation {
                action = "You caught a \(card.suit.name)-Computer's turn!"
                showAction = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showAction = false
                }
                
                
                playerTurn = !playerTurn
            }
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
            withAnimation {
                
                action = "You just created a book of \(chosenCard)s!"
                showAction
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    
                    showAction = false
                }
            }

            valid = true
        }
        
        //reset cards to !selected
        if valid {
            print("working")
            viewModel.players[1].cards = viewModel.players[1].cards.filter{ !$0.selected }
          //  printTest()
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
        } else {
            var suitChosen = viewModel.players[0].cards.randomElement()!.suit
            print(suitChosen)
                // printTest()
            
            let result = viewModel.gotAny(from: 0, to: 1, suit: suitChosen)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                
                if(result.success){
                    viewModel.players[1].cards = viewModel.players[1].cards.filter{ !$0.selected }
                    if result.matching > 1 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                            
                            withAnimation{
                                action = "Computer took \(result.matching) \(suitChosen)s from your hand"
                                SoundManager.instance.shuffleSound()
                                
                                showAction = true
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                            
                            withAnimation{
                                
                                action = "Computer took \(result.matching) \(suitChosen) from your hand"
                                SoundManager.instance.shuffleSound()
                                
                                showAction = true
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        withAnimation{
                            showAction = false
                        }
                        computerTurn()
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        
                        action = "Aw, no \(result.matching) \(suitChosen)s? :("
                        print("computer draws card")
                    }
                     
                    action = "Computer is drawing a card..."
 
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                         let card = viewModel.drawCard()
                        SoundManager.instance.goFish()

                        viewModel.players[0].cards.append(card)
 
                           if suitChosen.name == card.suit.name {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                
                                action = "Computer caught a \(card.suit.name) from the pond"
                                SoundManager.instance.shuffleSound()
                                viewModel.players[0].cards = viewModel.players[0].cards
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                                computerTurn()
                            }
                            
                        } else {
                            action = "Computer caught a \(card.suit.name)-Your Turn!"
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                                action = ""
                                playerTurn = !playerTurn
                                viewModel.players[0].cards = viewModel.players[0].cards
                            }
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
                        player = "It's a Tie"
                        
                    }
                    return player
                }
//                func printTest(){
//                    for element in viewModel.players[0].cards {
//                        print("\(element)")
//                        
//                    }
//                    print("user hand")
//                    for element in viewModel.players[1].cards {
//                        print("\(element)")
//                    }
//                    
//                    
//                }
            }
            
            #Preview{
                
                let game = GoFishGame()
                
                GameView(viewModel: game, continueGame:  true, chosenCard: "...", playerTurn: false)
            }
