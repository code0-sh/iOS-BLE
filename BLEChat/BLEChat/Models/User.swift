final class User {
    var date: String
    var name: String
    var comment: String
    init() {
        self.date = ""
        self.name = ""
        self.comment = ""
    }
    init(date: String, name: String, comment: String) {
        self.date = date
        self.name = name
        self.comment = comment
    }
}
