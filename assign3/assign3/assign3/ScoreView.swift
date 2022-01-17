//
//  ScoreView.swift
//  assign3
//
//  Created by HLi on 4/4/21.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var triple: Triples
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    var body: some View {
        if verticalSizeClass == .regular{
            List{
                Section(header: Text("Highest Scores").bold().font(.largeTitle)){
                    ForEach(0..<triple.score_list.count,id:\.self){ idx in
                        Text("\(triple.score_list[idx].score)\t\t\t\(triple.score_list[idx].time.description)")
                    }
                }
            }
        }else{
            List{
                Section(header: Text("Highest Scores").bold().font(.largeTitle)){
                    ForEach(0..<triple.score_list.count,id:\.self){ idx in
                        Text("\(triple.score_list[idx].score)\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\(triple.score_list[idx].time.description)")
                    }
                }
            }
        }
    }
}

// extend the userdefaults for encode and decode codable object.
public extension UserDefaults {
    func setCodable<T:Codable>(_ object: T, forKey: String) throws{
        do{
            let jsonData:Data = try JSONEncoder().encode(object)
            set(jsonData, forKey: forKey)
        }catch _{
            print("fail to encode")
        }
        
    }
    func getCodable<T:Codable>(_ ot: T.Type, forKey: String) -> T?{
        guard let result = value(forKey: forKey) as? Data else{
            return nil
        }
        return try? JSONDecoder().decode(ot, from: result)
    }
}



struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView()
    }
}
