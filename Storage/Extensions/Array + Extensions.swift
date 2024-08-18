//
//  Array + Extensions.swift
//  Storage
//
//  Created by KOДИ on 19.08.2024.
//

import UIKit

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
