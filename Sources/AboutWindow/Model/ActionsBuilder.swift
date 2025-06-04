//
//  ActionsBuilder.swift
//  WelcomeWindow
//
//  Created by Giorgi Tchelidze on 28.05.25.
//

import SwiftUI

@resultBuilder
public enum ActionsBuilder {
    public static func buildBlock() -> AboutActions {
        .none
    }

    public static func buildBlock<V1: View>(_ v1: V1) -> AboutActions {
        .one(AboutActionItem(v1))
    }

    public static func buildBlock<V1: View, V2: View>(_ v1: V1, _ v2: V2) -> AboutActions {
        .two(AboutActionItem(v1), AboutActionItem(v2))
    }

    public static func buildBlock<V1: View, V2: View, V3: View>(_ v1: V1, _ v2: V2, _ v3: V3) -> AboutActions {
        .three(AboutActionItem(v1), AboutActionItem(v2), AboutActionItem(v3))
    }
}
