// Structs vs Classes

// for reference vs value types see additional playground




// Structures
// aka named types
// a "template" for your types that can be used to create objects

// a convenient way to group data and pass it around using a "type" name
// can contain variables and functions
// the type name is referenced when creating instances of the structures

// use "struct" keyword followed by the "type" name
struct Location {
    // struct properties
    var x: Int
    var y: Int
    var label: String
    
    // struct methods
    func isSame(location: Location) -> Bool {
        return true
    }
    // by default methods cannot change the internal variables of value types (structs are value types)
    // creating a method that changes the value of properties within the struct can only happen useing the "mutating" keyword before the method
    mutating func randomize() {
        // code
    }
}

// create an instance
var myLocation = Location(x: 10, y: 20, label: "start")
// access the properties
myLocation.label

// call the methods
myLocation.isSame(location: myLocation)


//-------------------------------------------------------------------------------------------------

struct Book {
    var title: String
    var isPublished: Bool
}

struct Author {
    var firstName: String
    var lastName: String
    var booksWritten: [Book] = []
    var booksBeingWritten: [Book] = []
    
    // #P1
    var books: [Book] {
        get {
            return booksWritten
        }
// #P3
//        set {
//            for book in newValue { // setter variable will always be newValue
//                print(book.title)
//                if book.isPublished {
//                    booksWritten.append(book)
//                } else {
//                    booksBeingWritten.append(book)
//                }
//            }
//        }
    }
    
    // #P2
    var totalBooks: Int {
        return booksBeingWritten.count + booksWritten.count
    }
    
    // #1, #2, #P3
    mutating func addBook(aBook: Book) {
        //books.append(aBook)
        print(aBook.title)
        if aBook.isPublished {
            booksWritten.append(aBook)
        } else {
            booksBeingWritten.append(aBook)
        }
    }
}

var it = Book(title: "IT", isPublished: true)
it.title
var petCemetary = Book(title: "Pet Cemetary", isPublished: true)

var writer = Author(firstName: "Stephen", lastName: "King", booksWritten: [it, petCemetary], booksBeingWritten: [])

var anotherBook = Book(title: "Insomnia", isPublished: true)
// #1 we could add this book to the writer like so:
// writer.books.append(anotherBook)
// but it is better to add a method to the Author struct because we do not want code outside of the struct to determine how the data is organized inside of the struct
// the struct itself should manage its internal data like an interface

// #2 mutating
// we are changing the internal state of the struct aka the value of the books array,
// we need to use the "mutating" keyword bc value types are immutable by default
writer.addBook(aBook: anotherBook)




//-------------------------------------------------------------------------------------------------


// Properties

// variables included with objects

// #P2 computed properties:
// values obtained through some expression in the object
    // read only, no way of assigning value
    // computed in real time when the property is accessed

// #P1 Getter/Setter properties:
// used when the act of "getting" or "setting" a value requires additional computation
    // similar to a computed property but uses the "get" and "set" keywords
    // for setter properties, we gain access to the value by accessing a Swift provided variable called "newValue"

var unpublishedBook = Book(title: "Untitled", isPublished: false)
writer.addBook(aBook: unpublishedBook)
writer.booksBeingWritten
// #P3
// the addBook func is appending aBook to the books array which now has a getter and setter
// when we call books.append in the addBook func, the booksWritten array is being returned and we are adding aBook to it, so when we "set" the book, we are resetting the books over and over
print(writer.totalBooks) // 11

// Type properties "static" variabled:
// properties assigned to all instances of a type, not just an individual instance
    // "static" keyword
    // you do not need an instance of the type to access the property

// Property observer: "didSet"
    // runs just after a value is set

struct FuelTank {
    var lowFuel: Bool
    var level: Double {
        didSet {
            if level > 1.0 {
                level = 1.0
            } else if level < 0 {
                level = 0
            }
            if level < 0.01 {
                lowFuel = true
            } else {
                lowFuel = false
            }
        }
    }
}

var fuel = FuelTank(lowFuel: false, level: 0)
print(fuel.lowFuel)


//-------------------------------------------------------------------------------------------------


// Classes

// a named type with properties and methods

// Values Vs Reference Types 

// structs are value types
    // value types are copied and any changes are not reflected in the original
    // value types live in the stack (piece of memory), everytime a func is called, a stack frame is created. Any variables created in this method are added to the frame, eventually you stop calling func and return from them. As each func completes, a stack frame is popped off the stack. All those variables are then reclaimed.

// classes are reference types
    // reference types llive on the heap (another place of memory that hangs out for the duration of the program), the heap does not automatically clear out the variables like a stack. Instead the variables need to be removed

    // creating an instance to a reference type adds an object to the heap, crating a copy of that object/reference variable does NOT create a separate copy like a value type but creates a reference to the same object that is on the heap: Now 2 references are pointing to the same object, changing a property on one of the references, the other reference will reflect that change


// creating a let constant to a reference type: the object is still mutable, but the reference cannot be changed

// classes support inheritance, structs do not
// inheritance is the ability to use methods and properties from parent objects
// parent objects should be generic, child objects should be more specific
// objects in Swift can only have 1 parent

// base/Parent/super class
class Person {
    var firstName: String
    var lastName: String
    init() {
        firstName = ""
        lastName = ""
    }
}
// child class
class Student: Person {
    
    func recordGrade(grade: Int) {
        //code
    }
}
// specialized class
// final keyword stops the class from being subclassed, works with methods as well
final class StudentAthlete: Student {
    // override to add aditional functionality
    override func recordGrade(grade: Int) {
        // sometimes it is important to get the parent classes (Students) behavior
        // super keyword calls up to the parent class
        super.recordGrade(grade: grade)
        // additional code
    }
}











