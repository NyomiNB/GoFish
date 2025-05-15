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
    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, King, Joker
}
struct Player: Identifiable{
    var cards: [Card] = []
    var id = UUID()
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
struct Card{
    var rank: Rank
    var suit: Suit
    //let selected: Bool
    let flipped = true
    var filename: String{
        get {
            if flipped{
                return "\(suit) \(rank)"
            } else{
                return "back"
            }
        }
    }
}
 

 

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
