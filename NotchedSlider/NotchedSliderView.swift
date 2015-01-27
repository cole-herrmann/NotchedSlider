//
//  NotchedSliderView.swift
//  NotchedSlider
//
//  Created by Cole Herrmann on 1/26/15.
//  Copyright (c) 2015 Big Spoon Little Spoon. All rights reserved.
//

import Foundation
import UIKit

protocol NotchedSlider {
    func getSliderControlValue() -> Int
}

@IBDesignable class NotchedSliderView: UIView, NotchedSlider {

    @IBInspectable var numberOfNotches: Int = 0

    var sliderControlValue: Int = 1
    var delegate: SliderControlDelegate?
    
    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
    
    let slider: NotchedSliderControl = NotchedSliderControl(frame: self.bounds, numberOfNotches: self.numberOfNotches);
    self.addSubview(slider)
    
    }
    
    #else
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let slider: NotchedSliderControl = NotchedSliderControl(frame: self.bounds, numberOfNotches: self.numberOfNotches);
        slider.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(slider)
        
    }
    #endif
    
    func valueChanged(slider: NotchedSliderControl) {
        sliderControlValue = slider.sliderValue
        delegate?.sliderValueUpdated()
    }
    
    func getSliderControlValue() -> Int {
        return sliderControlValue
    }
    
}