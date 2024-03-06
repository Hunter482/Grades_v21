//
//  FachView.swift
//  Grades_v4
//
//  Created by Jakob Erlebach on 04.03.24.
//

import SwiftUI

struct FachView: View {
    
    var buttoncolor: Color = .red
    @ObservedObject var storage: storageclass
    @State var refreshtoogle: Bool = false
    @State var klassenarbeitenvorhanden: [testspeicher]
    @State var hüvorhanden: [testspeicher]
    @State var epovorhanden: [testspeicher]
    @State var offsetlistKA: [CGFloat]
    @State var offsetlistHÜ: [CGFloat]
    @State var offsetlistEPO: [CGFloat]
    @State var KAoffsetted: Bool = false
    @State var HÜoffsetted: Bool = false
    @State var EPOoffsetted: Bool = false
    @State var trydeletefach: Bool = false
    @State var alltests: [testspeicher]
    @State var fachdata: Fachspeicher?
    
    @State var klassenarbeitavarage: String = "-,--"
    @State var hüavarage: String = "-,--"
    @State var epoavarage: String = "-,--"
    @State var totalavarage: String = "-,--"
    
    
    init(storage: storageclass) {
        self.storage = storage
        self.hüvorhanden = []
        self.klassenarbeitenvorhanden = []
        self.epovorhanden = []
        self.fachdata = nil
        
        
        var hüspeicher: [testspeicher] = []
        var klassenarbeitenspeicher: [testspeicher] = []
        var epospeicher: [testspeicher] = []
        var offsetlistKAspeicher: [CGFloat] = []
        var offsetlistHÜspeicher: [CGFloat] = []
        var offsetlistEPOspeicher: [CGFloat] = []
        var alltestspeicher: [testspeicher] = []
        var fachdataspeicher: Fachspeicher?
        var gewichtung: [(testarten, Double)] = []
        var localklassenarbeitavarage: Double = 0
        var localhüavarage: Double = 0
        var localepoavarage: Double = 0
        
        
        var counter = 0
        for jahr in storage.schuljahre{
            if jahr.jahr == storage.activeschuljahr{
                var counter2 = 0
                for fach in storage.schuljahre[counter].fächer{
                    if fach.name == storage.activefach{
                        fachdataspeicher = fach
                        gewichtung = fach.gewichtung
                        var counter3 = 0
                        for test in storage.schuljahre[counter].fächer[counter2].tests{
                            alltestspeicher.append(test)
                            switch test.testart {
                            case .hü:
                                hüspeicher.append(storage.schuljahre[counter].fächer[counter2].tests[counter3])
                                offsetlistHÜspeicher.append(CGFloat(0))
                            case .klassenarbeit:
                                klassenarbeitenspeicher.append(storage.schuljahre[counter].fächer[counter2].tests[counter3])
                                offsetlistKAspeicher.append(CGFloat(0))
                            case .epo:
                                epospeicher.append(storage.schuljahre[counter].fächer[counter2].tests[counter3])
                                offsetlistEPOspeicher.append(CGFloat(0))
                            }
                            counter3 += 1
                        }
                    }
                    counter2 += 1
                }
            }
            counter += 1
        }
        
        _klassenarbeitavarage = {
            let speicher = klassenarbeitenspeicher
            let sum = speicher.reduce(0, { sum, new in
                sum + new.note
            })
            if sum != 0{
                var a = (sum / Double(klassenarbeitenspeicher.count)) * 100
                let b = Int(a)
                a = Double(b) / 100
                localklassenarbeitavarage = a
                return State(initialValue: String(a))
            }else{
                return State(initialValue: "-,--")
            }
        }()
        
        _hüavarage = {
            let speicher = hüspeicher
            let sum = speicher.reduce(0, { sum, new in
                sum + new.note
            })
            if sum != 0{
                var a = (sum / Double(hüspeicher.count)) * 100
                let b = Int(a)
                a = Double(b) / 100
                localhüavarage = a
                return State(initialValue: String(a))
            }else{
                return State(initialValue: "-,--")
            }
        }()
        
        _epoavarage = {
            let speicher = epospeicher
            let sum = speicher.reduce(0, { sum, new in
                sum + new.note
            })
            if sum != 0{
                var a = (sum / Double(epospeicher.count)) * 100
                let b = Int(a)
                a = Double(b) / 100
                localepoavarage = a
                return State(initialValue: String(a))
            }else{
                return State(initialValue: "-,--")
            }
        }()
        
        _totalavarage = {
            var sum: Double = 0
            var typsum: Double = 0
            for typ in gewichtung{
                switch typ.0{
                case .klassenarbeit:
                    if klassenarbeitenspeicher.count > 0{
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
            for typ in gewichtung{
                switch typ.0{
                case .klassenarbeit:
                    sum += typ.1 * localklassenarbeitavarage * factor
                case .hü:
                    sum += typ.1 * localhüavarage * factor
                case .epo:
                    sum += typ.1 * localepoavarage * factor
                }
            }
            if sum != 0 && sum.isFinite && !sum.isNaN{
                var avg = sum * 100
                let a = Int(avg)
                avg = Double(a) / 100
                
                return State(initialValue: String(avg))
            }else{
                return State(initialValue: "-,--")
            }
        }()
        
        _hüvorhanden = State(initialValue: hüspeicher)
        _klassenarbeitenvorhanden = State(initialValue: klassenarbeitenspeicher)
        _epovorhanden = State(initialValue: epospeicher)
        _offsetlistKA = State(initialValue: offsetlistKAspeicher)
        _offsetlistHÜ = State(initialValue: offsetlistHÜspeicher)
        _offsetlistEPO = State(initialValue: offsetlistEPOspeicher)
        _alltests = State(initialValue: alltestspeicher)
        if let unwrapped = fachdataspeicher{
            _fachdata = State(initialValue: unwrapped)
        }
        
    }
    
    func initialize(){
        hüvorhanden = []
        klassenarbeitenvorhanden = []
        epovorhanden = []
        fachdata = nil
        
        
        var hüspeicher: [testspeicher] = []
        var klassenarbeitenspeicher: [testspeicher] = []
        var epospeicher: [testspeicher] = []
        var offsetlistKAspeicher: [CGFloat] = []
        var offsetlistHÜspeicher: [CGFloat] = []
        var offsetlistEPOspeicher: [CGFloat] = []
        var alltestspeicher: [testspeicher] = []
        var fachdataspeicher: Fachspeicher?
        var gewichtung: [(testarten, Double)] = []
        var localklassenarbeitavarage: Double = 0
        var localhüavarage: Double = 0
        var localepoavarage: Double = 0
        
        
        var counter = 0
        for jahr in storage.schuljahre{
            if jahr.jahr == storage.activeschuljahr{
                var counter2 = 0
                for fach in storage.schuljahre[counter].fächer{
                    if fach.name == storage.activefach{
                        fachdataspeicher = fach
                        gewichtung = fach.gewichtung
                        var counter3 = 0
                        for test in storage.schuljahre[counter].fächer[counter2].tests{
                            alltestspeicher.append(test)
                            switch test.testart {
                            case .hü:
                                hüspeicher.append(storage.schuljahre[counter].fächer[counter2].tests[counter3])
                                offsetlistHÜspeicher.append(CGFloat(0))
                            case .klassenarbeit:
                                klassenarbeitenspeicher.append(storage.schuljahre[counter].fächer[counter2].tests[counter3])
                                offsetlistKAspeicher.append(CGFloat(0))
                            case .epo:
                                epospeicher.append(storage.schuljahre[counter].fächer[counter2].tests[counter3])
                                offsetlistEPOspeicher.append(CGFloat(0))
                            }
                            counter3 += 1
                        }
                    }
                    counter2 += 1
                }
            }
            counter += 1
        }
        
        klassenarbeitavarage = {
        let speicher = klassenarbeitenspeicher
            let sum = speicher.reduce(0, { sum, new in
                sum + new.note
            })
            if sum != 0{
                var a = (sum / Double(klassenarbeitenspeicher.count)) * 100
                let b = Int(a)
                a = Double(b) / 100
                localklassenarbeitavarage = a
                return String(a)
            }else{
                return "-,--"
            }
        }()
        
        hüavarage = {
            let speicher = hüspeicher
            let sum = speicher.reduce(0, { sum, new in
                sum + new.note
            })
            if sum != 0{
                var a = (sum / Double(hüspeicher.count)) * 100
                let b = Int(a)
                a = Double(b) / 100
                localhüavarage = a
                return String(a)
            }else{
                return "-,--"
            }
        }()
        
        epoavarage = {
            let speicher = epospeicher
            let sum = speicher.reduce(0, { sum, new in
                sum + new.note
            })
            if sum != 0{
                var a = (sum / Double(epospeicher.count)) * 100
                let b = Int(a)
                a = Double(b) / 100
                localepoavarage = a
                return String(a)
            }else{
                return "-,--"
            }
        }()
        
        totalavarage = {
            var sum: Double = 0
            var typsum: Double = 0
            for typ in gewichtung{
                switch typ.0{
                case .klassenarbeit:
                    if klassenarbeitenspeicher.count > 0{
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
            
            for typ in gewichtung{
                switch typ.0{
                case .klassenarbeit:
                    sum += typ.1 * localklassenarbeitavarage * factor
                case .hü:
                    sum += typ.1 * localhüavarage * factor
                case .epo:
                    sum += typ.1 * localepoavarage * factor
                }
            }
            if sum != 0{
                var avg = sum * 100
                let a = Int(avg)
                avg = Double(a) / 100
                var counter1 = 0
                for schuljahr in storage.schuljahre {
                    if schuljahr.jahr == storage.activeschuljahr{
                        var counter2 = 0
                        for fach in schuljahr.fächer{
                            if fach.name == storage.activefach{
                                storage.schuljahre[counter1].fächer[counter2].avg = avg
                                print("AVG:", fach.name, avg)
                                break
                            }
                            counter2 += 1
                        }
                    }
                    counter1 += 1
                }
                return String(avg)
            }else{
                return "-,--"
            }
        }()
        
        hüvorhanden = hüspeicher
        klassenarbeitenvorhanden = klassenarbeitenspeicher
        epovorhanden = epospeicher
        offsetlistKA = offsetlistKAspeicher
        offsetlistHÜ = offsetlistHÜspeicher
        offsetlistEPO = offsetlistEPOspeicher
        alltests = alltestspeicher
        if let unwrapped = fachdataspeicher{
            fachdata = unwrapped
        }
        
    }
    
    
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView{
                    Divider()
                        .onChange(of: refreshtoogle, {
                            initialize()
                        })
                    
                    if alltests.count >= 2{
                        Text("Diagramm:")
                            .font(.title)
                            .padding(.leading, 20)
                            .bold()
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        
                        
                        Chartview(storage: storage, color: fachdata != nil ? fachdata!.color : .gray)
                            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.width - 40)
                            .padding(.horizontal, 20)
                        Divider()
                    }
                    
                    if klassenarbeitenvorhanden.count > 0{
                        HStack{
                            Text("Klassenarbeiten").frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .font(.title)
                                .bold()
                            
                        label: do {
                            HStack{
                                Text(klassenarbeitavarage)
                                    .font(.title2)
                                    .foregroundStyle(Color("midgray"))
                                
                                Text("Ø").font(.title2)
                                    .bold()
                            }.padding(.trailing, 20)
                        }
                            
                        }
                        
                        ForEach(klassenarbeitenvorhanden.indices, id: \.self) { index in
                            HStack(){
                                Notenkasten(note: String(klassenarbeitenvorhanden[index].note), testtyp: klassenarbeitenvorhanden[index].testart)
                                    .padding(.horizontal)
                                    .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged({ value in
                                            self.offsetlistKA[index] = value.translation.width
                                            for offindex in offsetlistKA.indices{
                                                if offindex != index{
                                                    self.offsetlistKA[offindex] = CGFloat(0)
                                                }
                                            }
                                        })
                                             
                                            .onEnded({ value in
                                                if value.translation.width < 0 {
                                                    KAoffsetted = true
                                                    self.offsetlistKA[index] = -90
                                                }else{
                                                    KAoffsetted = false
                                                    //self.offset = 0
                                                }
                                            }))
                                
                                Button {
                                    for jahrindex in storage.schuljahre.indices{
                                        if storage.schuljahre[jahrindex].jahr == storage.activeschuljahr{
                                            for facherindex in storage.schuljahre[jahrindex].fächer.indices{
                                                if storage.schuljahre[jahrindex].fächer[facherindex].name == storage.activefach{
                                                    for testindex in storage.schuljahre[jahrindex].fächer[facherindex].tests.indices{
                                                        if storage.schuljahre[jahrindex].fächer[facherindex].tests[testindex].id == self.klassenarbeitenvorhanden[index].id{
                                                            storage.schuljahre[jahrindex].fächer[facherindex].tests.remove(at: testindex)
                                                            break
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.klassenarbeitenvorhanden.remove(at: index)
                                    self.offsetlistKA.remove(at: index)
                                    initialize()
                                } label: {
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.red)
                                            .cornerRadius(15)
                                            .frame(width: 70, alignment: .trailing)
                                        
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            
                                    }
                                }
                                .padding(.trailing, -70)
                            }
                            .offset(x: offsetlistKA[index])
                        }
                        
                        Divider()
                    }
                    
                    if hüvorhanden.count > 0{
                        HStack{
                            Text("HÜ'S").frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .font(.title)
                                .bold()
                            
                        label: do {
                            HStack{
                                Text(hüavarage)
                                    .font(.title2)
                                    .foregroundStyle(Color("midgray"))
                                
                                Text("Ø").font(.title2)
                                    .bold()
                            }.padding(.trailing, 20)
                        }
                            
                        }
                        
                        ForEach(hüvorhanden.indices, id: \.self) { index in
                            HStack(){
                                Notenkasten(note: String(hüvorhanden[index].note), testtyp: hüvorhanden[index].testart)
                                    .padding(.horizontal)
                                    .frame(width: UIScreen.main.bounds.width, alignment: .trailing)
                                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                        .onChanged({ value in
                                            self.offsetlistHÜ[index] = value.translation.width
                                            for offindex in offsetlistHÜ.indices{
                                                if offindex != index{
                                                    self.offsetlistHÜ[offindex] = CGFloat(0)
                                                }
                                            }
                                        })
                                             
                                            .onEnded({ value in
                                                if value.translation.width < 0 {
                                                    HÜoffsetted = true
                                                    self.offsetlistHÜ[index] = -90
                                                }else{
                                                    HÜoffsetted = false
                                                    //self.offset = 0
                                                }
                                            }))
                                
                                Button {
                                    for jahrindex in storage.schuljahre.indices{
                                        if storage.schuljahre[jahrindex].jahr == storage.activeschuljahr{
                                            for facherindex in storage.schuljahre[jahrindex].fächer.indices{
                                                if storage.schuljahre[jahrindex].fächer[facherindex].name == storage.activefach{
                                                    for testindex in storage.schuljahre[jahrindex].fächer[facherindex].tests.indices{
                                                        if storage.schuljahre[jahrindex].fächer[facherindex].tests[testindex].id == self.hüvorhanden[index].id{
                                                            storage.schuljahre[jahrindex].fächer[facherindex].tests.remove(at: testindex)
                                                            break
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.hüvorhanden.remove(at: index)
                                    self.offsetlistHÜ.remove(at: index)
                                    initialize()
                                } label: {
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.red)
                                            .cornerRadius(15)
                                            .frame(width: 70, alignment: .trailing)
                                        
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            
                                    }
                                }
                                .padding(.trailing, -70)
                            }
                            .offset(x: offsetlistHÜ[index])
                        }
                        
                        Divider()
                    }
                    if epovorhanden.count > 0{
                        HStack{
                            Text("EPO'S").frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .font(.title)
                                .bold()
                            
                        label: do {
                            HStack{
                                Text(epoavarage)
                                    .font(.title2)
                                    .foregroundStyle(Color("midgray"))
                                
                                Text("Ø").font(.title2)
                                    .bold()
                            }.padding(.trailing, 20)
                        }
                            
                        }
                        
                        
                        
                        
                        Divider()
                    }
                    
                    
                    Button("Löschen") {
                        self.trydeletefach = true
                    }.bold().font(.title3).foregroundColor(buttoncolor).frame(maxWidth: .infinity, alignment: .center)
                        .confirmationDialog("Are u sure?", isPresented: $trydeletefach){
                            Button("Fach Löschen", role: .destructive){
                                for jahrindex in storage.schuljahre.indices{
                                    if storage.schuljahre[jahrindex].jahr == storage.activeschuljahr{
                                        for facherindex in storage.schuljahre[jahrindex].fächer.indices{
                                            if storage.schuljahre[jahrindex].fächer[facherindex].name == storage.activefach{//------------
                                                storage.schuljahre[jahrindex].fächer.remove(at: facherindex)
                                                storage.activeview = .schuljahr
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    
                    
                    
                    
                }.navigationBarItems(trailing: Button(action: {
                    storage.addnote = true
                }){
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                        .foregroundColor(.blue)
                } )
                .navigationBarItems(leading:
                    Button(action: {
                        storage.activeview = .schuljahr
                    }, label: {
                        HStack{
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            
                                .foregroundColor(.blue)
                            
                            Text("Zurück")
                        }
                    })
                )
                .navigationBarTitle(fachdata!.name)
                .navigationTitle(storage.activefach)
                
            }
            if storage.addnote{
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .ignoresSafeArea(edges: .all)
                
                addnoteview(storage: storage, updatetoggle: $refreshtoogle, notenartinput: .klassenarbeit)
                    .padding(.horizontal, UIScreen.main.bounds.width / 6)
        }
        
    }
    
    }
}

struct FachView_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
    }
}

