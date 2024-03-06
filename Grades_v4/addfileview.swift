//
//  addfileview.swift
//  Grades_v4
//
//  Created by Jakob Erlebach on 08.03.24.
//

import SwiftUI

struct addfileview: View {
    @State var nameinput: String = ""
    @State var lehererinput: String = ""
    @State var rauminput: String = ""
    @State var pickedcolor: Color = .blue
    
    @State var showerror: Bool = false
    
    @State var gewichtung: [(testarten, Double)] = [(.klassenarbeit, 50), (.epo, 25), (.hü, 25)]
    @State var KAgewichtung: String = "50"
    @State var EPOgewichtung: String = "25"
    @State var HÜgewichtung: String = "25"
    
    @State var KAgewspeicher: String = "50"
    @State var EPOgewspeicher: String = "25"
    @State var HÜgewspeicher: String = "25"
    
    
    @State var showgewichtungsaswahl: Bool = false
    
    @ObservedObject var storage: storageclass
    //var schuljahr: [schuljahrspeicher]
    
    var body: some View {
        ZStack{
            if showgewichtungsaswahl{
                Group{
                    VStack{
                        
                        Section{
                            VStack{
                                HStack{
                                    Text("Klassenarbeiten:")
                                    
                                    TextField("50(%)", text: $KAgewichtung)
                                }
                            }
                            Divider()
                            VStack{
                                HStack{
                                    Text("HÜ:")/*
                                                if gewichtung.count > 0{
                                                Text(gewichtung[0].1)
                                                }*/
                                    TextField("25(%)", text: $HÜgewichtung)
                                }
                            }
                            Divider()
                            VStack{
                                HStack{
                                    Text("EPO:")
                                    
                                    TextField("25(%)", text: $EPOgewichtung)
                                }
                            }
                            
                        }
                        Button(action: {
                            
                            
                            gewichtung = {
                                let a = Double(KAgewichtung) ?? 0
                                let b = Double(EPOgewichtung) ?? 0
                                let c = Double(HÜgewichtung) ?? 0
                                
                                if a<=0 || b<=0 || c<=0{
                                    showerror = true
                                    return []
                                }
                                showgewichtungsaswahl = false
                                
                                HÜgewspeicher = HÜgewichtung
                                KAgewspeicher = KAgewichtung
                                EPOgewspeicher = EPOgewichtung
                                
                                
                                return [(.klassenarbeit, a), (.epo, b), (.hü, c)]
                            }()
                            
                        }, label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                                Text("Speichern")
                                    .bold()
                                    .foregroundStyle(.white)
                            }.frame(height: UIScreen.main.bounds.height / 20)
                        })
                        
                        Button(action: {
                            showgewichtungsaswahl = false
                            KAgewichtung = KAgewspeicher
                            HÜgewichtung = HÜgewspeicher
                            EPOgewichtung = EPOgewspeicher
                            
                            
                        }, label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(Color("lightgray"))
                                    .cornerRadius(10)
                                Text("Zurück")
                                    .bold()
                                    .foregroundStyle(.blue)
                            }.frame(height: UIScreen.main.bounds.height / 20)
                        })
                    }
                    .background(.white)
                }
                .padding()
                .background(.white)
                .cornerRadius(15)
            }else{
                Group{
                    VStack{
                        Text("Name")
                            .bold()
                            .font(.system(size: 20))
                            .frame(width: (2*UIScreen.main.bounds.width) / 3, alignment: .leading)
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("lightgray"))
                                .cornerRadius(10)
                            TextField("FACH BSPW. MATHE", text: $nameinput)
                                .padding(.horizontal)
                            
                            
                        }.frame(height: UIScreen.main.bounds.height / 20)
                        
                        Divider()
                        
                        HStack{
                            Text("Gewichtung")
                                .bold()
                                .font(.system(size: 20))
                            Spacer()
                            Button(action: {
                                showgewichtungsaswahl = true
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height:UIScreen.main.bounds.width / 15)
                            })
                        }
                        
                        Divider()
                        
                        
                        
                        ColorPicker(selection: $pickedcolor, label: {
                            Text("Farbe")
                                .bold()
                                .font(.system(size: 20))
                            
                        })
                        Divider()
                        Text("Lehrer")
                            .bold()
                            .font(.system(size: 20))
                            .frame(width: (2*UIScreen.main.bounds.width) / 3, alignment: .leading)
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("lightgray"))
                                .cornerRadius(10)
                            TextField("LEHRER", text: $lehererinput)
                                .padding(.horizontal)
                            
                            
                        }.frame(height: UIScreen.main.bounds.height / 20)
                        Divider()
                        
                        Text("Raum")
                            .bold()
                            .font(.system(size: 20))
                            .frame(width: (2*UIScreen.main.bounds.width) / 3, alignment: .leading)
                        ZStack{
                            Rectangle()
                                .foregroundColor(Color("lightgray"))
                                .cornerRadius(10)
                            TextField("Raum", text: $rauminput)
                                .padding(.horizontal)
                            
                            
                        }.frame(height: UIScreen.main.bounds.height / 20)
                        
                        Divider()
                        Button(action: {
                            var counter = 0
                            for jahr in storage.schuljahre{
                                if jahr.jahr == storage.activeschuljahr{
                                    storage.schuljahre[counter].fächer.append(Fachspeicher(tests: [], color: pickedcolor, name: nameinput, lehrer: lehererinput, raum: rauminput, gewichtung: gewichtung, avg: 0))
                                }
                                counter += 1
                            }
                            
                            storage.addfach = false
                        }, label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(.blue)
                                    .cornerRadius(10)
                                Text("Speichern")
                                    .bold()
                                    .foregroundStyle(.white)
                            }.frame(height: UIScreen.main.bounds.height / 20)
                        })
                        Divider()
                        Button(action: {
                            storage.addfach = false
                        }, label: {
                            ZStack{
                                Rectangle()
                                    .foregroundColor(Color("lightgray"))
                                    .cornerRadius(10)
                                Text("Zurück")
                                    .bold()
                                    .foregroundStyle(.blue)
                            }.frame(height: UIScreen.main.bounds.height / 20)
                        })
                    }
                }.padding()
                    .background(.white)
                    .cornerRadius(15)
                
                
            }
        }
    }
}

#Preview {
    Wrapper()
}
/*
 .frame(width: (2*UIScreen.main.bounds.width) / 3, alignment: .leading)
 */
