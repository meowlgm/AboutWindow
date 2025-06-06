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
                AboutButton(title: "Contributors", destination: {
                    ContributorsView()
                })
                AboutButton(title: "Acknowledgements", destination: {
                    AcknowledgementsView()
                })
                SomeActionButton(title: "Some Custom Stuff") {
                    MatchedTitle("Hello")
                }
            }, footer: {
                FooterView(
                    primaryView: {
                        Link(destination: URL(string: "https://opensource.org/licenses/MIT")!) {
                            Text("MIT License")
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
    @Environment(\.aboutWindowNavigation)
    private var aboutWindow
    
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        VStack(alignment: .center) {
            Text(title)
                .matchedGeometryEffect(id: AboutNamespaceID.title, in: namespaceWrapper.namespace)
            Button("Go Back") {
                aboutWindow?.pop()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
