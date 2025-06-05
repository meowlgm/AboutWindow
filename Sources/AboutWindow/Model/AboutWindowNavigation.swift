//
//  AboutWindowNavigation.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 04.06.25.
//
import SwiftUI

public struct AboutWindowNavigation {
    public let navigate: (any NavigableAction) -> Void
    public let pop: () -> Void

    public init(
        navigate: @escaping (any NavigableAction) -> Void,
        pop: @escaping () -> Void
    ) {
        self.navigate = navigate
        self.pop = pop
    }
}
