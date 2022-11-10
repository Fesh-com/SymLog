
# SymLog

Better debug information with **Symbol Logging** for Swift code


Usage:

Use *public func* **symLog** for logging without instance counting
This logging function can be called anywhere in your code like this:

    symLog(1, "first symLog test")      // try 1..80 as first param

Parameter 0 mutes logging



Use *class* **SymLogC** for logging Swift structs and classes with instance counting

Put
    private let symLog = SymLogC()
at the top of your Swift class/struct.

Put log calls in your code like this:
    symLog.log("your message here")
or
    symLog.log()
or
    symLog.log(Any-Class)
or
    symLog.log("your message with param \(Any-Class) and newlines \n\n")


If you want to (temporarely) stop logging for this class, add a parameter "0" like this:
    private let symLog = SymLogC(0)
The .log function calls in *this class* will be muted.



use *class* **SymLogV** for logging SwiftUI Views with instance counting

import SwiftUI
import SymLog

struct ContentView: View {
    private let symLog = SymLogV()      // parameter 0 mutes logging

    var body: some View {
        symLog {
            VStack {
or
        symLog {
            NavigationView {

 
Since SymLogV inherits from SymLogC, you can use the class logging function also
for debugging (Swift) logic in your (SwiftUI) view definitions. Just call
        symLog.log("your message here")
