//
//  AboutWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/03/2023.
//

import SwiftUI

/// A `SwiftUI` Scene presenting an app icon, buttons, and more, in a stylized window.
public struct AboutWindow<Footer: View, SubtitleView: View>: Scene {
    private let actions: () -> AboutActions
    let footer: () -> Footer
    let iconImage: Image?
    let title: String?
    let subtitleView: (() -> SubtitleView)?

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

    public var body: some Scene {
        WindowGroup("") {
            AboutView(
                actions: actions,
                footer: footer,
                iconImage: iconImage,
                title: title,
                subtitleView: subtitleView
            )
            .task {
                // With WindowGroup on macOS 12, the scene id may not map to window.identifier.
                // Fallback to keyWindow so styling always applies.
                let targetWindow = NSApp.findWindow(DefaultSceneID.about) ?? NSApp.keyWindow
                if let window = targetWindow {
                    window.styleMask = [
                        .titled, .closable, .fullSizeContentView, .nonactivatingPanel,
                    ]

                    window.titleVisibility = .hidden
                    window.titlebarAppearsTransparent = true
                    window.isOpaque = true
                    window.backgroundColor = .windowBackgroundColor
                    window.isMovableByWindowBackground = true

                    window.standardWindowButton(.zoomButton)?.isHidden = true
                    window.standardWindowButton(.miniaturizeButton)?.isHidden = true

                    // Match the compact, content-fitting look from the project intro on macOS 12+
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
                            window.center()
                        }
                    }
                }
            }
        }
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
