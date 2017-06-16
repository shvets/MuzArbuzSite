import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class MuzArbuzMediaItem: MediaItem {
  var items = [JSON]()

  override init(data: JSON) {
    super.init(data: data)

    //self.name = data["title"].stringValue
    self.thumb = "\(MuzArbuzAPI.SiteUrl)\(data["thumb"])"

    print(self.thumb)

//    self.items = []
//
//    let items = data["items"].arrayValue
//
//    for item in items {
//      self.items.append(item)
//    }
  }
  
  override func isContainer() -> Bool {
    return type == "album" || type == "double_album" || type == "tracks"
  }

  override func isAudioContainer() -> Bool {
    return true
  }

}
