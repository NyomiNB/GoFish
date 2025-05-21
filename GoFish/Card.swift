////
////  CardModel.swift
////  GoFish
////
////  Created by Nyomi Bell on 5/14/25.
////
//import SwiftUI
////import Foundation
//
////enum Rank{
////    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, King
////}
////
////enum Suit {
////    case One, Two, Three, Four
////}
//enum Rank: CaseIterable{
//    case One, Two, Three, Four
//}
//enum Suit: CaseIterable{
//    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, Joker
//    var name: String {
//        switch self{
//        case .One: return "One"
//        case  .Two: return "Two"
//        case  .Three: return "Three"
//        case  .Four: return "Four"
//        case  .Five: return "Five"
//        case  .Six: return "Six"
//        case  .Seven: return "Seven"
//        case  .Eight: return "Eight"
//        case  .Nine: return "Nine"
//        case  .Ten: return "Ten"
//        case  .Queen: return "Queen"
//        case  .Joker: return "Joker"
//            
//        }
//    }
//}
//enum Hand: CaseIterable{
//    case None, Single, Pair, Trio, Book
//}
//
//struct Player: Equatable{
// var playerName = ""
//  var cards: [Card] = []
//    var id = UUID()
//    var activePlayer = false
//    var books = 0
//
//    var isMe: Bool = false
//}
//
//class GoFish{
//    var deck = Deck()
//    @Published var players:[Player]
//    init() {
//        deck.createDeck()
//        deck.shuffle()
//        let opponent = [Player(playerName: "puter")]
//        players = opponent
//        players.append(Player(playerName: "User", isMe: true))
//        
//        for _ in 1...7{
//            let card = deck.drawCard()
//            players[1].cards.append(card)
//        }
//        for _ in 1...7{
//            let card = deck.drawCard()
//            players[0].cards.append(card)
//        }
//
//        //init hand        func index(of card: Card, in player: Player) -> Int{
//        //        return player.cards.firstIndex(where: { $0 == card })
//        //    }
//        //    func index(of player: Player) -> Int{
//        //        return player.cards.firstIndex(where: { $0 == player })
//        //    }
//        
//    }
//    typealias Stack = [Card]
//    //
//    //    extension Stack where Element == Card {
//    //        func sortByRank() -> Self {
//    //            var sortedHand = Stack()
//    //            var remainingCards = self
//    //
//    //            return sortedHand
//    //        }
//    //    }
//    func evaluateHand(of player: Player)-> Hand{
//        var returnType = Hand.None
//        let hand = player.cards.filter { $0.selected == true }
//        if hand.count == 1 {
//            returnType = .Single
//        }    else if hand.count == 2 {
//            if hand[0].suit == hand[1].suit {
//                returnType = .Pair
//            }
//        }      else if hand.count == 3 {
//            if hand[0].suit == hand[1].suit  && hand[0].suit == hand[2].suit {
//                returnType = .Trio
//                
//            }
//        }    else if hand.count == 4 {
//            if hand[0].suit == hand[1].suit  && hand[0].suit == hand[2].suit && hand[0].suit == hand[3].suit{
//                
//                returnType = .Book
//            }
//        }
//        return returnType
//        
//    }
//    
//    func select(_ card: Card, in player: Player){
//        if let cardIndex = player.cards.firstIndex(where: { $0 == card }){
//            if let playerIndex = players.firstIndex(where: { $0 == player }) {
//                players[playerIndex].cards[cardIndex].selected.toggle()
//            }
//        }
//    }
////    mutating func activatePlayer(_ player: Player){
////        if let playerIndex = players.firstIndex(where: { $0.id == player.id}){
////            players[playerIndex].activePlayer  = true
////            if !activePlayer.isMe{
////                let cpuHand = getCPUHand(of: Player(of: activePlayer))
////            }
////    }
////}
//    
//    func chooseStartingPlayer() -> Player {
//       var startingPlayer: Player!
//       if Int.random(in: 1..<30) % 2 == 0{
//            startingPlayer = players[0]
//       } else {
//           startingPlayer = players[1]
//
//       }
//       return startingPlayer
//   }
//
//}
// struct Card: Identifiable, Equatable{
//    var id = UUID()
//    var rank: Rank
//    var suit: Suit
//    var selected: Bool = false
//    var flipped: Bool = true
//    var filename: String{
//        get {
//            if flipped{
//                return "\(rank) \(suit)"
//            } else{
//                return "back"
//            }
//        }
//    }
//}
// 
//
// 
//var testData = [
//    Card (rank: .Four, suit: .One),
//    Card (rank: .Four, suit: .One),
//    Card (rank: .Four, suit: .One),
//    Card (rank: .Four, suit: .One),
//    Card (rank: .Two, suit: .One),
//    Card (rank: .Three, suit: .One),
//    Card (rank: .Four, suit: .Queen),
//    Card (rank: .Four, suit: .Four),
//    Card (rank: .One, suit: .Four),
//    Card (rank: .Four, suit: .Joker)
//]
//
//var testPlayers = [
//    Player(playerName: "Computer"),
//    Player(cards: testData, isMe:true)
//
//]
//
//struct Deck{
//     var cards = [Card]()
//    
//    mutating func drawCard() -> Card{
//             return cards.removeLast()
//      }
//   mutating func createDeck () {
//             for rank in Rank.allCases{
//                 for suit in Suit.allCases{
//                     cards.append(Card(rank: rank, suit: suit))
//             }
//        }
//    }
//    mutating func shuffle(){
//        cards.shuffle()
//    }
//    mutating func cardsRemaining() -> Int{
//        return cards.count
//    }
//
//}
////var cards = [Card]()
