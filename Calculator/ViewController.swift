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
        let operation = sender.currentTitle!
        if (isUserInMiddleOfTyping){
            enter()
        }
        
        switch operation{
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation {sqrt($0)}
        default: break
        }
    }
    
    //计算两个数
    func performOperation(operation:(Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    //计算单个数
    func performOperation(operation:(Double) -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()   //数字栈
    
    //点击回车，将改数字追加到数字栈中
    @IBAction func enter() {
        isUserInMiddleOfTyping = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
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

