//
//  ContentView.swift
//  Grades_v4
//
//  Created by Jakob Erlebach on 29.02.24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var storage: storageclass
    var schuljahr: [schuljahrspeicher]
    @State var refreshtoogle: Bool = false
    
    init(storage: storageclass) {
        
        self.storage = storage
        self.schuljahr = {
            storage.schuljahre.filter{ jahr in
                if jahr.jahr == storage.activeschuljahr{
                    return true
                }else{
                    return false
                }
                
            }
        }()
    }
    
    
    var body: some View {
        ZStack{
            
            Section{
                NavigationView{
                    ScrollView{
                        Divider()
                        ForEach(schuljahr[0].fächer, id: \.self) { fach in
                            Button(action: {
                                storage.activeview = .fach
                                storage.activefach = fach.name
                            }, label: {
                                Fachkachel(fachspeicher: fach, storage: storage, reloadtoggle: $refreshtoogle)
                            })
                            
                            
                        }
                        
                    }.navigationBarItems(leading: Button(action: {
                        
                    }){
                        Button(action: {
                            storage.activeview = .startscreen
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
                        
                        
                    } )
                    .navigationBarItems(trailing: Button(action: {
                        storage.addfach = true
                    }){
                        Image(systemName: "plus.rectangle.on.folder.fill")
                            .resizable()
                            .scaledToFit()
                            .padding(4)
                            .frame(width: 45, height: 35)
                        
                            .foregroundColor(.blue)
                    } )
                    .navigationTitle(schuljahr[0].jahr).frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            if storage.addfach{
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .ignoresSafeArea(edges: .all)
                    
                addfileview(storage: storage)
                    .padding(.horizontal, UIScreen.main.bounds.width / 9)

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


struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

#Preview {
    Wrapper()
}
