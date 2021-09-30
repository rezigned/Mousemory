//
//  Menu.swift
//  Mousemory
//
//  Created by @rezigned on 18/9/2564 BE.
//

import Foundation
import AppKit
import SwiftUI

class Menu {
    private var popover: NSPopover!
    private var statusBarItem: NSStatusItem!
    private var contentView: AnyView?

    private let menuItems = [
        (NSMenuItem(title: "Preferences...", action: #selector(showSettingsView(_:)), keyEquivalent: "S"), true),
        (NSMenuItem(title: "About", action: #selector(showAboutView(_:)), keyEquivalent: ""), true),
        (NSMenuItem.separator(), false),
        (NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"), false)
    ]

    init() {
        createStatusItem()
        createMenuItems()
        createPopover()
    }

    private func createStatusItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = statusBarItem.button {
            button.image = NSImage(named: "Icon")
        }
    }

    private func createMenuItems() {
        let menu = NSMenu()
        menuItems.forEach({(item, target) in
            // target must be specified when we're not using AppDelegate.
            // Otherwise the menu item will be disabled.
            if target {
              item.target = self
            }
            menu.addItem(item)
        })

        statusBarItem.menu = menu
    }

    func close() {
        self.contentView = nil
        popover.contentViewController = nil
        popover.close()
    }

    // Create the popover
    private func createPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient
    }

    private func addMenuItem(_ menu: NSMenu, menuItem: NSMenuItem, target: Bool?) {
        if target! {
            menuItem.target = self
        }

        menu.addItem(menuItem)
    }

    private func showView(_ sender: AnyObject?, view: AnyView) {
        if let button = statusBarItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.contentViewController = NSHostingController(rootView: view)
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    @objc func showAboutView(_ sender: AnyObject?) {
        contentView = AnyView(AboutView())
        showView(sender, view: contentView!)
    }

    @objc func showSettingsView(_ sender: AnyObject?) {
        contentView = AnyView(SettingsView())
        showView(sender, view: contentView!)
    }
}
