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
    var shapes: [Shape]
//    var
}

protocol SceneDisplaying {

}

class MainViewController: UIViewController {

    @IBOutlet var whiteboardView: WhiteboardView!
    @IBOutlet var editItem: UIBarButtonItem!

    var optionsController: UIViewController!
    var whiteboardDelegate = WhiteboardShapeDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        optionsController = UIViewController()
        optionsController.modalPresentationStyle = .popover
        whiteboardView.delegate = whiteboardDelegate
        editItem.target = self
        editItem.action = #selector(editDidTap)
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
