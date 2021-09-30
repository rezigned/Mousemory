//
//  Mouse.swift
//  Mousemory
//
//  Created by @rezigned on 15/9/2564 BE.
//

import Foundation
import AppKit

class Mouse {
    static var location: NSPoint {
        get {
            // We can't use `NSEvent.mouseLocation` since it returns different
            // coordinate system.
            //
            // See https://stackoverflow.com/a/59863164
            return CGEvent(source: nil)!.location
        }
        set {
            let pt = CGPoint(x: newValue.x, y: newValue.y)

            CGWarpMouseCursorPosition(pt)
        }
    }

    static func setLocation(pos: NSPoint) {
        let pt = CGPoint(x: pos.x, y: pos.y)

        CGWarpMouseCursorPosition(pt)
    }

    static func record() {
        let id = NSScreen.activeIdentifier()
        let pos = location
        let data = [pos.x, pos.y]

        UserDefaults.standard.set(data, forKey: id)
    }

    static func restore() {
        let id = NSScreen.activeIdentifier()
        let defaults = UserDefaults.standard

        if let pos = defaults.array(forKey: id) as? [CGFloat] {
            // restore previous position
            location = NSPoint(x: pos[0], y: pos[1])
        }
        else {
            // default to center
            let size = NSScreen.main?.visibleFrame.size
            location = NSPoint(x: size!.width/2, y: size!.height/2)
        }

        Highlight.show()
    }
}
