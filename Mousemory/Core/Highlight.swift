import Cocoa
import SwiftUI

// Controls HighlightView
class Highlight {
    private static var window: NSWindow?
    private static var task: DispatchWorkItem?
    private static var inited = false

    static func show() {
        guard let screen = NSScreen.main else { return }
        guard UserSettings.Highlight.enabled else { return }

        load(screen: screen)
    }

    private static func setupWindow() -> NSWindow {
        let window = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: true)
        window.isOpaque = false
        window.makeKeyAndOrderFront(nil)
        window.backgroundColor = .clear
        window.level = .floating

        return window
    }

    private static func getLocation(screen: NSScreen) -> CGPoint {
        var location = NSEvent.mouseLocation
        location.x -= screen.frame.origin.x
        location.y -= screen.frame.origin.y

        return location
    }

    private static func load(screen: NSScreen) {
        // dispose existing view first
        window = window ?? setupWindow()
        window?.contentView?.removeFromSuperview()

        // create new view
        let highlightView = HighlighterView(
            frame: screen.frame,
            settings: UserSettings.Highlight.self,
            location: getLocation(screen: screen)
        )
        highlightView.settings = UserSettings.Highlight.self
        highlightView.location = getLocation(screen: screen)

        // attach to view to window
        window?.contentView = highlightView
        window?.setFrame(screen.frame, display: true)

        task?.cancel()
        task = DispatchWorkItem() { highlightView.hide() }

        DispatchQueue.main.async(execute: task!)
    }
}

class HighlighterView: NSView {
    var settings: UserSettings.Highlight.Type!
    var location: CGPoint?

    public init(frame: NSRect, settings: UserSettings.Highlight.Type, location: CGPoint) {
        super.init(frame: frame)
        self.settings = settings
        self.location = location
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let location = location else { return }

        let size = settings.size
        let color = settings.color
        let rect = setupRect(location: location, size: size)
        let path = NSBezierPath(roundedRect: rect, xRadius: size, yRadius: size)

        color.set()
        path.fill()
        path.appendRect(dirtyRect)
    }

    private func setupRect(location: CGPoint, size: CGFloat) -> NSRect {
        return NSMakeRect(
            location.x - size / 2,
            location.y - size / 2,
            size,
            size
        )
    }

    private func shake() {
        let animation = CABasicAnimation(keyPath: "position")

        animation.duration = 0.06
        animation.beginTime = CFTimeInterval() * -2
        animation.repeatCount = 2
        animation.autoreverses = true

        animation.fromValue = NSValue(point: CGPoint(x: self.frame.origin.x - 10, y: self.frame.origin.y - 10))
        animation.toValue = NSValue(point: CGPoint(x: self.frame.origin.x + 10, y: self.frame.origin.y + 10))
        self.layer?.add(animation, forKey: "position")
    }

    private func fadeOut() {
        self.alphaValue = 1
        self.isHidden = false

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.animator().alphaValue = 0
        })
    }

    func hide() {
        // remove animation will trigger completion handler
        self.layer?.removeAllAnimations()

        shake()
        fadeOut()
    }
}
