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

class WhiteboardView: UIView {

    struct Options {
        var shapeType: Shape.Type = Stroke.self
        var graphicsOptions = GraphicsOptions()
        var backgroundColor = UIColor.white
    }

    var options = Options() {
        didSet {
            backgroundColor = options.backgroundColor
            setNeedsDisplay()
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
        if let count = delegate?.numberOfShapes(whiteboard: self) {
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

        context.saveGState()
        shape.draw(in: context, with: options)
        context.restoreGState()
    }

    override func draw(_ rect: CGRect) {
        drawShapes()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        let location: CGPoint = touch.location(in: self)

        currentShape = options.shapeType.init(
            points: [location],
            options: options.graphicsOptions
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
