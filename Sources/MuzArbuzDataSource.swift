import SwiftyJSON
import WebAPI
import TVSetKit

class MuzArbuzDataSource: DataSource {
  let service = MuzArbuzService.shared

  override open func load(params: Parameters) throws -> [Any] {
    var result: [Any] = []

    let selectedItem = params["selectedItem"] as? Item

    var request = params["requestType"] as! String
    let pageSize = params["pageSize"] as! Int
    let currentPage = params["currentPage"] as! Int

    if selectedItem?.type == "double_album" {
      request = "Double Album"
    }
    else if selectedItem?.type == "album" {
      request = "Album Tracks"
    }
    else if selectedItem?.type == "artist" {
      request = "Artist Tracks"
    }
    else if selectedItem?.type == "collection" {
      request = "Collection Tracks"
    }

    switch request {
    case "Bookmarks":
      if let bookmarksManager = params["bookmarksManager"]  as? BookmarksManager,
         let bookmarks = bookmarksManager.bookmarks {
        result = bookmarks.getBookmarks(pageSize: 60, page: currentPage)
      }

    case "History":
      if let historyManager = params["historyManager"]  as? HistoryManager,
         let history = historyManager.history {
        result = history.getHistoryItems(pageSize: 60, page: currentPage)
      }

      case "Albums":
        //var params = ["year__gte": "1960", "year__lte": "1980"]

        result = try service.getAlbums(params: [:], pageSize: pageSize, page: currentPage)["items"] as! [Any]

      case "Albums By Genre":
        if let genre = params["parentId"] as? String {
          result = try service.getAlbums(params: ["genre__in": genre], pageSize: pageSize, page: currentPage)["items"] as! [Any]
        }

      case "Double Album":
        if let parentId = params["parentId"] as? String {
          result = try service.getAlbums(params: ["parent__id": parentId], pageSize: pageSize, page: currentPage)["items"] as! [Any]
        }

      case "All Artists":
        result = try service.getArtists(params: [:], pageSize: pageSize, page: currentPage)["items"] as! [Any]

      case "Artists":
        if let letter = params["parentName"] as? String {
          let encodedLetter = letter.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
          result = try service.getArtistAnnotated(params: ["title__istartswith": encodedLetter.lowercased()],
            pageSize: pageSize, page: currentPage)["items"] as! [Any]
        }

      case "Collections":
        result = try service.getCollections(params: [:], pageSize: pageSize, page: currentPage)["items"] as! [Any]

      case "Genres":
        result = try service.getGenres(params: [:], pageSize: pageSize, page: currentPage)["items"] as! [Any]

      case "Artists Letter":
        if let parentId = params["parentId"] as? String {
          let letters = parentId == "By Letter" ? MuzArbuzAPI.CyrillicLetters : MuzArbuzAPI.LatinLetters

          var list = [Any]()

          for letter in letters {
            list.append(["name": letter])
          }

          result = list
        }

      case "Album Tracks":
        if let album = selectedItem?.id {
          result = try service.getTracks(params: ["album": album])["items"] as! [Any]
        }

      case "Artist Tracks":
        if let artist = selectedItem?.id {
          result = try service.getTracks(params: ["artists": artist])["items"] as! [Any]
        }

      case "Collection Tracks":
        if let collection = selectedItem?.id {
          result = try service.getTracks(params: ["collection__id": collection])["items"] as! [Any]
        }

      case "Search":
        if let query = params["query"] as? String {
          if !query.isEmpty {
            let r = try service.search(query, page: currentPage)

            //result = (r["album"] as! [String: Any])["items"] as! [Any]
//            result = []
//            result.append((r["album"] as! [String: Any])["items"])
//            result.append((r["collection"] as! [String: Any])["items"])
//            result.append((r["artist_annotated"] as! [String: Any])["items"])
//            result.append((r["audio_track"] as! [String: Any])["items"])

            result = [r]
          }
        }

      case "Search Albums":
        if let query = params["query"] as? String {
          if !query.isEmpty {
            var newParams = [String: String]()
            newParams["q"] = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

            let searchResult = try service.searchAlbum(newParams, pageSize: pageSize, page: currentPage)

            result = searchResult["items"] as! [Any]
          }
        }

      case "Search Collection":
        if let query = params["query"] as? String {
          if !query.isEmpty {
            var newParams = [String: String]()
            newParams["q"] = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

            let searchResult = try service.searchCollection(newParams, pageSize: pageSize, page: currentPage)

            result = searchResult["items"] as! [Any]
          }
        }

      case "Search Artist Annotated":
        if let query = params["query"] as? String {
          if !query.isEmpty {
            var newParams = [String: String]()
            newParams["q"] = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

            let searchResult = try service.searchArtistAnnotated(newParams, pageSize: pageSize, page: currentPage)

            result = searchResult["items"] as! [Any]
          }
        }

      case "Search Audio Track":
        if let query = params["query"] as? String {
          if !query.isEmpty {
            var newParams = [String: String]()
            newParams["q"] = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

            let searchResult = try service.searchAudioTrack(newParams, pageSize: pageSize, page: currentPage)

            result = searchResult["items"] as! [Any]
          }
        }

      default:
        result = []
    }

    let convert = params["convert"] as? Bool ?? true

    if convert {
      return convertToMediaItems(result)
    }
    else {
      return result
    }
  }

  func convertToMediaItems(_ items: [Any]) -> [Item] {
    var newItems = [Item]()

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
