//
//  Types.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

struct LineDash {
    var phase: CGFloat
    var lengths: [CGFloat]
}

extension LineDash {
    static let solid = LineDash(phase: 0, lengths: [0])
    static let dashDot = LineDash(phase: 0, lengths: [10, 10, 1])
    static let dash = LineDash(phase: 0, lengths: [20])
}

struct GraphicsOptions {
    var lineWidth: CGFloat = 10
    var strokeColor = UIColor.darkGray
    var lineDash = LineDash.dash
}

protocol Shape {
    init(points: [CGPoint], options: GraphicsOptions)
    func draw(in context: CGContext, with options: WhiteboardView.Options)
    mutating func append(point: CGPoint)
}

extension Shape {
    init(_ options: GraphicsOptions) {
        self.init(points: [], options: options)
    }
}
