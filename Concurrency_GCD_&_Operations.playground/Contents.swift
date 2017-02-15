import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Concurrency with GCD & Operations Notes

/* 
 
 Concurrency is more than one task running at the same time

 Concurrency keeps the user interface responsive by structuring tasks to run at the same time. Tasks that modify the same resource must not run at the same time, unless the resource is threadsafe or read values

 GCD is easier for "simple" jobs and uses functions whereas Operations is better for "complex" jobs and uses objects to encapsulate data and functionality. Depends on the amount of communication you need between tasks and how closely you need to monitor their execution

 tasks run on threads: the UI is on the Main thread, the system creates other threads for its own tasks that the app can use
 
 GCD and Operations let you work with Queues instead of directly managing threads
    you create units of work aka tasks/operations and run them off the main thread
    on dispatch or operation queues. The system figures out how many threads to create
 
 Queues are on a higher level that threads
    ex:
    Queue       task1, t2, t3, t4, t5, t6
    Thread1     task1, t3, t5, t6
    Thread2     t3, t4,
 
 
 GCD and Operations allow us to run slow tasks asynchronously on another thread
    some APIs do this naturally
 

// here is a URLSession with the task of downloading data from a URL on another thread
let downloadSession = URLSession(configuration: .ephemeral)
let _ = downloadSession.dataTask(with: url) { data, response, error in
    self.image = UIImage(data: data!)
    // check image != nil

    DispatchQueue.main.async {
        // update UI with image
    }
}

// here is the GCD way
 let queue = DispatchQueue(label: "com.raywenderlich.worker")
 queue.async {
    // call slow non-UI sync func that produces some data
 
    DispatchQueue.main.async {
        // do something with produced data in the UI
    }
 }

*/


// Concurrency Problems

/*
 
 Race Conditions - can happen when two threads try to access the same value
    The result depends on how the threads are scheduled, when they start, sleep, and resume relative to each other
 
 
 Priority inversion - when a low priority task pre-empts a high priority task (threads can be assigned different priorities) when a shared resource gets locked by a low priority task and higher priority tasks can't access it
 
 
 Deadlock - where 2 threads are each waiting for the other to release a shared resource or to do something necessary before continuing
 
*/


// Terminology

/*
 a task can be synchronous or asynchronous from the current queue
 
 GCD queues manage threads reducing the burden on the programmer
 
 a queue can be: 
 
    1. serial: with one thread running slow non-UI tasks one at a time where the later task has to wait for the first to finish
       can solve many concurrency problems bc only one task at a time can be executed - provides mutual exclusion more safely than directly using threadlocks
 
    2. concurrent: with multiple threads running slow non-UI tasks on multiple threads so the later task can be run immediately
 
 you can run a task asynchronously on a serial or concurrent queue
 
 sync vs async tells us whether the current queue has to wait for the task to be complete
    its about the source of the task
 
 serial vs concurrent tells us whether a queue has one or many threads (running one or many tasks simultaneously)
    is about the destination of the task

*/


// GCD Terminology

/*
 
 Grand Central Dispatch is the name of the underlying lib dispatch C library
 
 provides 5 global queues plus the main queue for the UI that is serial with only one thread so it is often referred to as the main thread
 
 GCD queues are FIFO where out means start, tasks start in the order they arrive
 
 the 5 non-main, global queues are concurrent so they can create and manage multiple threads to run tasks
 
 if you run a task sync on a concurrent queue, the queue can continue working on other tasks on other threads, if another task arrives it just creates more threads or queues it onto an existing thread
 
 tasks on concurrent queues can finish in a different order than when they started
*/

// Main queue/thread used for UI type properties
let mainQ = DispatchQueue.main
// always call non-UI tasks async from the main queue

// you can create private queues from the DispatchQueue initializer by providing a label and attributes
// private queues are serial by default and are handy for protecting shared resources
let mySerialQ = DispatchQueue(label: "aSerialQueue")
// a private concurrent queue needs the concurrent attribute
let workerQ = DispatchQueue(label: "aWorkerQueue", attributes: .concurrent)



// underlying threads run at different priority levels which allows the scheduler to prioritize some threads over others

// for queues, Apple abstracts thread priorty levels to a concept called QUALITY OF SERVICE (qos). we specify the purpose of the queue or task and let the scheduler decide how to juggle priorities

// each global queue has a different quality of service

// for tasks the user is directly interacting with: UIUpdates, animations, responsive and fast
DispatchQueue.global(qos: .userInteractive)
// user needs immediately but can be done async like opening a saved document
DispatchQueue.global(qos: .userInitiated)
// No explicit or inferred qos
DispatchQueue.global() // .default qos
// long running tasks with progress indicators
DispatchQueue.global(qos: .utility)
// tasks the user isn't aware of
DispatchQueue.global(qos: .background)
DispatchQueue.global(qos: .unspecified)



// Dispatching tasks to a queue

// the quickest way to dispatch tasks to a queue using sunc or async method is to provide the task in a closure:

// use the .async method to #1 move slow tasks off the main queue and #2 update UI on main queue
// #1
DispatchQueue.global().async {
    // do expensive sync task
    // #2
    DispatchQueue.main.async {
        // update UI when task finishes
    }
}

// use the .sync method to stop the current thread until a short but critical task completes on another queue, usually setting or getting a value
// sync is normally used for thread safety to avoid race conditions

var internalName = "Berry"
var newName = "Larry"
private let internalQueue = DispatchQueue(label: "anInternalQ")
var name: String {
    get {
        return internalQueue.sync { internalName }
    }
    set (newName) {
        internalQueue.sync { internalName = newName }
    }
}
// use sync dispatch with extreme caution!!!!

/* 
 Never dispatch sync ONTO the current queue bc it blocks the queue creating a deadlock
 if currentQueue is the current queue, don't do this:
currentQueue.sync {
    task1()
}

Never dispatch sync FROM the main queue
 If the current queue is the main queue, don't do this:
anyOtherQueue.sync {
 task2()
}

*/

// Every task eventially ends up being executed to the to the Global Dispatch Queue. You can dispatch tasks directly to the GlobalDispatchQueue. In an app you might dispatch to the .userInitiated DispatchQueue by referencing it:
let userQueue = DispatchQueue.global(qos: .userInitiated)

// the defaultQueue
let defaultQueue = DispatchQueue.global()

// the main queue
// in an app ALWAYS dispatch back to the main queue for UI updates
let mainQueue = DispatchQueue.main

// Global queues are FIFO and concurrent

// serial vs concurrent tells you how many tasks you can run simultaneously

// Some tasks:

func task1() {
    print("Task 1 started")
    // make task1 take longer than task2
    sleep(1)
    print("Task 1 finished")
}

func task2() {
    print("Task 2 started")
    print("Task 2 finished")
}

print("=== Starting userInitated global queue ===")
// DONE: Dispatch tasks onto the userInitated queue

userQueue.async {
    task1()
}
userQueue.async {
    task2()
}

// allows above tasks to finish before below
sleep(3)


//-------------------------------------------------------------------------------

// Using a Private Serial Queue

// only global serial queue is DispatchQueue.main (for UI-activity) but you can create a private serial queue to run tasks in the order they arrive useful for ensuring serial access to a resource AVOIDING race conditions or deadlocks

// Create mySerialQueue .serial is the default attribute
let mySerialQueue = DispatchQueue(label: "aSerialQ")

print("\n=== Starting mySerialQueue ===")

// Dispatch tasks onto mySerialQueue
mySerialQueue.async {
    task1()
}
mySerialQueue.async {
    task2()
}


// allows above tasks to finish before below
sleep(3)




//-------------------------------------------------------------------------------

// Pivate Concurrent queues

// used to group tasks triggered by user interactions keeping them separate from the global queues

// Create workerQueue
let workerQueue = DispatchQueue(label: "aWorker", attributes: .concurrent)
print("\n=== Starting workerQueue ===")

// Dispatch tasks onto workerQueue
workerQueue.async {
    task1()
}
workerQueue.async {
    task2()
}
// tasks on the workerQueue start and finish in the same order as those on the global Queue bc both are concurrent queues



// allows above tasks to finish before below
sleep(3)

//-------------------------------------------------------------------------------

// Dispatching work synchronously

/* 
 
 so far we have only dispatched tasks async whether queue is serial or concurrent bc async method returns immediately to the current thread so it can immediately execute the next statement
        concurrent queues create muliple threads to do the work while serial queues run tasks on single thread

if we run the userQueue sync:
 
userQueue.sync {
    task1()
}
urserQueue.async {
    task2()
}

 task2 would not start until task one is complete
 dispatching synchronously to the userQueue blocked the current thread until task1 finished
 
 BE CAREFUL calling the queue's sync method bc the current thread has to wait until the task finishes running on the queue
 NEVER call sync on the main queue because it will deadlock the app
 
 if the queue is serial and the only way to access an object, then the sync method is useful for avoiding race conditions. It behaves like a mutual exclusion lock guaranteeing all threads get consistent values
 
 we can create a simple race condition by changing value async on a private queue while displaying value on the current thread:
*/

let queue = DispatchQueue(label: "aSerialQueue")
var value = 42

func changeValue() {
    sleep(1)
    value = 0
}

// Dispatch changeValue() asynchronously, and display value on the current thread

mySerialQueue.async {
    changeValue()
}
// current thread displays 42 on the right bc it executes before changeValue() finishes changing the value to 0
value

// Now reset value, then run changeValue() synchronously, to block the current thread until the changeValue task has finished, thus removing the race condition:

value = 42
mySerialQueue.sync {
    changeValue()
}
value
// Dispatching changeValue sync will block the current thread until the changeValue() task is finished thus removing the race condition





// allows above tasks to finish before below
sleep(3)



// you can run a task sync or async on a serial or concurrent queue
// Dispatch async to move work off the main thread and handle the result in the completion handler, not right after dispatching
// Use dispatch sync to control access to a shared resource, use global concurrent queues matching the qos to the task and NEVER dispatch sync from the main thread

























PlaygroundPage.current.finishExecution()
