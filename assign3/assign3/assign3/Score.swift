//
//  Score.swift
//  assign3
//
//  Created by HLi on 4/4/21.
//

import Foundation

struct Score: Hashable,Codable{
    var score: Int
    var time: Date
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
}
