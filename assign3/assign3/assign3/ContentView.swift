//
//  ContentView.swift
//  assign3
//
//  Created by HLi on 3/19/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BoardView().tabItem {
                Label("Board", systemImage: "gamecontroller")
            }
            ScoreView().tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            AboutView().tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Triples())
    }
}

