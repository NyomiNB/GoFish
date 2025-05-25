//
//  GoFishApp.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI

@main
struct GoFishApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            let game = GoFishGame()
            MenuView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
