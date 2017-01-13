//ARC & Memory Management

// References:
// https://www.raywenderlich.com/134411/arc-memory-management-swift
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html


//-----------------------------------------------------------------------------------------

// Defining a class
class Dog {
    // one property
    var name: String
    
    // init called just after memory allocation
    init(name: String) {
        self.name = name
        print("Dog \(name) is initialized")
    }
    // deinit called just prior to deallocation
    deinit {
        print("Dog \(name) is being deallocated")
    }
}

// uncomment dog1 and comment dog2
//let dog1 = Dog(name: "Fido")
// Notice "Dog Fido is initialized\n" in the sidebar. However, the deinit is not called for Fido. This means that the object is never deinitialized, which means it’s never deallocated. That’s because the scope in which it was initialized is never closed so the object is not removed from memory.

// recomment dog1 and uncomment dog2
// wrapping the Dog instance in a "do" statement creates a scope aroung the initialization of the dog2 object
do {
    let dog2 = Dog(name: "Pebbles")
}
//Now you see both print statements that correspond to initialization and deinitialization. This shows the object is being deinitialized at the end of the scope, just before it’s removed from memory.

//-----------------------------------------------------------------------------------------

//The lifetime of a Swift object consists of five stages:
    // 1 Allocation (memory taken from stack or heap)
    // 2 Initialization (init code runs)
    // 3 Usage (the object is used)
    // 4 Deinitialization (deinit code runs)
    // 5 Deallocation (memory returned to stack or heap)

// Sometimes “deallocate” and “deinit” are used interchangeably, but they are actually two distinct stages in an object’s lifetime.

//Reference counting:
    // the mechanism by which an object is deallocated when it is no longer required. 

// Reference counting keeps a usage count, aka the reference count, inside each object instance.

// This count indicates how many “things” reference the object. When the reference count of an object hits zero no clients of the object remain, so the object deinitializes and deallocates.


//-----------------------------------------------------------------------------------------

// Reference cycles

// Memory leaks can happen when two objects are no longer required, but each reference one another. Since each has a non-zero reference count, deallocation of both objects can never occur.

// This is called a strong reference cycle. It fools ARC and prevents it from cleaning up. As you can see, the reference count at the end is not zero, and thus object1 and object2 are never deallocated even though they’re no longer required.


// Defining a class
class Buyer {

    var name: String
    
    // add a phones array property to hold all phones owned by a buyer. 
    // The setter is made private so that clients are forced to use add(phone:).
    private(set) var phones: [Phone] = []
    // method ensures that owner is set properly when added
    func add(phone: Phone) {
        phones.append(phone)
        phone.owner = self
    }
    
    // init called just after memory allocation
    init(name: String) {
        self.name = name
        print("Buyer \(name) is initialized")
    }
    // deinit called just prior to deallocation
    deinit {
        print("Buyer \(name) is being deallocated")
    }
}

class Phone {
    let model: String
    var owner: Buyer?
    
    init(model: String) {
        self.model = model
        print("Phone \(model) is initialized")
    }
    
    deinit {
        print("Phone \(model) is being deallocated")
    }
}

// uncomment here, comment out below do, press play
//do {
//    let buyer1 = Buyer(name: "John")
//    let iPhone = Phone(model: "iPhone 6s Plus")
//}
//Currently, as you can see in the sidebar, both Phone and Buyer objects deallocate as expected.

//But now recomment above, uncomment below, press play
do {
    let buyer1 = Buyer(name: "John")
    let iPhone = Phone(model: "iPhone 6s Plus")
    buyer1.add(phone: iPhone)
}
// Here, you add iPhone to buyer1. This automatically sets the owner property of iPhone to buyer1. A strong reference cycle between the two objects prevents ARC from deallocating them. As a result, both buyer1 and iPhone never deallocate.




//-----------------------------------------------------------------------------------------












