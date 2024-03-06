//
//  Fachkachel.swift
//  Grades_v4
//
//  Created by Jakob Erlebach on 02.03.24.
//

import SwiftUI
//@ObservedObject var storage: storageclass
struct Fachkachel: View, Hashable{

    
    @ObservedObject var storage: storageclass
    @Binding var reloadtoggle: Bool
    var accentcolor: Color = .white
    var fachspeicher: Fachspeicher
    var schnittKA: String
    var schnittHÜ: String
    var schnittEPO: String
    let id = UUID()
    var totalavg: String
    
    static func == (lhs: Fachkachel, rhs: Fachkachel) -> Bool {
        return lhs.storage == rhs.storage
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    
    init(fachspeicher: Fachspeicher, storage: storageclass, reloadtoggle: Binding<Bool>) {
        self.accentcolor = .white
        self.fachspeicher = fachspeicher
        self.storage = storage
        self._reloadtoggle = reloadtoggle
        
        var localavgka: Double = 0
        var localavghü: Double = 0
        var localavgepo: Double = 0
        
        var klassenarbeitspeicher: [testspeicher] = []
        var epospeicher: [testspeicher] = []
        var hüspeicher: [testspeicher] = []
        
        for test in fachspeicher.tests {
            switch test.testart {
            case .hü:
                hüspeicher.append(test)
            case .klassenarbeit:
                klassenarbeitspeicher.append(test)
            case .epo:
                epospeicher.append(test)
            }
        }
        
        
        self.schnittKA = {
            var sum: Double = 0
            var counter: Double = 0
            
            for test in fachspeicher.tests{
                if test.testart == .klassenarbeit{
                    sum += test.note
                    counter += 1
                }
            }
            localavgka = (sum/counter)
            
            if counter > 0{
                var avg = (sum/counter) * 100
                let a = Int(avg)
                avg = Double(a) / 100
                
                return String(avg)
            }else{
                return "-"
            }
            
        }()
        self.schnittHÜ = {
            var sum: Double = 0
            var counter: Double = 0
            
            for test in fachspeicher.tests{
                if test.testart == .hü{
                    sum += test.note
                    counter += 1
                }
            }
            localavghü = (sum/counter)
            
            if counter > 0{
                var avg = (sum/counter) * 100
                let a = Int(avg)
                avg = Double(a) / 100
                
                return String(avg)
            }else{
                return "-"
            }
        }()
        self.schnittEPO = {
            var sum: Double = 0
            var counter: Double = 0
            
            for test in fachspeicher.tests{
                if test.testart == .epo{
                    sum += test.note
                    counter += 1
                }
            }
            localavgepo = (sum/counter)
            
            if counter > 0{
                var avg = (sum/counter) * 100
                let a = Int(avg)
                avg = Double(a) / 100
                
                return String(avg)
            }else{
                return "-"
            }
        }()
        

        
        
        self.totalavg = {
            var sum: Double = 0
            var typsum: Double = 0
            for typ in fachspeicher.gewichtung{
                switch typ.0{
                case .klassenarbeit:
                    if klassenarbeitspeicher.count > 0{
                        typsum += typ.1
                    }
                case .hü:
                    if hüspeicher.count > 0{
                        typsum += typ.1
                    }
                case .epo:
                    if epospeicher.count > 0{
                        typsum += typ.1
                    }
                }
            }
            var factor: Double = 1/typsum
            
            for typ in fachspeicher.gewichtung{
                switch typ.0{
                case .klassenarbeit:
                    if localavgka > 0{
                        sum += typ.1 * localavgka * factor
                    }
                case .hü:
                    if localavghü > 0{
                        sum += typ.1 * localavghü * factor
                    }
                case .epo:
                    if localavgepo > 0{
                        sum += typ.1 * localavgepo * factor
                    }
                }
            }
            if sum != 0{
                var avg = sum * 100
                let a = Int(avg)
                avg = Double(a) / 100
                
                return String(avg)
            }else{
                return "-,--"
            }

        }()
    }
   
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 29.09)
                .foregroundStyle(fachspeicher.color)
                .opacity(0.77)
            
            
            VStack{
                
                HStack{
                    Text(fachspeicher.name)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.top, 15)
                        .padding(.leading, 20)
                        .foregroundColor(accentcolor)
                    
                    Button(action: {
                        storage.addnote = true
                        reloadtoggle.toggle()
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                            .frame(width: 40, height: 40)
                            .foregroundColor(accentcolor)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.top, 15)
                    .padding(.trailing, 15)
                }
                HStack{
                    VStack{
                        
                        Text("Ø KA")
                            .foregroundColor(Color("lightgray"))
                            .bold()
                        
                        Text(schnittKA)
                            .font(.title)
                            .foregroundColor(Color("lightgray"))
                            .bold()
                    }
                    VStack{
                        Text("")
                        
                        Text("|")
                            .font(.title)
                            .foregroundColor(Color("lightgray"))
                            .bold()
                    }
                    VStack{
                        Text("Ø HÜ")
                            .foregroundColor(Color("lightgray"))
                            .bold()
                        
                        Text(schnittHÜ)
                            .font(.title)
                            .foregroundColor(Color("lightgray"))
                            .bold()
                    }
                    VStack{
                        Text("")
                        
                        Text("|")
                            .font(.title)
                            .foregroundColor(Color("lightgray"))
                            .bold()
                    }
                    VStack{
                        Text("Ø Epo")
                            .foregroundColor(Color("lightgray"))
                            .bold()
                        
                        Text(schnittEPO)
                            .font(.title)
                            .foregroundColor(Color("lightgray"))
                            .bold()
                    }
                        Spacer()
                    VStack{
                    label: do {
                        HStack{
                            Text(totalavg)
                                .font(.largeTitle)
                                .foregroundColor(Color("lightgray"))
                            
                            Text("Ø").font(.largeTitle)
                                .foregroundColor(Color("lightgray"))
                        }.padding(.trailing, 25)
                    }
                    }
                        
                        
                    }.padding(.bottom, 15)
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                
            }
        }
        .padding(.horizontal, 15)
        .frame(height: 130)
    }
}

struct Fachkachel_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
    }
}

