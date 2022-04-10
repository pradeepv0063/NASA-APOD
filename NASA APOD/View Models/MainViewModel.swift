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

    var title: String = ""
    var detail: String = ""
    var date: String = ""
    var imageUrl: URL?
    var videoId: String?
    var mediaType: MediaType = .unknown
    
    let service: APODServiceType.Type

    init(service: APODServiceType.Type = APODService.self) {
        self.service = service
    }
    
    func viewLoaded() {
        loadPicture(on: Date())
    }
    
    func loadPicture(on date: Date) {
        let dateString =  date.getDateString()
        getPicture(for: dateString)
    }
    
    func toggleFavorite() -> Bool {
        var isSelected: Bool
        if var favorites = UserDefaults.standard.object(forKey: UserDefaultKeys.favorites.rawValue) as? [String: String] {
            
            if favorites[title] == nil {
                isSelected = true
                favorites[title] = date
            } else {
                isSelected = false
                favorites[title] = nil
            }
            UserDefaults.standard.set(favorites, forKey: UserDefaultKeys.favorites.rawValue)
        } else {
            isSelected = true
            let favorites = [title: date]
            UserDefaults.standard.set(favorites, forKey: UserDefaultKeys.favorites.rawValue)
        }
        
        return isSelected
    }
    
    func getFavStatus() -> Bool {
        let favorites = UserDefaults.standard.object(forKey: UserDefaultKeys.favorites.rawValue) as? [String: String]
        return favorites?[title] != nil
    }
    
    func getFavList() -> [String] {
        guard let favorites = UserDefaults.standard.object(forKey: UserDefaultKeys.favorites.rawValue) as? [String: String] else { return [] }
        let keys = favorites.map { $0.key }
        return keys
    }
    
    func loadFav(title: String) {
        guard let favorites = UserDefaults.standard.object(forKey: UserDefaultKeys.favorites.rawValue) as? [String: String], let date = favorites[title] else { return }
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
}
