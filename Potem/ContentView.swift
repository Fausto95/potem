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
            HStack {
                Text("App")
                Spacer()
                Text("Time")
            }
                .padding(.horizontal, 5)
                .background(Color.white)
            ForEach(viewModel.runningApps.sorted(by: { (lhs, rhs) -> Bool in
                        return lhs.value.activeTime > rhs.value.activeTime
            }), id: \.key) { key, value in
                HStack {
                    HStack {
                        Image(nsImage: value.icon )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(value.name)
                            .bold()
                    }
                    Spacer()
                    Text(value.activeTime.formatted())

                }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 5)
            }
        }
        .background(Color.white)
        .onAppear{
            logApps()
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
