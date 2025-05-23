//
//  GameOverView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/22/25.
//
import SwiftUI
struct GameOverView: View {
    @Binding var winnerIs:  String
    var body: some View {
        Text(winnerIs)
    }
}


