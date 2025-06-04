//
//  NavigateKey.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 04.06.25.
//
import SwiftUI

private struct NavigateKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue: ((any NavigableAction) -> Void)? = nil
}

extension EnvironmentValues {
    var navigate: ((any NavigableAction) -> Void)? {
        get { self[NavigateKey.self] }
        set { self[NavigateKey.self] = newValue }
    }
}
