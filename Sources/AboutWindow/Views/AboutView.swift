//
//  AboutView.swift
//  CodeEditModules/About
//
//  Created by Andrei Vidrasco on 02.04.2022
//

import SwiftUI

public enum AboutMode: String, CaseIterable {
    case about
    case acknowledgements
    case contributors
}

public struct AboutView<Actions: View, Footer: View>: View {
    @Environment(\.openURL)
    private var openURL
    @Environment(\.colorScheme)
    private var colorScheme
    @Environment(\.dismiss)
    private var dismiss

    @State var aboutMode: AboutMode = .about

    @Namespace var animator
    
    let actions: () -> Actions
    let footer: () -> Footer

    public init(
        @ViewBuilder actions: @escaping () -> Actions,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.actions = actions
        self.footer = footer
    }

    public var body: some View {
        ZStack(alignment: .top) {
            switch aboutMode {
            case .about:
                AboutDefaultView(
                    aboutMode: $aboutMode,
                    namespace: animator,
                    actions: actions,
                    footer: footer
                )
            case .acknowledgements:
                AcknowledgementsView(aboutMode: $aboutMode, namespace: animator)
            case .contributors:
                ContributorsView(aboutMode: $aboutMode, namespace: animator)
            }
        }
        .animation(.smooth, value: aboutMode)
        .ignoresSafeArea()
        .frame(width: 280, height: 400 - 28)
        .fixedSize()
        // hack required to get buttons appearing correctly in light appearance
        // if anyone knows of a better way to do this feel free to refactor
        .background(.regularMaterial.opacity(0))
        .background(EffectView(.popover, blendingMode: .behindWindow).ignoresSafeArea())
        .background {
            Button("") {
                dismiss()
            }
            .keyboardShortcut(.escape, modifiers: [])
            .hidden()
        }
    }
}
