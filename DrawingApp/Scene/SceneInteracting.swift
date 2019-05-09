//
//  SceneInteracting.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import Foundation

protocol SceneInteracting {
    var ui: SceneStateDisplaying? { get }

    func uiDidLoad()
    func uiDidTapEdit()
    func uiDidChangeOptions(_ options: DrawingOptions)
    func uiDidAddNewShape(_ shape: Shape)
    func uiDidTapClear()
}

extension SceneInteracting where Self: SceneStateDisplaying {
    var ui: SceneStateDisplaying? {
        return self
    }
}

extension SceneInteracting where Self: SceneProcessing {
    func uiDidLoad() {
        ui?.state = SceneState()
    }

    func uiDidChangeOptions(_ options: DrawingOptions) {
        ui?.state = changeDrawingOptions(options)
    }

    func uiDidAddNewShape(_ shape: Shape) {
        ui?.state = addNewShape(shape)
    }

    func uiDidTapClear() {
        ui?.state = clearShapes()
    }
}

extension SceneInteracting where Self: SceneRouting {
    func uiDidTapEdit() {
        showDrawingOptions()
    }
}
