// These functions were ported from https://github.com/lwouis/alt-tab-macos/
//
//  WorkspaceManager.swift
//  Potem
//
//  Created by Faustino KIALUNGILA on 22/07/2023.
//

import Foundation
import AppKit
import Cocoa


func isNotXpc(_ app: NSRunningApplication) -> Bool {
    // these private APIs are more reliable than Bundle.init? as it can return nil (e.g. for com.apple.dock.etci)
    var psn = ProcessSerialNumber()
    GetProcessForPID(app.processIdentifier, &psn)
    var info = ProcessInfoRec()
    GetProcessInformation(&psn, &info)
    return String(info.processType) != "XPC!"
}

func isActualApplication(_ app: NSRunningApplication) -> Bool {
    // an app can start with .activationPolicy == .prohibited, then transition to != .prohibited later
    // an app can be both activationPolicy == .accessory and XPC (e.g. com.apple.dock.etci)
    return (isNotXpc(app)) && !app.processIdentifier.isZombie()
}
