//
//  Wrapper.swift
//  Grades_v4
//
//  Created by Jakob Erlebach on 04.03.24.
//

import SwiftUI
import SwiftData


struct Wrapper: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var storage: storageclass = storageclass()
    
    var body: some View {
        switch storage.activeview {
        case .schuljahr:
            ContentView(storage: storage)
        case .fach:
            FachView(storage: storage)
        case .startscreen:
            startsreen(storage: storage)
        }
            .modelContext(modelContext)
    }
}

struct Wrapper_Previews: PreviewProvider {
    static var previews: some View {
        Wrapper()
    }
}
