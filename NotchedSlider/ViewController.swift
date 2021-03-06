//
//  ViewController.swift
//  NotchedSlider
//
//  Created by Cole Herrmann on 1/26/15.
//  Copyright (c) 2015 Big Spoon Little Spoon. All rights reserved.
//

import UIKit

protocol SliderControlDelegate{
    func sliderValueUpdated()
}

class ViewController: UIViewController, SliderControlDelegate {

    @IBOutlet weak var notchedSlider: NotchedSliderView!
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        notchedSlider.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sliderValueUpdated() {
        var numberString = "\(notchedSlider.getSliderControlValue())"
        numberLabel.text = numberString
    }

}

