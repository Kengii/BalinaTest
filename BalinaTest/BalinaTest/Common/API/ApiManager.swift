//
//  ApiManager.swift
//  BalinaTest
//
//  Created by Владимир Данилович on 25.09.23.
//

import Foundation
import Combine

enum ApiPath: String {
    case getRequest = "https://junior.balinasoft.com/api/v2/photo/type"
    case postRequest = "https://junior.balinasoft.com/api/v2/photo"
}

final class ApiManager {

  init() {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    self.decoder = decoder
  }

  let decoder: JSONDecoder

  func get() -> AnyPublisher<PageModel, Never> {
    let link = ApiPath.getRequest.rawValue
    guard let url = URL(string: link) else {
      return Just(PageModel(content: [], page: 0, pageSize: 0, totalElements: 0, totalPages: 0)).eraseToAnyPublisher()
    }

    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: PageModel.self, decoder: JSONDecoder()) // декодер не даавал сдекодить данные
    .replaceError(with: .init(content: [], page: 0, pageSize: 0, totalElements: 0, totalPages: 0))
      .eraseToAnyPublisher()
  }

  func post(id: String, name: String, image: Data) {
      let link = ApiPath.postRequest.rawValue
      guard let url = URL(string: link) else { return }
      let body = ModelToSend(id: id, name: name, image: image)
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      guard let httpBody = try? JSONEncoder().encode(body) else { return } 
      request.httpBody = httpBody

      let session = URLSession.shared
      session.dataTask(with: request) { (data, response, error) in
          if let response = response {
              print(response)
          }

          guard let data = data else { return }
          do {
              let json = try JSONSerialization.jsonObject(with: data)
              print(json)
          } catch {
              print(error)
          }
      }.resume()
  }
}


