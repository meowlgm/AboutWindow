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
    let iconImage: Image?
    let title: String?
    let subtitle: String?
    
    public init(
        namespace: Namespace.ID,
        @ActionsBuilder actions: @escaping () -> AboutActions,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() },
        iconImage: Image? = nil,
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.namespace = namespace
        self.actions = actions
        self.footer = footer
        self.iconImage = iconImage
        self.title = title
        self.subtitle = subtitle
    }

    @Environment(\.colorScheme)
    var colorScheme

    private var licenseURL = URL(string: "https://github.com/CodeEditApp/CodeEdit/blob/main/LICENSE.md")!

    let smallTitlebarHeight: CGFloat = 28
    let mediumTitlebarHeight: CGFloat = 113
    let largeTitlebarHeight: CGFloat = 231

    public var body: some View {
        VStack(spacing: 0) {
            (iconImage ?? Image(nsImage: NSApp.applicationIconImage))
                .resizable()
                .matchedGeometryEffect(id: "AppIcon", in: namespace)
                .frame(width: 128, height: 128)
                .padding(.top, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                Text(title ?? Bundle.displayName)
                    .matchedGeometryEffect(id: "Title", in: namespace, properties: .position, anchor: .center)
                    .foregroundColor(.primary)
                    .font(.system(
                        size: 26,
                        weight: .bold
                    ))
                Text(subtitle ?? "Version \(appVersion)\(appVersionPostfix) (\(appBuild))")
                    .textSelection(.enabled)
                    .foregroundColor(Color(.tertiaryLabelColor))
                    .font(.body)
                    .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                    .padding(.top, 4)
                    .matchedGeometryEffect(
                        id: "Version",
                        in: namespace,
                        properties: .position,
                        anchor: UnitPoint(x: 0.5, y: -0.75)
                    )
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
        }
        .padding(.horizontal)
    }
}
