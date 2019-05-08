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
    var strokeColor = UIColor.darkGray.cgColor
    var lineDash = LineDash.solid
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

struct Stroke {
    var points: [CGPoint] = []
    var width: CGFloat = 10
    var color: CGColor = UIColor.darkGray.cgColor
}

struct Eraser {
    var stroke: Stroke
}

struct DashedStroke {
    var lineDash = LineDash.solid
    var stroke: Stroke
}

// TODO: move conformances to `Shape` into separate directory and file
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

extension Eraser: Shape {
    init(points: [CGPoint], options: GraphicsOptions) {
        stroke = Stroke(points: points, options: options)
    }

    mutating func append(point: CGPoint) {
        stroke.append(point: point)
    }

    func draw(in context: CGContext, with options: WhiteboardView.Options) {
        var stroke = self.stroke
        stroke.color = options.backgroundColor.cgColor
        stroke.draw(in: context, with: options)
    }
}

extension DashedStroke: Shape {
    init(points: [CGPoint], options: GraphicsOptions) {
        stroke = Stroke(points: points, options: options)
        lineDash = options.lineDash
    }

    mutating func append(point: CGPoint) {
        stroke.append(point: point)
    }

    func draw(in context: CGContext, with options: WhiteboardView.Options) {
        context.setLineDash(phase: lineDash.phase, lengths: lineDash.lengths)
        stroke.draw(in: context, with: options)
    }
}
