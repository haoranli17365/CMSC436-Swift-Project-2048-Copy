//
//  assign3App.swift
//  assign3
//
//  Created by HLi on 3/19/21.
//

import SwiftUI

@main
struct assign3App: App {
    @StateObject var triple: Triples = Triples()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(triple)
        }
    }
}
