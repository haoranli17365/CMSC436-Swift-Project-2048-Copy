//
//  BoardView.swift
//  assign3
//
//  Created by HLi on 4/4/21.
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var triple: Triples
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var is_random: Bool = true
    @State var show_pop_up = false
    @State var shift_dir:Direction = Direction.up
    @State var is_animate:Bool = false
    @State var prev_board:[[Tile?]] = [[Tile?]](repeating: [Tile?](repeating: nil, count: 4), count: 4)
    var body: some View {
        ZStack{
            if verticalSizeClass == .regular{
            VStack{
                HStack{
                    Text("Score: \(triple.score)")
                        .font(.title)
                        .frame(width: 180, height:30)
                }
                VStack{
//                    let rec:CGRect = self.getFrame(dir: shift_dir)
                    
                    ForEach(0..<4, id: \.self){ row in
                        HStack{
                            ForEach(0..<4, id: \.self){ col in
                                TileView(tile: triple.board[row][col], is_animate: is_animate)
//                                    .offset(x: triple.board[row][col]?.val != nil && is_animate ? rec.minX : 0,
//                                            y:triple.board[row][col]?.val != nil && is_animate ? rec.minY : 0)
                                    .animation(Animation.easeInOut(duration: 1))
                            }
                        }
                    }
                    
                    
                }
                .onAppear(){
                    is_animate = false
                    prev_board = triple.board
                }
                .padding(.all, 10)
                .background(Color.gray)
            
                Button("Up"){
                    withAnimation(.easeInOut(duration: 1)){
                        shift_dir = .up
                        is_animate.toggle()
                    }
                    triple.collapse(dir: Direction.up,is_spawn: true)
                    triple.isGameDone()
                    if triple.is_done{
                        withAnimation(.linear(duration: 0.3)){
                            show_pop_up.toggle()
                        }
                    }
                }
                .buttonStyle(FilledButton())
                HStack{
                    Button("Left"){
                        shift_dir = .left
                        is_animate.toggle()
                        triple.collapse(dir: Direction.left,is_spawn: true)
                        triple.isGameDone()
                        if triple.is_done{
                            withAnimation(.linear(duration: 0.3)){
                                show_pop_up.toggle()
                            }
                        }
                    }
                    .frame(width: 170, height: 65)
                    .buttonStyle(FilledButton())
                    
                    Button("Right"){
                        shift_dir = .right
                        is_animate.toggle()
                        triple.collapse(dir: Direction.right,is_spawn: true)
                        triple.isGameDone()
                        if triple.is_done{
                            withAnimation(.linear(duration: 0.3)){
                                show_pop_up.toggle()
                            }
                        }
                    }
                    .frame(width: 170, height: 65)
                    .buttonStyle(FilledButton())
                }
                Button("Down"){
                    shift_dir = .down
                    is_animate.toggle()
                    triple.collapse(dir: Direction.down,is_spawn: true)
                    triple.isGameDone()
                    if triple.is_done{
                        withAnimation(.linear(duration: 0.3)){
                            show_pop_up.toggle()
                        }
                    }
                }
                .buttonStyle(FilledButton())
                
                Button("New Game"){
                    withAnimation(.linear(duration: 0.3)){
                        show_pop_up.toggle()
                    }
                }.buttonStyle(FilledButton())
                    
                Picker(selection: $is_random,label: Text("Select Mode")){
                    Text("Random").tag(true)
                    Text("Determ").tag(false)
                }.pickerStyle(SegmentedPickerStyle()).padding(12)
            
            }
            .gesture(DragGesture(minimumDistance: 10.0, coordinateSpace: .global)
                        .onEnded{ v in
                            let coord_x = v.location.x - v.startLocation.x
                            let coord_y = v.location.y - v.startLocation.y
                            if (coord_y >= 80) && (coord_x <= 50 && coord_x >= -50){
                                triple.collapse(dir: Direction.down, is_spawn: true)
                            }else if (coord_y <= -80) && (coord_x <= 50 && coord_x >= -50){
                                triple.collapse(dir: Direction.up, is_spawn: true)
                            }else if (coord_x >= 80) && (coord_y <= 50 && coord_y >= -50){
                                triple.collapse(dir: Direction.right, is_spawn: true)
                            }else if (coord_x <= -80) && (coord_y <= 50 && coord_y >= -50){
                                triple.collapse(dir: Direction.left, is_spawn: true)
                            }
                            triple.isGameDone()
                            if triple.is_done{
                                withAnimation(.linear(duration: 0.3)){
                                    show_pop_up.toggle()
                                }
                            }
                        })
            }else{
                HStack{
                    VStack{
                        ForEach(0..<4, id: \.self){ row in
                            HStack{
                                ForEach(0..<4, id: \.self){ col in
                                    TileView(tile: triple.board[row][col],is_animate: is_animate)
                                        .animation(.easeInOut(duration: 1))
                                }
                            }
                        }
                    }
                    .padding(.all, 5)
                    .background(Color.gray)

                    VStack{
                        HStack{
                            Text("Score: \(triple.score)")
                                .font(.title)
                                .frame(width: 180, height:30)
                        }
                        Button("Up"){
                            triple.collapse(dir: Direction.up,is_spawn: true)
                            triple.isGameDone()
                            if triple.is_done{
                                withAnimation(.linear(duration: 0.3)){
                                    show_pop_up.toggle()
                                }
                            }
                        }
                        .buttonStyle(FilledHButton())
                        HStack{
                            Button("Left"){
                                triple.collapse(dir: Direction.left,is_spawn: true)
                                triple.isGameDone()
                                if triple.is_done{
                                    withAnimation(.linear(duration: 0.3)){
                                        show_pop_up.toggle()
                                    }
                                }
                            }
                            .frame(width: 170, height: 65)
                            .buttonStyle(FilledHButton())
                            
                            Button("Right"){
                                triple.collapse(dir: Direction.right,is_spawn: true)
                                triple.isGameDone()
                                if triple.is_done{
                                    withAnimation(.linear(duration: 0.3)){
                                        show_pop_up.toggle()
                                    }
                                }
                            }
                            .frame(width: 170, height: 65)
                            .buttonStyle(FilledHButton())
                        }
                        Button("Down"){
                            triple.collapse(dir: Direction.down,is_spawn: true)
                            triple.isGameDone()
                            if triple.is_done{
                                withAnimation(.linear(duration: 0.3)){
                                    show_pop_up.toggle()
                                }
                            }
                        }
                        .buttonStyle(FilledHButton())
                        
                        Button("New Game"){
                            withAnimation(.linear(duration: 0.3)){
                                show_pop_up.toggle()
                            }
                        }.buttonStyle(FilledHButton())
                            
                        Picker(selection: $is_random,label: Text("Select Mode")){
                            Text("Random").tag(true)
                            Text("Determ").tag(false)
                        }.pickerStyle(SegmentedPickerStyle()).padding(8)
                    }
                }.gesture(DragGesture(minimumDistance: 10.0, coordinateSpace: .global)
                            .onEnded{ v in
                                let coord_x = v.location.x - v.startLocation.x
                                let coord_y = v.location.y - v.startLocation.y
                                if (coord_y >= 80) && (coord_x <= 50 && coord_x >= -50){
                                    triple.collapse(dir: Direction.down, is_spawn: true)
                                }else if (coord_y <= -80) && (coord_x <= 50 && coord_x >= -50){
                                    triple.collapse(dir: Direction.up, is_spawn: true)
                                }else if (coord_x >= 80) && (coord_y <= 50 && coord_y >= -50){
                                    triple.collapse(dir: Direction.right, is_spawn: true)
                                }else if (coord_x <= -80) && (coord_y <= 50 && coord_y >= -50){
                                    triple.collapse(dir: Direction.left, is_spawn: true)
                                }
                                triple.isGameDone()
                                if triple.is_done{
                                    withAnimation(.linear(duration: 0.3)){
                                        show_pop_up.toggle()
                                    }
                                }
                            })
            }
            PopupView(score:self.triple.score, show: $show_pop_up, is_random: is_random)
        }
    }
    func getFrame(dir:Direction) -> CGRect{
        if dir == .up{
            return CGRect(x: 0, y: -85, width: 80, height: 80)
        }else if dir == .down{
            return CGRect(x: 0, y: 85, width: 80, height: 80)
        }else if dir == .left{
            return CGRect(x: -88, y: 0, width: 80, height: 80)
        }else{
            return CGRect(x: 88, y: 0, width: 80, height: 80)
        }
    }
}

struct TileView: View{
    var tile = Tile(val: 0, id: 0, row: 0, col: 0)
        
    init(tile: Tile?, is_animate:Bool) {
        self.tile = tile ?? Tile(val: -1, id: -1, row: -1, col: -1)
    }
        
    var body: some View {
        // TODO: Change it back after debug
        Text("\(tile.val.description)")
            .frame(width: 80, height: 80)
            .padding(.bottom, -3)
            
            .background(tile.val == 1 ?
            Color.blue : (tile.val == 2 ?
            Color.green : (tile.val == 3 ?
            Color.yellow : (tile.val == 6 ?
            Color.red : (tile.val == 12 ?
            Color.purple : Color.white)))))
            .foregroundColor(tile.val == -1 ? Color.clear: Color.black)
            .font(Font.largeTitle)
    }
    
    
}

// define a button style for the game
struct FilledButton: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.title)
            .padding(11)
            .foregroundColor(.white)
            .frame(minWidth: 90)
            .background(configuration.isPressed ? Color.orange : .blue)
            .cornerRadius(9)
    }
}

struct FilledHButton: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .font(.title)
            .padding(8)
            .foregroundColor(.white)
            .frame(minWidth: 90)
            .background(configuration.isPressed ? Color.orange : .blue)
            .cornerRadius(9)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView().environmentObject(Triples())
    }
}
