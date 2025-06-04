//
//  AboutAction.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 04.06.25.
//
import SwiftUI

public struct AboutActionItem: Identifiable, Hashable {
    public let id = UUID()
    public let view: AnyView
    public let navTarget: (any NavigableAction)?

    public init<V: View>(_ view: V) {
        if let nav = view as? any NavigableAction {
            self.navTarget = nav
            self.view = AnyView(view)
        } else {
            self.navTarget = nil
            self.view = AnyView(view)
        }
    }

    public static func == (lhs: AboutActionItem, rhs: AboutActionItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
