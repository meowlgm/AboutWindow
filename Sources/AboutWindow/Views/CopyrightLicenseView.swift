//
//  CopyrightLicenseView.swift
//  AboutWindow
//
//  Created by Giorgi Tchelidze on 02.06.25.
//

import SwiftUI

public struct CopyrightLicenseView: View {
    let licenseURL: URL
    let copyright: String?

    @Environment(\.colorScheme)
    private var colorScheme

    public init(
        licenseURL: URL = URL(string: "https://github.com/CodeEditApp/CodeEdit/blob/main/LICENSE.md")!,
        copyright: String? = nil
    ) {
        self.licenseURL = licenseURL
        self.copyright = copyright
    }

    public var body: some View {
        VStack(spacing: 2) {
            Link(destination: licenseURL) {
                Text("MIT License")
                    .underline()
            }
            if let copyright {
                Text(copyright)
            }
        }
        .textSelection(.disabled)
        .font(.system(size: 11, weight: .regular))
        .foregroundColor(Color(.tertiaryLabelColor))
        .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
        .padding(.top, 12)
        .padding(.bottom, 24)
    }
}
