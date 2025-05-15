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

struct Card{
  var rank: Rank
    var suit: Suit
let flipped: Bool
let used: Bool
    
 }
let cards = [Card]()
