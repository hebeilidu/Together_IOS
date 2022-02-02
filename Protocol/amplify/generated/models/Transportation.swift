// swiftlint:disable all
import Amplify
import Foundation

public enum Transportation: String, EnumPersistable {
  case car = "CAR"
  case walk = "WALK"
  case tram = "TRAM"
  case bike = "BIKE"
  case taxi = "TAXI"
}