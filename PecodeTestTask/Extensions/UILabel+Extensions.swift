//
//  UILabel+Extensions.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

extension UILabel {
    
    private enum Constants {
        enum Layout {
            static let visibleTextOffset = 5
            static let heightMultiplier = 2.8
        }
    }
    
    func addShowMoreText(maxLinesNumber: Int, trailingText: String = " ", moreText: String = "Show more", button: UIButton) {
        let showMoreText = trailingText + moreText
        
        let labelWidth = self.frame.size.width
        let sizeConstraint = CGSize(width: labelWidth, 
                                    height: CGFloat.greatestFiniteMagnitude)
        let boundingRect = self.text?.boundingRect(with: sizeConstraint,
                                                   options: .usesLineFragmentOrigin, attributes: [.font: self.font as Any], context: nil)
        let textHeight = boundingRect?.height ?? 0
        let lineHeight = self.font.lineHeight
        let maxLines = Int(textHeight / lineHeight)

        if maxLines <= maxLinesNumber {
            return
        }

        let visibleTextLength = self.visibleTextLength(for: maxLinesNumber) - Constants.Layout.visibleTextOffset
        guard visibleTextLength > 0, let text = self.text else { return }

        let mutableText = text as NSString
        let trimmedText = mutableText.replacingCharacters(in: NSRange(location: visibleTextLength, 
                                                                      length: text.count - visibleTextLength), with: "")

        if trimmedText.count <= showMoreText.count { return }

        let trimmedForShowMore = (trimmedText as NSString).replacingCharacters(in: NSRange(location: trimmedText.count - showMoreText.count, length: showMoreText.count), with: "") + trailingText

        let finalText = NSMutableAttributedString(string: trimmedForShowMore, 
                                                  attributes: [NSAttributedString.Key.font: self.font as Any])
        self.attributedText = finalText

        let buttonX = self.intrinsicContentSize.width - button.frame.width
        let buttonY = self.font.lineHeight * Constants.Layout.heightMultiplier
        button.frame = CGRect(x: buttonX, 
                              y: buttonY,
                              width: button.frame.width,
                              height: button.frame.height)

        self.addSubview(button)
    }

    private func visibleTextLength(for maxLinesNumber: Int) -> Int {
        guard let text = self.text else { return 0 }
        
        let font = self.font
        let labelWidth = self.frame.size.width
        let sizeConstraint = CGSize(width: labelWidth, 
                                    height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font as Any]
        let attributedText = NSAttributedString(string: text, 
                                                attributes: attributes)
        let boundingRect = attributedText.boundingRect(with: sizeConstraint, 
                                                       options: .usesLineFragmentOrigin, 
                                                       context: nil)
        
        if boundingRect.size.height > self.font.lineHeight * CGFloat(maxLinesNumber) {
            var index = 0
            var previous = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                previous = index
                index = (text as NSString).rangeOfCharacter(from: characterSet, 
                                                            options: [],
                                                            range: NSRange(location: index + 1, length: text.count - index - 1)).location
                let substring = (text as NSString).substring(to: index)
                let substringBoundingRect = (substring as NSString).boundingRect(with: sizeConstraint, 
                                                                                 options: .usesLineFragmentOrigin,
                                                                                 attributes: attributes,
                                                                                 context: nil)
                if substringBoundingRect.size.height > self.font.lineHeight * CGFloat(maxLinesNumber) {
                    return previous
                }
            } while index != NSNotFound && index < text.count
            return previous
        }
        
        return text.count
    }
}
