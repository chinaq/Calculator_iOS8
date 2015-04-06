//
//  ViewController.swift
//  Calculator
//
//  Created by 强忠华 on 15/2/1.
//  Copyright (c) 2015年 Stadnford Univercity. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    var isUserInMiddleOfTyping = false
    var brain = CalculatorBrain()           //Model
    
    //点击数字
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        if(isUserInMiddleOfTyping){
            display.text = display.text! + digit
        }else{
            display.text = digit
            isUserInMiddleOfTyping = true
        }        
    }
    
    //点击操作符，对栈中最后两个数进行计算
    @IBAction func operate(sender: UIButton) {
        if (isUserInMiddleOfTyping){
            enter()
        }
        if let operation = sender.currentTitle{
            if let result = brain.performOperation(operation) {
                displayValue = result
            }
        } else {
            displayValue = 0
        }

    }
    

    
    //点击回车，将改数字追加到数字栈中
    @IBAction func enter() {
        isUserInMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    
    //显示值的属性
    var displayValue:Double{
        get{
            return NSNumberFormatter()
                .numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            isUserInMiddleOfTyping = false
        }
    }
}

