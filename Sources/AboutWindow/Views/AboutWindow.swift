//
//  AboutWindow.swift
//  CodeEdit
//
//  Created by Wouter Hennen on 14/03/2023.
//

import SwiftUI

public struct AboutWindow: Scene {
    
    public init() {}

    public var body: some Scene {
        Window("", id: DefaultSceneID.about) {
            AboutView()
        }
        .defaultSize(width: 530, height: 220)
        .windowResizability(.contentSize)
        .windowStyle(.hiddenTitleBar)
    }
}
