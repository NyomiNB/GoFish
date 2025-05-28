//
//  Menu.swift
//  GoFish
//
//  Created by Nyomi Bell on 5/5/25.
//

import SwiftUI

struct MenuView: View {
    let game = GoFishGame()
    var body: some View {
 
             NavigationStack{
                Text("Go Fish!")
                    .bold()
                    .font(.largeTitle)
                
                Button(action: {
                    print("play")
                }, label: {
                    NavigationLink(destination: GameView(viewModel: game, continueGame: true, playerTurn: true)) {
                        Text("Play").foregroundColor(.white)
                    }
                    .padding()
                    .padding()
                    .frame(width: 170, height: 50)
                    .background(.blue.opacity(1.0))
                    .cornerRadius(20.0)
                    
                    
                })
                
                
                Button(action: {
                    print("Instructions")
                }, label: {
                    NavigationLink(destination: InstructionsView()) {
                        Text("Instructions").foregroundColor(.white)
                    }
                    .padding()
                    .padding()
                    .frame(width: 170, height: 50)
                    .background(.blue.opacity(1.0))
                    .cornerRadius(20.0)
                    
                })
                
                Button(action: {
                    print("Credits")
                }, label: {
                    NavigationLink(destination: CreditView()) {
                        Text("Credits").foregroundColor(.white)
                    }
                    .padding()
                    .padding()
                    .frame(width: 170, height: 50)
                    .background(.blue.opacity(1.0))
                    .cornerRadius(20.0)
                    
                })
                
         }
         .onAppear(){
             SoundManager.instance.pauseMusic()
             
         }
//               Button(action: {
//                   print("Instructions")
//               }, label:{
//                   "Instructions"
//                   NavigationLink(destination: InstructionsView()){
//                    }
//               }
//                      Button(action: {
//                          print("Credits")
//                      }, label:{
//                          "Credits"
//                          NavigationLink(destination: CreditView()){
//                           }
//                      }


 
    }
}

#Preview {
    MenuView()
}
