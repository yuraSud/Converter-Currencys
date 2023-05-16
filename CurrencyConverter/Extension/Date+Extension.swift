

import Foundation

extension Date {
    
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
    
    func formateDateToJsonRequest() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
    
    func formateDateToUpdateLabel() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func differenceCalculation(date: Date) -> Bool {
        let diffComponents = Calendar.current.dateComponents([.hour], from: date, to: self)
        let hours = diffComponents.hour ?? 0
        return abs(hours) < 20 ? true : false
    }
}
