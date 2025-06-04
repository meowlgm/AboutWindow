//
//  AboutAction.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 04.06.25.
//
import SwiftUI

public struct AboutActionItem: Hashable, Identifiable {
    public let id = UUID()
    public let view: AnyView
    public let actionView: AboutActionView?

    public init<V: View>(_ view: V) {
        if let actionView = view as? AboutActionView {
            self.view = AnyView(actionView)
            self.actionView = actionView
        } else {
            self.view = AnyView(view)
            self.actionView = nil
        }
    }

    public static func == (lhs: AboutActionItem, rhs: AboutActionItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
