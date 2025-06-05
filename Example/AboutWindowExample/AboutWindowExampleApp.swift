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
            AboutWindow(actions: {
                AboutButton(title: "Acknowledgements", destination: {
                    AcknowledgementsView()
                })

                AboutButton(title: "Contributors", destination: {
                    ContributorsView()
                })

                SomeActionButton(title: "Some Custom Stuff") {
                    Text("Hello")
                }
              
            }, footer: {
                CopyrightLicenseView()
            })
        }
    }
}
