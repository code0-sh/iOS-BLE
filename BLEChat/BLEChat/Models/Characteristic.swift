final class Characteristic {
    var UUID: String
    var value: String
    init(data: [String: String]) {
        self.UUID = data["UUID"] ?? ""
        self.value = data["value"] ?? ""
    }
}
