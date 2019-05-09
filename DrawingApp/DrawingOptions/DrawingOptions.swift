//
//  DrawingOptions.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 09/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

struct DrawingOptions {

    static let allTools: [DrawingTool] = [
        DrawTool(), DashesTool(), EraseTool()
    ]

    static let lineWidthRatio: CGFloat = 40

    var lineWidth: CGFloat = 10
    var strokeColor = UIColor.darkGray
    var backgroundColor = UIColor.white
    var lineDash = LineDash.dash
    var selectedTool: DrawingTool {
        return DrawingOptions.allTools[selectedToolIndex]
    }

    var selectedToolIndex: Int = 0
}
