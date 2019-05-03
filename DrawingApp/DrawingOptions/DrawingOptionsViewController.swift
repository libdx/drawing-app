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
    static let lineWidthRatio: Double = 20

    var lineWidth: Double = 4
    var backgroundColor = UIColor.white
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

    override func viewDidLoad() {
        super.viewDidLoad()
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        slider.value = DrawingOptions().sliderValue
    }
}

extension DrawingOptionsViewController {
    @IBAction @objc func sliderDidChange() {
        let lineWidth = Double(slider.value) * DrawingOptions.lineWidthRatio
        var options = DrawingOptions()
        options.lineWidth = lineWidth
        delegate?.optionsDidChanges(self, options: options)
    }
}
