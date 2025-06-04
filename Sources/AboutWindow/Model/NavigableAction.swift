//
//  NavigableAction.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 04.06.25.
//
import SwiftUI

public protocol NavigableAction: Hashable {
    @MainActor func destinationView() -> AnyView
}

