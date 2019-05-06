//
//  Types.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import Foundation
import CoreGraphics

//enum ShapeKind {
//    case stroke
//    case eraser
//    case pattern
//    case image
//}

protocol Shape {
    init(points: [CGPoint], options: WhiteboardDrawingOptions)
    func draw(in context: CGContext, with options: WhiteboardDrawingOptions)
    mutating func append(point: CGPoint)
}

//struct Color {
//    var red: UInt8
//    var green: UInt8
//    var blue: UInt8
//    var alpha: Float
//}

struct Stroke {
    var points: [CGPoint]
    var width: CGFloat
    var color: CGColor
}

// TODO: move conformances to `Shape` into separate directory and file
extension Stroke: Shape {
    init(points: [CGPoint], options: WhiteboardDrawingOptions) {
        self.points = points
        width = options.lineWidth
        color = options.strokeColor.cgColor
    }

    mutating func append(point: CGPoint) {
        points.append(point)
    }

    func draw(in context: CGContext, with options: WhiteboardDrawingOptions) {
        let first = points[0]
        let rest = points[1 ..< points.count]

        context.setLineWidth(CGFloat(width))
        context.setStrokeColor(color)
        context.setLineCap(.round)
        context.move(to: first)
        for point in rest {
            context.addLine(to: point)
        }
        context.strokePath()
    }
}

// ctx.setLineDash(phase: 0, lengths: [10]) // [10, 10, 1]

struct Eraser {
    var stroke: Stroke
}

extension Eraser: Shape {
    init(points: [CGPoint], options: WhiteboardDrawingOptions) {
        stroke = Stroke(points: points, options: options)
    }

    mutating func append(point: CGPoint) {
        stroke.append(point: point)
    }

    func draw(in context: CGContext, with options: WhiteboardDrawingOptions) {
        var stroke = self.stroke
        stroke.color = options.backgroundColor.cgColor
        stroke.draw(in: context, with: options)
    }
}

//struct Shape {
//    var points: [CGPoint]
//    var width: Double
//    var strokeColor: CGColor
//}


