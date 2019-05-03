//
//  MainViewController.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 01/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

struct Shape {
    var points: [CGPoint]
    var width: Double
    var strokeColor: CGColor
}

/////

struct SceneState {
//    var shapes: [Shape]
    var lineWidth: Double = 4
}

protocol SceneProcessing {
    func applyOptionsChanges(_ options: DrawingOptions) -> SceneState
}

extension SceneProcessing where Self: SceneDisplaying {
    func applyOptionsChanges(_ options: DrawingOptions) -> SceneState {
        var state = self.state
        state.lineWidth = options.lineWidth
        return state
    }
}

protocol SceneInteracting {
    var ui: SceneDisplaying? { get }

    func uiDidChangeOptions(_ options: DrawingOptions)
}

extension SceneInteracting where Self: SceneDisplaying {
    var ui: SceneDisplaying? {
        return self
    }
}

extension SceneInteracting where Self: SceneProcessing {
    func uiDidChangeOptions(_ options: DrawingOptions) {
        ui?.state = applyOptionsChanges(options)
    }
}

protocol SceneDisplaying: class {
    var state: SceneState { get set }
}

protocol SceneDisplayUpdating {
    func update(with state: SceneState)
}

class MainViewController: UIViewController, SceneDisplaying {

    @IBOutlet var whiteboardView: WhiteboardView!
    @IBOutlet var editItem: UIBarButtonItem!

    var optionsController: UIViewController!
    var whiteboardDelegate = WhiteboardShapeDelegate()

    var state = SceneState() {
        willSet {
            update(with: newValue)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let drawingController = DrawingOptionsViewController()
        drawingController.delegate = self
        optionsController = drawingController
        optionsController.modalPresentationStyle = .popover
        whiteboardView.delegate = whiteboardDelegate
        editItem.target = self
        editItem.action = #selector(editDidTap)
    }
}

extension MainViewController: SceneDisplayUpdating {
    func update(with state: SceneState) {
        whiteboardView.lineWidth = state.lineWidth
    }
}

extension MainViewController {
    @IBAction @objc func editDidTap() {
        optionsController.popoverPresentationController?.barButtonItem = editItem
        present(optionsController, animated: true, completion: {})
    }
}

extension MainViewController: UIToolbarDelegate {
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension MainViewController: DrawingOptionsDelegate {
    func optionsDidChanges(_ controller: DrawingOptionsViewController, options: DrawingOptions) {
        uiDidChangeOptions(options)
    }
}

extension MainViewController: SceneInteracting, SceneProcessing {}
