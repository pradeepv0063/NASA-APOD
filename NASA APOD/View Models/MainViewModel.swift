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
