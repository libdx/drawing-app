//
//  WhiteboardView+Scene.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 07/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

extension DrawingOptions {
    var graphicsOptions: GraphicsOptions {
        return GraphicsOptions(
            lineWidth: lineWidth,
            strokeColor: strokeColor.cgColor,
            lineDash: lineDash
        )
    }
}

extension WhiteboardView.Options {
    init(_ drawingOptions: DrawingOptions) {
        backgroundColor = drawingOptions.backgroundColor
        shapeType = drawingOptions.selectedTool.shapeType
        graphicsOptions = drawingOptions.graphicsOptions
    }
}
