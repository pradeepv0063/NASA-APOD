//
//  ViewController.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import UIKit
import Kingfisher
import MBProgressHUD
import youtube_ios_player_helper

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

    @IBAction func favoritesTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Your Favorites", message: "", preferredStyle: .actionSheet)
        
        let favList = viewModel.getFavList()
        
        if favList.isEmpty {
            alert.title = "No Favorites"
        } else {
            
            alert.title = "Your Favorites"
            for item in favList {
                alert.addAction(UIAlertAction(title: item, style: .default, handler: { _ in
                    self.viewModel.loadFav(title: item)
                }))
            }
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: false)
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
                cell.favorite.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
                let isSelected = viewModel.getFavStatus()
                cell.favorite.isSelected = isSelected
                return cell
                
            case CellRows.media.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.mediaCell.rawValue, for: indexPath) as? MediaTableViewCell else { return UITableViewCell() }
                if viewModel.mediaType == .image {
                    cell.videoView.isHidden = true
                    cell.imgView.isHidden = false
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
                    cell.imgView.isHidden = true
                    cell.videoView.isHidden = false
                    cell.videoView.load(withVideoId: viewModel.videoId!)
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
    
    @objc func favoriteTapped() {
        
        let isSelected = viewModel.toggleFavorite()
        let titleIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: titleIndexPath) as? TitleTableViewCell
        cell?.favorite.isSelected = isSelected
        tableView.reloadRows(at: [titleIndexPath], with: .automatic)
    }
}
