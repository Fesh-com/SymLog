# SymLog
Better debug information with **Symbol Logging** for Swift code
  
Usage:
  
### Use *public func* **symLog** for logging without instance counting  
This logging function can be called anywhere in your code like this:
```swift
	symLog(1, "first symLog test")      // try 1..80 as first param
```
Parameter 0 mutes logging
  
  
  
### Use *class* **SymLogC** for logging Swift structs and classes with instance counting:
Put  
```swift
	private let symLog = SymLogC()     // parameter 0 mutes logging
```
at the top of your Swift class/struct.
  
Put log calls in your code like this:
```swift
	symLog.log("your message here")
```
or
```swift
	symLog.log()
```
or
```swift
	symLog.log(Any-Class)
```
or
```swift
	symLog.log("your message with param \(Any-Class) and newlines \n\n")
```
  
If you want to (temporarely) stop logging for this class, add a parameter "0" like this:
```swift
	private let symLog = SymLogC(0)     // parameter 0 mutes logging
```
The .log function calls in *this class* will be muted.
  
  
  
### Use *class* **SymLogV** for logging SwiftUI Views with instance counting: 
```swift
	import SwiftUI
	import SymLog

	struct ContentView: View {
		private let symLog = SymLogV()      // parameter 0 mutes logging

	var body: some View {
		symLog {
			VStack {
```
or
```swift
		symLog {
			NavigationView {
```
  
Since SymLogV inherits from SymLogC, you can use the class logging function also
for debugging (Swift) logic in your (SwiftUI) view definitions. Just call  
```swift
			symLog.log("your message here")
```
