//
//  ActiveAppManager.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 22/07/2023.
//

import Foundation
import Cocoa
import AppKit
import Combine

struct RunningApp {
    let name: String
    var activeTime: TimeInterval
}

class RunningAppsViewModel: ObservableObject {
    @Published var runningApps_: [RunningApp] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        let workspace = NSWorkspace.shared
        
        workspace.notificationCenter.publisher(for: NSWorkspace.didActivateApplicationNotification)
            .sink { [weak self] notification in
                self?.handleAppActivation(notification: notification)
            }
            .store(in: &cancellables)
        
        workspace.notificationCenter.publisher(for: NSWorkspace.didDeactivateApplicationNotification)
            .sink { [weak self] notification in
                self?.handleAppDeactivation(notification: notification)
            }
            .store(in: &cancellables)
        
        runningApps_ = workspace.runningApplications.filter({ app in
            return isActualApplication(app) && app.launchDate != nil
        }).map { RunningApp(name: $0.localizedName!, activeTime: 0) }
    }
    
    func handleAppActivation(notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        if let index = runningApps_.firstIndex(where: { $0.name == app.localizedName! }) {
            // App is already in the array, update its active state
            runningApps_[index].activeTime = 0
        } else {
            // App is not in the array, add it
            runningApps_.append(RunningApp(name: app.localizedName!, activeTime: 0))
        }
    }
    
    func handleAppDeactivation(notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        if let index = runningApps_.firstIndex(where: { $0.name == app.localizedName! }) {
            let activeTime = Date().timeIntervalSince(app.activationPolicy == .regular ? app.launchDate ?? Date() : Date())
            runningApps_[index].activeTime += activeTime
        }
    }
}

// Example usage
let viewModel = RunningAppsViewModel()

func logApps() {
    for app in viewModel.runningApps_ {
        let hours = Int(app.activeTime / 3600)
        let minutes = Int((app.activeTime.truncatingRemainder(dividingBy: 3600)) / 60)
        print("\(app.name ?? "") was active for \(hours) hours and \(minutes) minutes.")
    }
}
