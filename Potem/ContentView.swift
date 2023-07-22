//
//  ContentView.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 13/07/2023.
//

import SwiftUI


struct ListView: View {
    var registers: [Registers]
    
    var body: some View {
        VStack {
            Table(registers) {
                TableColumn("App", value: \.appName)
                TableColumn("Duration", value: \.duration)
            }
        }
    }
}

struct ContentView: View {

    var body: some View {
        VStack {
            ListView(registers: DATA_FIXTURES)
        }
    }
}

struct Registers: Identifiable {
    var id = UUID()
    var appName: String;
    var duration: String;
}

let DATA_FIXTURES = [
    Registers(appName: "VS Code", duration: "33min"),
    Registers(appName: "Zed Preview", duration: "40min"),
    Registers(appName: "Google Chrome", duration: "40min"),
    Registers(appName: "Xcode", duration: "40min"),
    Registers(appName: "Notion", duration: "40min"),
    Registers(appName: "Arc", duration: "40min")
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
