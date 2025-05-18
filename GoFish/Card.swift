//
//  CardModel.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/14/25.
//
import SwiftUI
//import Foundation

//enum Rank{
//    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, King
//}
//
//enum Suit {
//    case One, Two, Three, Four
//}
enum Rank: CaseIterable{
    case One, Two, Three, Four
}
enum Suit: CaseIterable{
    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, Joker
}
struct Player{
    var cards:[Card] = testData

//    var cards: [Card] = []
//    var id = UUID()
    var isMe: Bool = false
}

struct GoFish{
  var  deck = Deck()
    var players:[Player]
    init() {
        deck.createDeck()
        deck.shuffle()
        let opponent = [Player()]
        players = opponent
        players.append(Player(isMe: true))
   
        for _ in 1...7{
            let card = deck.drawCard()
            players[1].cards.append(card)
        }
        for _ in 1...7{
            let card = deck.drawCard()
            players[0].cards.append(card)
        }

    }
    //init hand
    
}
struct Card: Identifiable{
    var id = UUID()
    var rank: Rank
    var suit: Suit
    //let selected: Bool
    let flipped = true
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
 

 
var testData = [
    Card (rank: .Four, suit: .One),
    Card (rank: .Two, suit: .One),
    Card (rank: .Three, suit: .One),
    Card (rank: .Four, suit: .Queen),
    Card (rank: .Four, suit: .Four),
    Card (rank: .One, suit: .Four),
    Card (rank: .Four, suit: .Joker)

]
var playerTest = [
Player(),
Player(cards: testData, isMe:true)

]

struct Deck{
    @State var cards: [Card] = []
    func drawCard() -> Card{
        return cards.removeLast()
    }
    func createDeck () {
        for suit in Suit.allCases{
            for rank in Rank.allCases{
                cards.append(Card(rank: rank, suit: suit))
            }
        }
    }
    func shuffle(){
        cards.shuffle()
    }
    func cardsRemaining() -> Int{
        return cards.count
    }

}
var cards = [Card]()
