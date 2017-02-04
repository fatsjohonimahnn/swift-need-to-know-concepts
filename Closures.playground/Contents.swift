// Closures

/* 
 
 Small blocs of code, like functions, but without names
 
 Encapsulate code, take parameters and can return values 
 
 Used by assigning them to a variable
*/

// Defined by its parameters and return value
var takesTwoIntParametersAndReturnsAnInt: (Int, Int) -> (Int)
// does not need variable names like a func when being defined
// ALWAYS define a return type, even when it returns nothing:
var voidClosure: () -> Void
var returnsNothing: () -> ()

// only need variable names when being implemented

// creating a closure:
// #1 start with an assignment operator: takesTwoIntParametersAndReturnsAnInt
takesTwoIntParametersAndReturnsAnInt = { // opening brace starts the closure
    (number1: Int, number2: Int) -> Int  // head declares the parameters and return value
    in                                   // separator: "in" keyword
    return number1 + number2             // body is the actual code you will write
}                                        // closing brace ends the closure

// you then call the closure using its assigned variable:
takesTwoIntParametersAndReturnsAnInt(2, 3)



// Type Inference

// if our closure has a single return statement, we can omit the "return" keyword
var multiplyClosure: (Int, Int) -> (Int)
multiplyClosure = { (number: Int, multiplier: Int) -> Int in
    number * multiplier // no "return" keyword
}

multiplyClosure(4, 2)


// closures can be compacted even further
var addClosure: (Int, Int) -> (Int)

// you do not need to specify parameter names
addClosure = {
    // by default, swift assigns parameter names a number starting at 0 and are referenced in the closure using a "$" dollar sign infront of the number
    $0 + $1
}

addClosure(56, 4)

multiplyClosure = {
    $0 * $1
}
multiplyClosure(3, 4)



// closures "close over" values aka "capture" values

var counter = 0
var incrementCounter = {
    counter += 1 // this closure references the counter var and captures the var or "closes over it"
}
// any changes the closure makes to the variable are visible inside and outside the closure
incrementCounter()
print("counter = \(counter)")


//-------------------------------------------------------------------------

// closure syntax practice ( without parameters)

var longClosureWithoutParameters = { () -> Void in print("long way of writing a closure") }

longClosureWithoutParameters()

// not returning a value
var shortClosureWithoutParameters = { print("a shorthand way of writing a closure") }

shortClosureWithoutParameters()

// explicit way of defining a type
var explicitClosureWithoutParameters: () -> () = { print("explicit way of writing a closure") }


// method that will run a closure that takes no parameters and returns nothing
func runClosure(_ aClosure: () -> Void) {
    aClosure()
}
// can pass any closure that takes no parameters and returns nothing
runClosure(explicitClosureWithoutParameters)


// we can also create our own closure and pass it into the func like so:
runClosure {
    print("a created closure that takes no parameters and returns nothing")
}
// this way of "easy on the eyes" writing is called syntactic sugar
// the normal way of writing it would be:
runClosure( { print("the non-sugary way") })


//----------------------------------------------------------------------------

// closure syntax practice (with parameters)

var explicitClosureWithParametersLongFormWay: (String, Int) -> Void = { (message: String, times: Int) -> Void in // -> Void not needed
    for i in 0..<times {
        print("\(message) #\(i)")
    }
}

explicitClosureWithParametersLongFormWay("Message to print", 5)

var multiply2IntsAndReturnInt: (Int, Int) -> (Int) = { (int1: Int, int2: Int) in return int1 * int2 }

multiply2IntsAndReturnInt(5, 5)

var condenseMultiplyWithTypeInference: (Int, Int) -> (Int) = { $0 * $1 }

condenseMultiplyWithTypeInference(5, 6)

var newCounter = 0
var counterClosure = {
    newCounter += 1 // counter closure captures the newCounter variable
}

counterClosure()
counterClosure()
counterClosure()
counterClosure()
newCounter
newCounter = 0
counterClosure()
newCounter
// changes to a variable outside of the closure will affect the variable inside the closure



//----------------------------------------------------------------------------

// Write a closure that will print out a message that reads "I love Swift"

var iLoveSwift = { print("I Love Swift") }
var iLoveSwift2: () -> Void = { print("I Love Swift2") }

//: Call this closure
iLoveSwift()
iLoveSwift2()

// Write a function that will run a given closure a given number of times. Declare the function like so: func repeatTask(times: Int, task: () -> Void)

func repeatTask(times: Int, task: () -> Void) {
    
    for _ in 0..<times {
        task()
    }
}
repeatTask(times: 5, task: iLoveSwift)


// Create a new array called myArray and add the following integers: 40, 534, 10, 54, 42. Create two closures. One is called printNumbers and the other is printNumbersInReverse. Call both closures pasisng in the array.

var myArray = [40, 534, 10, 54, 42]

var printNumbers: ([Int]) -> Void = { (numbers: [Int]) in
    for number in numbers {
        print(number)
    }
}

var printNumbersInReverse: ([Int]) -> () = { (numbers: [Int]) in
    for number in numbers.reversed() {
        print(number)
    }
}

printNumbers(myArray)
print("---------------------")
printNumbersInReverse(myArray)
















