//
//  AboutWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/03/2023.
//

@preconcurrency import SwiftUI

/// A custom NSWindow subclass for the About window with proper styling
private class AboutNSWindow: NSWindow {
    private var stateObservers: [NSObjectProtocol] = []

    override init(
        contentRect: NSRect,
        styleMask style: NSWindow.StyleMask,
        backing backingStoreType: NSWindow.BackingStoreType,
        defer flag: Bool
    ) {
        super.init(
            contentRect: contentRect,
            styleMask: style,
            backing: backingStoreType,
            defer: flag
        )

        // Configure window style immediately
        configureWindowStyle()

        // Add observers to maintain style on state changes
        setupObservers()
    }

    private func configureWindowStyle() {
        self.titleVisibility = .hidden
        self.titlebarAppearsTransparent = true
        self.isOpaque = false
        self.backgroundColor = .clear
        self.isMovableByWindowBackground = true

        self.standardWindowButton(.zoomButton)?.isHidden = true
        self.standardWindowButton(.miniaturizeButton)?.isHidden = true
    }

    private func setupObservers() {
        // Reapply configuration when window becomes or resigns key
        let becomeKeyObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didBecomeKeyNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.configureWindowStyle()
            }
        }
        stateObservers.append(becomeKeyObserver)

        let resignKeyObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didResignKeyNotification,
            object: self,
            queue: .main
        ) { [weak self] _ in
            DispatchQueue.main.async {
                self?.configureWindowStyle()
            }
        }
        stateObservers.append(resignKeyObserver)
    }

    deinit {
        stateObservers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}

/// A window controller for presenting an About window with app icon, buttons, and more.
///
/// Use the `.show()` method to display the About window using AppKit for better control
/// over window styling and behavior, especially on macOS 12.
public struct AboutWindow<Footer: View, SubtitleView: View> {
    private let actions: () -> AboutActions
    let footer: () -> Footer
    let iconImage: Image?
    let title: String?
    let subtitleView: (() -> SubtitleView)?

    /// Creates an About window controller
    /// - Parameters:
    ///   - iconImage: Optional custom app icon
    ///   - title: Optional custom title
    ///   - subtitleView: Optional custom subtitle view
    ///   - actions: Builder for action buttons
    ///   - footer: Builder for footer content
    public init(
        iconImage: Image? = nil,
        title: String? = nil,
        subtitleView: (() -> SubtitleView)? = nil,
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.iconImage = iconImage
        self.title = title
        self.subtitleView = subtitleView
        self.actions = actions
        self.footer = footer
    }

    /// Show the about window using AppKit
    @MainActor
    public func show() {
        // Check if window already exists
        if let existingWindow = NSApp.windows.first(where: { $0 is AboutNSWindow }) {
            existingWindow.makeKeyAndOrderFront(nil)
            return
        }

        // Create the SwiftUI view
        let aboutView = AboutView(
            actions: actions,
            footer: footer,
            iconImage: iconImage,
            title: title,
            subtitleView: subtitleView
        )

        // Create hosting controller
        let hostingController = NSHostingController(rootView: aboutView)

        // Create window with proper style
        let window = AboutNSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 420),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController

        // Size window to fit content
        DispatchQueue.main.async {
            if let contentView = window.contentView {
                contentView.layoutSubtreeIfNeeded()
                var fittingSize = contentView.fittingSize
                if fittingSize.width <= 1 || fittingSize.height <= 1 {
                    fittingSize = NSSize(width: 280, height: 420)
                }
                window.setContentSize(fittingSize)
                window.minSize = fittingSize
                window.maxSize = fittingSize
            }
        }

        window.center()
        window.makeKeyAndOrderFront(nil)
    }
}

extension AboutWindow where SubtitleView == EmptyView {
    /// Creates an about window without a subtitle view.
    public init(
        iconImage: Image? = nil,
        title: String? = nil,
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.init(
            iconImage: iconImage,
            title: title,
            subtitleView: nil,
            actions: actions,
            footer: footer
        )
    }
}

// MARK: - Scene Conformance
extension AboutWindow: Scene {
    public var body: some Scene {
        WindowGroup {
            AboutView(
                actions: actions,
                footer: footer,
                iconImage: iconImage,
                title: title,
                subtitleView: subtitleView
            )
            .background(WindowAccessor())
        }
    }
}

// MARK: - Window Accessor Helper
private struct WindowAccessor: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        WindowAccessorView()
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

private class WindowAccessorView: NSView {
    private var hasConfigured = false
    private var hasSizedWindow = false
    private var observers: [NSObjectProtocol] = []

    override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)

        // Clean up old observers
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()

        guard let window = newWindow else { return }

        if !hasConfigured {
            hasConfigured = true

            // Hide window temporarily to prevent flash
            let wasVisible = window.isVisible
            window.alphaValue = 0

            // Configure window style immediately (synchronously)
            Self.configureWindowStyle(window)

            // Size and center window, then show it
            DispatchQueue.main.async { [weak self, weak window] in
                guard let self = self, let window = window, !self.hasSizedWindow else { return }
                self.hasSizedWindow = true
                Self.sizeAndCenterWindow(window)

                // Restore visibility after configuration
                if wasVisible || window.isVisible {
                    window.alphaValue = 1
                }
            }
        }

        // Add observers to reapply style configuration on state changes
        let becomeKeyObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didBecomeKeyNotification,
            object: window,
            queue: .main
        ) { [weak window] _ in
            guard let window = window else { return }
            DispatchQueue.main.async {
                Self.configureWindowStyle(window)
            }
        }
        observers.append(becomeKeyObserver)

        let resignKeyObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.didResignKeyNotification,
            object: window,
            queue: .main
        ) { [weak window] _ in
            guard let window = window else { return }
            DispatchQueue.main.async {
                Self.configureWindowStyle(window)
            }
        }
        observers.append(resignKeyObserver)
    }

    private static func configureWindowStyle(_ window: NSWindow) {
        window.styleMask = [.titled, .closable, .fullSizeContentView]
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.isOpaque = false
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true

        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
    }

    private static func sizeAndCenterWindow(_ window: NSWindow) {
        if let contentView = window.contentView {
            contentView.layoutSubtreeIfNeeded()
            var fittingSize = contentView.fittingSize
            if fittingSize.width <= 1 || fittingSize.height <= 1 {
                fittingSize = NSSize(width: 280, height: 420)
            }
            window.setContentSize(fittingSize)
            window.minSize = fittingSize
            window.maxSize = fittingSize
            window.center()
        }
    }

    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}
