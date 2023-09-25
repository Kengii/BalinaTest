//
//  MainTableViewController.swift
//  BalinaTest
//
//  Created by Владимир Данилович on 25.09.23.
//

import SwiftUI
import Combine

final class MainTableViewController: UITableViewController, UINavigationControllerDelegate {

  var viewModel = MainViewModel()

  private var content: [PhotoTypeDtoOut] = []
  private var cancellable = Set<AnyCancellable>()
  private var photo = UIImage()
  private var currentPage = 1
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let refreshControl = UIRefreshControl()
      refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
      tableView.refreshControl = refreshControl
      bindToState()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Сell", for: indexPath) as! MainTableViewCell

      if content.isEmpty {
        cell.textLabel?.text = ""
      } else {
        let item = content[indexPath.row]
        cell.textLabel?.text = "\(item.name)"
        cell.textLabel?.textAlignment = .center
        if let data = item.imageData {
          photo = UIImage(data: data) ?? UIImage()
          cell.photo.image = photo
        }
      }
        return cell
    }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = content[indexPath.row].id
    viewModel.id = String(item)
    setupCamera()
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == content.count - 1, currentPage < viewModel.totalPages {
      loadData()
    }
  }

  private func setupCamera() {
    let cameraIcon = UIImage(systemName: "camera")
    let actionSheet = UIAlertController(title: nil,
      message: nil,
      preferredStyle: .actionSheet)
    let camera = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
      self?.chooseImagePicker(source: .camera)
    }
    camera.setValue(cameraIcon, forKey: "image")
    camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)

    actionSheet.addAction(camera)
    actionSheet.addAction(cancel)

    self.present(actionSheet, animated: true)
  }

  private func bindToState() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
      guard let self else { return }
      switch state {
      case .loading:
        print("Load")
      case .ready:
        content = viewModel.content
        tableView.reloadData()
      }
    }
      .store(in: &cancellable)
  }

  @objc private func loadData() {
    currentPage = Int(viewModel.totalPages)
    currentPage += 1
    refreshControl?.endRefreshing()
  }
}

extension MainTableViewController: UIImagePickerControllerDelegate {
  func chooseImagePicker (source: UIImagePickerController.SourceType) {
    if UIImagePickerController.isSourceTypeAvailable(source) {
      let imagePicker = UIImagePickerController()
      imagePicker.delegate = self
      imagePicker.allowsEditing = true
      imagePicker.sourceType = source
      present(imagePicker, animated: true)
    }

  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let data = image.pngData() else { return }
    viewModel.modelToSend(image: data)
    dismiss(animated: true)
  }
}

