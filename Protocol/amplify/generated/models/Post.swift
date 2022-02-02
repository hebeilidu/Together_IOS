// swiftlint:disable all
import Amplify
import Foundation

public struct Post: Model {
  public let id: String
  public var title: String?
  public var departurePlace: String?
  public var destination: String?
  public var transportation: Transportation?
  public var departureTime: Temporal.DateTime?
  public var maxMembers: Int?
  public var description: String?
  public var owner: String?
  public var members: [String?]?
  public var applicants: [String?]?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      title: String? = nil,
      departurePlace: String? = nil,
      destination: String? = nil,
      transportation: Transportation? = nil,
      departureTime: Temporal.DateTime? = nil,
      maxMembers: Int? = nil,
      description: String? = nil,
      owner: String? = nil,
      members: [String?]? = nil,
      applicants: [String?]? = nil) {
    self.init(id: id,
      title: title,
      departurePlace: departurePlace,
      destination: destination,
      transportation: transportation,
      departureTime: departureTime,
      maxMembers: maxMembers,
      description: description,
      owner: owner,
      members: members,
      applicants: applicants,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      title: String? = nil,
      departurePlace: String? = nil,
      destination: String? = nil,
      transportation: Transportation? = nil,
      departureTime: Temporal.DateTime? = nil,
      maxMembers: Int? = nil,
      description: String? = nil,
      owner: String? = nil,
      members: [String?]? = nil,
      applicants: [String?]? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.title = title
      self.departurePlace = departurePlace
      self.destination = destination
      self.transportation = transportation
      self.departureTime = departureTime
      self.maxMembers = maxMembers
      self.description = description
      self.owner = owner
      self.members = members
      self.applicants = applicants
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}