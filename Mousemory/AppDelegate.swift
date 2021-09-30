//
//  AppDelegate.swift
//  Mousemory
//
//  Created by @rezigned on 11/9/2564 BE.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var menu: Menu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        menu = Menu.init()
        observe()
    }

    func applicationDidResignActive(_ notification: Notification) {
        menu.close()
    }
}
