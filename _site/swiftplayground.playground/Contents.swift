//: Playground - noun: a place where people can play

import Foundation

var str = "Hello, playground"
print(str)

class Car {
    var name: String = "Ferrari" // Stored properties
    var isAvailable: Bool { //Computed properties
        return false
    }
    init(name: String) {
        self.name = name
    }
}

var car = Car(name: "Ford")
print(car.name)

var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["bird"] = 2

print(numberOfLegs)

