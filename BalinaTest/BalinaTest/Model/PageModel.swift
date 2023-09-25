//
//  Page.swift
//  BalinaTest
//
//  Created by Владимир Данилович on 25.09.23.
//

import Foundation

struct PageModel: Codable {
  let content: [PhotoTypeDtoOut]
  let page: Int32
  let pageSize: Int32
  let totalElements: Int64
  let totalPages: Int32
}

struct PhotoDtoOut: Codable {
  let id: String?
}

struct PhotoTypeDtoOut: Codable {
  let id: Int32
  let name: String
  let image: URL?
  var imageData: Data?

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(Int32.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.image = try container.decodeIfPresent(URL.self, forKey: .image)

    if let image {
      let data = try? Data(contentsOf: image)
      self.imageData = data
    }
  }
}

struct ModelToSend: Encodable {
    let id: String
    let name: String
    let image: Data
}
