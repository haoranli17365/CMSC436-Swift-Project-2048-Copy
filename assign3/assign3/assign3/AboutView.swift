//
//  AboutView.swift
//  assign3
//
//  Created by HLi on 4/4/21.
//

import SwiftUI

struct AboutView: View {
    @State var is_animate = false
    @State var degree:Double = 0.0
    let width:CGFloat = UIScreen.main.bounds.width
    let height:CGFloat = UIScreen.main.bounds.height
    let color_list:[Color] = [
        Color.init(red: 0, green: 0.9, blue: 1),
        Color.init(red: 0, green: 0.7, blue: 1),
        Color.blue,
        Color.init(red: 0, green: 0.2, blue: 0.9),
        Color.init(red: 0, green: 0.1, blue: 0.7)
    ]
    let duration_list:[Double] = [4.1,3.8,3.6,3.3,3]
    let standard_list:[CGFloat] = [
        UIScreen.main.bounds.height/26,
        UIScreen.main.bounds.height/12,
        UIScreen.main.bounds.height/5,
        UIScreen.main.bounds.height/3,
        UIScreen.main.bounds.height/2
    ]
    var body: some View {
        ZStack{
            
            ForEach(0...4,id:\.self){ idx in
                Path{ path in
                    path.move(to: CGPoint(x:0, y:standard_list[idx]))
                    
                    // fill the bottom space
                    path.addLine(to:CGPoint(x: width*5,y: height))
                    path.addLine(to: CGPoint(x: 0,y: height))
                }
                .offset(x: is_animate ? -1*width : 0)
                .animation(Animation.linear(duration: duration_list[idx])
                .repeatForever(autoreverses: true))
                .foregroundColor(color_list[idx])
                
            }
            Text("CMSC436")
                .frame(width: 300, height: 100, alignment: .center)
                .font(.largeTitle)
                .foregroundColor(.white)
        }.onAppear(){
            is_animate = true
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
