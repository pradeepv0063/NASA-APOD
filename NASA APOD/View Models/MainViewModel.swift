//
//  MainViewModel.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import Foundation

protocol MainViewModelType {
    
}

class MainViewModel: MainViewModelType {
    
    var reload: Dynamic<Bool> = Dynamic(false)
    var showLoader: Dynamic<(Bool, String)> = Dynamic((false, ""))
    var showAlert: Dynamic<(String, String)> = Dynamic(("", ""))
    var updateDatePicker: Dynamic<Date?> = Dynamic(nil)

    var title: String = ""
    var detail: String = ""
    var date: String = ""
    var imageUrl: URL?
    var videoId: String?
    var mediaType: MediaType = .unknown
    
    let service: APODServiceType.Type
    var storageService: LocalStorageServiceType.Type = LocalStorageService.self

    init(service: APODServiceType.Type = APODService.self) {
        self.service = service
    }

    /// Called when UIViewController's viewDidLoad is executed.  We load Today's picture here.
    ///
    /// - Parameter date: `Date` selected by the user
    func viewLoaded() {
        loadPicture(on: Date())
    }
    
    /// Called to Load a picture information on a specific date
    ///
    /// - Parameter date: `Date` selected by the user
    func loadPicture(on date: Date) {
        let dateString =  date.getDateString()
        getPicture(for: dateString)
    }
}

extension MainViewModel {
    
    /// Called to Toggle the Favorite option of a individual day. If it is favorite then this function unfavorites and viceversa.
    ///
    /// - Returns: `Bool` Indicates the current Picture is in favorite state or unfavorite state post toggle
    ///
    /// The Favorite will be stored and retrieved from a storage service.
    func toggleFavorite() -> Bool {
        
        var favoritesList = storageService.favorites
        var isSelected: Bool
        
        if favoritesList.isEmpty {
            
            isSelected = true
            storageService.favorites = [title: date]
        } else {
            
            if favoritesList[title] == nil {
                isSelected = true
                favoritesList[title] = date
            } else {
                isSelected = false
                favoritesList[title] = nil
            }
            storageService.favorites = favoritesList
        }

        return isSelected
    }
    
    /// Called to get the Favorite status of current Picture
    ///
    /// - Returns: `Bool` Indicates the favorite status of current Picture
    func getFavStatus() -> Bool {
        let status = storageService.favorites[title] != nil
        return status
    }
    
    /// Called to get list of Favorites
    ///
    /// - Returns: An Array of string with list of Favorites
    func getFavList() -> [String] {
        let keys = storageService.favorites.map { $0.key }
        return keys
    }
    
    /// Called to a favorite is selected
    ///
    /// - Parameter date: `String` containing the title of the picture
    func loadFav(title: String) {
        let favorites = storageService.favorites
        guard let date = favorites[title] else {
            showErrorAlert("Please try after sometime")
            return
        }
        updateDatePicker.value = date.getDate()
        getPicture(for: date)
    }
}

private extension MainViewModel {
    
    func getPicture(for date: String) {
        
        showLoader.value = (true, "Loading")
        service.getPicture(date: date).done { [weak self] model in
            self?.setView(with: model)
            self?.reload.value = true
        }.catch { error in
            print("Error: \(error.localizedDescription)")
            self.showErrorAlert(error.localizedDescription)
        }.finally {
            self.showLoader.value = (false, "")
        }
    }
    
    func setView(with model: APODModel) {
        
        title = model.title
        detail = model.detail
        mediaType = model.mediaType
        date = model.date
        switch model.mediaType {
            case .image:
                imageUrl = model.url
                videoId = nil
            case .video:
                videoId = model.urlString.components(separatedBy: "/").last
                imageUrl = nil
            default: break
        }
    }
    
    func showErrorAlert(_ message: String) {
        showAlert.value = ("Error", message)
    }
}
