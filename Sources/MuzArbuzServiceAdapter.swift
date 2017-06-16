import UIKit
import SwiftyJSON
import WebAPI
import TVSetKit

class MuzArbuzServiceAdapter: ServiceAdapter {
  static let bookmarksFileName = NSHomeDirectory() + "/Library/Caches/muzarbuz-bookmarks.json"
  static let historyFileName = NSHomeDirectory() + "/Library/Caches/muzarbuz-history.json"

  override open class var StoryboardId: String { return "MuzArbuz" }
  override open class var BundleId: String { return "com.rubikon.MuzArbuzSite" }

  lazy var bookmarks = Bookmarks(bookmarksFileName)
  lazy var history = History(historyFileName)

  public init(mobile: Bool=false) {
    super.init(dataSource: MuzArbuzDataSource(), mobile: mobile)

    bookmarks.load()
    history.load()

    pageLoader.pageSize = 12
    pageLoader.rowSize = 6

    pageLoader.load = {
      return try self.load()
    }
  }

  override open func clone() -> ServiceAdapter {
    let cloned = MuzArbuzServiceAdapter(mobile: mobile!)

    cloned.clear()

    return cloned
  }

  override open func load() throws -> [Any] {
    params["bookmarks"] = bookmarks
    params["history"] = history

    return try super.load()
  }

  override func addBookmark(item: MediaItem) -> Bool {
    return bookmarks.addBookmark(item: item)
  }

  override func removeBookmark(item: MediaItem) -> Bool {
    return bookmarks.removeBookmark(item: item)
  }

  override func addHistoryItem(_ item: MediaItem) {
    history.add(item: item)
  }

}