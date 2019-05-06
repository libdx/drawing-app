//
//  DrawingOptionsViewController.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

//struct DrawingOptionsState {
//    var options = DrawingOptions()
//}

//protocol DrawingOptionsProcessing {
//    func changeDrawingOptions(_ options: DrawingOptions) -> DrawingOptionsState
//}
//
//protocol DrawingOptionsInteracting {
//    func uiDidChangeOptions(_ options: DrawingOptions)
//}

struct DrawingOptions {

    enum Tool: Int {
        case draw
        case erase
    }

    static let lineWidthRatio: Double = 20

    var lineWidth: Double = 4
    var backgroundColor = UIColor.white
    var selectedTool: Tool = .draw
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
        slider.value = DrawingOptions().sliderValue
        segmentedControl.selectedSegmentIndex = drawingOptions.selectedTool.rawValue
    }
}

extension DrawingOptionsViewController {
    @IBAction @objc func sliderDidChange() {
        let lineWidth = Double(slider.value) * DrawingOptions.lineWidthRatio

        drawingOptions.lineWidth = lineWidth
        delegate?.optionsDidChanges(self, options: drawingOptions)
    }

    @IBAction @objc func toolDidChange() {
        let index = segmentedControl.selectedSegmentIndex

        if let tool = DrawingOptions.Tool(rawValue: index) {
            drawingOptions.selectedTool = tool
            delegate?.optionsDidChanges(self, options: drawingOptions)
        }
    }
}
