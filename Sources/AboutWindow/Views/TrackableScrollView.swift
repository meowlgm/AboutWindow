//
//  TrackableScrollView.swift
//  CodeEdit
//
//  Created by Lukas Pistrol on 19.01.23.
//

//  Inspired by SwiftUITrackableScrollView by Natchanon A.
//  https://github.com/maxnatchanon/trackable-scroll-view

import SwiftUI

@MainActor
private struct ScrollViewOffsetPreferenceKey: @preconcurrency PreferenceKey {
    typealias Value = [CGFloat]

    static var defaultValue: [CGFloat] = [0]

    nonisolated static func reduce(value: inout [CGFloat], nextValue: () -> [CGFloat]) {
        // Keep only the latest emitted value to avoid multiple updates per frame
        value = nextValue()
    }
}

struct TrackableScrollView<Content>: View where Content: View {
    let axes: Axis.Set
    let showIndicators: Bool
    @Binding var contentOffset: CGFloat
    @Binding var contentTrailingOffset: CGFloat?
    let content: Content

    init(
        _ axes: Axis.Set = .vertical,
        showIndicators: Bool = true,
        contentOffset: Binding<CGFloat>,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self._contentTrailingOffset = Binding.constant(nil)
        self.content = content()
    }

    init(
        _ axes: Axis.Set = .vertical,
        showIndicators: Bool = true,
        contentOffset: Binding<CGFloat>,
        contentTrailingOffset: Binding<CGFloat?>?,
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showIndicators = showIndicators
        self._contentOffset = contentOffset
        self._contentTrailingOffset = contentTrailingOffset ?? Binding.constant(nil)
        self.content = content()
    }

    var body: some View {
        GeometryReader { outsideProxy in
            ScrollView(self.axes, showsIndicators: self.showIndicators) {
                ZStack(alignment: self.axes == .vertical ? .top : .leading) {
                    GeometryReader { insideProxy in
                        Color.clear
                            .preference(
                                key: ScrollViewOffsetPreferenceKey.self,
                                value: [
                                    self.calculateContentOffset(
                                        fromOutsideProxy: outsideProxy,
                                        insideProxy: insideProxy
                                    ),
                                    self.calculateContentTrailingOffset(
                                        fromOutsideProxy: outsideProxy,
                                        insideProxy: insideProxy
                                    ),
                                ]
                            )
                    }
                    VStack {
                        self.content
                    }
                }
            }
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                let newOffset = value.indices.contains(0) ? value[0] : 0
                if abs(newOffset - contentOffset) > 0.5 {
                    contentOffset = newOffset
                }
                if contentTrailingOffset != nil, value.indices.contains(1) {
                    let newTrailing = value[1]
                    if abs((contentTrailingOffset ?? 0) - newTrailing) > 0.5 {
                        contentTrailingOffset = newTrailing
                    }
                }
            }
        }
    }

    private func calculateContentOffset(
        fromOutsideProxy outsideProxy: GeometryProxy,
        insideProxy: GeometryProxy
    ) -> CGFloat {
        if axes == .vertical {
            return insideProxy.frame(in: .global).minY - outsideProxy.frame(in: .global).minY
        } else {
            return insideProxy.frame(in: .global).minX - outsideProxy.frame(in: .global).minX
        }
    }

    private func calculateContentTrailingOffset(
        fromOutsideProxy outsideProxy: GeometryProxy,
        insideProxy: GeometryProxy
    ) -> CGFloat {
        if axes == .vertical {
            return insideProxy.frame(in: .global).maxY - outsideProxy.frame(in: .global).maxY
        } else {
            return insideProxy.frame(in: .global).maxX - outsideProxy.frame(in: .global).maxX
        }
    }
}
