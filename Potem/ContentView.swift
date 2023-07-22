//
//  ContentView.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 13/07/2023.
//

import SwiftUI


struct ListView: View {
    var data: [AppModel]
    
    var body: some View {
        List {
            ForEach(data) { app in
                HStack {
                    Text(app.name)
                        .bold()
                        .font(.headline)
                    Text(app.duration)
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct ContentView: View {

    // @StateObject var registers = [ActiveApps]
    var body: some View {
        VStack {
            ListView(data: DATA_FIXTURES)
        }
    }
}


struct AppModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String;
    var duration: String;
}

let DATA_FIXTURES = [
    AppModel(name: "VS Code", duration: "33min"),
    AppModel(name: "Zed Preview", duration: "40min"),
    AppModel(name: "Google Chrome", duration: "40min"),
    AppModel(name: "Xcode", duration: "40min"),
    AppModel(name: "Notion", duration: "40min"),
    AppModel(name: "Arc", duration: "40min")
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
