import Foundation
// Collection Data Structures
// Swift's fundamental collection data structures: Arrays, Dictionaries, Sets

// References: https://www.raywenderlich.com/123100/collection-data-structures-swift-2
// https://opensource.apple.com/source/CF/CF-550.13/CFArray.h
// https://opensource.apple.com/source/headerdoc/headerdoc-8.5.10/ExampleHeaders/CFDictionary.h

// There are many types of collection data structures and each represents a specific way to organize and access a collection of data
// They allow us to handle a bunch of items as one entity, impose some structure upon them, and efficiently insert, remove and retrieve items

// Big-O notation:

// Big-O notation is a way of describing the efficiency of an operation on a data structure
    // efficiency could mean: how much memory the data structure consumess, hoe much time an operation takes under the worst case scenario, or how much time an operationtakes on average
    // we are describing the way the memory or time scales as the size of the data structure scales, NOT the raw memory or time

//---------------------------------------------------------------------------------------

// Common iOS Data Structures:

// Arrays

// a group of items placed in a specific order, where items can be accessed via an index(number that indicates its position in the order)
    // subscripting is when you write the index in brackets after the name of the array variable

let immutableArray = [0, 1, 2, 3, 4]
var mutableArray = [5, 6, 7, 8, 9]
// homogenous, only one type allowed
// unless you specify that the one type is AnyObject, since every type is also a subtype of AnyObject
let heterogeneousSwiftArray = ([1, "a", 23, "any type can fit"] as AnyObject)

var foundationImmuatableNSArray: NSArray = ["can", "not", "be", "changed", "by", "default", "but are heterogeneous, meaning can have different types:", 123]
var foundationMutableNSMutableArray: NSMutableArray = [1, "can", "be", "mutated", "and are heterogenous"]
foundationMutableNSMutableArray.add("see")



// Expected performance and when to use arrays:

// primary reason to use an array is when the order of variables matters.

// accessing any value at a particuar index in an array is at worst O(log n), but should usually be O(1)
    // If you already know where an item is, then looking it up in the array should be fast.

// searching for an object at an unknown index is at worst O(n (log n)) , but will generally be O(n)
    // If you don’t know where a particular item is, you’ll need to look through the array from beginning to end. Your search will be slower.

// inserting or deleting an object is at worst O(n (log n)) but will often be O(1)
    // If you know where you’re adding or removing an object it’s not too difficult. Although, you may need to adjust the rest of the array afterwards, and that’s more time-consuming.



//---------------------------------------------------------------------------------------


// Dictionaries:

// Dictionaries store values that don’t need to be in any particular order and are uniquely associated with keys, used to store or look up a value.

let pets = ["John" : "Garfield", "Charlie" : "Snoopy", "Young" : "Zorro", "Clare" : "Dolly"]

// Dictionaries use subscripting syntax: dictionary["hello"] gives you the value associated with the key hello.
pets["Young"]
//print(pets["Young"]) // returns an optional, good idea to use the if let optional unwrapping syntax
pets["Snoopy"]

if let johnsPet = pets["John"] {
    print("John's pet is named \(johnsPet).")
} else {
    print("John's pet's name is not found!")
}

// Like arrays, Swift dictionaries are immutable if declared with let and mutable if declared with var. Similarly on the Foundation side, there are both NSDictionary and NSMutableDictionary classes

// Another similar characteristic to Swift arrays is that dictionaries are strongly typed, and you must have known key and value types. NSDictionary objects are able to take any NSObject as a key and store any object as a value. You’ll see this in action when you call a Cocoa API that takes or returns an NSDictionary. From Swift, this type appears as [NSObject: AnyObject]. This indicates that the key must be an NSObject subclass, and the value can be any Swift-compatible object.



// Expected performance of Dictionaries:

// The performance degradation of getting a single value is guaranteed to be at worst O(log n), but will often be O(1).
// Insertion and deletion can be as bad as O(n (log n)), but typically be closer to O(1) because of under-the-hood optimizations.
// These aren’t quite as obvious as the array degradations. Due to the more complex nature of storing keys and values versus a lovely ordered array, the performance characteristics are harder to explain.



//---------------------------------------------------------------------------------------


// Sets:

// A set stores unordered, unique values, meaning you won’t be able to add duplicates.
// Swift sets are type-specific, all items must be same type.
// Like arrays and dictionaries, a native Swift Set is immutable declared with let and mutable declared with var. Once again on the Foundation side, there are both NSSet and NSMutableSet classes for you to use.

// Sets are most useful when uniqueness matters, but order does not. For example, what if you wanted to select four random names out of an array of eight names, with no duplicates?

let names = ["John", "Paul", "George", "Ringo", "Mick", "Keith", "Charlie", "Ronnie"]

var stringSet = Set<String>() // initialize the set to add objects to it
var loopsCount = 0
while stringSet.count < 4 {
    let randomNumber = arc4random_uniform(UInt32(names.count)) // picks a random number between 0 and names.count
    let randomName = names[Int(randomNumber)] // assigns the name at the random index
    print(randomName) // logs the name to the console
    stringSet.insert(randomName) // add the selected name to the mutable set
    loopsCount += 1 // increment the loop counter so you can see how many times the loop ran
}

// once the loop finishes, print out the loop counter and the contents of the mutable set
print("Loops: " + loopsCount.description + ", Set contents: " + stringSet.description)


// Expected performance of Sets:

// Creation degrades for both Swift and Foundation set types at a rate of around O(n). 
    // This is expected because every single item in the set must be checked for equality before a new item may be added. 
    // When requiring a data structure for a large sample size, a Set‘s initial creation time cost will be a major consideration.
// Removing and looking up actions are both around O(1) performance degradations across Swift and Foundation, making set lookup considerably faster than array lookup. 
    // This is largely because set structures use hashes to check for equality, and the hashes can be calculated and stored in sorted order.
// Overall, it appears that adding an object to an NSSet stays near O(1), whereas it can degrade at a rate higher than O(n) with Swift’s Set structure.

//---------------------------------------------------------------------------------------


// Lesser-known Foundation Data Structures:



// NSCache

// very similar to using NSMutableDictionary – you just add and retrieve objects by key. The difference is that NSCache is designed for temporary storage of things that you can always recalculate or regenerate. 
// If available memory gets low, NSCache might remove some objects. They are thread-safe, but Apple’s documentation warns:
    // …The cache may decide to automatically mutate itself asynchronously behind the scenes if it is called to free up memory.
// This means that an NSCache is like an NSMutableDictionary, except that Foundation may automatically remove an object at any time to relieve memory pressure. This is good for managing how much memory the cache uses, but can cause issues if you rely on an object that may potentially be removed.

// NSCache also stores weak references to keys rather than strong references.


//---------------------------------------------------------------------------------------

// NSCountedSet

// tracks how many times you’ve added an object to a mutable set. It inherits from NSMutableSet, so if you try to add the same object again it will only be reflected once in the set.
// However, an NSCountedSet tracks how many times an object has been added. You can see how many times an object was added with countForObject().

// Note that when you call count on an NSCountedSet, it only returns the count of unique objects, not the number of times all objects were added to the set.

// To illustrate, at the end of your Playground take the array of names you created in your earlier NSMutableSet testing and add each one to an NSCountedSet twice:
let countedMutable = NSCountedSet()
for name in names {
    countedMutable.add(name)
    countedMutable.add(name)
}
//Then, log out of the set itself and find out how many times “Ringo” was added:

let ringos = countedMutable.count(for: "Ringo")
print("Counted Mutable set: \(countedMutable)) with count for Ringo: \(ringos)")
/* Your log should read:
Counted Mutable set: {(
    George,
    John,
    Ronnie,
    Mick,
    Keith,
    Charlie,
    Paul,
    Ringo
    )}) with count for Ringo: 2
*/

// Note that while you may see a different order for the set, you should only see “Ringo” appear in the list of names once, even though you can see that it was added twice.


//---------------------------------------------------------------------------------------



// NSOrderedSet

// along with its mutable counterpart, NSMutableOrderedSet, is a data structure that allows you to store a group of distinct objects in a specific order. A lot like an array but Apple succinctly sums up why you’d want to use an NSOrderedSet instead of an array:
// You can use ordered sets as an alternative to arrays when element order matters and performance while testing whether an object is contained in the set is a consideration — testing for membership of an array is slower than testing for membership of a set.
// Because of this, the ideal time to use an NSOrderedSet is when you need to store an ordered collection of objects that cannot contain duplicates.
// Note: While NSCountedSet inherits from NSMutableSet, NSOrderedSet inherits from NSObject. This is a great example of how Apple names classes based on what they do, but not necessarily how they work under the hood.


//---------------------------------------------------------------------------------------

// NSHashTable and NSMapTable

// another data structure that is similar to Set, but with a few key differences from NSMutableSet.
// You can set up an NSHashTable using any arbitrary pointers and not just objects, so you can add structures and other non-object items to an NSHashTable. You can also set memory management and equality comparison terms explicitly using NSHashTableOptions enum.

// NSMapTable is a dictionary-like data structure, but with similar behaviors to NSHashTable when it comes to memory management.
// Like an NSCache, an NSMapTable can hold weak references to keys. However, it can also remove the object related to that key automatically whenever the key is deallocated. These options can be set from the NSMapTableOptions enum.



//---------------------------------------------------------------------------------------


// NSIndexSet

// an immutable collection of unique unsigned integers intended to represent indexes of an array.
// If you have an NSArray of ten items where you regularly need to access items’ specific positions, you can store an NSIndexSet and use NSArray’s objectsAtIndexes: to pull those objects directly:

let items: NSArray = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]

let indexSet = NSMutableIndexSet()
indexSet.add(3)
indexSet.add(8)
indexSet.add(9)

items.objects(at: indexSet as IndexSet) // returns ["four", "nine", "ten"]

// You specify that “items” is an NSArray since right now, Swift arrays don’t have an equivalent way to access multiple items using an NSIndexSet or a Swift equivalent.
// An NSIndexSet retains the behavior of NSSet that only allows a value to appear once. Hence, you shouldn’t use it to store an arbitrary list of integers unless only a single appearance is a requirement.
// With an NSIndexSet, you’re storing indexes as sorted ranges, so it is more efficient than storing an array of integers.


