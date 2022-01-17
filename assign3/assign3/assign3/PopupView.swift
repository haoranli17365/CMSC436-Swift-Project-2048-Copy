//
//  PopupView.swift
//  assign3
//
//  Created by HLi on 4/4/21.
//

import SwiftUI

struct PopupView: View {
    @EnvironmentObject var triple: Triples
    var score: Int
    var defaults = UserDefaults.standard
    @Binding var show: Bool
    var is_random:Bool
    var body: some View {
        ZStack{
            if show{
                Color.black.opacity(show ? 0.3 : 0).edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 0){
                    Text("😆")
                        .font(.largeTitle)
                    Text("Score: \(self.score)")
                        .font(.title)
                        .padding(.all, 40)
                    Button("Close"){
                        withAnimation(.linear(duration: 0.3)){
                            show = false
                        }
                        // set up new game
                        triple.newgame(is_random)
        
                        // set the score in userdefault.standard, count total score.
                        if defaults.integer(forKey: "Total") == 0{
                            defaults.set(1, forKey: "Total")
                        }else{
                            defaults.set(defaults.integer(forKey: "Total")+1, forKey: "Total")
                        }
                        try? defaults.setCodable(Score(score: score, time: Date()), forKey: String(defaults.integer(forKey: "Total")))
                        triple.rerieve_score()
                    }
                    .buttonStyle(FilledButton())
                    .cornerRadius(30)
                }
                .frame(width: 350, height: 260, alignment: .center)
                .background(Color.white)
                .cornerRadius(9)
            }
        }
        
    }
    
}
