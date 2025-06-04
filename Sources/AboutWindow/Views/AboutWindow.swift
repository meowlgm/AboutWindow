//
//  AboutWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/03/2023.
//

import SwiftUI

public struct AboutWindow<Footer: View>: Scene {
    private let actions: () -> AboutActions
    let footer: () -> Footer

    public init(
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.actions = actions
        self.footer = footer
    }

    public var body: some Scene {
        Window("", id: DefaultSceneID.about) {
            AboutView(actions: actions, footer: footer)
                .task {
                    if let window = NSApp.findWindow(DefaultSceneID.about) {
                        window.styleMask = [
                            .titled, .closable, .fullSizeContentView, .nonactivatingPanel
                        ]

                        window.titleVisibility = .hidden
                        window.titlebarAppearsTransparent = true
                        window.backgroundColor = .clear
                        window.isMovableByWindowBackground = true

                        window.standardWindowButton(.zoomButton)?.isHidden = true
                        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                    }
                }
        }
        .defaultSize(width: 530, height: 220)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
