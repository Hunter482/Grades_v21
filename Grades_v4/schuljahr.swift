//
//  schuljahr.swift
//  Grades_v4
//
//  Created by Etienne Hüttl on 16.03.24.
//

import SwiftUI

struct schuljahr: View {
    var avg: String
    var accentcolour: Color = .white
    var schuljahr: schuljahrspeicher
    init(schuljahr: schuljahrspeicher) {
        self.accentcolour = .white
        self.schuljahr = schuljahr
        self.avg = {
            var sum: Double = 0
            var counter: Double = 0
            for fach in schuljahr.fächer{
                sum += fach.avg
                counter += 1
            }
            if counter != 0{
                var avg1 = sum / counter
                if avg1 == 0{
                    return "-,--"
                }else{
                    let a = avg1 * 100
                    let b = Double(Int(a))
                    let c = b / 100
                    return String(c)
                }
            }else{
                return "-,--"
            }
        }()

    }
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 27.54)
                .foregroundColor(schuljahr.farbe)
            
            VStack{
                HStack{
                    Text(schuljahr.jahr)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .bold()
                        .font(.title)
                        .padding(.leading, 20)
                        .padding(.top, 15)
                        .foregroundColor(accentcolour)
                    
                    VStack{
                    label: do {
                        HStack{
                            Text(self.avg)
                                .font(.largeTitle)
                                .foregroundColor(Color("lightgray"))
                            
                            Text("Ø").font(.largeTitle)
                                .foregroundColor(Color("lightgray"))
                        }.padding(.trailing, 25)
                    }
                    }
                }
                
                
            }
        }.frame(height: 130)
            .padding(.horizontal)
    }
}
#Preview {
    Wrapper()
}
