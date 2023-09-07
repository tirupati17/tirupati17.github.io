---
title: "The Interplay of Life and Code: SwiftUI Property Wrappers"
date: 2023-09-06T19:23:13+05:30
draft: false # Set 'false' to publish
description: ""
categories:
- Swift
tags:
- swift
- swiftui
- propertywrappers
---

As a technology enthusiast deeply influenced by spirituality and philosophy, I find that the two fields often intersect in fascinating ways. While penning articles on the towering figures of Indian philosophy [Adi Shankaracharya](https://www.mysticadii.com/post/adi-shankaracharya-the-timeless-philosopher) and [Ramanuja](https://www.mysticadii.com/post/ramanuja-illuminating-the-path-of-bhakti-and-visishtadvaita-philosophy) at [Mysticadii](https://www.mysticadii.com/), a revelation occurred. I began to discern parallels between the monistic teachings of Adi Shankaracharya, which advocate the oneness of the self and the universe, and the Visishtadvaita philosophy of Ramanuja, which emphasizes the intimate relationship between the individual soul, God, and the world. I found a similar duality and interplay of elements at work in SwiftUI's property wrappers.

Just as Adi Shankaracharya and Ramanuja provided frameworks to understand our inner and outer worlds, SwiftUI property wrappers offer tools to manage state and behavior in software applications. This realization inspired me to craft this unique article, where I attempt to bridge the metaphysical with the technical. The following sections explore SwiftUI property wrappers, not just as tools for state management in software development, but also as metaphors for understanding various aspects of life.

By drawing on these age-old wisdom traditions, we can gain novel insights into modern technology and, perhaps, vice versa. Here, I present to you SwiftUI property wrappers in the light of life philosophy, complete with code examples and metaphorical interpretations.

## So, What is property wrappers?
> In the declarative and reactive programming approach of SwiftUI, the idea is that your view is a function of some state.When the state changes, the function (your view) is re-evaluated, and the UI is redrawn to reflect those changes. Property wrappers in SwiftUI assist in this paradigm by managing state and its changes in a predictable manner

Let's classify the property wrappers based on where they are most commonly used: in the **View** or in the **ViewModel**. This should help you understand their roles a bit more clearly.

### View: The Physical Realm - The World as We Perceive It

1. **@Binding**: The Messenger - Gods on Earth
2. **@Environment**: The Cosmic Oracle - Our Surroundings
3. **@FocusState**: The Attention Director - Our Thoughts
4. **@SceneStorage**: The Continuity Master - The Supreme One
5. **@State**: The Core Being - The Self
6. **@GestureState**: The Motion Tracker - Our Actions
7. **@ScaledMetric**: The Relative Gauge - Personal Perspective
8. **@FetchRequest**: The Quest for Knowledge - Intellectual Pursuit
9. **@ThreadLocal**: The Individual Experience - Personal Realities
10. **@Lazy**: The Potential Energy - Untapped Capabilities

### ViewModel: The Mental Realm - The World of Ideas and Intentions

1. **@Published**: The Broadcaster - We, The People
2. **@AppStorage**: The Memory Keeper - Human Memory
3. **@StateObject**: The Persistent Self - The Soul
4. **@ObservedObject**: The Change Watcher - Destiny and Fate
5. **@EnvironmentObject**: The Invisible Hand - Shared Experiences
6. **@Derived**: The Inference Maker - Logical Conclusions
7. **@Atomic**: The Uninterrupted Force - Flow of Life

### Can Be Used in Both

1. **Creating Your Own Property Wrapper**: The Guardrails - Life's Boundaries

## 1. @Published: The Broadcaster - We, The People

### Swift Meaning with Example

In SwiftUI, `@Published` is used to notify views about state changes. It's the go-to property wrapper for simple state management in a SwiftUI application.

```swift
class UserSettings: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

struct ContentView: View {
    @ObservedObject var settings = UserSettings()

    var body: some View {
        Toggle("Logged In", isOn: $settings.isLoggedIn)
    }
}
```

### **The Metaphor**

In life's grand theater, we are the broadcasters. Our actions, words, and even thoughts serve as signals that echo through society.

### **The Life Parallel**

Like the `@Published` property wrapper, each person serves as a dynamic entity, broadcasting their emotions, decisions, and actions, affecting and being affected by others in the social network.

---

## 2. @Binding: The Messenger - Gods on Earth

### Swift Meaning with Example

`@Binding` allows for a two-way link between a piece of state and a view that doesn't own that state. 

```swift
struct ChildView: View {
    @Binding var text: String

    var body: some View {
        TextField("Enter text", text: $text)
    }
}

struct ParentView: View {
    @State private var text: String = ""

    var body: some View {
        ChildView(text: $text)
    }
}
```

### **The Metaphor**

Consider messengers or divine entities who come to Earth to impart wisdom or change the course of events. They serve as mediators between the earthly and the divine.

### **The Life Parallel**

Like `@Binding`, these special entities or events create a two-way channel of influence, transforming us and being transformed in return.

---

## 3. @Environment: The Cosmic Oracle - Our Surroundings

### Swift Meaning with Example

`@Environment` allows SwiftUI views to read values from the ambient environment.

```swift
struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Text("Hello, World!")
            .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
```

### **The Metaphor**

Our environment—be it culture, climate, or society—acts as an all-knowing cosmic oracle that shapes us.

### **The Life Parallel**

Much like SwiftUI views adapt to the system settings, humans adapt to their environment, molding their behavior and perspectives.

---

## 4. @AppStorage: The Memory Keeper - Human Memory

### Swift Meaning with Example

`@AppStorage` facilitates reading and writing small amounts of data to UserDefaults.

```swift
struct ContentView: View {
    @AppStorage("username") var username: String = "Guest"

    var body: some View {
        Text("Hello, \(username)")
    }
}
```

### **The Metaphor**

Our memory is like a personal storage system, fragile yet influential, shaping our future actions and decisions.

### **The Life Parallel**

Much like `@AppStorage` persists data across app launches, our memories persist throughout life, impacting our actions and choices.

---

## 5. @FocusState: The Attention Director - Our Thoughts

### Swift Meaning with Example

`@FocusState` controls which UI element is currently focused on the screen.

```swift
struct ContentView: View {
    @FocusState private var isFocused: Bool

    var body: some View {
        TextField("Enter text", text: .constant(""))
            .focused($isFocused)
    }
}
```

### **The Metaphor**

Our focus is directed by our thoughts, becoming the lens through which we see and interact with the world.

### **The Life Parallel**

Just like `@FocusState` in SwiftUI helps manage focus across UI elements, our thoughts and concentration determine our actions and the subsequent results.

---

## 6. @SceneStorage: The Continuity Master - The Supreme One

### Swift Meaning with Example

`@SceneStorage` is used to save and restore state across scene sessions.

```swift
struct ContentView: View {
    @SceneStorage("selectedTab") var selectedTab: String?

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Home").tabItem { Text("Home") }.tag("home")
            Text("Settings").tabItem { Text("Settings") }.tag("settings")
        }
    }
}
```

### **The Metaphor**

In life's grand drama, a Supreme Being or Universal Force ensures that our essence persists through life's myriad scenes and acts.

### **The Life Parallel**

Like `@SceneStorage` maintains state across scene transitions, many believe that a higher force keeps our essence intact across lifetimes, creating a continuity of existence.


## 7. @State: The Core Being - The Self

#### Swift Meaning with Example

`@State` is used for local state management in a SwiftUI view.

```swift
struct ContentView: View {
    @State private var counter = 0

    var body: some View {
        Button("Increment") {
            counter += 1
        }
    }
}

```

#### The Metaphor

At its core, `@State` represents the inner self, mutable yet owned by the individual.

#### The Life Parallel

In life, our core values and traits serve as our internal `@State`, driving our actions and responses to the world around us.

---

## 8. @StateObject: The Persistent Self - The Soul

#### Swift Meaning with Example

`@StateObject` is used to manage the lifecycle of an observed object.

```swift
struct ContentView: View {
    @StateObject var model = MyModel()

    var body: some View {
        Text(model.text)
    }
}
```

#### The Metaphor

`@StateObject` symbolizes the soul or the persistent self that remains constant throughout our life's phases.

#### The Life Parallel

Just like our soul, `@StateObject` persists, holding on to the essentials as we navigate through the turbulence of life.

---

## 9. @ObservedObject: The Change Watcher - Destiny and Fate

#### Swift Meaning with Example

`@ObservedObject` is used to observe changes in an external data model.

```swift
struct ContentView: View {
    @ObservedObject var model = MyModel()

    var body: some View {
        Text(model.text)
    }
}
```

#### The Metaphor

`@ObservedObject` is like destiny and fate combined. It watches over the unfolding events, making adjustments as necessary.

#### The Life Parallel

In our lives, fate watches over us as we make decisions and take actions, guiding us toward our ultimate destiny.


## 10. @EnvironmentObject: The Invisible Hand - Shared Experiences

#### Swift Meaning with Example

`@EnvironmentObject` is used to share data across multiple SwiftUI views.

```swift
struct ContentView: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        Text("User is logged in: \(settings.isLoggedIn)")
    }
}
```

#### The Metaphor

`@EnvironmentObject` is the invisible hand that shapes collective behavior, the shared experiences and knowledge that subtly guide our actions.

#### The Life Parallel

In life, shared experiences and societal norms function as our collective `@EnvironmentObject`, steering us as a community.

---

## 11. @GestureState: The Motion Tracker - Our Actions

#### Swift Meaning with Example

`@GestureState` is used to transiently track the state of a gesture.

```swift
struct ContentView: View {
    @GestureState private var dragState = CGSize.zero
    
    var body: some View {
        Rectangle()
            .offset(dragState)
            .gesture(
                DragGesture()
                    .updating($dragState) { (value, state, _) in
                        state = value.translation
                    }
            )
    }
}
```

#### The Metaphor

`@GestureState` symbolizes the transient nature of our actions, the fleeting moments that nevertheless make up the fabric of our existence.

#### The Life Parallel

Our actions, transient yet impactful, define the course of our lives, much like how `@GestureState` dictates the ongoing gesture operations within an application.

---

## 12. @ScaledMetric: The Relative Gauge - Personal Perspective

#### Swift Meaning with Example

`@ScaledMetric` adjusts a numerical value relative to the dynamic type setting of the device.

```swift
struct ContentView: View {
    @ScaledMetric var size: CGFloat = 100
    
    var body: some View {
        Circle()
            .frame(width: size, height: size)
    }
}
```

#### The Metaphor

`@ScaledMetric` serves as the relative gauge that adapts to individual perspectives.

#### The Life Parallel

Much like `@ScaledMetric`, our perspectives scale according to our experiences, shaping our understanding of the world.


## 13. @FetchRequest: The Quest for Knowledge - Intellectual Pursuit

#### Swift Meaning with Example

`@FetchRequest` is used for querying data models, most commonly with Core Data in SwiftUI.

```swift
struct ContentView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        List(items) { item in
            Text("Item at \(item.timestamp!, formatter: itemFormatter)")
        }
    }
}
```

#### The Metaphor

`@FetchRequest` represents the continual quest for knowledge and understanding, an intellectual pursuit that never ceases.

#### The Life Parallel

In life, we are always seeking, always querying the world for new information and insights, much like a `@FetchRequest` queries a data model.

---

## 14. @Derived: The Inference Maker - Logical Conclusions

#### Swift Meaning with Example

As of my last update in September 2021, SwiftUI doesn't provide a native `@Derived` property wrapper. However, one can create custom property wrappers to derive state based on other states.

#### The Metaphor

`@Derived` would symbolize our ability to draw logical conclusions based on the information available to us.

#### The Life Parallel

In life, we often derive understanding or insights from our experiences and observations, akin to how a `@Derived` property might work.

---

## 15. @Atomic: The Uninterrupted Force - Flow of Life

#### Swift Meaning with Example

`@Atomic` isn't a SwiftUI property wrapper, but it's often used in Swift to ensure that a property is only accessed by one thread at a time.

```swift
@Atomic var counter = 0
```

#### The Metaphor

`@Atomic` represents the uninterrupted flow of life, where each moment is accessed one at a time but contributes to a seamless experience.

#### The Life Parallel

Just as `@Atomic` ensures that data is accessed one piece at a time, life flows in a series of atomic moments that create a coherent whole.

---

## 16. @ThreadLocal: The Individual Experience - Personal Realities

#### Swift Meaning with Example

`@ThreadLocal` stores data that is specific to individual threads.

```swift
@ThreadLocal var threadSpecificValue: Int
```

#### The Metaphor

`@ThreadLocal` represents our individual experiences that contribute to our personal realities.

#### The Life Parallel

Each of us has a unique path, a series of experiences that are ours alone, similar to how `@ThreadLocal` gives each thread its own unique data.

---

## 17. @Lazy: The Potential Energy - Untapped Capabilities

#### Swift Meaning with Example

`@Lazy` is used in Swift to delay computation until a property is accessed for the first time.

```swift
class SomeClass {
    @Lazy var someExpensiveComputation = computeSomethingExpensive()
}
```

#### The Metaphor

`@Lazy` symbolizes the untapped potential within us, waiting for the right moment to be unleashed.

#### The Life Parallel

In life, many of us have dormant talents or capabilities that await the right circumstance to manifest, much like a `@Lazy` property.

---

## 18. Creating Your Own Property Wrapper: The Guardrails - Life's Boundaries

#### Swift Meaning with Example

Creating a property wrapper in Swift allows you to add additional behavior to variables. Let's look at a real-world example involving a clamping property wrapper. This property wrapper restricts a variable's value to be within a specified range.

Let's say you are building an app that simulates a bank account. For some reason, the bank has a policy that accounts can have at most $5,000 and at least $0 (no overdraft allowed). You can create a `@Clamping` property wrapper to enforce these rules:

```swift
@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>
    
    var wrappedValue: Value {
        get { value }
        set { value = min(max(range.lowerBound, newValue), range.upperBound) }
    }
    
    init(wrappedValue: Value, _ range: ClosedRange<Value>) {
        self.value = wrappedValue
        self.range = range
    }
}

struct BankAccount {
    @Clamping(0...5000) var balance: Int
    
    init(initialBalance: Int) {
        _balance = Clamping(wrappedValue: initialBalance, 0...5000)
    }
}

var account = BankAccount(initialBalance: 100)
account.balance = 6000  // Will be clamped to 5000
account.balance = -50   // Will be clamped to 0
print(account.balance)  // Output will be 0
```

#### The Metaphor

The `@Clamping` property wrapper serves as the guardrails on the highway of life. It ensures you don't go off the track, setting boundaries for where you can go.

#### The Life Parallel

In life, boundaries—whether set by society, laws, or personal morals—act as our guardrails. They keep us on the right path and help us to make decisions within acceptable limits, much like the `@Clamping` property wrapper keeps our bank balance within an acceptable range.

---
This blending of technical examples with metaphorical insights provides a fuller understanding of both the SwiftUI property wrappers and the life themes they can represent. The marriage of code and metaphor opens new vistas for exploring the intricate weave of existence.

---
## A Note of Gratitude and Disclaimer

I hope this exploration has given you some food for thought, and perhaps even made complex coding concepts a tad easier to grasp. As we wrap up, it's important to mention that I've had a little help from ChatGPT in organizing and articulating my ideas. I'm truly grateful for this AI tool, which serves almost like a co-writer, helping me transform a whirlpool of thoughts into coherent sentences.
