//
//  AboutWindowExampleApp.swift
//  AboutWindowExample
//
//  Created by Giorgi Tchelidze on 02.06.25.
//

import AboutWindow
import SwiftUI

@main
struct AboutWindowExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About AboutWindow Example") {
                    showAboutWindow()
                }
            }
        }
    }

    private func showAboutWindow() {
        AboutWindow.show(
            actions: {
                AboutButton(
                    title: "Contributors",
                    destination: {
                        ContributorsView()
                    })
                AboutButton(
                    title: "Acknowledgements",
                    destination: {
                        AcknowledgementsView()
                    })
                SomeActionButton(title: "Some Custom Stuff") {
                    MatchedTitle("Hello")
                }
            },
            footer: {
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
            }
        )
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("AboutWindow Example")
                .font(.largeTitle)

            Button("Show About Window") {
                AboutWindow.show(
                    actions: {
                        AboutButton(
                            title: "Contributors",
                            destination: {
                                ContributorsView()
                            })
                        AboutButton(
                            title: "Acknowledgements",
                            destination: {
                                AcknowledgementsView()
                            })
                        SomeActionButton(title: "Some Custom Stuff") {
                            MatchedTitle("Hello")
                        }
                    },
                    footer: {
                        FooterView(
                            primaryView: {
                                Link(
                                    destination: URL(string: "https://opensource.org/licenses/MIT")!
                                ) {
                                    Text("MIT License")
                                        .underline()
                                }
                            },
                            secondaryView: {
                                Text("© 2025 Example Inc.")
                            }
                        )
                    }
                )
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(width: 400, height: 300)
    }
}
