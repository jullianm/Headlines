//
//  ImageService.swift
//  Headlines
//
//  Created by Jullianm on 16/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import UIKit
import Combine

class ImageService {
   static let shared = ImageService()

   enum ImageError: Error {
       case decodingError
   }

    func fetchImage(url: URL) -> AnyPublisher<UIImage?, Never> {
       return URLSession.shared.dataTaskPublisher(for: url)
           .tryMap { (data, response) -> UIImage? in
               return UIImage(data: data)
       }.catch { error in
           return Just(nil)
       }
       .eraseToAnyPublisher()
   }
}

extension String {
    var url: URL {
        URL(string: self)!
    }
}
