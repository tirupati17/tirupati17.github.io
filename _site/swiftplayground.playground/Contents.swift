//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print(str)

protocol Wework {
    //stored properties
    var isFreeMember : Bool { get set }
    //computed properties
//    var isGreenZone : Bool {
//        return true
//    }
    //type properties
}

struct ThirteenthFlour : Wework {
    //stored properties
    var isFreeMember: Bool
    //computed properties
    var isGreenZone: Bool {
        return true
    }
    //type properties
}

let thirteenthFloor = ThirteenthFlour(isFreeMember: true)
print(thirteenthFloor.isGreenZone)

class FourteenthFloor {
    //stored properties
    
    //computed properties
    
    //type properties
}

enum TwelfthFloor {
    //stored properties
    
    //computed properties
    
    //type properties
}
