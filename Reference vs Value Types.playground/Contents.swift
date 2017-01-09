// References:
// https://www.raywenderlich.com/112027/reference-value-types-in-swift-part-1
// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/ClassesAndStructures.html

// Classes (reference type) VS Structures (value type)

// With classes you get inheritance and are passed by reference (reference type),
// structs do not have inheritance and are passed by value (value types).


//----------------------------------------------------------------------------------------------------

// Value Types Vs. Reference Types

// Value Types KEEP a unique copy of their data
// they are always copied when they are assigned or passed as an argument to a function
// Example: struct, enum

// Value Semantics

var a = "Hello"
var b = a
b += "! How are you?"
print(a)  // Hello
print(b)  // Hello! How are you?

// when you assigned a to b, you gave a copy of a's value to b

// ** They do not point to the same underlying instance **

// Thus when you changed b's value, it had no impact on a's value.
// They are distinct from each other.

// Value Types

// Primitives example
var c = 42
var d = c
d += 1

print(c) // 42
print(d) // 43

// Same is true for struct
struct Cat {
    var wasFed = false
}

var cat = Cat()
var kitten = cat
kitten.wasFed = true

print(cat.wasFed)    // false
print(kitten.wasFed) // true

// kitten is a type of cat but a value type, not a reference
// kitten is a COPY of the value of cat instead of a reference
// so whatever happens to the kitten has no effect on the cat

// Swift's basic types: Array, Dictionary, Int, String... are all implemented as structs, they are all VALUE TYPES

// Always consider modeling data with a struct first, then move on to a class if needed


//----------------------------

// Reference Semantics

// Reference types create additonal references to the same underlying instance (not copies)
// Reference Types SHARE a single copy of their data
// Example: class

class HistoricalFigure {
    var name: String
    init(name: String) {
        self.name = name
    }
}

let abraham = HistoricalFigure(name: "Abraham")
let anotherAbraham = abraham

// we have two constants - but both point to the same instance of HistoricalFigure class.

anotherAbraham.name = "AnotherAbraham"
print(anotherAbraham.name)  // prints: AnotherAbraham
print(abraham.name)         // prints: AnotherAbraham

// the code: HistoricalFigure(name: "Abraham") created an instance of HistoricalFigure class

// When you assign an instance of a class to a constant or variable,
// that constant or variable gets a reference to the instance NOT A COPY

// With a reference, the constant or variable refers to an instance of a class in memory
// Therefore, both abraham and anotherAbraham refer to the SAME instance of the class
// and a change in one will be reflectd in the other

class Dog {
    var wasFed = false
}

// We create a new instance of the Dog class like so:
let dog = Dog()
// This simply points to a location in memory that stores dog.


// We can add another object to hold a reference to the SAME dog like so:
let puppy = dog
// because dog is a reference to a memory address, puppy points to the exact same address

// we can feed the puppy by setting "wasFed" to true:
puppy.wasFed = true

// since puppy and dog both point to the same memory address, we would expect both to be true
print(dog.wasFed)   // true
print(puppy.wasFed) // true
// changing one named instance affects the other since they both REFERENCE the same object


//----------------------------------------------------------------------------------------------------


// Runtime:

// faster to assign a reference to a variable, but copies are almost as cheap
// copy operations run in constant O(n) time since they use a fixed number of reference-counting operations based on the size of the data

//----------------------------------------------------------------------------------------------------

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

//----------------------------------

// Constant Value and Reference Types

// Value and reference types behave differently when they are constants

struct WhiteHouse {
    var commanderInChief: HistoricalFigure
}

// var makes this property mutable with var

let whiteHouse = WhiteHouse(commanderInChief: abraham)

let george = HistoricalFigure(name: "George")
//whiteHouse.commanderInChief = george // will not work bc whiteHouse is a constant
print(whiteHouse.commanderInChief.name)
// this works differently for reference types

george.name = "George Jr."
print(george.name) // prints: George Jr.

// george is an instance of a reference type, refereing to HistoricalFigures class
// changing the value that the name property stores
// doesn't change what george really is (a reference to HistoricalFigures)


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

class AccountHolder {
    let account: Account
    init(account: Account) {
        self.account = account
    }
}

// if any joint account holders add money to the account then the new balance should be reflected on all debit cards linked to the account:
let jointAccount = Account()
let accountHolder1 = AccountHolder(account: jointAccount)
let accountHolder2 = AccountHolder(account: jointAccount)

accountHolder2.account.balance += 100.0

print(accountHolder1.account.balance) // 100.0
print(accountHolder2.account.balance) // 100.0
// 1 reference, everyone stays in sync





//--------------------------------------------------------


// Mixing Value and Reference Types

// A Reference Type containing Value Type Properties: (very common)

struct Address {    // Value Type
    var streetAddress: String
    var city: String
    var state: String
    var postalCode: Int
}

class Person {  // Reference Type
    var name: String        // Value Type
    var address: Address    // Value Type
    
    init(name: String, address: Address) {
        self.name = name
        self.address = address
    }
}

// This mixing makes sense, each class instance has its own value type property instances that aren't shared
// There is no risk of 2 different people sharing and unexpectedly changing the address of the other person
// ex:

let kingsLanding = Address(streetAddress: "1 King Way", city: "Kings Landing", state: "Westeros", postalCode: 11111)
let madKing = Person(name: "Aerys", address: kingsLanding)
let kingSlayer = Person(name: "Jaime", address: kingsLanding)

kingSlayer.address.streetAddress = "1 King Way Apt. 1"

print(madKing.address.streetAddress)    // 1 King Way
print(kingSlayer.address.streetAddress) // 1 King Way Apt. 1


// this is all perfectly normal, the issue is when Value Types contain Reference Types:


//--------------------------------------------------------

// Value Types Containing Reference Type Properties

struct Bill {
    let amount: Float
    let billedTo: Person
}
// Each copy of Bill is a unique copy of the data
// But the billedTo Person object will be shared by numerous Bill instances:

let billPayer = Person(name: "Robert", address: kingsLanding)

let bill = Bill(amount: 42.99, billedTo: billPayer)
let bill2 = bill

billPayer.name = "Bob"

print(bill.billedTo.name)   // Bob
print(bill2.billedTo.name)  // Bob

// Changing the person in one bill changes the other.

// one way to fix this is make the Bill struct copy a new unique reference in init(amount: billedTo:)
// you will need to write your own copy method since Person isnt an NSObject and doesn't have its own version

// Copying References During Initialization:

// we can add an explicit initializer to Bill struct:

struct BillStruct2 {
    let amount: Float
    let billedTo: Person
    
    init(amount: Float, billedTo: Person) {
        self.amount = amount
        // Create a new Person reference from the parameter
        self.billedTo = Person(name: billedTo.name, address: billedTo.address)
    }
}

// Instead of simply assigning billedTo, you create a new Person instance with the same data (name and address) as the one passed in. The caller won’t be able to edit their original copy of Person and affect Bill.

let billPayer2 = Person(name: "Joffery", address: kingsLanding)

let bill3 = BillStruct2(amount: 60.99, billedTo: billPayer2)
let bill4 = bill3

billPayer2.name = "Eddard"

print(bill3.billedTo.name)  // Joffery
print(bill4.billedTo.name)  // Joffery

// Notice they kept the original values even after mutating the passed-in parameter

// A big issue with this design is that you can access "billedTo" from outside the struct
// meaning it could be mutated by an outside entity in an unexpected manner

bill3.billedTo.name = "Tommin"

print(bill3.billedTo.name)  // Tommin
print(bill4.billedTo.name)  // Tommin
// The issue is that even if your struct is immutable, anyone with access to it could mutate it underlying data



// Using Copy-on-Write Computed Properties:

// Native Swift value types implement a feature called copy-on-write: when assigned, each reference points to the same memory address. 
// It’s only when one of the references modifies the underlying data that Swift actually copies the original instance and makes the modification.
// You could apply this technique by making billedTo "private" and only returning a copy on write.

struct CopyOnWriteBill {
    let amount: Float
    private var billedTo: Person // This private variable holds a reference to the Person object
    
    var billedToForRead: Person { // This computed property 
        return billedTo           // returns the private variable for read operations
    }
    
    var billedToForWrite: Person { // Another computed property
        mutating get {             // must declare mutating since it changes underlying value of struct
            billedTo = Person(name: billedTo.name, address: billedTo.address)
            return billedTo        // will always make a new, unique copy of Person for write purposes
        }
    }
    
    init(amount: Float, billedTo: Person) {
        self.amount = amount
        self.billedTo = Person(name: billedTo.name, address: billedTo.address)
    }
}

// If you can guarantee that your caller will use your structure exactly as you meant, this approach would solve your issue. In a perfect world, your caller would always use billedToForRead to get data from your reference and billedToForWrite to make a change to the reference.
// But that's not how it works...



// Defensive Mutating Methods

struct DefensiveCopyOnWriteBill {
    let amount: Float
    private var billedTo: Person
    
    // private means callers cannot access the properties directly
    private var billedToForRead: Person {
        return billedTo
    }
    
    private var billedToForWrite: Person {
        mutating get {
            billedTo = Person(name: billedTo.name, address: billedTo.address)
            return billedTo
        }
    }
    
    init(amount: Float, billedTo: Person) {
        self.amount = amount
        self.billedTo = Person(name: billedTo.name, address: billedTo.address)
    }
    
    // added methods to mutate the Person reference with a new name or address. This makes it impossible for someone else to use it incorrectly, since you’re hiding the underlying billedTo property.
    mutating func updateBilledToAddress(address: Address) {
        billedToForWrite.address = address
    }
    
    mutating func updateBilledToName(name: String) {
        billedToForWrite.name = name
    }
    
    // ... Methods to read billedToForRead data
}

// Declaring this method as mutating means you can only call it when you instantiate your Bill object using var instead of let. This behavior is exactly what you’d expect when working with value semantics.



// A More Efficient Copy-On-Write

// Currently, DefensiveCopyOnWriteBill copies the reference type Person every single time you write to it.
// A better way is to only copy the data if the multiple objects hold reference to it

struct EfficientCopyOnWriteBill {
    let amount: Float
    private var billedTo: Person
    
    private var billedToForRead: Person {
        return billedTo
    }
    
    // isKnownUniquelyReferenced checks that no other object holds a reference to the passed-in parameter. If no other object shares the reference, then there’s no need to make a copy and you return the current reference. That will save you a copy, and mimics what Swift itself does when working with value types.
    private var billedToForWrite: Person {
        mutating get {
            if !isKnownUniquelyReferenced(&billedTo) {
                print("Making a copy of billedTo")
                billedTo = Person(name: billedTo.name, address: billedTo.address)
            } else {
                print("Not making a copy of billedTo")
            }
            return billedTo
        }
    }
    
    init(amount: Float, billedTo: Person) {
        self.amount = amount
        self.billedTo = Person(name: billedTo.name, address: billedTo.address)
    }
    
    mutating func updateBilledToAddress(address: Address) {
        billedToForWrite.address = address
    }
    
    mutating func updateBilledToName(name: String) {
        billedToForWrite.name = name
    }
}

var myEfficientBill = EfficientCopyOnWriteBill(amount: 99.99, billedTo: billPayer2)
myEfficientBill.updateBilledToName(name: "Cercei") // Not making a copy of billedTo

// Because myEfficientBill is uniquely referenced, no copy will be made.

    // side Note: You’ll actually see the print result twice. This is because the playground’s results sidebar dynamically resolves the object on each line to give you a preview. This results in one access to billedToForWrite from updateBilledToName(_:), and another from the results sidebar to display the Person object.


var myEfficientBillCopy = myEfficientBill
myEfficientBillCopy.updateBilledToName(name: "Danyrius") //Making a copy of billedTo

// You’ll see an extra print for the playground’s results sidebar, but this time it won’t match. That’s because updateBilledToName(_:) created a unique copy before mutating its value. When the playground accesses this property again, there’s now no other object sharing reference to the copy, so a new copy isn’t made!
