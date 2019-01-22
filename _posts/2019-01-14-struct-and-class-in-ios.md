---
layout: post
comments: true
title: Struct and Class in iOS using Swift
excerpt_separator:  <!--more-->
---

In Swift, **Structure** and **Classes** works out somewhere likewise but they have a few unique key variations which make them distinct from each other and they have diverse use cases. 

> In this article we will gonna explore those variations and differences which make them different from each other along with possible code example. 


**NOTE: For a quick compilation of below code, I've used [Ideone](https://ideone.com/) online compiler and debugging tool**

<h2>So, what is struct and class?</h2>

<strong>Structures</strong> (enum and tuple) are `value types`, means each instance keeps a unique copy of its data.

<small>See below for an example</small>

<small>[Edit Online](https://ideone.com/mduYlK)</small>
{% highlight swift %}
struct Car {
    var name: String 
    let model: String
    let color: String
}

// We declared `ford` instance using `let` (immutable now) i.e we are not gonna change its content
let ford = Car(name: "Ford", model: "2010", color: "Red")

// Ford instance being copied by ferrari i.e ferrari and ford have two different copies 
// We declared `ferrari` instance using `var` (mutable now). In Struct, it always behaves like immutability so we have to declare his instance (i.e ferrari) and variable (i.e name) using `var` only to get mutable behavior 
 
var ferrari = ford

ferrari.name = "Ferrari"

print(ford.name) // Output: Ford
print(ferrari.name) // Output: Ferrari
{% endhighlight %}

<strong>Classes</strong> are  `reference types`, means instance share a single copy of its data.

<small>See below for an example</small>

<small>[Edit Online](https://ideone.com/neZBFa)</small>
{% highlight swift %}
class Car {
    var name: String
    let model: String
    let color: String

    init(name: String, model: String, color: String) { // In Class, we need to implement `init` which is a constructor but in struct, it is not necessary 
        self.name = name
        self.model = model
        self.color = color
    }
}

let ford = Car(name:"Ford", model:"2010", color:"Red")

// Ford instance share his reference to Ferrari i.e Ferrari and Ford both having same copy of data i.e pointing to the same reference 
// We declared `ferrari` instance using `let` (immutable now). In class, we can always change it's variable (But variable should be declared as `var` then only it is possible)

let ferrari = ford 

ferrari.name = "Ferrari"

print(ford.name) // Output : Ferrari (Because ford referring to same reference point which ferrari has)
print(ferrari.name) // Output : Ferrari
{% endhighlight %}


---

<h2>Let's discuss common and uncommon things in struct and class</h2>

**Common things as below:**

- <h3>Properties to store values</h3>
    Properties associate values with a particular class, structure, or enumeration.
    Properties basically have two types
    - **Stored properties**

        Stored properties store constant and variable values as part of an instance and are provided only by classes and structures

        A lazy stored property is a property whose initial value is not calculated until the first time it is used. You indicate a lazy stored property by writing the lazy modifier before its declaration.

    - **Computed properties**
    
        Computed properties calculate (rather than store) value and are provided by classes, structures, and enumerations

        A computed property with a getter but no setter is known as a read-only computed property. A read-only computed property always returns a value, and can be accessed through dot syntax, but cannot be set to a different value

- <h3>Method or function for functionality</h3>
    Methods are functions that are associated with a particular type. Classes, structures, and enumerations can all define instance methods, which encapsulate specific tasks and functionality for working with an instance of a given type.
    
    >  In Objective-C, classes are the only types that can define methods.<br>
    > In Swift, you can choose whether to define a class, structure, or enumeration, and still have the flexibility to define methods on the type you create.

    > You can also define methods that are called on the type itself. These kinds of methods are called `type methods`. 

{% highlight swift %}
class SomeClass {
    class func someTypeMethod() {
        // type method implementation goes here
    }
}
SomeClass.someTypeMethod()
{% endhighlight %}

- <h3>Subscripts to access values using subscript syntax</h3>
    Classes, structures, and enumerations can define subscripts, which are shortcuts for accessing the member elements of a collection, list, or sequence.

    <small>See below for an example</small>
{% highlight swift %}
class Car {
    let price: Int
    subscript(index: Int) -> Int {
        return price * index
    }

    init(price:Int) { 
        self.price = price
    }
}
let car = Car(price: 2000)
print("Two car prices are \(car[2])") //Output : Two car prices are 4000
{% endhighlight %}

> Swift’s Dictionary type implements a subscript to set and retrieve the values stored in a Dictionary instance

<small>See below for an example</small>
{% highlight swift %}
var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["bird"] = 2

print(numberOfLegs) //["ant": 6, "cat": 4, "bird": 2, "spider": 8]
{% endhighlight %}

- <h3>Initializers to setup initial state </h3>
    Initialization is the process of preparing an instance of a class, structure, or enumeration for use.

    You implement this initialization process by defining initializers, which are like special methods that can be called to create a new instance of a particular type.

    An initializer is like an instance method with no parameters, written using the init keyword:

<small>See below for an example</small>
{% highlight swift %}
init() {
    // perform initialization here
}
{% endhighlight %}

- <h3>Extensions to expand default functionality </h3>
    Extensions add new functionality to an existing class, structure, enumeration, or protocol type. 

    This includes the ability to extend types for which you do not have access to the original source code (known as retroactive modeling). 

    > Unlike Objective-C categories, Swift extensions do not have names.

    Extensions can provide few below capabilities:

    - Computed instance and type properties
    - Instance methods and type methods
    - Initializers
    - Subscripts
    - Nested types
    - Conform to a protocol

<small>See below for an example</small>
{% highlight swift %}
struct Car {
    let price: Int
    let name: String
}

extension Car {
    var model: String {
        return "2010"
    }
}
var car = Car(price: 20000, name: "Ferrari")
print("\(car.name) \(car.model) model price is \(car.price)") //Output : `Ferrari 2010 model price is 20000`
{% endhighlight %}

- <h3>Protocols to adapt the functionality of others </h3>
    A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.

    > The protocol can then be adopted by a class, structure, or enumeration <br>
    > Any type that satisfies the requirements of a protocol is said to conform to that protocol

<small>See below for an example</small>
{% highlight swift %}
protocol PriceProtocol {
    func priceInUsd() -> Int
}

struct Car: PriceProtocol {
    let price: Int
    let name: String

    func priceInUsd() -> Int {
    return (self.price * 75)
    }
}
extension Car {
    var model: String {
        return "2010"
    }
}
var car = Car(price: 20000, name: "Ferrari")
print("\(car.name) \(car.model) model usd price is \(car.priceInUsd())") //Output : `Ferrari 2010 model usd price is 1500000`
{% endhighlight %}

<h2>Few things which class only have as below:</h2>

- <h3>Inheritance</h3> 
  
    A class can inherit methods, properties, and other characteristics from another class. When one class inherits from another, the inheriting class is known as a subclass, and the class it inherits from is known as its superclass.

    Any class that does not inherit from another class is known as a base class.

<small>See below for an example</small>
{% highlight swift %}
class Car { //Base class
    var name: String = "Ferrari" // Stored properties
    var isAvailable: Bool { //Computed properties
    	get {
    		return true
    	}
    	set(value) {
    		self.isAvailable = value
    	}
    }
    init(name: String) {
        self.name = name
    }
}

class AverageSpeed : Car { //average speed is now subclass which inherits from Car as its superclass
    var speed: String 
    init(speed: String) {
        self.speed = speed
        super.init(name: "Ferrari") //'super.init' should called on all paths before returning from initializer
    }
}
var averageSpeed = AverageSpeed(speed:"23")
averageSpeed.speed = "20 KH"
averageSpeed.name = "Ford"

print(averageSpeed.isAvailable ? "Car is available." : "Car is unavailable.")
print("\(averageSpeed.name) average speed is \(averageSpeed.speed)") //Output : `Ferrari average speed is 20 k/h`

{% endhighlight %}

- <h3>Type casting</h3> 
    Type casting is a way to check the type of an instance or to treat that instance as a different superclass or subclass from somewhere else in its own class hierarchy.

    Type casting in Swift is implemented with below two operators i.e
    
    - **Type check operator `is`**
    - **Type cast operator `as? or as!`**

<small>See below for an example - Type check</small>
{% highlight swift %}
var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}
print("Media library contains \(movieCount) movies and \(songCount) songs")
{% endhighlight %}

<small>See below for an example - Type cast</small>
{% highlight swift %}
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// Movie: Casablanca, dir. Michael Curtiz
// Song: Blue Suede Shoes, by Elvis Presley
// Movie: Citizen Kane, dir. Orson Welles
// Song: The One And Only, by Chesney Hawkes
// Song: Never Gonna Give You Up, by Rick Astley
{% endhighlight %}

- <h3>Deinitializers</h3> 
    A deinitializer is called immediately before a class instance is deallocated. You write deinitializers with the deinit keyword, similar to how initializers are written with the init keyword. Deinitializers are only available on class types.

<small>See below for an example</small>
{% highlight swift %}
deinit {
    // perform the deinitialization
}
{% endhighlight %}

- <h3>Automatic Reference Counting</h3>
    Swift uses Automatic Reference Counting (ARC) to track and manage your app’s memory usage. 

    Reference counting applies only to instances of classes. Structures and enumerations are value types, not reference types, and are not stored and passed by reference.

<h2>Mutating (for struct only)</h2>

Structures and enumerations are value types. By default, the properties of a value type cannot be modified from within its instance methods.

However, if you need to modify the properties of your structure or enumeration within a particular method, you can opt-in to mutating behavior for that method.

<small>See below for an example</small>
{% highlight swift %}
struct Car {
    var width = 0.0, height = 0.0

    mutating func increaseWeightBy(width deltaWidth: Double, height deltaHeight: Double) { //To modify width and height
        width += deltaWidth
        height += deltaHeight
    }

    func getCarDimensions() -> Double {
        return width * height
    }
}
var car = Car(width: 170, height: 85)
car.increaseWeightBy(width: 10, height: 10)

print("The car dimensions is \(car.getCarDimensions())cm")

// Output: The car dimensions is 17,100 cm"
{% endhighlight %}

<h2>Overall conclusion</h2>

Structures and classes are the building blocks of our program’s and Unlike other languages, Swift doesn’t require you to create separate interface and implementation files for custom structures and classes. In Swift, you define a structure or class in a single file.
    
When interfacing with cocoa and Objective-C, we usually use classes and to implement delegate for most of UIController like table view, we don't have a choice, we have to use a class only. Many apple frameworks depend on subclassing.

So, It's not always easy to decide whether your new type should be a struct or a class. Because both behave differently, knowing that difference will help you make a decision.

Well, Thank you for taking the time to read this article.

<h3>References:</h3>
- [Apple docs](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)
- [Advanced swift](https://www.objc.io/books/advanced-swift/)