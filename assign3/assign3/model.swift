//
//  model.swift
//  assign3
//
//  Created by HLi on 3/19/21.
//

import Foundation

// define enumeration for direction
enum Direction: CaseIterable{
    case up,down,left,right
}


class Triples: ObservableObject{
    // the main board
    @Published var board: [[Tile?]]
    @Published var score: Int
    @Published var is_random: Bool
    @Published var is_done:Bool
    @Published var score_list: [Score]
    var id_counter: Int // Tile ID counter to avoid repeatiton.
    var seed_generator: SeededGenerator
    
    // class initializer
    init() {
        self.id_counter = 0
        self.score_list = [Score]()
        self.board = [[Tile?]](repeating: [Tile?](repeating: nil, count: 4), count: 4)
        self.score = 0
        self.is_random = true
        self.is_done = false
        self.seed_generator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
        spawn(4, is_random, gen: &seed_generator)
        rerieve_score()
    }
    
    // re-inits 'board', and any other state you define
    public func newgame(_ is_random:Bool) {
        self.id_counter = 0
        self.board = [[Tile?]](repeating: [Tile?](repeating: nil, count: 4), count: 4)// re-init board
        self.score = 0
        self.is_random = is_random  // check the mode
        self.is_done = false
        if is_random{
            self.seed_generator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
        }else{
            self.seed_generator = SeededGenerator(seed: 14)
        }
        spawn(4, is_random, gen: &seed_generator)
    }
    
    public func rerieve_score(){
        score_list.removeAll()
        for idx in 1...UserDefaults.standard.integer(forKey: "Total"){
            if let elem = UserDefaults.standard.getCodable(Score.self, forKey: String(idx)){
                score_list.append(elem)
            }
        }
        score_list = score_list.sorted(by: { $0.score > $1.score })
    }
    
    func isGameDone(){
        // check all spaces
        var is_full = true
        var more_move = true
        // check if the board is full
        if !isBoardFull(){
            is_full = false
        }
        // making deep copy to test collapse for 4 directions
        if is_full && self.is_done == false{
            let original_board = self.board
            // check four direction
            for dir in Direction.allCases{
                self.collapse(dir: dir, is_spawn: false)
                //check for more move
                for row in 0..<4{
                    for col in 0..<4{
                        if self.board[row][col]?.val == original_board[row][col]?.val{
                            more_move = false
                        }else{
                            self.board = original_board // reset game board to previous move
                            return
                        }
                    }
                }
                self.board = original_board // reset game board to previous move
            }
            self.board = original_board // reset game board to previous move
        }
        if is_full && !more_move{
            self.is_done = true
        }
    }
    
    // check if game board is full
    func isBoardFull() -> Bool{
        for row in 0..<4{
            for col in 0..<4{
                if self.board[row][col] == nil{
                    return false
                }
            }
        }
        return true
    }
    
    // randomly chooses to create a new '1' or a '2', and puts it in an open tile, if there is one.
    func spawn(_ count:Int, _ mode:Bool, gen:inout SeededGenerator){
        var counter = count
        var spot_list = [(Int, Int)]()
        
        // check empty tile and store them
        for row in 0...3{
            for col in 0...3{
                if self.board[row][col] == nil{
                    spot_list.append((row,col))
                }
            }
        }
        while spot_list.count != 0 && counter != 0{
            if is_random{
                var _ = Int.random(in: 0..<spot_list.count, using: &gen)
            }
            // generate new 1 or 2, increament score
            let new_num = Int.random(in: 1...2, using: &gen)
            self.score += new_num
            // find spot to insert new number, remove spot from spot_list
            let spot_idx = Int.random(in: 0..<spot_list.count, using: &gen)
            let (row, col) = spot_list[spot_idx]
            
            self.board[row][col] = Tile(val: new_num, id: self.id_counter, row: row+1, col: col+1)
            self.id_counter += 1 // increment id_counter for next tile.
            
            spot_list.remove(at: spot_idx) // remove from avaliable spot list
            counter -= 1
        }
    }
    
    // rotate a square 2D Int array clockwise
    func rotate() {
        self.board = rotate2D(input: self.board)
    }
    
    // collapse to the left
    func shift(_ mode:Bool) {

        var new_board = self.board
        
        for temp_row_idx in 0...3{
            // collapsed flag
            var collapsed:Bool = false
            // check every element
            for idx in 1...3{
                //TODO: ID need to be swap.
                // previous is zero,current is non-zero. Swap
                if new_board[temp_row_idx][idx-1] == nil && new_board[temp_row_idx][idx] != nil{
                    // swap value of 2 tiles
                    new_board[temp_row_idx][idx-1] = Tile(val: new_board[temp_row_idx][idx]!.val, id: new_board[temp_row_idx][idx]!.id, row: new_board[temp_row_idx][idx]!.row, col: new_board[temp_row_idx][idx]!.col)
                    new_board[temp_row_idx][idx] = nil
                }
                // determine if two can collapse if have not been collapsed in the current row.
                if (new_board[temp_row_idx][idx-1] != nil && new_board[temp_row_idx][idx] != nil) && !collapsed{
                    if new_board[temp_row_idx][idx-1]!.val + new_board[temp_row_idx][idx]!.val == 3{
                        // 1 + 2 or 2 + 1
                        
                        new_board[temp_row_idx][idx-1] = Tile(val: (new_board[temp_row_idx][idx]!.val + new_board[temp_row_idx][idx-1]!.val), id: new_board[temp_row_idx][idx]!.id, row: new_board[temp_row_idx][idx]!.row, col: new_board[temp_row_idx][idx]!.col)
                        new_board[temp_row_idx][idx] = nil
                        
                        collapsed = true // set flag to true
                        
                        if mode{ // increment score
                            self.score += 3
                        }
                    }else if new_board[temp_row_idx][idx]!.val == new_board[temp_row_idx][idx-1]!.val && (new_board[temp_row_idx][idx]!.val + new_board[temp_row_idx][idx-1]!.val) % 3 == 0 {
                        // 3 or higher: two identical number adding and the result must be multiple of 3
                        let curr_score = new_board[temp_row_idx][idx]!.val
                        new_board[temp_row_idx][idx-1] = Tile(val: new_board[temp_row_idx][idx]!.val + new_board[temp_row_idx][idx-1]!.val, id: new_board[temp_row_idx][idx]!.id, row: new_board[temp_row_idx][idx]!.row, col: new_board[temp_row_idx][idx]!.col)
                        new_board[temp_row_idx][idx] = nil
                        collapsed = true // set flag to true
                        
                        if mode{ // increment score
                            self.score += (2*curr_score)
                        }
                    }else{
                        collapsed = false // still false
                    }
                }
            }
        }
        self.board = new_board // take the reference of the new board
    }
    
    // collapse in specified direction using shift() and rotate()
    public func collapse(dir: Direction,is_spawn: Bool){
        switch dir{
        case .up:
            rotate()
            rotate()
            rotate()
            shift(is_spawn)
            rotate()
        case .down:
            rotate()
            shift(is_spawn)
            rotate()
            rotate()
            rotate()
        case .left:
            shift(is_spawn)
        case .right:
            rotate()
            rotate()
            shift(is_spawn)
            rotate()
            rotate()
        }
        
        if is_spawn{
            spawn(1,is_random, gen: &seed_generator)
        }
        
    }
}

// class-less function that will return of any square 2D Int array rotated clockwise
public func rotate2DInts(input: [[Int]]) -> [[Int]] {
    rotate2D(input: input)
}

public func rotate2D<T>(input: [[T]]) -> [[T]] {
    var new_board:[[T]] = input // directly take the reference of the input 2d array
    var temp_row_idx = 0
    
    for idx in 0...3{
        var temp_idx = 0
        for arr in input.reversed(){
            new_board[temp_row_idx][temp_idx] = arr[idx]
            temp_idx += 1
        }
        temp_row_idx += 1
    }
    return new_board
}

