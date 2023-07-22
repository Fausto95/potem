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

extension TimeInterval {
    func formatted() -> String {
        let hours = Int(self / 3600)
        let minutes = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
        let hoursStr = hours != 0 ? "\(hours)h" : ""
        return "\(hoursStr) \(minutes)min"
    }
}

struct RunningApp {
    static func > (lhs: RunningApp, rhs: RunningApp) -> Bool {
        return lhs.activeTime > rhs.activeTime
    }
    
    let id: String
    let name: String
    let icon: NSImage
    var activeTime: TimeInterval
}

class RunningAppsViewModel: ObservableObject {
    @Published var runningApps: [String: RunningApp] = [:]
    
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
        
        runningApps = workspace.runningApplications.filter({ app in
            return isActualApplication(app) && app.launchDate != nil
        }).reduce(into: [String: RunningApp]()) { acc, app in
            acc[app.bundleIdentifier!] = RunningApp(id: app.bundleIdentifier!, name: app.localizedName!, icon: app.icon!, activeTime: 0)
        }
    }
    
    func handleAppActivation(notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        if runningApps[app.bundleIdentifier ?? ""] == nil {
            // App is not in the array, add it
            runningApps[app.bundleIdentifier!] = RunningApp(id: app.bundleIdentifier!,name: app.localizedName!, icon: app.icon!, activeTime: 0)
        }
    }
    
    func handleAppDeactivation(notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        
        if (runningApps[app.bundleIdentifier!] != nil) {
            let activeTime = Date().timeIntervalSince(app.activationPolicy == .regular ? app.launchDate ?? Date() : Date())
            runningApps[app.bundleIdentifier!]!.activeTime = activeTime
        }
    }
}

let viewModel = RunningAppsViewModel()

func logApps() {
    for (_, app) in viewModel.runningApps {
        let hours = Int(app.activeTime / 3600)
        let minutes = Int((app.activeTime.truncatingRemainder(dividingBy: 3600)) / 60)
        print("\(app.name) was active for \(hours) hours and \(minutes) minutes.")
    }
}
