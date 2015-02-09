//
//  ViewController.swift
//  Calculator
//
//  Created by Chrisna Aing on 2/8/15.
//  Copyright (c) 2015 Chrisna Aing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: -
    // MARK: Private Properties

    private var operandStack = [Double]()
    private var userIsInTheMiddleOfTypingANumber = false

    // MARK: Computed Properties

    private var displayValue: Double {
        get {
            // Directly accessing doubleValue would be too permissive.
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    // MARK: Outlets

    @IBOutlet private weak var display: UILabel!

    // MARK: -
    // MARK: Utilities

    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    private func performOperation(operation: Double -> Double) {
        if !operandStack.isEmpty {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    // MARK: -
    // MARK: UI

    @IBAction private func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    @IBAction private func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        default: break
        }
    }

    @IBAction private func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }

}
