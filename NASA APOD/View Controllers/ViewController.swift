//
//  ViewController.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import UIKit
import Kingfisher
import MBProgressHUD

enum CellRows: Int {
    case title = 0, media, detail
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!

    lazy var viewModel = MainViewModel()
    var currentImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.viewLoaded()
    }
    
    @IBAction func dateSelected(_ sender: UIButton) {
        presentedViewController?.dismiss(animated: true, completion: nil)
        viewModel.loadPicture(on: datePicker.date)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
                
            case CellRows.title.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.titleCell.rawValue, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
                cell.imageTitle.text = viewModel.title
                return cell
                
            case CellRows.media.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.mediaCell.rawValue, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
                if viewModel.mediaType == .image {
                    cell.imgView.kf.setImage(with: viewModel.imageUrl) { result in
                        switch result {
                        case .success(let value):
                            self.currentImage = value.image
                            tableView.reloadRows(at: [indexPath], with: .automatic)
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                    }
                } else if viewModel.mediaType == .video {
                    
                }
                return cell
                
            case CellRows.detail.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.detailCell.rawValue, for: indexPath) as? DetailTableViewCell else { return UITableViewCell() }
                cell.detail.text = viewModel.detail
                return cell
                
            default: return UITableViewCell()
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == 1, let image = currentImage else { return UITableView.automaticDimension }
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        guard imageWidth > 0 && imageHeight > 0 else { return UITableView.automaticDimension }
        let requiredWidth = tableView.frame.width
        let widthRatio = requiredWidth / imageWidth
        let requiredHeight = imageHeight * widthRatio
        return requiredHeight
    }
}

private extension ViewController {

    func setupBindings() {
        
        viewModel.reload.bind { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        viewModel.showLoader.bind { [weak self] (show, message) in
            guard let self = self else { return }
            if show {
                let loader = MBProgressHUD.showAdded(to: self.view, animated: true)
                loader.label.text = message
                loader.backgroundView.style = .blur
            } else {
                MBProgressHUD .hide(for: self.view, animated: true)
            }
        }
    }
}
