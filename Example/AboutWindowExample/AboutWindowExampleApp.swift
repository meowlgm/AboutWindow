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
            AboutWindow(iconImage: Image(systemName: "circle.fill"), actions: {
                AboutButton(title: "Acknowledgements", destination: {
                    AcknowledgementsView()
                })

                AboutButton(title: "Credits", destination: { Text("Credits View") })

                SomeAboutActionButton(title: "Some Custom Stuff") {
                    Text("Hello")
                }
              
            }, footer: {
                CopyrightLicenseView()
            })
        }
    }
}
