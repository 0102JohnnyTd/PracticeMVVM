//
//  UIImage+.swift
//  PracticeMVVM
//
//  Created by Johnny Toda on 2022/11/06.
//

import UIKit

extension UIImage {
    // UIColorをUIImageに変換
    convenience init?(color: UIColor, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgimage = image?.cgImage else { return  nil}
        self.init(cgImage: cgimage)
    }
}
