# Sort Spectacle

Sort Spectacle is a Swift/SwiftUI app demonstrating visually how different sorting algorithms behave.

Currently Bubble sort, Lamp sort and Quick sort are implemented. Additionally, Swift Foundation array's sort() is called, to compare performance in the final step of the demonstration. Array.sort() implements Timsort (AFAIK).

## How to use

Clone the repo, build using Xcode and run either in simulator or in a real device (iPhone, iPad, macOS). 

Please note that you should build the app in Release configuration to make it run full speed without debugging stuff inside. 

## To do

More sorting methods. E.g. restructure Timsort from Foundation source code to execute step by step.

Better settings / configuration to select: 

- count of numbers to sort
- fancy graphics to display
- adjusting speed, depending on array size

## Contributing

See the docs generated from the code. If you want to add a new sorting method:

1. Read the `SortMethod` protocol and the [documentation](https://anttijuu.github.io/SortSpectacle) of the app.
1. Using other methods as samples, implement your sorting method, both the step by step method (`SortMethod.nextStep()`) and the `realAlgorithm()`.
1. Test your sort method by adding it to existing testing methods in unit tests (`SortSpectacleTests.swift`) as well as writing new tests.
1. Add your sort method to the `SortCoordinator.prepare()`
1. Share your sort method. I'd like to add more in this project.

## License

MIT License

## Who did this

(c) Antti Juustila, 2020 All Rights Reserved.
INTERACT Research Group, University of Oulu, Finland

