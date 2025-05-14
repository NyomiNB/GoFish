//
//  CardModel.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/14/25.
//
import SwiftUI
//import Foundation

enum Rank{
    case One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Queen, King
}

enum Suit {
    case One, Two, Three, Four
}
struct Card: Identifiable{
    
    var id = UUID()
let suit: Suit
let rank: Rank
let flipped: Bool
let used: Bool
    var fileName: String{
        return "\(suit)-\(rank)"
    }
}
let cards = [Card]()
