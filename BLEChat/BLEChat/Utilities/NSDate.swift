import Foundation

extension NSDate {
    /**
     * 日付のフォーマットを設定する
     */
    func dateString() -> String {
        let formatter = DateFormatter()
        let jaLocale = Locale(identifier: "ja_JP")
        formatter.locale = jaLocale
        formatter.dateStyle = .long
        formatter.timeStyle = .long
        let date = formatter.string(from: self as Date)
        return date
    }
}
