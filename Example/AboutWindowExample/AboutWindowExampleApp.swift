//
//  AboutWindowExampleApp.swift
//  AboutWindowExample
//
//  Created by Giorgi Tchelidze on 02.06.25.
//

import SwiftUI
import AboutWindow

@main
struct AboutWindowExampleApp: App {
    var body: some Scene {
        Group {
            AboutWindow {
                AboutActionView(title: "Acknowledgements", action: { print("Hello") })
                AboutActionView(title: "Credits", action: { print("Hello") })
                AboutActionView(title: "Contributors", action: { print("Hello") })
            } footer: {
                CopyrightLicenseView()
            }
        }
    }
}
