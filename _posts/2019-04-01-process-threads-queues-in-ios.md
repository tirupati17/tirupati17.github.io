---
layout: post
comments: true
title: Process, Threads and Queues in iOS
tags: 
    - Process
    - Threads  
    - Queues
    - Objective-C
    - Swift

excerpt_separator:  <!--more-->
---

Since a long time, I'm thinking about to write something on threads and queues along with the real-world example as we could find a bunch of examples on the web about running dispatch queue on a different thread but nothing specific about `when` to use them.

>  In this article, we'll gonna learn the usage of DispatchQueue on `main` thread along with `QoS` priority on `background` thread of my own upcoming open source app [`Wreely - Community Platform`](https://wreely.com/) for a perfect real-world example. 

## So, what is the Process?

A process (say application) in iOS or OS X have made up of one or more threads, which represent a single path of execution (for example `main` function) through application code.

Let me explain it better way through the below POSIX Thread diagram and let's talk about a thread only.

![alt text][POSIXdiagram]
Image Reference:  https://www.w3.org/People/Frystyk/thesis/multithread.html

## Thread?
Using thread one can execute multiple code path concurrently (at the same time) in a single application. 
In iOS or OSX threads categorized into two as below:

- Main Thread (UI Thread)
- Background Thread

### Main Thread
A thread which design to execute all AppKit, UIKit and other standard UI API and code.
See below example of task running on main thread using DispatchQueue:
```swift
let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
   if let data = data {
      DispatchQueue.main.async { // On main thread to update UIKit class i.e UILabel
         self.label.text = "\(data.count) bytes downloaded"
      }
   }
}
task.resume()
```

To dispatch synchronously on main thread:

```swift
DispatchQueue.main.sync {
    //async task here
}
```

To dispatch asynchronously on main thread:

```swift
DispatchQueue.main.async {
    //async task here
}
```

### Background Thread
A thread which design to execute all other API and code other than AppKit and UIKit.
See below example of task running on a background thread using DispatchQueue:
```swift
func sendDataToServer( data : NSData ) {
   DispatchQueue.global().async { // Perform the task on a background queue.
      // Request the task assertion and save the ID.
      self.backgroundTaskID = UIApplication.shared.
                 beginBackgroundTask (withName: "Finish Network Tasks") {
              self.endBackgroundTask() // End the task if time expires.
      }
            
      // Send the data synchronously.
      self.sendAppDataToServer( data: data)
      self.endBackgroundTask()
   }
}

func endBackgroundTask() {
      // End the task assertion.
      UIApplication.shared.endBackgroundTask(self.backgroundTaskID!)
      self.backgroundTaskID = UIBackgroundTaskInvalid
}

``` 

To dispatch synchronously on some background thread:

```swift
DispatchQueue.global().sync { // QoS default value is `DispatchQoS.QoSClass.default`
    //async task here
}
```

To dispatch asynchronously on some background thread:

```swift
DispatchQueue.global().async { // QoS default value is `DispatchQoS.QoSClass.default`
    //async task here
}
```

Well, Threads and queues are two different things and we should know what GCD does with it. Whenever we use Dispatch Queues via GCD, we are queueing not threading.

Basically GCD framework do all threading behalf of us because for us implementing a correct threading solution become difficult.

## What is Dispatch or GCD(Grand Central Dispatch)?

To execute multiple code path at the same time or say for concurrency apple built few modern API which is Dispatch, also known as Grand Central Dispatch (GCD) and using GCD one can run application faster, more efficiently, and with improved responsiveness.

>  NOTE: There are other API also available for concurrency like  NSOperation, NSOperationQueue, NSThread objects and pthreads (POSIX threads) but in this article, we covered only GCD.

GCD introduced [DispatchQueue](https://developer.apple.com/documentation/dispatch/dispatchqueue) an object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.

### Usage of DispatchQueue
DispatchQueue implements two types of queues i.e `serial` and `concurrent` but remembers all queues are concurrent which is relative to each other means whatever code we run in the background we run it concurrently with another thread usually main thread.

Let's talk about two types of queues as below
1. Serial
2. Concurrent

#### Serial
Also known as private dispatch queues which execute the tasks one at a time in the order that they were added to that particular queue. Here serialization works while specific tasks within a specific queue are made in serial.

Two serial queues can run concurrently if they are on separate queues. Tasks inside this queue can run on well-defined threads but not all task is running on the same thread.

Private non global queues are serial by default, See below example to create a serial queue:

```swift
let serialQueue = DispatchQueue(label: "serial")
```
- `Sync`
In sync mode code runs on a background thread but the main thread waits for it to finish which blocks all updates to the UI. The block assume it's the only block running in this queue

    To dispatch synchronously:
    ```swift
    serialQueue.sync {
        //sync task here
    }
    ```
- `Async`
In Async mode code runs on a background thread and control returns immediately to the main thread. The block assume it's the only block running in this queue

    To dispatch asynchronously:
    ```swift
    serialQueue.async {
        //async task here
    }
    ```

#### Concurrent
Also known as global dispatch queues which execute tasks simultaneously (the tasks are, however, guaranteed to initiate in the order that they were added to that specific queue).

The GCD framework comes with four ready-to-use concurrent queues. 
You can create a concurrent queue using the below example:
```swift
let concurrentQueue = DispatchQueue(label: "concurrent", attributes: [.concurrent])
```

OR

Simply use one of Apple's global queues along with QoS
```swift
let concurrentQueue = DispatchQueue.global(qos: .default)
```
- `Sync`
In Sync mode code runs on a background thread but the main thread waits for it to finish, blocking any updates to the UI. The block can't assume that it's the only block running on that queue.
    
    To dispatch synchronously:

    ```swift
    concurrentQueue.sync {
        
    }
    ```
    
- `Async`
In Async mode code runs on a background thread. Control returns immediately to the main thread (and UI). The block can't assume that it's the only block running on that queue.

    To dispatch asynchronously:
    ```swift
    concurrentQueue.async {
        
    }
    ```
### DispatchQueue with QoS (Concurrent Queues)

Background thread introduced DispatchQoS a quality of service, or the execution priority apply to the tasks which allow you to categorize work to be performed by NSOperation, NSOperationQueue, NSThread objects, dispatch queues, and pthreads (POSIX threads).

#### Let's see an example of each QoS type on DispatchQueue class 

- UserIntractive

    | Type of work and focus of QoS | Duration of work to be performed |
    |----------|:-------------:|
    | Work that is interacting with the user, such as operating on the main thread, refreshing the user interface, or performing animations. If the work doesn’t happen quickly, the user interface may appear frozen. Focuses on responsiveness and performance. | Work is virtually instantaneous. |

    ```swift
    DispatchQueue.global(qos: .userIntractive).sync/async {
        //sync/async task here
    }
    ```
    
- UserInitiated

    | Type of work and focus of QoS | Duration of work to be performed |
    |----------|:-------------:|
    | Work that the user has initiated and requires immediate results, such as opening a saved document or performing an action when the user clicks something in the user interface. The work is required in order to continue user interaction. Focuses on responsiveness and performance. | Work is nearly instantaneous, such as a few seconds or less. |

    ```swift
    DispatchQueue.global(qos: .userInitiated).sync/async {
        //sync/async task here
    }
    ```

- Utility

    | Type of work and focus of QoS | Duration of work to be performed |
    |----------|:-------------:|
    | Work that may take some time to complete and doesn’t require an immediate result, such as downloading or importing data. Utility tasks typically have a progress bar that is visible to the user. Focuses on providing a balance between responsiveness, performance, and energy efficiency. | Work takes a few seconds to a few minutes. |
 
    ```swift
    DispatchQueue.global(qos: .utility).sync/async {
        //sync/async task here
    }
    ```

- Background

    | Type of work and focus of QoS | Duration of work to be performed |
    |----------|:-------------:|
    | Work that operates in the background and isn’t visible to the user, such as indexing, synchronizing, and backups. Focuses on energy efficiency. | Work takes significant time, such as minutes or hours. |

    ```swift
    DispatchQueue.global(qos: .background).sync/async {
        //sync/async task here
    }
    ```


Well through the above details we are now bit familiar with GCD framework implementation and use cases. I know I mentioned I'll show you a real-world example of GCD uses which I've used in my [Wreely community platform](https://wreely.com) but for now, Wreely ios project is bit big so working on licensing part before making the code base open source.

Thanks for reading this article and soon will update current article based on the working example of GCD in [Wreely App](https://itunes.apple.com/us/app/wreely-community-platform/id1351815873?ls=1&mt=8).

Thanks again!!

Reference:
- [Concurrency Programming Guide - Apple docs](https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40008091-CH1-SW1)
- [Concurrent Programming With GCD in Swift 3 - WWDC2016](https://developer.apple.com/videos/play/wwdc2016/720/)

[POSIXdiagram]: https://www.w3.org/People/Frystyk/thesis/MultiStackThread.gif "POSIX Thread"
