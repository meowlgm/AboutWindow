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
                AboutActionView(title: "Acknowledgements", destination: {
                    AcknowledgementsView()
                })
                AboutActionView(title: "Credits", destination: { Text("Hellow") })
      
                AboutActionCard(title: "Jello") {
                    Text("Molley")
                }
            } footer: {
                CopyrightLicenseView()
            }
        }
    }
}
