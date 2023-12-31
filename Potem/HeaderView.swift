//
//  HeaderView.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 23/07/2023.
//

import SwiftUI

let date = Date()

struct HeaderView: View {
    var totalActiveTime = ""
    
    var body: some View {
        HStack {
            Text("Today")
                .font(.title)
            Spacer()
            VStack(alignment: .trailing) {
                Text("Total time")
                    .bold()
                Text(
                    totalActiveTime)
                    .font(.title)
            }
            .frame(minWidth: 50)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
