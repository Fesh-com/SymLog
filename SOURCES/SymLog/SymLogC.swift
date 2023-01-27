//
//  Copyright © 2018-2023 Marc Stibane
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
import Foundation

/// use this for logging classes/structs with instance counting
public class SymLogC {
    private static func className() -> String {"\(self)"}
    private static var loggedClasses: [String] = []     // names of classes using IDLogC
    private static var loggedInstances: [Int] = []      // how many instances of "name" have been allocated
    public static var watchedInstance: Int = 0          // set to # of instance you want to catch

    // returns instance count and symbol#
    static func count(_ name: String)-> (Int, Int) {
        if let index = loggedClasses.firstIndex(of:name) {
            let instance = loggedInstances[index]
            loggedInstances[index] = instance+1
            return (instance+1, index+1)
        } else {        // new class
            loggedClasses.append(name)
            loggedInstances.append(1)
            let count = loggedClasses.count
            return (1, count)
        }
    }
    
    let name: String                                    // the class name of the logging object
    var symbol: Int                                     // the symbol to use (1..80) or 0 to disable logging
    let instance: Int                                   // the instance number of this logging object
    public var catchDeinit: Bool = false                // set true to catch only deinit of instance

    deinit {
        if catchDeinit {
            catchDeinit = false                         // set a breakpoint here to catch deinit
        }                                               //   then step out to see where it got deleted
        if self.symbol > 0 {
            print("\(logSymbol(self.symbol-1)) [\(threadNum())] \(self.name)#\(self.instance) deinit()")
        }
    }

    public init(_ symbol: Int = -1,                     // init with 0 to disable logging for this class
                funcName: String = #function,
                filePath: String = #file,
                    line: UInt = #line) {
        if funcName.hasPrefix("init(") {                // funcName is botched
            let fileName = fileToName(filePath)
            if fileName.hasSuffix(".swift") {           // use filename without swift suffix instead
                self.name = String(fileName.dropLast(6))
            } else {
                self.name = fileName                    // if not .swift
            }
        } else {
            self.name = funcName                        // should be the class name
        }

        let (instance, index) = Self.count(name)
        self.instance = instance                        // incremented instance# from loggedInstances
        if symbol > 0 {
            self.symbol = symbol                        // manual override
        } else if symbol < 0 {
            self.symbol = index                         // automatic, use incremented index
        } else {
            self.symbol = -index                        // 0 ==> no logging, but save negative index
        }

        self.log("", funcName:"\(Self.className())()", filePath:filePath, line:line)
    }
    
    public func log(_ message: Any = "",
                     funcName: String = #function,
                     filePath: String = #file,
                         line: UInt = #line) {
        let _ = self.vlog(message, funcName: funcName, filePath: filePath, line: line)
    }

    public func vlog(_ message: Any = "",
                      funcName: String = #function,
                      filePath: String = #file,
                          line: UInt = #line) -> Character {
        if instance == Self.watchedInstance {
            catchDeinit = true                          // set a breakpoint here to catch watched instance
        }
        if symbol > 0 {                                 // don't log if symbol <= 0
            let classFuncName = "\(name)#\(instance) \(funcName)"
            return symLog(message, symbol, funcName: classFuncName, filePath: filePath, line: line)
        }
        return logSymbol(symbol-1)
    }
}
