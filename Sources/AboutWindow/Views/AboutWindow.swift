//
//  AboutWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/03/2023.
//

import AppKit
import SwiftUI

/// An AppKit-based window presenting an app icon, buttons, and more, in a stylized window.
public class AboutWindow: NSPanel {
    private static var shared: AboutWindow?

    /// Shows the About window, creating it if necessary
    public static func show<Footer: View, SubtitleView: View>(
        iconImage: Image? = nil,
        title: String? = nil,
        subtitleView: (() -> SubtitleView)? = nil,
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        if let existingWindow = shared {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let aboutView = AboutView(
            actions: actions,
            footer: footer,
            iconImage: iconImage,
            title: title,
            subtitleView: subtitleView
        )

        let hostingController = NSHostingController(rootView: aboutView)

        let window = AboutWindow(
            contentRect: NSRect(x: 0, y: 0, width: 280, height: 400),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )

        window.contentViewController = hostingController
        window.center()
        window.title = ""
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.backgroundColor = .clear
        window.isMovableByWindowBackground = true
        window.isReleasedWhenClosed = false

        window.standardWindowButton(.zoomButton)?.isHidden = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true

        shared = window

        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    /// Shows the About window without subtitle view
    public static func show<Footer: View>(
        iconImage: Image? = nil,
        title: String? = nil,
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        show(
            iconImage: iconImage,
            title: title,
            subtitleView: { EmptyView() } as (() -> EmptyView)?,
            actions: actions,
            footer: footer
        )
    }

    /// Shows the About window with default footer
    public static func show<SubtitleView: View>(
        iconImage: Image? = nil,
        title: String? = nil,
        subtitleView: (() -> SubtitleView)? = nil,
        @ActionsBuilder actions: @escaping () -> AboutActions
    ) {
        show(
            iconImage: iconImage,
            title: title,
            subtitleView: subtitleView,
            actions: actions,
            footer: { EmptyView() }
        )
    }

    /// Shows the About window without subtitle view and with default footer
    public static func show(
        iconImage: Image? = nil,
        title: String? = nil,
        @ActionsBuilder actions: @escaping () -> AboutActions
    ) {
        show(
            iconImage: iconImage,
            title: title,
            subtitleView: { EmptyView() } as (() -> EmptyView)?,
            actions: actions,
            footer: { EmptyView() }
        )
    }

    public override func close() {
        super.close()
        Self.shared = nil
    }
}
