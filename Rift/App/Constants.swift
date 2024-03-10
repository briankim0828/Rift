//
//  Constants.swift
//  Rift
//
//  Created by Brian Kim on 3/9/24.
//

import Foundation
import SwiftUI

enum Constants {
    static let maxSimultaneousRenders = 3
    static let rotationPerSecond = Angle(degrees: 7)
    static let rotationAxis = SIMD3<Float>(0, 1, 0)
#if !os(visionOS)
    static let fovy = Angle(degrees: 65)
#endif
    static let modelCenterZ: Float = -8
}


