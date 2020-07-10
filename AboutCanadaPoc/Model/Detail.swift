

import Foundation


struct Detail: Codable {
    let title: String?
    let description: String?
    var imageUrl: URL?
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case imageUrl = "imageHref"
    }
    
    func getString() -> String {
        return "title: \(String(describing: self.title))"
    }
    
    init() {
        self.title = nil
        self.description = nil
        self.imageUrl = nil
    }
    
}
