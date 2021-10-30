import Foundation
import Combine

public protocol PropertyObservableObject: AnyObject {
  /// A publisher that emits when an object property has changed.
  var propertyDidChange: PassthroughSubject<AnyPropertyChangeEvent, Never> { get }
}

/// Represent an object mutation.
public struct AnyPropertyChangeEvent {
  /// The proxy's wrapped value.
  public let object: Any
  
  /// The mutated keyPath.
  public let keyPath: AnyKeyPath?
  
  /// Optional debug label for this event.
  public let debugLabel: String?
  
  /// Returns a new `allChanged` event.
  public static func allChangedEvent<T>(object: T) -> AnyPropertyChangeEvent {
    AnyPropertyChangeEvent(object: object, keyPath: nil, debugLabel: "*")
  }

  /// This event signal that the whole object changed and all of its properties should be marked
  /// as dirty.
  public func allChanged<T>(type: T.Type) -> Bool {
    guard let _ = object as? T, keyPath == nil else {
      return false
    }
    return true
  }

  /// Returns the tuple `object, value` if this property change matches the `keyPath` passed as
  /// argument.
  public func match<T, V>(keyPath: KeyPath<T, V>) -> (T, V)? {
    guard self.keyPath === keyPath, let obj = self.object as? T else {
      return nil
    }
    return (obj, obj[keyPath: keyPath])
  }
}
