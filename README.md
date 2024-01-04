# SwiftUI Core Location

## Usage
``` swift
struct Content: View {
    @State var locationEvent = LocationEvent.initial

    var body: some View {
        VStack {
           ...
           ...
        }
        .locationManager(requestPermission: .always, event: $locationEvent)
    }

}
```


