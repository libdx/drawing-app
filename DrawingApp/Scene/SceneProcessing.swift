//
//  SceneProcessing.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import Foundation

protocol SceneProcessing {
    func changeDrawingOptions(_ options: DrawingOptions) -> SceneState
    func addNewShape(_ shape: Shape) -> SceneState
}

extension SceneProcessing where Self: SceneStateDisplaying {
    func changeDrawingOptions(_ options: DrawingOptions) -> SceneState {
        var state = self.state
        state.drawingOptions = options
        return state
    }

    func addNewShape(_ shape: Shape) -> SceneState {
        var state = self.state
        state.shapes.append(shape)
        return state
    }
}
