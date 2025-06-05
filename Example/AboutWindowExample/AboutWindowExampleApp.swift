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
            AboutWindow(actions: { namespace in
                AboutButton(title: "Acknowledgements", destination: {
                    AcknowledgementsView(namespace: namespace)
                })

                AboutButton(title: "Contributors", destination: {
                    ContributorsView(namespace: namespace)
                })

                SomeActionButton(title: "Some Custom Stuff") {
                    Text("Hello")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
              
            }, footer: {
                CopyrightLicenseView()
            })
        }
    }
}
