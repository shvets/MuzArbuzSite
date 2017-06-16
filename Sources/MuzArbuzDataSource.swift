import SwiftyJSON
import WebAPI
import TVSetKit
import Wrap

class MuzArbuzDataSource: DataSource {
  let service = MuzArbuzService.shared

  override open func load(params: Parameters) throws -> [Any] {
    var result: [Any] = []

    let selectedItem = params["selectedItem"] as? MediaItem

    var request = params["requestType"] as! String
    var pageSize = params["pageSize"] as! Int
    let currentPage = params["currentPage"] as! Int

    if selectedItem?.type == "book" {
      request = "Tracks"
    }

    switch request {
//      case "Bookmarks":
//        if let bookmarks = params["bookmarks"]  as? Bookmarks {
//          bookmarks.load()
//          result = bookmarks.getBookmarks(pageSize: 60, page: currentPage)
//        }
//
//      case "History":
//        if let history = params["history"] as? History {
//          history.load()
//          result = history.getHistoryItems(pageSize: 60, page: currentPage)
//        }

      case "Albums":
        var params = ["year__gte": "1960", "year__lte": "1980"]

        result = try service.getAlbums(params: params, pageSize: pageSize, page: currentPage)["items"] as! [Any]

      case "Artists":
        print("Artists")

//        var params = ["year__gte": "1960", "year__lte": "1980"]
//        result = try service.getArtists(params: params, pageSize: pageSize, page: currentPage)["items"]

      case "Collections":
        print("Collections")

      case "Genres":
        print("Genres")
//        result = try service.getGenres(page: currentPage)["movies"] as! [Any]


      case "Search":
        print("Search")
//        if let query = params["query"] as? String {
//          if !query.isEmpty {
//            result = try service.search(query, page: currentPage)["movies"] as! [Any]
//          }
//          else {
//            result = []
//          }
//        }

      default:
        result = []
    }

    return convertToMediaItems(result)

//    let convert = params["convert"] as? Bool ?? true
//
//    if convert {
//      return convertToMediaItems(result)
//    }
//    else {
//      return result
//    }
  }

  func convertToMediaItems(_ items: [Any]) -> [MediaItem] {
    var newItems = [MediaItem]()

    for item in items {
      var jsonItem = item as? JSON

      if jsonItem == nil {
        jsonItem = JSON(item)
      }

      let movie = MuzArbuzMediaItem(data: jsonItem!)

      newItems += [movie]
    }

    return newItems
  }

  func getLetters(_ items: [NameClassifier.ItemsGroup]) -> [String] {
    var rletters = [String]()
    var eletters = [String]()

    for item in items {
      let groupName = item.key

      let index = groupName.index(groupName.startIndex, offsetBy: 0)

      let letter = String(groupName[index])

      if (letter >= "a" && letter <= "z") || (letter >= "A" && letter <= "Z") {
        if !eletters.contains(letter) {
          eletters.append(letter)
        }
      }
      else if (letter >= "а" && letter <= "я") || (letter >= "А" && letter <= "Я") {
        if !rletters.contains(letter) {
          rletters.append(letter)
        }
      }
    }

    return rletters + eletters
  }

}
