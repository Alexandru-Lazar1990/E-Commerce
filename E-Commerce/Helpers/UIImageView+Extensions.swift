//
//  UIImageView+Extensions.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        image = placeholder
        let cacheKey = url.absoluteString
        if let cachedImage = ImageCache.shared.getImage(forKey: cacheKey) {
            image = cachedImage
            return
        }
        Task { [weak self] in
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                return
            }
            ImageCache.shared.setImage(image, forKey: cacheKey)
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
