//
//  Events.swift
//  Mousemory
//
//  Created by @rezigned on 15/9/2564 BE.
//

import Foundation
import AppKit

extension AppDelegate {
    func observe() {
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                            selector: #selector(setActiveApp(_:)),
                                                            name: NSWorkspace.didActivateApplicationNotification,
                                                            object:nil)
    }

    // Activate event gets triggered before Deactivate event.
    @objc func setActiveApp(_ notification: NSNotification) {
        let delay = Int(UserSettings.delay)

        log("BEFORE: \(delay)")
        NSScreen.previous = NSScreen.main!
        Mouse.record()

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: { () in
            guard NSScreen.previous != NSScreen.main! else { return }

            log("AFTER: ", NSScreen.main!.localizedName)
            Mouse.restore()
        })
    }
}
