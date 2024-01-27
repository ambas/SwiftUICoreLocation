import AsyncLocationKit
import MapKit
import SwiftUI

public struct EquatableError: Error, Equatable {
    let base: Error
  
  init(_ base: Error) {
    self.base = base
  }

    public static func ==(lhs: EquatableError, rhs: EquatableError) -> Bool {
        return type(of: lhs.base) == type(of: rhs.base) &&
        lhs.base.localizedDescription == rhs.base.localizedDescription
    }
}

public enum LocationEvent: Equatable {
  case initial
  case paused
  case resume
  case update(locations: [CLLocation])
  case fail(EquatableError)
}

public enum LocationPermission {
    case always
    case whenInUsage
    case notRequest
}

@available(visionOS, unavailable)
public struct LocationManager: ViewModifier {
  let requestPermission: LocationPermission
  let manager: AsyncLocationManager
  @Binding var event: LocationEvent
  
  public init(requestPermission: SwiftUICoreLocation.LocationPermission, event: Binding<LocationEvent>) {
    self.requestPermission = requestPermission
    _event = event
    manager = AsyncLocationManager(desiredAccuracy: .bestAccuracy)
  }
  
  public func body(content: Content) -> some View {
    content
      .task {
        if let requestPermission = requestPermission.permission {
          let _ = await manager.requestPermission(with: requestPermission)
          for await event in await manager.startUpdatingLocation() {
            switch event {
            case .didPaused:
              self.event = .paused
            case .didResume:
              self.event = .resume
            case .didUpdateLocations(locations: let locations):
              self.event = .update(locations: locations)
            case .didFailWith(error: let error):
              self.event = .fail(.init(error))
            }
          }
        }

      }
  }
}

@available(visionOS, unavailable)
public extension View {
  func locationManager(requestPermission: LocationPermission, event: Binding<LocationEvent>) -> some View {
    modifier(LocationManager(requestPermission: requestPermission, event: event))
  }
}

extension LocationPermission {
  var permission: AsyncLocationKit.LocationPermission? {
    switch self {
    case .always: return .always
    case .whenInUsage: return .whenInUsage
    default: return nil
    }
  }
}
