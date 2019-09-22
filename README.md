# Headlines

Headlines is an iOS app built 95% in SwiftUI and 5% UIKit. 
It uses Combine, Apple's solution to reactive programming, to handle asynchronous operations.
The MVVM architecture has been implemented with a one and only view model conforming to the @ObservableObject protocol which will be observed by our views.
Any changes in the model will be known to the view model and be reflected on the UI.

Disclaimer: The app is 95% done, there are still a few issues to address.

![alt text](https://github.com/jullianm/Headlines/blob/master/headlines_screen.png)

**UI**
- Headlines is built 95% in SwiftUI using all the built-in components the system provide such as VStack, HStack, Stack, Picker, List.
- It includes a UIKit component, a UICollectionView, which conforms to the `UIViewRepresentable` protocol, Apple’s built-in solution to integrate UIKit components into SwiftUI.

**Networking**
- Network request have been implemented using Combine, Apple's new framework to handle asynchronous events by combining event-processing operators. 

**Design pattern**
- The app is built using an MVVM architecture which is a perfect fit for SwiftUI as we can make our view model conform the ObservableObject and mark its underlying properties as @Published so that our views always reflect the latest model changes. 

![alt text](https://github.com/jullianm/Headlines/blob/master/headlines_mvvm_flow.png) 

**Platforms**
- Headlines runs on iPhone.

**Resources**
- If you're interested in the process of building that app, you can check my series of articles on  [Medium](https://medium.com/@jllnmercier).
- If you like what I'm doing consider following me on [Twitter](https://twitter.com/jullian_mercier).

