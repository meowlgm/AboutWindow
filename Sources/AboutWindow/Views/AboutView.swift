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

public struct AboutView<Footer: View>: View {
    @Environment(\.openURL)
    private var openURL
    @Environment(\.colorScheme)
    private var colorScheme
    @Environment(\.dismiss)
    private var dismiss
    
    @State var aboutMode: AboutMode = .about
    
    @Namespace var animator
    
    private let actions: () -> AboutActions
    let footer: () -> Footer
    
    @State private var path: NavigationPath = .init()

    public init(
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.actions = actions
        self.footer = footer
    }
    
    public var body: some View {
        
        NavigationStack(path: $path) {
            AboutDefaultView(namespace: animator, actions: actions, footer: footer)
            .navigationBarBackButtonHidden(true)
            .environment(\.aboutWindowNavigation, AboutWindowNavigation(
                navigate: { action in
                    path.append(AnyHashable(action))
                },
                pop: {
                    if !path.isEmpty {
                        path.removeLast()
                    }
                },
                popToRoot: {
                    path = NavigationPath()
                }
            ))
            .navigationDestination(for: AnyHashable.self) { hashable in
                if let navigable = hashable.base as? any NavigableAction {
                    navigable.destinationView()
                } else {
                    EmptyView()
                }
            }

            
        }
        .overlay(alignment: .topTrailing) {
            VStack {
                Button {
                    withAnimation {
                        path.removeLast()
                    }
                    
                    
                } label: {
                    Text("Remove")
                }
            }
            
        }
        .animation(.smooth, value: aboutMode)
        .ignoresSafeArea()
        .frame(width: 280, height: 400)
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
