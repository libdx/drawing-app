//
//  SceneOptionsViewController.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

extension DrawingOptions {
    var sliderValue: Float {
        return Float(lineWidth / DrawingOptions.lineWidthRatio)
    }
}

protocol SceneOptionsDelegate: class {
    func optionsDidChanges(_ controller: SceneOptionsViewController, options: DrawingOptions)
}

class SceneOptionsViewController: UIViewController {
    weak var delegate: SceneOptionsDelegate?

    @IBOutlet var slider: UISlider!
    @IBOutlet var segmentedControl: UISegmentedControl!

    var drawingOptions = DrawingOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        segmentedControl.addTarget(self, action: #selector(toolDidChange), for: .valueChanged)
        slider.value = drawingOptions.sliderValue
    }

    private func setupSegmentedControl() {
        for (index, tool) in DrawingOptions.allTools.enumerated() {
            segmentedControl.setTitle(tool.title, forSegmentAt: index)
        }
        segmentedControl.selectedSegmentIndex = drawingOptions.selectedToolIndex
    }
}

extension SceneOptionsViewController {
    @IBAction @objc func sliderDidChange() {
        let lineWidth = CGFloat(slider.value) * DrawingOptions.lineWidthRatio

        drawingOptions.lineWidth = lineWidth
        delegate?.optionsDidChanges(self, options: drawingOptions)
    }

    @IBAction @objc func toolDidChange() {
        let index = segmentedControl.selectedSegmentIndex

        drawingOptions.selectedToolIndex = index
        delegate?.optionsDidChanges(self, options: drawingOptions)
    }
}
