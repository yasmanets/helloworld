//
//  UILabel.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 6/5/22.
//

import UIKit

extension UILabel {
    func textSize() -> CGRect {
        let maxSize = CGSize(width: self.frame.size.width, height: CGFloat(Float.infinity))
        let text = self.text! as NSString
        let textBounds = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)
        return textBounds
    }
}
