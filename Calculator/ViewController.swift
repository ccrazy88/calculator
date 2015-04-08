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

    private var displayValue: Double? {
        get {
            // Directly accessing doubleValue would be too permissive.
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if let value = newValue {
                display.text = "\(value)"
            } else {
                display.text = nil
            }
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
        removeLastFromHistory()
        // Add symbol to represent the completion of an operation.
        addToHistory("=")
    }

    private func addToHistory(text: String) {
        // An operation completion indicator should only show up if it's the last entry.
        removeOperationCompletionIndicator()
        historyList.append(text)
        history.text = " ".join(historyList)
    }

    private func removeLastFromHistory() {
        historyList.removeLast()
        history.text = " ".join(historyList)
    }

    private func removeOperationCompletionIndicator() {
        if let last = historyList.last {
            if last == "=" {
                removeLastFromHistory()
            }
        }
    }

    private func changeDisplaySign() {
        if display.text!.hasPrefix("-") {
            display.text!.removeAtIndex(display.text!.startIndex)
        } else {
            display.text = "-" + display.text!
        }
    }

    // MARK: -
    // MARK: UI

    @IBAction private func reset() {
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
            removeOperationCompletionIndicator()
        }
    }

    @IBAction private func deleteDigit() {
        if countElements(display.text!) > 0 {
            display.text = dropLast(display.text!)
        }
        if countElements(display.text!) == 0 {
            display.text = "0"
            userIsInTheMiddleOfTypingANumber = false
        }
    }

    @IBAction private func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            // Don't actually "operate" if the user's typing and we're just changing signs.
            if operation == "ᐩ/-" {
                changeDisplaySign()
                return
            }
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
        case "ᐩ/-": performOperation { -$0 }
        default: break
        }
    }

    @IBAction private func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let displayValue = displayValue {
            operandStack.append(displayValue)
            addToHistory(display.text!)
        } else {
            display.text = nil
        }
        println(operandStack)
    }

}
