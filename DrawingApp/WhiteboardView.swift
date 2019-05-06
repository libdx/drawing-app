//
//  WhiteboardView.swift
//  Chalk
//
//  Created by Alexander Ignatenko on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import CoreGraphics

protocol WhiteboardViewDelegate {
    func numberOfShapes(whiteboard: WhiteboardView) -> Int
    func shapeAt(whiteboard: WhiteboardView, index: Int) -> Shape
    func didCreateShape(whiteboard: WhiteboardView, shape: Shape)
}

struct WhiteboardDrawingOptions {
    var lineWidth: CGFloat = 4
    var strokeColor = UIColor.darkGray
    var backgroundColor = UIColor.white
    var shapeType: Shape.Type = Stroke.self
}

class WhiteboardView: UIView {

    var options = WhiteboardDrawingOptions() {
        didSet {
            backgroundColor = options.backgroundColor
        }
    }

    var delegate: WhiteboardViewDelegate?

    private var currentShape: Shape?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func drawShapes() {
        if let count = delegate?.numberOfShapes(whiteboard: self){
            for i in 0 ..< count {
                if let shape = self.delegate?.shapeAt(whiteboard: self, index: i) {
                    drawShape(shape)
                }
            }
            if let currentShape = self.currentShape {
                drawShape(currentShape)
            }
        }
    }

    func drawShape(_ shape: Shape) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        shape.draw(in: context, with: options)

//        let first = shape.points[0]
//        let rest = shape.points[1 ..< shape.points.count]
//
//        ctx.setLineWidth(CGFloat(shape.width))
//        ctx.setStrokeColor(shape.strokeColor)
//        ctx.setLineCap(.round)
//        ctx.move(to: first)
//        for point in rest {
//            ctx.addLine(to: point)
//        }
//        ctx.strokePath()
    }

    override func draw(_ rect: CGRect) {
        drawShapes()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location: CGPoint = touch.location(in: self)

        currentShape = options.shapeType.init(
            points: [location],
            options: options
        )
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location: CGPoint = touch.location(in: self)

        // TODO: we may want to skip some locations (?)
        currentShape?.append(point: location)

        // we need to draw current shape
        setNeedsDisplay()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentShape = currentShape else { return }

        delegate?.didCreateShape(whiteboard: self, shape: currentShape)
        self.currentShape = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentShape = nil
    }
}
