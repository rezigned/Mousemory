//
//  Settings.swift
//  Mousemory
//
//  Created by @rezigned on 19/9/2564 BE.
//

import Foundation
import SwiftUI

struct UserSettings {
    struct Highlight {
        static let defaultEnabled: Bool = true
        static let defaultColor: Color = Color(red: 0.45, green: 0.95, blue: 0.97, opacity: 0.7)
        static let defaultRawColor: String = defaultColor.rawValue
        static let defaultSize: Double = 25.0
        static let defaultRawSize: NSNumber = defaultSize as NSNumber
        static let defaultDuration: NSNumber = 3
        static let enableKey = "highlight.enabled"
        static let colorKey = "highlight.color"
        static let sizeKey = "highlight.size"
        static let durationKey = "highlight.delay"

        static var enabled: Bool {
            get {
                return UserDefaults.get(enableKey, defaultValue: defaultEnabled)
            }
        }

        static var color: NSColor {
            get {
                let color = UserDefaults.get(colorKey, defaultValue: defaultRawColor)

                return NSColor(Color.init(rawValue: color)!)
            }
        }

        static var size: CGFloat {
            get {
                let size = UserDefaults.get(sizeKey, defaultValue: defaultRawSize)

                return CGFloat(size.floatValue)
            }
        }

        static var duration: CGFloat {
            get {
                let duration = UserDefaults.get(durationKey, defaultValue: defaultDuration)

                return CGFloat(duration.floatValue)
            }
        }
    }

    static let defaultDelay: Double = 200.0
    static let defaultRawDelay: NSNumber = defaultDelay as NSNumber
    static let delayKey = "settings.delay"

    static var delay: CGFloat {
        get {
            let delay = UserDefaults.get(delayKey, defaultValue: defaultRawDelay)

            return CGFloat(delay.floatValue)
        }
    }
}

extension UserDefaults {
    static func get<T>(_ key: String, defaultValue: T) -> T {
        if let value = UserDefaults.standard.object(forKey: key) {
            return value as! T
        } else {
            return defaultValue
        }
    }

    static func reset() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
