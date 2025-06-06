//
//  AboutDefaultView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 21/01/2023.
//

import SwiftUI

public struct AboutDefaultView<Footer: View>: View {
    
    @Environment(\.isAboutDetailPresented) private var isDetail
    
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

    let smallTitlebarHeight: CGFloat = 28
    let mediumTitlebarHeight: CGFloat = 113
    let largeTitlebarHeight: CGFloat = 231

    public var body: some View {
        VStack(spacing: 0) {
            (iconImage ?? Image(nsImage: NSApp.applicationIconImage))
                .resizable()
                .matchedGeometryEffect(id: AboutNamespaceID.appIcon.rawValue, in: namespace)
                .frame(width: 128, height: 128)
                .padding(.top, 16)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                Text(title ?? Bundle.displayName)
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
                    // Apply offset to mimic anchor: UnitPoint(x: 0.5, y: -0.75)
                    .offset(y: isDetail ? -10 : 0) // Adjust offset dynamically based on isDetail
            }
            .matchedGeometryEffect(
                id: AboutNamespaceID.title.rawValue,
                in: namespace,
                properties: .position,
                anchor: .center // Use center for the group, adjust subtitle with offset
            )
            .blur(radius: !isDetail ? 0 : 10)
            .opacity(!isDetail ? 1 : 0)
            .padding(.horizontal)
        }
        .padding(24)

        VStack {
            Spacer()
            VStack {
                ForEach(actions().all, id: \.id) { action in
                    action.button
                }
                footer()
            }
            .matchedGeometryEffect(id: AboutNamespaceID.titleBar.rawValue, in: namespace, properties: .position, anchor: .top)
            .matchedGeometryEffect(id: AboutNamespaceID.scrollView.rawValue, in: namespace, properties: .position, anchor: .top)
            .blur(radius: !isDetail ? 0 : 10)
            .opacity(!isDetail ? 1 : 0)
        }
        .padding(.horizontal)
    }
}
