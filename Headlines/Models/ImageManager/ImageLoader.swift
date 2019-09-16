//
//  ImageLoader.swift
//  Headlines
//
//  Created by Jullianm on 16/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import Combine

final class ImageLoader: ObservableObject {
    var url: URL?
    var objectWillChange: AnyPublisher<UIImage?, Never> = Publishers.Sequence<[UIImage?], Never>(sequence: []).eraseToAnyPublisher()
    
    @Published var image: UIImage? = nil
    
    var cancellable: AnyCancellable?
    
    init(model: HeadlinesViewModel) {
        self.url = model.selectedArticle?.urlToImage?.url
        
        self.objectWillChange = $image.handleEvents(receiveSubscription: { [weak self] sub in
            self?.loadImage()
            }, receiveCancel: { [weak self] in
                self?.cancellable?.cancel()
        }).eraseToAnyPublisher()
    }
    
    private func loadImage() {
        guard let url = url, image == nil else {
            return
        }
        cancellable = ImageService.shared.fetchImage(url: url)
            .receive(on: DispatchQueue.main)
            .assign(to: \ImageLoader.image, on: self)
    }
    
    deinit {
        cancellable?.cancel()
    }
}
