//
//  Tile.swift
//  assign3
//
//  Created by HLi on 3/19/21.
//

import Foundation

struct Tile: Equatable {
    var val : Int
    var id : Int
    var row: Int
    var col: Int
    
    static func ==(lhs: Tile, rhs: Tile) -> Bool {
        return lhs.val == rhs.val && lhs.id == rhs.id
    }
}
