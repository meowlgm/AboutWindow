//
//  AboutActionView.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 02.06.25.
//
import SwiftUI

public struct AboutActionView: View {
    private let id = UUID()
    private let title: String
    private let destination: AnyView?
    private let action: (() -> Void)?
    
    @Environment(\.navigate)
    private var navigate

    // Action only
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.destination = nil
    }

    // Destination only
    public init<V: View>(title: String, @ViewBuilder destination: () -> V) {
        self.title = title
        self.action = nil
        self.destination = AnyView(destination())
    }

    // Action + Destination
    public init<V: View>(title: String, action: @escaping () -> Void, @ViewBuilder destination: () -> V) {
        self.title = title
        self.action = action
        self.destination = AnyView(destination())
    }

    public var body: some View {
        Button {
            withAnimation {
                action?()
                if destination != nil {
                    navigate?(self)
                }
            }
        } label: {
            Text(title)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
        }
        .controlSize(.large)
        .buttonStyle(.blur)


    }
}

// MARK: - Navigable
extension AboutActionView: NavigableAction {
    public func destinationView() -> AnyView {
        destination ?? AnyView(EmptyView())
    }
}

// MARK: - Hashable + Equatable (nonisolated)

extension AboutActionView: Hashable {
    nonisolated public static func == (lhs: AboutActionView, rhs: AboutActionView) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct AboutActionCard: View, NavigableAction {
    let title: String
    let destination: AnyView

    @Environment(\.navigate) private var navigate

    public init<V: View>(title: String, @ViewBuilder destination: () -> V) {
        self.title = title
        self.destination = AnyView(destination())
    }

    public var body: some View {
        Button(action: {
            navigate?(self)
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

    nonisolated public static func == (lhs: AboutActionCard, rhs: AboutActionCard) -> Bool {
        lhs.title == rhs.title
    }

    nonisolated public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
