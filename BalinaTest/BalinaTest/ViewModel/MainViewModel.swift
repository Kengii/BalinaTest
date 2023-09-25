//
//  MainViewModel.swift
//  BalinaTest
//
//  Created by Владимир Данилович on 25.09.23.
//

import SwiftUI
import Combine

enum State {
  case loading
  case ready
}

final class MainViewModel {
  init() {
    get()
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
      self?.state = .ready
    }
  }

  // MARK: Published

  @Published var state: State = .loading
  @Published var page = 0
  @Published var pageSize = 0
  @Published var totalElements = 0
  @Published var totalPages = 0
  @Published var content: [PhotoTypeDtoOut] = []

  // MARK: Private

  private let api = ApiManager()
  private var cancellable = Set<AnyCancellable>()

  // MARK: POST

  var id: String = ""
  private let name: String = "Vladimir Danilovich"

  func get() {
    api.get()
      .sink { [weak self] page in
      self?.page = Int(page.page)
      self?.pageSize = Int(page.pageSize)
      self?.totalElements = Int(page.totalElements)
      self?.totalPages = Int(page.totalPages)
      self?.content = page.content
    }
      .store(in: &cancellable)
  }

  func modelToSend(image: Data) {
    api.post(id: id, name: name, image: image)
  }

}
