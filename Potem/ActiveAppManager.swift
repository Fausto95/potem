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
        let minutesStr = minutes != 0 ? "\(minutes)min": hours != 0 ? "0min" : "N/A"
        return "\(hoursStr) \(minutesStr)"
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

let POTEM_BUNDLE_ID = "com.potemteam.Potem"

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
            return app.activationPolicy == .regular
        }).reduce(into: [String: RunningApp]()) { acc, app in

            if app.bundleIdentifier == POTEM_BUNDLE_ID {
                acc[app.bundleIdentifier!] = RunningApp(
                    id: app.bundleIdentifier!,
                    name: app.localizedName!,
                    icon: app.icon!,
                    activeTime: 0
                )
            }

        }
    }

    func handleAppActivation(notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }

        let bundleId = app.bundleIdentifier ?? ""
        if let foundApp = runningApps[bundleId] {
            runningApps[foundApp.id]?.activeTime = 0;
        } else {
            // App is not in the array, add it
            if app.bundleIdentifier != POTEM_BUNDLE_ID {
                runningApps[bundleId] = RunningApp(
                    id: app.bundleIdentifier!,
                    name: app.localizedName!,
                    icon: app.icon!,
                    activeTime: 0
                )
            }

        }
    }

    func handleAppDeactivation(notification: Notification) {
        guard let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication else {
            return
        }
        let bundleId = app.bundleIdentifier ?? ""
        if runningApps[bundleId] != nil {
            let activeTime = Date().timeIntervalSince(app.activationPolicy == .regular ? app.launchDate ?? Date() : Date())
            runningApps[bundleId]?.activeTime += activeTime
        }
    }
}

let viewModel = RunningAppsViewModel()

func getTotalActiveTime(data: [String: RunningApp]) -> String {
    let total  = data.reduce(into: 0) { result, item in
        result += item.value.activeTime
    }
    
    let hours = Int(total / 3600)
    let minutes = Int(total.truncatingRemainder(dividingBy: 3600) / 60)
    let hoursStr = hours != 0 ? "\(hours)h" : ""
    return "\(hoursStr) \(minutes)min"
}

func logApps() {
    for (_, app) in viewModel.runningApps {
        let hours = Int(app.activeTime / 3600)
        let minutes = Int((app.activeTime.truncatingRemainder(dividingBy: 3600)) / 60)
        print("\(app.name) was active for \(hours) hours and \(minutes) minutes.")
    }
}
