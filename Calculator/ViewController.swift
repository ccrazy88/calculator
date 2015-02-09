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

    private let historyPlaceholder = "history"

    private var historyList = [String]()
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
    @IBOutlet weak var history: UILabel!

    // MARK: -
    // MARK: Utilities

    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            completeOperation()
        }
    }

    private func performOperation(operation: Double -> Double) {
        if !operandStack.isEmpty {
            displayValue = operation(operandStack.removeLast())
            completeOperation()
        }
    }

    private func performOperation(operation: Double) {
        displayValue = operation
        completeOperation()
    }

    private func completeOperation() {
        enter()
        // Remove operation result from history.
        historyList.removeLast()
        history.text = " ".join(historyList)
    }

    private func addToHistory(text: String) {
        historyList.append(text)
        history.text = " ".join(historyList)
    }

    // MARK: -
    // MARK: UI

    @IBAction func reset() {
        display.text = "0"
        history.text = historyPlaceholder

        historyList = [String]()
        operandStack = [Double]()
        userIsInTheMiddleOfTypingANumber = false
    }

    @IBAction private func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if !(digit == "." && (display.text! as NSString).containsString(".")) {
                display.text = display.text! + digit
            }
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
        addToHistory(operation)
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": performOperation(M_PI)
        default: break
        }
    }

    @IBAction private func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        addToHistory(display.text!)
    }

}
