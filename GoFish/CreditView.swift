//
//  CreditView.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI

struct CreditView: View {
    var body: some View {
        Text("Credits")
            .bold()
            .font(.largeTitle)
         Text("Images")
            .bold()
            .font(.title2)

        Text("Canva")
            .font(.title3)

        
        Text("Audio")
            .font(.title2)
            .bold()
        Text("FreeSound.org")
            .font(.title3)

    }
}

#Preview {
    CreditView()
}
