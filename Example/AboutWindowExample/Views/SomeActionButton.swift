//
//  SomeActionButton.swift
//  AboutWindowExample
//
//  Created by Giorgi Tchelidze on 04.06.25.
//
import SwiftUI
import AboutWindow

public struct SomeActionButton: View, NavigableAction {
    let title: String
    let destination: AnyView

    @Environment(\.aboutWindowNavigation)
    private var aboutWindow

    public init<V: View>(title: String, @ViewBuilder destination: () -> V) {
        self.title = title
        self.destination = AnyView(destination())
    }

    public var body: some View {
        Button(action: {
            aboutWindow?.navigate(self)
        }) {
            Text(title)
                .padding(10)
                .background(.gray.opacity(0.2))
                .clipShape(.capsule)
        }
        .buttonStyle(.plain)
    }

    public func destinationView() -> AnyView {
        destination
    }
}
