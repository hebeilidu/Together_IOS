// swiftlint:disable all
import Amplify
import Foundation

extension Post {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case title
    case departurePlace
    case destination
    case transportation
    case departureTime
    case maxMembers
    case description
    case owner
    case members
    case applicants
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let post = Post.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .delete]),
      rule(allow: .private, operations: [.read, .update])
    ]
    
    model.pluralName = "Posts"
    
    model.fields(
      .id(),
      .field(post.title, is: .optional, ofType: .string),
      .field(post.departurePlace, is: .optional, ofType: .string),
      .field(post.destination, is: .optional, ofType: .string),
      .field(post.transportation, is: .optional, ofType: .enum(type: Transportation.self)),
      .field(post.departureTime, is: .optional, ofType: .dateTime),
      .field(post.maxMembers, is: .optional, ofType: .int),
      .field(post.description, is: .optional, ofType: .string),
      .field(post.owner, is: .optional, ofType: .string),
      .field(post.members, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(post.applicants, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(post.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(post.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}