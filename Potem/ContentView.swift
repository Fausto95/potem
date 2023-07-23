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
        HeaderView(totalActiveTime: getTotalActiveTime(data: viewModel.runningApps))
            .frame(height: 100)
            .background(Color.white)
            .padding(.horizontal, 20)
        HStack {
            Text("App")
                .bold()
            Spacer()
            Text("Time")
                .bold()
        }
            .padding(.horizontal, 20)
        List {
            ForEach(viewModel.runningApps.sorted(by: { (lhs, rhs) -> Bool in
                        return lhs.value.activeTime > rhs.value.activeTime
            }), id: \.key) { key, value in
                HStack {
                    HStack {
                        Image(nsImage: value.icon )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(value.name)
                    }
                    Spacer()
                    Text(value.activeTime.formatted())

                }
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
        .frame(minWidth: 500, minHeight: 300)
        .background(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
