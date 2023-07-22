//
//  ContentView.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 13/07/2023.
//

import SwiftUI


struct ListView: View {
    @ObservedObject var viewModel = RunningAppsViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.runningApps_.keys.sorted(), id: \.self) { key in
                HStack {
                    Text("\(viewModel.runningApps_[key]?.name ?? "")")
                    Text("\(viewModel.runningApps_[key]?.activeTime.formatted() ?? "")")
                }
            }
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
