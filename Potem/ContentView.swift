//
//  ContentView.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 13/07/2023.
//

import SwiftUI


struct ListView: View {
    @ObservedObject var appViewModel: AppViewModel = AppViewModel()
    
    var body: some View {
        List {
            ForEach(appViewModel.apps) { app in
                HStack {
                    Text(app.name)
                        .bold()
                        .font(.headline)
                    Text(app.duration)
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            print(appViewModel.apps)
            getAllRunningApps()
            logApps()
            appViewModel.getAll()
        }
    }
}

struct ContentView: View {

    var body: some View {
        VStack {
            ListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
