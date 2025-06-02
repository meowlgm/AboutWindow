//
//  AboutActionView.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 02.06.25.
//


import SwiftUI

public struct AboutActionView: View {
    public var title: String
    public var action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
        }
        .controlSize(.large)
        .buttonStyle(.blur)
    }
}
