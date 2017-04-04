final class User {
    var date: String
    var name: String
    var comment: String
    var distance: Int
    init() {
        self.date = ""
        self.name = ""
        self.comment = ""
        self.distance = 0
    }
    init(date: String, name: String, comment: String, distance: Int) {
        self.date = date
        self.name = name
        self.comment = comment
        self.distance = distance
    }
}
