
//------------------------------------------------------------------------------

// Error Handling

// Error handling is the process of responding to and recovering from error
// conditions in your program.

// https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/ErrorHandling.html#//apple_ref/doc/uid/TP40014097-CH42-ID508

// http://www.techotopia.com/index.php/Understanding_Error_Handling_in_Swift_2

// 2 sides to error handling: 
    // 1 Triggering (throwing) an error when the desired results are not achieved within the method
        // When an error is thrown, it will be of a particular type, which can be used to identify the specific nature of ther error and used to decide a course of action
    // 2 Catching and handling the error after it is thrown by a method


//------------------------------------------------------------------------------

// In Swift, errors are represented by values that conform to the ErrorType
// protocol and are typically implemented using enumerations which allow us to
// group several related error conditions together. 

// Using enumerations also allows us to set associated values which can be used to pass additional
// information about the nature of an error.
//
// #1 For example, here’s how you might represent the error conditions of operating
// a vending machine.

enum VendingMachineError: Error {
    
    case InvalidSelection
    case OutOfStock
    case InsufficientFunds(coinsNeeded: Int)
}

// Next, we'll create a VendingMachine class that uses the VendingMachineError
// to communicate error conditions back to the users of the class.

struct Item {
    
    var price: Int
    var count: Int
}

class VendingMachine {
    
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    
    var coinsDeposited = 0
    
    func dispenseSnack(snack: String) {
        print("Dispensing \(snack)")
    }
    
// #2 a method declares that it can throw an error using the "throws" keyword 
// (placed before the return type if any)
    func vend(itemNamed name: String) throws {
        
// #3 guard statements are used in conjuction with "throws" and checks a condition for a true or false result
// if false, the "else" statement is executed and the throw statement is used to throw one of ther error values contained in the VendingMachineError enum
        guard let item = inventory[name] else {
            throw VendingMachineError.InvalidSelection
        }
        
        guard item.count > 0 else {
            throw VendingMachineError.OutOfStock
        }
        
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.InsufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }
        
        coinsDeposited -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        dispenseSnack(snack: name)
    }
}

//------------------------------------------------------------------------------

// Now, lets test our VendingMachine class:

var vendingMachine = VendingMachine()

vendingMachine.coinsDeposited = 8

// The first thing you'll notice is that you can't simply call the vend() method
// without writing extra code to catch the errors that may result from calling
// vend().

// This will not work!
//vendingMachine.vend(itemNamed:"Chips")

// #4 once a method is declared as throwing errors, it can no longer be called in the usual manner
// we need a "do-catch" statement to "catch" and handle any errors that might be thrown

do {
    
    try vendingMachine.vend(itemNamed: "Chips")
    
} catch VendingMachineError.InvalidSelection {
    
    print("Invalid Selection.")
    
} catch VendingMachineError.OutOfStock {
    
    print("Out of Stock.")
    
} catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
    
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
}


//------------------------------------------------------------------------------

// But, if the vend() method is being called inside another function or method,
// we can pass responsibility for catching and handling the errors to someone
// else by having the function or method throw the errors to the caller for
// handling.


let favoriteSnacks = [
    
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels",
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    
    // Get the person's favorite snack. If nil - just default to "Candy Bar".
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    
    // Try to vend the snack, but if an error occurs, throw it to the caller
    // of this function for handling.
    try vendingMachine.vend(itemNamed: snackName)
}


var vendingMachine2 = VendingMachine()

vendingMachine2.coinsDeposited = 900


do {
    
    try buyFavoriteSnack(person: "Eve", vendingMachine: vendingMachine2)
    
} catch VendingMachineError.InvalidSelection {
    
    print("Invalid Selection.")
    
} catch VendingMachineError.OutOfStock {
    
    print("Out of Stock.")
    
} catch VendingMachineError.InsufficientFunds(let coinsNeeded) {
    
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
}

//------------------------------------------------------------------------------

// Disabling Error Propagation

// Sometimes you know a throwing function or method won’t, in fact, throw an
// error at runtime.

// On those occasions, you can write "try!" before the expression
// to disable error propagation and wrap the call in a runtime assertion that no
// error will be thrown. If an error actually is thrown, you’ll get a runtime error.

var vendingMachine3 = VendingMachine()

vendingMachine3.coinsDeposited = 100

try! vendingMachine3.vend(itemNamed: "Chips")

//------------------------------------------------------------------------------

// Specifying Cleanup Actions, user the defere statement

// You can use a defer statement to execute some code just before code execution 
// leaves the current block of code. 

// This statement lets you do any necessary cleanup that should be performed 
// regardless of how execution leaves the current block of code 
// — whether it leaves because an error was thrown or
// because of a statement such as return or break.

// In the example function below, a defer statement is used to ensure that the
// file descriptor is guaranteed to be closed once we leave the scope of the
// if statement "if exists(filename)"

/*
 
func processFile(filename: String) throws {
    
    if exists(filename) {
        
        let file = open(filename)
        
        defer {
            close(file)
        }
        
        while let line = try file.readline() {
            // Work with the file.
        }
        
        // Our defer code will be called here, at the end of the scope and
        // will guarantee that close(file) will get called.
    }
}
 
*/


