//
//  DrawingOptionsViewController.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

protocol DrawingTool {
    var title: String { get }
    var shapeType: Shape.Type { get }
}

class DrawTool: DrawingTool {
    var title: String {
        return "Draw"
    }

    var shapeType: Shape.Type {
        return Stroke.self
    }
}

class DashesTool: DrawingTool {
    var title: String {
        return "Dashes"
    }

    var shapeType: Shape.Type {
        return DashedStroke.self
    }
}

class EraseTool: DrawingTool {
    var title: String {
        return "Erase"
    }

    var shapeType: Shape.Type {
        return Eraser.self
    }
}

struct DrawingOptions {

    static let allTools: [DrawingTool] = [
        DrawTool(), DashesTool(), EraseTool()
    ]

    static let lineWidthRatio: CGFloat = 40

    var lineWidth: CGFloat = 10
    var strokeColor = UIColor.darkGray
    var backgroundColor = UIColor.white
    var lineDash = LineDash.dash
    var selectedTool: DrawingTool {
        return DrawingOptions.allTools[selectedToolIndex]
    }

    fileprivate var selectedToolIndex: Int = 0
}

extension DrawingOptions {
    var sliderValue: Float {
        return Float(lineWidth / DrawingOptions.lineWidthRatio)
    }
}

protocol DrawingOptionsDelegate: class {
    func optionsDidChanges(_ controller: DrawingOptionsViewController, options: DrawingOptions)
}

class DrawingOptionsViewController: UIViewController {
    weak var delegate: DrawingOptionsDelegate?

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

extension DrawingOptionsViewController {
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
