//
//  ActiveApps.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 22/07/2023.
//

import Foundation
import SwiftUI

struct AppModel: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var duration: String
    
}

func lol() -> Void {
    print("Hello world")
}

class AppViewModel: ObservableObject {
    @Published var apps: [AppModel] = []
    
    func add(app: AppModel) {
        apps.append(app)
    }
    
    func remove(index: IndexSet) {
        apps.remove(atOffsets: index)
    }
    
    func getAll() {
        let app1 = AppModel(name: "VS Code", duration: "33min")
        let app2 = AppModel(name: "Zed Preview", duration: "34min")
        let app3 = AppModel(name: "Notion", duration: "35min")
        
        apps.append(app1)
        apps.append(app2)
        apps.append(app3)
    }
}
