//
//  Stroke.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 09/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import Foundation
import CoreGraphics

struct Stroke {
    var points: [CGPoint]
    var width: CGFloat
    var color: CGColor
}

extension Stroke: Shape {
    init(points: [CGPoint], options: GraphicsOptions) {
        self.points = points
        width = options.lineWidth
        color = options.strokeColor
    }

    mutating func append(point: CGPoint) {
        points.append(point)
    }

    func draw(in context: CGContext, with options: WhiteboardView.Options) {
        context.setLineWidth(CGFloat(width))
        context.setStrokeColor(color)
        context.setLineCap(.round)

        let first = points[0]
        let rest = points[1 ..< points.count]

        context.move(to: first)
        for point in rest {
            context.addLine(to: point)
        }
        context.strokePath()
    }
}
