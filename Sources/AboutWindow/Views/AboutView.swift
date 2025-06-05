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

import SwiftUI

public struct AboutView<Footer: View>: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentView: AnyView? // Tracks the current view (nil for root)
    @State private var aboutMode: AboutMode = .about
    
    @Namespace private var animator
    
    private let actions: (Namespace.ID) -> AboutActions
    private let footer: () -> Footer
    private let iconImage: Image?
    private let title: String?
    private let subtitle: String?
    
    public init(
        @ActionsBuilder actions: @escaping (Namespace.ID) -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer,
        iconImage: Image? = nil,
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.actions = actions
        self.footer = footer
        self.iconImage = iconImage
        self.title = title
        self.subtitle = subtitle
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // Root view (AboutDefaultView) or destination view
            if let destinationView = currentView {
                destinationView
            } else {
                AboutDefaultView(
                    namespace: animator,
                    actions: actions,
                    footer: footer,
                    iconImage: iconImage,
                    title: title,
                    subtitle: subtitle
                )
             
            }
        }
        .overlay(alignment: .topTrailing) {
            if currentView != nil {
                VStack {
                    Button {
                        withAnimation(.smooth) {
                            currentView = nil // Pop back to root
                        }
                    } label: {
                        Text("Remove")
                    }
                }
            }
        }
        .environment(\.aboutWindowNavigation, AboutWindowNavigation(
            navigate: { action in
                withAnimation(.smooth) {
                    if let navigable = action as? any NavigableAction {
                        currentView = navigable.destinationView()
                    }
                }
            },
            pop: {
                withAnimation(.smooth) {
                    currentView = nil
                }
            }
        ))
        .animation(.smooth, value: aboutMode)
        .ignoresSafeArea()
        .frame(width: 280, height: 400)
        .fixedSize()
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
