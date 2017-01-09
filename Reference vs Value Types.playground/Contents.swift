// References:
// https://www.raywenderlich.com/112027/reference-value-types-in-swift-part-1

// Reference Types Vs. Value Types

// Value Types KEEP a unique copy of their data
// Example: struct, enum



// Reference Types SHARE a single copy of their data
// Example: class

class Dog {
    var wasFed = false
}

// We create a new instance of the Cat class like so:
let dog = Dog()
// This simply points to a location in memory that stores cat.


// We can add another object to hold a reference to the SAME cat like so:
let puppy = dog
// because cat is a reference to a memory address, kitten points to the exact same address

// we can feed the kitten by setting "wasFed" to true:
puppy.wasFed = true

// since kitten and dog both point to the same memory address, we would expect both to be true
print(dog.wasFed)   // true
print(puppy.wasFed) // true
// changing one named instance affects the other since they both REFERENCE the same object


//---------------------------------------------------

// Value Types

// Primitives example
var a = 42
var b = a
b += 1

print(a) // 42
print(b) // 43

// Same is true for struct
struct Cat {
    var wasFed = false
}

var cat = Cat()
var kitten = cat
kitten.wasFed = true

print(cat.wasFed) // false 
print(kitten.wasFed) // true

// kitten is a type of cat but a value type, not a reference
// kitten is a COPY of the value of cat instead of a reference
// so whatever happens to the kitten has no effect on the cat



//--------------------------------------------------------

// Runtime:

// faster to assign a reference to a variable, but copies are almost as cheap
// copy operations run in constant O(n) time since they use a fixed number of reference-counting operations based on the size of the data

//--------------------------------------------------------

// Mutability:

//Reference Types:
// "let" means the REFERENCE must remain constant (cannot change the instance the constant references)
// but you CAN change/mutate the instance itself

let snoopy = dog
// this cannot happen: snoopy = cat

// Instances of reference types cannot be changed to other reference types
var snowball = dog
// this cannot happen: snowball = cat


//Value Types:
// "let" means the INSTANCE must remain constant
// No properties of the instance will ever change regardless of var or let


//--------------------------------------------------------

// When to Use a Value Type

    // 1) Comparing instance data with ==
    // Consider whether the data should be comparable

struct Point: CustomStringConvertible {
    var x: Float
    var y: Float
    
    var description: String {
        return "{x: \(x), y: \(y)"
    }
}
// 2 points with the same internal values should be considered equal, no matter the memory locations
let point1 = Point(x: 2, y: 3)
let point2 = Point(x: 2, y: 3)
// good practice for all value types is to conform to the Equatable protocol
// this protocol defines only one function which you must implement globally in order to compare two instances of the object
// Sample implementation of == for Point
extension Point: Equatable {}
func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

    // 2) Copies should have independent state

struct Shape {
    var center: Point
}

let initialPoint = Point(x: 0, y: 0)
let circle = Shape(center: initialPoint)
var square = Shape(center: initialPoint)

// If we altered the centerPont of one of the shapes:
square.center.x = 5   // {x: 5.0, y: 0.0}
circle.center         // {x: 0.0, y: 0.0}
// each shape needs its own copy of a point to maintain an independent state of each other


    // 3) The data will be used in code across multiple threads

    // If multiple threads need to access this data, then does the data need to be equal across all threads?
    // If YES (it needs to be accessed and equal across multiple threads)
        // you will need to use a REFERENCE type and implement "locking"
    // If NO (threads can uniquely own the data) using Value types makes the situation up for debate
        // since each owner of the data holds a unique copy rather than a shared reference

//--------------------------------------------------------

// When to Use a Reference Type

    // 1) Comparing instance identity with ===
    // === checks if 2 objects are EXACTLY identical, even the memory address

class Money {
    var bill = 20
}
let aTwenty = Money()
let aJackson = aTwenty

aTwenty === aJackson // true
print(aTwenty === Money())  // false because these are 2 separate instances of Money class

// rarely do we care about the memory address of the data, we usually care about the data values


    // 2) You want to create a shared, mutable state

    // sometimes we want a piece of data to be stored as a single instance and accessed and mutated by multiple consumers

class Account {
    var balance = 0.0
}

class Person {
    let account: Account
    init(account: Account) {
        self.account = account
    }
}

// if any joint account holders add money to the account then the new balance should be reflected on all debit cards linked to the account:
let jointAccount = Account()
let person1 = Person(account: jointAccount)
let person2 = Person(account: jointAccount)

person2.account.balance += 100.0

print(person1.account.balance) // 100.0
print(person2.account.balance) // 100.0
// 1 reference, everyone stays in sync






