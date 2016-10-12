//
//  CalculatorModel.swift
//  L4calc
//
//  Created by James Cremer on 9/1/16.
//  Copyright © 2016 James Cremer. All rights reserved.
//

import Foundation

class CalculatorModel {
	
	var stack:[Int] = []
	
	private func stackEmpty() -> Bool {
		return stack.count == 0
	}
	
	private func pushOntoStack(item:Int) {
		stack.append(item)
	}
	
	private func popStack() -> Int {
		let stackTop:Int = stack[stack.count - 1]
		stack.removeLast()
		return stackTop
	}
	
	
	func enterNumber(number:Int) {
		pushOntoStack(item: number)
		print("stack is: ", stack)
	}
	
	func performOperation(operation:String) -> Int{
		print("stack is: ", stack)
		let operand2:Int = popStack()
		let operand1:Int = popStack()
		print("stack is: ", stack)
		let result:Int
		if operation == "+" {
			result = operand1 + operand2
		} else if operation == "-" {
			result = operand1 - operand2
		} else if operation == "*" {
			result = operand1 * operand2
		} else if operation == "/" {
			result = operand1 / operand2
		} else {
			result = 0
		}
		pushOntoStack(item:result)
		print("stack is: ", stack)
		print("result of operation: ", result)
		return result
	}
}
