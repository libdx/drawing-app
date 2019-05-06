//
//  SceneViewController+Updating.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

extension SceneViewController: SceneStateUpdating {
    func update(with state: SceneState) {
        whiteboardView.options.update(with: state.drawingOptions)
    }
}

