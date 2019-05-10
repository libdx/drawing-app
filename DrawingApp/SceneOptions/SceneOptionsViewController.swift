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
        return Float(graphicsOptions.lineWidth / DrawingOptions.lineWidthRatio)
    }
}

struct SceneOptionsState {
    var drawingOptions = DrawingOptions()
}

protocol SceneOptionsDelegate: class {
    func optionsDidChanges(_ controller: SceneOptionsViewController, options: DrawingOptions)
    func didTapClearButton(_ controller: SceneOptionsViewController)
}

class SceneOptionsViewController: UIViewController {
    weak var delegate: SceneOptionsDelegate?

    @IBOutlet var slider: UISlider!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var clearButton: UIButton!

    var state = SceneOptionsState()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentedControl()
        setupSlider()
        setupClearButton()
    }

    private func setupClearButton() {
        clearButton.addTarget(self, action: #selector(clearDidTap), for: .touchUpInside)
    }

    private func setupSlider() {
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        slider.value = state.drawingOptions.sliderValue
    }

    private func setupSegmentedControl() {
        for (index, tool) in DrawingOptions.allTools.enumerated() {
            segmentedControl.setTitle(tool.title, forSegmentAt: index)
        }
        segmentedControl.selectedSegmentIndex = state.drawingOptions.selectedToolIndex
        segmentedControl.addTarget(self, action: #selector(toolDidChange), for: .valueChanged)
    }
}

extension SceneOptionsViewController {
    @objc func sliderDidChange() {
        let lineWidth = CGFloat(slider.value) * DrawingOptions.lineWidthRatio

        state.drawingOptions.graphicsOptions.lineWidth = lineWidth
        delegate?.optionsDidChanges(self, options: state.drawingOptions)
    }

    @objc func toolDidChange() {
        let index = segmentedControl.selectedSegmentIndex

        state.drawingOptions.selectedToolIndex = index
        delegate?.optionsDidChanges(self, options: state.drawingOptions)
    }

    @objc func clearDidTap() {
        // TODO: show confirmation alert or inline confirmation prompt
        delegate?.didTapClearButton(self)
    }
}
