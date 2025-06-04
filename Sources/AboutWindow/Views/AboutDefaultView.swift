//
//  AboutDefaultView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 21/01/2023.
//

import SwiftUI

public struct AboutDefaultView<Footer: View>: View {
    private var appVersion: String {
        Bundle.versionString ?? "No Version"
    }

    private var appBuild: String {
        Bundle.buildString ?? "No Build"
    }

    private var appVersionPostfix: String {
        Bundle.versionPostfix ?? ""
    }

    var namespace: Namespace.ID
    
    private let actions: () -> AboutActions
    let footer: () -> Footer
    
    public init(
        namespace: Namespace.ID,
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.namespace = namespace
        self.actions = actions
        self.footer = footer
    }

    @Environment(\.colorScheme)
    var colorScheme

    private var licenseURL = URL(string: "https://github.com/CodeEditApp/CodeEdit/blob/main/LICENSE.md")!

    let smallTitlebarHeight: CGFloat = 28
    let mediumTitlebarHeight: CGFloat = 113
    let largeTitlebarHeight: CGFloat = 231

    public var body: some View {
        VStack(spacing: 0) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .matchedGeometryEffect(id: "AppIcon", in: namespace)
                .frame(width: 128, height: 128)
                .padding(.top, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                Text(Bundle.displayName)
                    .matchedGeometryEffect(id: "Title", in: namespace, properties: .position, anchor: .center)
//                    .blur(radius: aboutMode == .about ? 0 : 10)
                    .foregroundColor(.primary)
                    .font(.system(
                        size: 26,
                        weight: .bold
                    ))
                Text("Version \(appVersion)\(appVersionPostfix) (\(appBuild))")
                    .textSelection(.enabled)
                    .foregroundColor(Color(.tertiaryLabelColor))
                    .font(.body)
                    .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                    .padding(.top, 4)
                    .matchedGeometryEffect(
                        id: "Title",
                        in: namespace,
                        properties: .position,
                        anchor: UnitPoint(x: 0.5, y: -0.75)
                    )
//                    .blur(radius: aboutMode == .about ? 0 : 10)
//                    .opacity(aboutMode == .about ? 1 : 0)
            }
            .padding(.horizontal)
        }
        .padding(24)

        VStack {
            Spacer()
            VStack {
                ForEach(actions().all, id: \.self) { action in
                    action.view
                }
               footer()
            }
            .matchedGeometryEffect(id: "Titlebar", in: namespace, properties: .position, anchor: .top)
            .matchedGeometryEffect(id: "ScrollView", in: namespace, properties: .position, anchor: .top)
//            .blur(radius: aboutMode == .about ? 0 : 10)
//            .opacity(aboutMode == .about ? 1 : 0)
        }
        .padding(.horizontal)
    }
}
