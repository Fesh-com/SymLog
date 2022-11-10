//
//  Copyright © 2018-2022 Marc Stibane
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
import SwiftUI

/// use this for logging SwiftUI views with instance counting
public class SymLogV: SymLogC {
    private static var indent: Int = 0

    public override init(_ symbol: Int = -1,              // init with 0 to disable logging for this class
                         funcName: String = #function,
                         filePath: String = #file,
                             line: UInt = #line) {
        if symbol > 0 {
            print(String(repeating: " ", count: Self.indent), terminator: "")
        }
        super.init(symbol, funcName: funcName, filePath: filePath, line: line)
    }
    
    deinit {
        if catchDeinit {
            catchDeinit = false                         // set a breakpoint here to catch deinit
        }                                               //   then step out...
        if self.symbol > 0 {
            print(String(repeating: " ", count: Self.indent), terminator: "")
            // will continue to print in IDLogC deinit
        }
    }

    public func callAsFunction<Result>(_ message: String? = nil,
                                       _ result: () -> Result) -> Result {
        self("\(name).body #\(instance) {")
        Self.indent += 2
        if let message = message {
            self(message)
        }
        defer {
            Self.indent -= 2
            self("} //\(name).body #\(instance)")
        }
        return result()
    }
    
    public func callAsFunction(_ string: String) {
        if self.symbol > 0 {
            print(String(repeating: " ", count: Self.indent)
                  + "\(logSymbol(self.symbol-1)) [\(threadNum())] " + string)
        }
    }
}

public struct DebugView<WrappedView:View>: View {
    let view: WrappedView
    var instance: Int
    var symbol: Character
    init(_ view: WrappedView) {
        self.view = view
        let viewName: String = "\(view)"
        let (instNr, index) = SymLogV.count(viewName)
        instance = instNr
        self.symbol = logSymbol(index-1)
        print("\(symbol) \(WrappedView.self).init #\(instance)")
    }
    public var body: some View {
        print("\(symbol)\(WrappedView.self).body #\(instance)")
        return view
    }
}
