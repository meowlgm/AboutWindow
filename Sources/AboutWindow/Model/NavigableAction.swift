//
//  NavigableAction.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 04.06.25.
//

import SwiftUI

public protocol NavigableAction {
    @MainActor func destinationView() -> AnyView
}

