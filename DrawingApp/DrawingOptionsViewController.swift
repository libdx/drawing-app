//
//  DrawingOptionsViewController.swift
//  DrawingApp
//
//  Created by Oleksandr Ignatenko on 03/05/2019.
//  Copyright © 2019 Oleksandr Ignatenko. All rights reserved.
//

import UIKit

struct DrawingOptions {
    var lineWidth: Double
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
        slider.value = Float(SceneState().lineWidth / 20)
    }
}

extension DrawingOptionsViewController {
    @IBAction @objc func sliderDidChange() {
        let lineWidth = Double(slider.value * 20)
        let options = DrawingOptions(lineWidth: lineWidth)
        delegate?.optionsDidChanges(self, options: options)
    }
}
