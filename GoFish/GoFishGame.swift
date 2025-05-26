//
//  GoFishGame.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/18/25.
//

import Foundation
import SwiftUI
 
class GoFishGame: ObservableObject {
   

     class Player: ObservableObject, Identifiable{
        let playerName: String
      @Published var cards: [Card] = []
         var id = UUID()
         @Published var books: [String] = []

        var isMe: Bool = false
        init(name: String, cards: [Card] = [], isMe: Bool) {
            self.playerName = name
            self.cards = cards
            self.isMe = isMe

        }
 

    }
    @Published var players:[Player] = [
           Player(name: "Computer", isMe: false),
           Player(name: "User", isMe: true)
       ]
    

    func chooseStartingPlayer() -> Player {
         var startingPlayer: Player!
         if Int.random(in: 1..<30) % 2 == 0{
              startingPlayer = players[0]
         } else {
             startingPlayer = players[1]
         }
         return startingPlayer
     }
     struct Card: Identifiable, Equatable{
       var id = UUID()
       var rank: Rank
       var suit: Suit
       var selected: Bool = false
       var flipped: Bool = true
       var filename: String{
           get {
               if flipped{
                   return "\(rank) \(suit)"
               } else{
                   return "back"
               }
           }
       }
   }
    var selectedCards: [Card] = []
 
    var deck: [Card] = []
    init(){
        createDeck()
        //dealHands()
    }
    func createDeck () {
        deck.removeAll()
              for rank in Rank.allCases{
                  for suit in Suit.allCases{
                      deck.append(Card(rank: rank, suit: suit))
              }
         }
        deck.shuffle()
     }
    func drawCard() -> Card{
        return deck.popLast() ?? Card(rank: .One, suit: .One)
    }
//    func dealNextCard(){
//        var dealingToStartPlayer = true
//        var dealingIndex = 0
//var isDealing = true
//        guard dealingIndex < 7 else {
//            isDealing = false
//            return
//        }
//        withAnimation(.easeInOut(duration: 0.3)){
//            let playerIndex = dealingToStartPlayer ? 1 : 0
//            let card = drawCard()
//            players[playerIndex].cards.append(card)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
//            dealingToStartPlayer = !dealingToStartPlayer
//            if !dealingToStartPlayer{
//                dealingIndex += 1
//            }
//            self.dealNextCard()
//        }
//        
//    }
    @Published var dealingToStartPlayer = true
    @Published  var dealingIndex = 0
    @Published var dealing = true

    func dealHands () {
 
           guard dealingIndex < 7 else {
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                   
                   self.dealing = false
               }
            return
        }
        withAnimation(.easeInOut(duration: 0.3)){
 
            let playerIndex = dealingToStartPlayer ? 1 : 0
            let card = drawCard()
            players[playerIndex].cards.append(card)
            players[playerIndex].cards = players[playerIndex].cards
            print(("animation"))
 
            print((card))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            print("first\(self.dealingToStartPlayer)")
    self.dealingToStartPlayer.toggle()

            if !self.dealingToStartPlayer{
 
                self.dealingIndex  += 1
                print(("dealinh in"))

                print((self.dealingIndex))
                 print(("player"))

 
            }
            print((self.dealingToStartPlayer))

            self.dealHands()
        }

        
//        var testCards = [
//            Card (rank: .Four, suit: .One),
//            Card (rank: .Four, suit: .One),
//            Card (rank: .Four, suit: .One),
//            Card (rank: .Four, suit: .One),
//            Card (rank: .Two, suit: .One),
//            Card (rank: .Three, suit: .One),
//            Card (rank: .Four, suit: .Queen),
//            Card (rank: .Four, suit: .Four),
//            Card (rank: .One, suit: .Four),
//            Card (rank: .Four, suit: .Joker)
//        ]
//        
        // players[1].cards = testCards
        
    }
    func playerDraws(playerIndex: Int){
        var card = drawCard()
            players[playerIndex].cards.append(card)
        
    }
    func gotAny(from requestingIndex: Int, to targetIndex: Int, suit: Suit) -> (success: Bool, matching: Int) {
         let targetPlayer = players[targetIndex]
        let requestingPlayer = players[requestingIndex]
        let takenCards = removeCards(of: suit, of: targetPlayer)
        var success = false
 
        if !takenCards.isEmpty{
            players[requestingIndex].cards.append(contentsOf: takenCards)
            return (true, takenCards.count)
        } else{
            playerDraws(playerIndex: requestingIndex)
            return (false, takenCards.count)
        }
    }
    func removeCards(of suit: Suit, of player: Player) -> [Card]{
        let matching = player.cards.filter { $0.suit == suit }
        player.cards.removeAll { $0.suit == suit }
        return matching
    }
    func evaluateComputerHand(in hand: [Card])-> [String]{
        var suitCount : [Suit: Int] = [:]
        var results: [String] = []
        for card in hand {
            suitCount [card.suit, default: 0] += 1
            
        }
        for (suit, count) in suitCount {
            if count == 4 {
                results.append(suit.name)
                removeCards(of: suit, of: players[0])
             }
        }
       return results
    }
    func evaluateHand(of player: Player)-> Hand{
        var returnType = Hand.None
        let hand = player.cards.filter { $0.selected == true }
        if hand.count == 1 {
            returnType = .Single
        }    else if hand.count == 2 {
            if hand[0].suit == hand[1].suit {
                returnType = .Pair
            }
        }      else if hand.count == 3 {
            if hand[0].suit == hand[1].suit  && hand[0].suit == hand[2].suit {
                returnType = .Trio
                
            }
        }    else if hand.count == 4 {
            if hand[0].suit == hand[1].suit  && hand[0].suit == hand[2].suit && hand[0].suit == hand[3].suit{
                
                returnType = .Book
            }
        }
        return returnType
        
    }
    

    func select(_ card: Card, in player: Player){
        guard let playerIndex = players.firstIndex(where: { $0 == player }) else {return}

        guard let cardIndex = players[playerIndex].cards.firstIndex(where: { $0 == card }) else {return}
                 players[playerIndex].cards[cardIndex].selected.toggle()
        print("Selected card at playerIndex \(playerIndex), cardIndex \(cardIndex)")
      }
        

     enum Rank: CaseIterable{
        case One, Two, Three, Four
    }
    enum Suit: CaseIterable{
        case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, Joker
        var name: String {
            switch self{
            case .One: return "One"
            case  .Two: return "Two"
            case  .Three: return "Three"
            case  .Four: return "Four"
            case  .Five: return "Five"
            case  .Six: return "Six"
            case  .Seven: return "Seven"
            case  .Eight: return "Eight"
            case  .Nine: return "Nine"
            case  .Ten: return "Ten"
            case  .Queen: return "Queen"
            case  .Joker: return "Joker"
                
            }
        }
    }
    enum Hand: CaseIterable{
        case None, Single, Pair, Trio, Book
    }

  
//
//    @Published var model: GoFish = GoFish()
//    
//  var players:[Player]{
//        return model.players
//    }
 //     func drawCard() -> Card{
//         return model.deck.drawCard()
//      }
//
//    func evaluateHand(of player: Player) -> Hand{
//        return model.evaluateHand(of: player)
//    }
//    func chooseStartingPlayer() -> Player {
//        return model.chooseStartingPlayer()
//    }

}
extension GoFishGame.Player: Equatable {
    static func == (lhs: GoFishGame.Player, rhs: GoFishGame.Player) -> Bool {
        return lhs.id == rhs.id
    }
}
