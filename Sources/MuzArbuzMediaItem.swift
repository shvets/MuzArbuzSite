import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class MuzArbuzMediaItem: MediaItem {
  var items = [JSON]()

  override init(data: JSON) {
    super.init(data: data)

    let thumb = data["thumb"].stringValue

    if !thumb.isEmpty {
      if thumb.range(of: MuzArbuzAPI.SiteUrl)?.lowerBound != nil {
        self.thumb = thumb
      }
      else {
        self.thumb = "\(MuzArbuzAPI.SiteUrl)\(thumb)"
      }
    }

//    print(self.thumb)
  }
  
  override func isContainer() -> Bool {
    return type == "album" || type == "double_album" || type == "artist" || type == "collection" ||
           type == "genre" || type == "tracks"
  }

  override func isAudioContainer() -> Bool {
    return type != "double_album"
  }

}
