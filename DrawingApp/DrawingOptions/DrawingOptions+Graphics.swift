//
//  DrawingOptions+Graphics.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 09/05/2019.
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
