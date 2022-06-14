# Sort Spectacle

Sort Spectacle is a Swift/SwiftUI app demonstrating visually how different sorting algorithms behave.

Current implementation includes:

- Bubble sort
- Lamp sort
- Shell sort
- Heap sort
- Radix sort and 
- Block sort (variant of Merge sort).

Additionally, Swift Foundation Array's `sort()` is called, to compare performance in the final step of the demonstration. Swift's `Array.sort()` implements Tim sort.

Note that the Block sort (nor Timsort) is not yet animated, so it will be executed only at the end when measuring performance without animation.

See a short [demo video](https://youtu.be/xeXszpIwsmY) of the app running on iPhone 11.

## How to use

Clone the repo, build using Xcode and run either in simulator or in a real device (iPhone, iPad, macOS). 

Please note that for performance comparisons, you should build the app in **Release configuration** to make it run full speed without debugging stuff inside. 

## To do

- [ ] More sorting methods. E.g. implement Timsort from Foundation source code to execute step by step.
- [ ] Implement step by step version of Block sort.
- [ ] Count of numbers to sort. Currently has a picker at front page but it is ugly.
- [ ] Fancier graphics and audio, but not compromising the sort speed, though, especially with low count of numbers to sort.
- [ ] Adjusting speed, depending on array size. Is already slower if array size is small but does not look too good.

## Contributing

See the docs generated from the code. If you want to add a new sorting method:

1. Read the `SortMethod` protocol and the [documentation](https://anttijuu.github.io/SortSpectacle) of the app.
1. Using other methods as samples, implement your sorting method, both the step by step method (`SortMethod.nextStep()`) and the `realAlgorithm()`.
1. Test your sort method by adding it to existing testing methods in unit tests (`SortSpectacleTests.swift`) as well as writing new tests. Make sure tests do not fail.
1. Add your sort method to the `SortCoordinator.prepare()`.
1. Share your sort method. I'd like to add more in this project.

The preferred way to contribute is to fork the project, creating a branch to your own fork. In the branch, implement the new sorting method. When you have tested that it works (see the unit tests in `SortSpectacleTests.swift`), provide a pull request from your fork to my repository. I'll then check & test and merge it into the main project if all is well.

Optimizing and improving already implemented methods are also welcomed contributions (especially Radix sort, see it with small number counts and observe how it does basically nothing useful at the end part.). Also Block sort and Timsort animations are not yet implemented (`SortMethod.nextStep()` basically returns true), and need to be done.

## License

MIT License. See the LICENSE file for details.

## Who did this

(c) Antti Juustila, 2020-2022 All Rights Reserved.
INTERACT Research Group, University of Oulu, Finland

