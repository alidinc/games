//
//  UIImage+Extension.swift
//  Speeltuin
//
//  Created by alidinc on 29/01/2024.
//

import UIKit

extension UIImage {
    func resizeTo(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: .init(origin: .zero, size: size))
        }
    }
}
