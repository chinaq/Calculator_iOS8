//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 强忠华 on 15/3/3.
//  Copyright (c) 2015年 Stadnford Univercity. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable {               //枚举内可以包含数据
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
    
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    
    private var opStack = [Op]()  //数组(包含数字和计算)
    private var knownOps = [String:Op]()  //字典（已知的运算符）
    
    
    //构造函数
    init(){
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        //"×", "÷", "+", "−", "√"
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.UnaryOperation("√", sqrt))
        
        //knownOps["×"] = Op.BinaryOperation("×", *)
        //knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        //knownOps["+"] = Op.BinaryOperation("+", +)
        //knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        //knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    //递归计算栈，返回顶层计算的结果和余下的栈
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()      //取出最后一个输入的值或操作符
            
            switch op {
            case .Operand(let operand):                                                     //值
                    return (operand, remainingOps)                                              //返回最后一个值或操作符、及余下未计算的栈
            case .UnaryOperation(_, let operation):                                         //单运算符
                let operandEvaluation = evaluate(remainingOps)                                  //递归计算余下的栈
                if let operand = operandEvaluation.result {                                     //返回计算的单运算值，及余下的未计算的栈
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):                                        //双运算符
                let op1Evaluation = evaluate(remainingOps)                                      //递归计算第一个值
                if let operand1 = op1Evaluation.result {                                        //
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)                                  //递归计算第二个值
                    if let operand2 = op2Evaluation.result{                                     //
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)      //返回计算到的值，以及余下未计算的栈
                    }
                }
            }
        }                                                                           //remainingOps的返回好像没有任何意义
        return (nil, ops)
    }
    
    //通过运算符和值进行计算
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack.description) = \(result) with \(remainder) left over")
        return result
    }
    
    //将值压入栈，并进行计算
    func pushOperand(operand: Double) -> Double?{
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    //将运算符压入栈，并进行计算
    func performOperation(symbol: String) -> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
}