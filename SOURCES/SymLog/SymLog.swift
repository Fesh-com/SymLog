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

/// get unicode character at position from String:   let c = string[position]
public extension StringProtocol {
    subscript(position: Int) -> Character { self[index(startIndex, offsetBy: position)] }
}

/// returns a nice symbol which stands out in your logs
public func logSymbol(_ position: Int) -> Character {
    if position < 0 {
        return "❗️"
    } else {
        let symbols = "⚪️🔴🔵⚫️🟢" + "🥎⚽️🏀⚾️🏐"      // 1..10
                    + "🤍❤️💙🖤💚" + "💛🧡🤎💜💟"
                    + "♣️♠️♥️♦️💎" + "🍏🍎🍐🍊🍋"      // 21..30
                    + "☁️⛅️☀️🌙🌟" + "❄️🌑🌓🌕🌗"
                    + "👹😡👽😈😀" + "😭😎😇💪👍"      // 41..50
                    + "👧🏼👨🏼👩🏻👱🏽👴🏻" + "👵👮🏻🎅🌞😱"
                    + "💣💩🍗🍔🍺" + "🐼👾🐸🐟🐞"      // 61..70
                    + "🕰⌛️⏰⏱☎️" + "👤👥💧💦👀"
        let max = symbols.count                         // we have only so much symbols
        var pos = position
        while pos > max {
            pos -= max                                  // start over
        }
        return symbols[pos]                             // needs subscript StringProtocol
    }
}

/// returns a short thread number or "M" for the main thread
public func threadNum() -> String {
    let thread = Thread.isMainThread ? "M"              // main thread is number "1"
                                     : "\(Thread.current.value(forKeyPath: "private.seqNum")!)"
    return thread
}

/// defines the format of the timestamp for logging
class Dater: DateFormatter {
    static var shared = Dater()                         // shared DateFormatter singleton

    private override init() {
        super.init()
//      self.locale = NSLocale(localeIdentifier: "en_US") as Locale
        self.dateFormat = "HH:mm:ss.SSS"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public func fileToName(_ filePath: String) -> String {
    let fileName: NSString = NSString(string: filePath)
    return fileName.lastPathComponent
}

/// nicely formatted logging
public func symLog(_ message: Any = "",
                    _ symbol: Int = 80,                 // use 0 to disable logging
                    funcName: String = #function,
                    filePath: String = #file,
                        line: UInt = #line) -> Character {
    if symbol > 0 {                                     // don't log if symbol <= 0
        let fileName = fileToName(filePath)
        let fileLine = "\(fileName):\(line)"
        let symbol = logSymbol(symbol-1)
        let time = Dater.shared.string(from: Date())
        print("[\(threadNum())] \(time) \(symbol) \(fileLine)  \(funcName)  \(message)")
        return symbol
    }
    return logSymbol(symbol-1)
}
