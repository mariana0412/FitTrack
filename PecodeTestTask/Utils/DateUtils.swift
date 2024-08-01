//
//  DateUtils.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

import Foundation

class DateUtils {
    static func convertTimestampToString(_ timestamp: Int?) -> String {
        guard let timestamp = timestamp else { return "" }
        
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: date)
    }
}
