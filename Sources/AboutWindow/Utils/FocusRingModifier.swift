//
//  FocusRingModifier.swift
//  CodeEditWelcomeWindow
//
//  Created by Giorgi Tchelidze on 25.05.25.
//

import SwiftUI

struct FocusRingModifier<S: InsettableShape>: ViewModifier {
    let isFocused: Bool
    let shape: S

    func body(content: Content) -> some View {
        content
            .padding(1)
            .background(
                shape
                    .stroke(
                        isFocused ? Color(NSColor.keyboardFocusIndicatorColor) : Color.clear,
                        lineWidth: 3
                    )
            )
    }
}
