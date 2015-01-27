//
//  NotchedSliderControl.swift
//  NotchedSlider
//
//  Created by Cole Herrmann on 1/23/15.
//  Copyright (c) 2015 Big Spoon Little Spoon. All rights reserved.
//

import Foundation
import UIKit

class NotchedSliderControl: UIControl {
    
    var sliderValue: Int = 0
    
    //handle view & frame that will get updated based on touch
    private var handleFrame: CGRect = CGRectZero
    private let handleView: UIView = UIView()

    //properties required for tracking touch correctly
    private var prevTouch: CGFloat = 0
    private var prevOrigin: CGFloat = 0
    
    //interval of notches, used to calculate value of slider
    private var interval: Double = 0

    //array of notches, used to figure out where to snap handle
    private var arrayOfNotches: [UIView] = [UIView]()
    
    //sizes of line, notches, handle
    private let handleSize: CGFloat = 40
    private let notchHeight: CGFloat = 40
    private let notchWidth: CGFloat = 8
    private let sliderLineHeight:CGFloat = 10
    
    //calculated in init
    private let sliderLineWidth:CGFloat = 0
    
    init(frame: CGRect, numberOfNotches: Int) {
        super.init(frame: frame)
        
        sliderLineWidth = (frame.size.width - handleSize)
        
        handleFrame = CGRectMake(self.frame.origin.x, center.y - handleSize/2, handleSize, handleSize)
        
        handleView = UIView(frame: handleFrame)
        handleView.userInteractionEnabled = false
        handleView.layer.cornerRadius = handleSize/2
        handleView.backgroundColor = UIColor.whiteColor()
        handleView.layer.borderWidth = 2
        handleView.layer.borderColor = UIColor(red:0.031, green:0.290, blue:0.522, alpha: 1).CGColor
        
        addSliderLine()
        addNotches(numberOfNotches)
        
        addSubview(handleView)
        
        backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSliderLine() {
        var view = UIView(frame:
            CGRectMake(frame.size.width/2 - sliderLineWidth/2,
            frame.size.height/2 - sliderLineHeight/2,
            sliderLineWidth,
            sliderLineHeight))
        
        view.backgroundColor = UIColor(red:0.031, green:0.290, blue:0.522, alpha: 1)
        view.userInteractionEnabled = false
        view.layer.cornerRadius = 5
        addSubview(view)
    }
    
    private func addNotches(numberOfNotches: Int) {
        
        interval = (Double(sliderLineWidth) / Double(numberOfNotches - 1))
        
        for(var i = 0; i < numberOfNotches; i++){
            
            var x = (CGFloat(interval) * CGFloat(i)) + (handleSize/2)
        
            var view = UIView(frame:
                CGRectMake((i != numberOfNotches - 1) ? x : x - notchWidth,
                    center.y - notchHeight/2,
                    notchWidth,
                    notchHeight))
            
            view.backgroundColor = UIColor(red:0.031, green:0.290, blue:0.522, alpha: 1)
            view.userInteractionEnabled = false
            view.layer.cornerRadius = 4
            arrayOfNotches.append(view)
            addSubview(view)
        }
    
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        handleView.frame = handleFrame
    }
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        //get the last place user touched, and last origin of the handle's frame
        //use this to calculate how far handle should move on slide
        prevTouch = touch.locationInView(self).x
        prevOrigin = handleFrame.origin.x
        
        return (CGRectContainsPoint(handleFrame, touch.locationInView(self)))
    }
    
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        var lastPoint = touch.locationInView(self)
        self.moveHandle(lastPoint)
        
        return true
    }
    
    
    private func moveHandle(lastPoint:CGPoint){
        
        var deltaX = (lastPoint.x - prevTouch)
        
        //check to make sure slider doesn't go outside of view
        if((prevOrigin + deltaX) >= 0 && (prevOrigin + deltaX) <= (frame.size.width - handleFrame.size.width)){
            handleFrame = CGRectMake(prevOrigin + deltaX, center.y - handleSize/2, handleSize, handleSize)
        }
        
        sliderValue = (Int(handleView.center.x) / Int(interval)) + 1
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        setNeedsDisplay()
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)

        //determine where slider handle should snap to
        for(var i = 0; i < arrayOfNotches.count - 1; i++){
            var view1 = arrayOfNotches[i]
            var view2 = arrayOfNotches[i + 1]
            if(handleView.center.x >= view1.center.x && handleView.center.x <= view2.center.x){
                if((handleView.center.x - view1.center.x) < (view2.center.x - handleView.center.x)){
                    self.animateToFrame(view1)
                    self.sliderValue = i + 1
                } else {
                    self.animateToFrame(view2)
                    self.sliderValue = i + 2
                }
                
                self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
                return
            }
        }
        
    }
    
    private func animateToFrame(frame: UIView){
     
        //animate the slider to the correct position on release of finger
        UIView.animateWithDuration(0.1, animations: { () -> Void in
        
            self.handleView.center = frame.center
        
        }) { (value: Bool) -> Void in
            
            self.handleFrame = CGRectMake(
                self.handleView.center.x - self.handleSize/2,
                self.handleView.center.y - self.handleSize/2,
                self.handleSize,
                self.handleSize)
            
        }
    }
    
    
}
