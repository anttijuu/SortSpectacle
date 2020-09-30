# Sort Spectacle

Sort Spectacle is a Swift/SwiftUI app demonstrating visually how different sorting algorithms behave.

Currently Bubble sort, Lamp sort, Shell sort and Radix sort are implemented. Additionally, Swift Foundation array's sort() is called, to compare performance in the final step of the demonstration. Swift's Array.sort() implements Timsort (AFAIK).

See a short [demo video](https://youtu.be/5oQp6j5spfM) of the app running on iPhone 11.


## How to use

Clone the repo, build using Xcode and run either in simulator or in a real device (iPhone, iPad, macOS). 

Please note that you should build the app in **Release configuration** to make it run full speed without debugging stuff inside. 

## To do

More sorting methods. E.g. restructure Timsort from Foundation source code to execute step by step.

Better settings / configuration: 

- count of numbers to sort (has a picker at front page but it is ugly)
- fancier graphics to display (not compromizing the sort speed, though), especially with low count of numbers to sort
- adjusting speed, depending on array size (is already slower if count <= 100 but does not look good)

## Contributing

See the docs generated from the code. If you want to add a new sorting method:

1. Read the `SortMethod` protocol and the [documentation](https://anttijuu.github.io/SortSpectacle) of the app.
1. Using other methods as samples, implement your sorting method, both the step by step method (`SortMethod.nextStep()`) and the `realAlgorithm()`.
1. Test your sort method by adding it to existing testing methods in unit tests (`SortSpectacleTests.swift`) as well as writing new tests.
1. Add your sort method to the `SortCoordinator.prepare()`
1. Share your sort method. I'd like to add more in this project.

Optimizing and improving already implemented methods are also welcome (especially Radix sort, see it with count < 100 and observe how it does basically nothing useful at the end part.).

## License

MIT License

## Who did this

(c) Antti Juustila, 2020 All Rights Reserved.
INTERACT Research Group, University of Oulu, Finland

