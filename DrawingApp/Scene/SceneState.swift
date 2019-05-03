//
//  Scene.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import Foundation

struct SceneState {
    var shapes: [Shape] = []
    var drawingOptions = DrawingOptions()
}

protocol SceneStateDisplaying: class {
    var state: SceneState { get set }
}

protocol SceneStateUpdating {
    func update(with state: SceneState)
}
