# TaggedTextField

[![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg)](https://developer.apple.com)

<p>
  <img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExcWhleThwbm1kMG5oYmx2NDVjOW9pN3JpeWJudnZha2w5b3lqMjN4dCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/v8btYyHGuqy3gRQrKo/giphy.gif">
</p>
A SwiftUI text field with tagging functionality, allowing users to easily mention or tag items from a searchable list.

## Usage

1. Import the package
```swift
import TaggedTextField
```

2. Expand the model you are going to use in a search with TaggedItem. Here is an example:
```swift
struct User: TaggedItem {
    let id: String
    let name: String
    
    func displayName() -> String {
        return name
    }
    
    func taggedDisplayText() -> String {
        return "@\(name) " // How it appears in text after selection
    }
}
```

3. In your view, declare states of text and search results:
```swift
@State private var text = ""
@State private var searchResults: [User] = []
    
```

4. Add the TaggedTextFieldView to your view as per example:
```swift
  VStack {
            ... // ChatView(), etc
            Spacer()
            
            TaggedTextFieldView(
                text: $text,
                tagConfig: TagConfiguration(
                    trigger: "@",
                    searchPlaceholder: "Search users...",
                    noResultsMessage: "No users found",
                    itemBackgroundColor: .gray.opacity(0.1),
                    triggerColor: .blue
                ),
                onSearch: { trigger, searchText in
                    // Perform search based on trigger and searchText
                    print("onSearch: \(trigger); \(searchText)")
                    if trigger == "@" {
                        
                        searchResults = users.filter({
                            return $0.name.lowercased().contains(searchText.lowercased())
                        })
                    } else if trigger == "#" {
                        ...
                    }
                },
                onSubmit: { text in
                    // Handle text submission
                },
                onSelectItem: { user in
                    // Handle user selection
                },
                searchResults: searchResults
            )
}
```



## Requirements

- Swift 5.5+
- iOS 17.0+

## Installation
### Swift Package Manager
`TaggedTextField` is available through [Swift Package Manager](https://swift.org/package-manager/). 

To add package go to `File -> Swift Packages -> Add Package Dependancy `

```ruby
name: "TaggedTextField"
url: https://github.com/Ninise/TaggedTextField.git
version: 1.0.0
```
