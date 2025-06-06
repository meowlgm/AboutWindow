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
                    MatchedTitle("Hello")
                }
              
            }, footer: {
                FooterView(
                    primaryView: {
                        Link(destination: URL(string: "https://example.com")!) {
                            Text("Terms")
                                .underline()
                        }
                    },
                    secondaryView: {
                        Text("© 2025 Example Inc.")
                    }
                )
            })
        }
    }
}

struct MatchedTitle: View {
    @EnvironmentObject var namespaceWrapper: NamespaceWrapper

    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .matchedGeometryEffect(id: "Title", in: namespaceWrapper.namespace)
    }
}
