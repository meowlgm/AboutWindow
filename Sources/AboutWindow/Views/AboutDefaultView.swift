//
//  AboutDefaultView.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 21/01/2023.
//

import SwiftUI

public struct AboutDefaultView<Footer: View>: View {

    @Environment(\.isAboutDetailPresented)
    private var isDetail

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

    private var isFooterEmpty: Bool {
        let footerView = footer()
        return Mirror(reflecting: footerView).subjectType == EmptyView.self
    }

    private var isMinimalContent: Bool {
        actions().all.isEmpty && isFooterEmpty
    }

    public var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 0) {
                (iconImage ?? Image(nsImage: NSApp.applicationIconImage))
                    .resizable()
                    .matchedGeometryEffect(id: AboutNamespaceID.appIcon, in: namespace)
                    .frame(width: 128, height: 128)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                VStack(spacing: 0) {

                    Text(title ?? Bundle.displayName)
                        .foregroundColor(.primary)
                        .blur(radius: !isDetail ? 0 : 10)
                        .font(.system(size: 26, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(subtitle ?? "Version \(appVersion)\(appVersionPostfix) (\(appBuild))")
                        .textSelection(.enabled)
                        .foregroundColor(Color(.tertiaryLabelColor))
                        .font(.body)
                        .blendMode(colorScheme == .dark ? .plusLighter : .plusDarker)
                        .padding(.top, 4)
                    // Apply offset to mimic anchor: UnitPoint(x: 0.5, y: -0.75)
                        .offset(y: isDetail ? -10 : 0) // Adjust offset dynamically based on isDetail
                        .blur(radius: !isDetail ? 0 : 10)
                        .opacity(!isDetail ? 1 : 0)
                }
                .matchedGeometryEffect(
                    id: AboutNamespaceID.title,
                    in: namespace,
                    properties: .position,
                    anchor: .center // Use center for the group, adjust subtitle with offset
                )
                .padding(.horizontal)
            }
            .padding([.top, .leading, .trailing], 24)
            .padding(.bottom, isMinimalContent ? 24 - 14 : 24)
            VStack {
                ForEach(actions().all, id: \.id) { action in
                    action.button
                        .blur(radius: !isDetail ? 0 : 10)
                        .opacity(!isDetail ? 1 : 0)
                }
                footer()
                    .blur(radius: !isDetail ? 0 : 10)
                    .opacity(!isDetail ? 1 : 0)
            }
            .matchedGeometryEffect(id: AboutNamespaceID.titleBar, in: namespace, properties: .position, anchor: .top)
            .matchedGeometryEffect(id: AboutNamespaceID.scrollView, in: namespace, properties: .position, anchor: .top)
            .padding(.horizontal)
        }
    }
}
