//
//  Navigator.swift
//  Headlines
//
//  Created by Jullianm on 15/09/2019.
//  Copyright © 2019 Jullianm. All rights reserved.
//

import Foundation

class Navigator: ObservableObject {
    enum ModalType {
        case preferences, details
    }
    var presenting: ModalType = .preferences {
        willSet {
            showSheet = true
        }
    }
    
    @Published var showSheet: Bool = false
}
