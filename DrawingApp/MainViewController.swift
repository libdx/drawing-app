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
    var shapes: [Shape] = []
    var drawingOptions = DrawingOptions()
}

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

protocol SceneInteracting {
    var ui: SceneStateDisplaying? { get }

    func uiDidLoad()
    func uiDidChangeOptions(_ options: DrawingOptions)
    func uiDidAddNewShape(_ shape: Shape)
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
}

protocol SceneStateDisplaying: class {
    var state: SceneState { get set }
}

protocol SceneStateUpdating {
    func update(with state: SceneState)
}

class MainViewController: UIViewController, SceneStateDisplaying {

    @IBOutlet var whiteboardView: WhiteboardView!
    @IBOutlet var editItem: UIBarButtonItem!

    var optionsController: UIViewController!

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
        whiteboardView.delegate = self
        editItem.target = self
        editItem.action = #selector(editDidTap)
    }
}

extension WhiteboardView {
    func update(with options: DrawingOptions) {
        lineWidth = options.lineWidth
    }
}

extension MainViewController: SceneStateUpdating {
    func update(with state: SceneState) {
        whiteboardView.update(with: state.drawingOptions)
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

extension MainViewController: WhiteboardViewDelegate {
    func numberOfShapes(whiteboard: WhiteboardView) -> Int {
        return state.shapes.count
    }

    func shapeAt(whiteboard: WhiteboardView, index: Int) -> Shape {
        return state.shapes[index]
    }

    func hasNewShape(whiteboard: WhiteboardView, shape: Shape) {
        uiDidAddNewShape(shape)
        whiteboard.setNeedsDisplay()
    }
}

extension MainViewController: SceneInteracting, SceneProcessing {}
