//
//  DrawingOptionsViewController.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

struct DrawingOptions: Codable {
    static let lineWidthRatio: Double = 20
    var lineWidth: Double = 4
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
        slider.value = Float(DrawingOptions().lineWidth / DrawingOptions.lineWidthRatio)
    }
}

extension DrawingOptionsViewController {
    @IBAction @objc func sliderDidChange() {
        let lineWidth = Double(slider.value) * DrawingOptions.lineWidthRatio
        let options = DrawingOptions(lineWidth: lineWidth)
        delegate?.optionsDidChanges(self, options: options)
    }
}
