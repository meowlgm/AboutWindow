//
//  AboutActions.swift
//  WelcomeWindow
//
//  Created by Giorgi Tchelidze on 28.05.25.
//

import SwiftUI

public enum AboutActions {
    case none
    case one(AboutActionItem)
    case two(AboutActionItem, AboutActionItem)
    case three(AboutActionItem, AboutActionItem, AboutActionItem)

    public var all: [AboutActionItem] {
        switch self {
        case .none: return []
        case .one(let a): return [a]
        case .two(let a, let b): return [a, b]
        case .three(let a, let b, let c): return [a, b, c]
        }
    }

    public var navigable: [AboutActionView] {
        all.compactMap { $0.actionView }
    }
}

