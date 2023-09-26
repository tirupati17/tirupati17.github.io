---
title: "Kickstarting Swift Composable Architecture"
date: 2023-09-24T19:23:13+05:30
draft: true # Set 'false' to publish
description: ""
categories:
- Swift
tags:
- swift
- architecture
- composablearchitecture
- composable
---

I have been exploring various architectures & design pattern for the past 12 years while working with Swift & Objective-C. This time, I am eager to try the Composable Architecture. One of the key reasons for choosing it is due to its adoption by [Bending Spoons](https://bendingspoons.com/), a company I greatly admire. They have numerous apps, including [Splice](https://spliceapp.com), a video editor which I regularly use to create [Mysticadii](https://www.mysticadii.com) Videos.

Previously, I followed Bending Spoons' open-source projects like Katana Swift & Tempura. However, based on [a notice](https://github.com/BendingSpoons/katana-swift#state-of-the-project) in Katana’s GitHub repo, it seems they have also transitioned to the Composable Architecture. Given its growing popularity and remarkable reusability, I have finally decided to delve into it. So, let’s get started!

## **What is Composable Architecture?**

Composable Architecture, often abbreviated as TCA, is a Swift library designed to build applications in a well-organized, modular, and scalable manner. It primarily focuses on managing the app's state effectively, ensuring each component of the app remains independent, easily testable, and consistent.

## A Practical Example
To grasp the concepts better, let’s explore a real-world example, a [SIP Calculator](https://github.com/tirupati17/sip-calculator-swift), developed in Swift by me. This example will illustrate how business logic is encapsulated and how components interact within this architecture.

To implement the SIP Calculator App using the Composable Architecture, we need to follow a distinct approach compared to the standard UIKit based implementation.

In the Composable Architecture (TCA), the core components are:
- **State:** Represents the data your feature needs to perform its logic and render its UI.
- **Action:** Represents all the ways the state can change.
- **Environment:** Holds any dependencies the feature needs, like API clients, analytics clients, etc.
- **Reducer:** A function that describes how to evolve the current state to the next state given an action.

Let’s try to compose an equivalent Composable Architecture for the given UIKit code. Please note, TCA is more suited for SwiftUI, so consider moving to SwiftUI for UI if we are adopting TCA.
