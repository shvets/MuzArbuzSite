import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit
import AudioPlayer

enum SelectionType {
  case album
  case collection
  case artistAnnotated
  case audioTrack
}

extension SelectionType: RawRepresentable {
  public typealias RawValue = String

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "Album": self = .album
      case "Collection": self = .collection
      case "Artist Annotated": self = .artistAnnotated
      case "Audio Track": self = .audioTrack

      default: return nil
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .album: return "Album"
      case .collection: return "Collection"
      case .artistAnnotated: return "Artist Annotated"
      case .audioTrack: return "Audio Track"
    }
  }
}


class SearchResultTableViewController: MuzArbuzBaseTableViewController {
  static let SegueIdentifier = "Search Result"

  override open var CellIdentifier: String { return "SearchResultTableCell" }
  override open var BundleId: String { return MuzArbuzServiceAdapter.BundleId }

  let GroupNames = [SelectionType.album, SelectionType.collection, SelectionType.artistAnnotated, SelectionType.audioTrack]

  var query: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("Search Result")

    query = adapter.params["query"] as? String

    loadData()
  }

  func loadData() {
    items.append(Item(name: GroupNames[0].rawValue))
    items.append(Item(name: GroupNames[1].rawValue))
    items.append(Item(name: GroupNames[2].rawValue))
    items.append(Item(name: GroupNames[3].rawValue))
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let selection = mediaItem.name

    if selection == GroupNames[0].rawValue || selection == GroupNames[1].rawValue ||
         selection == GroupNames[2].rawValue {
      performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
    else if selection == GroupNames[3].rawValue {
      performSegue(withIdentifier: AudioItemsController.SegueIdentifier, sender: view)
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case MediaItemsController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? MediaItemsController,
           let view = sender as? MediaNameTableCell {

          let adapter = MuzArbuzServiceAdapter(mobile: true)

          adapter.pageLoader.enablePagination()
          adapter.pageLoader.pageSize = 20
          adapter.pageLoader.rowSize = 1

          let mediaItem = getItem(for: view)

          let selection = mediaItem.name

          if selection == "Album" {
            adapter.params["requestType"] = "Search Albums"
          } else if selection == "Collection" {
            adapter.params["requestType"] = "Search Collection"
          } else if selection == "Artist Annotated" {
            adapter.params["requestType"] = "Search Artist Annotated"
          }

          adapter.params["query"] = query!
          adapter.params["parentName"] = localizer.localize(mediaItem.name!)
          adapter.params["selectedItem"] = getItem(for: view)

          destination.adapter = adapter
        }

      case AudioItemsController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? AudioItemsController,
           let view = sender as? MediaNameTableCell {

            adapter.pageLoader.enablePagination()
            adapter.pageLoader.pageSize = 2000
            adapter.pageLoader.rowSize = 1

          let mediaItem = getItem(for: view)

          destination.pageLoader.load = {
            var items: [AudioItem] = []

            self.adapter.params["requestType"] = "Search Audio Track"
            self.adapter.params["selectedItem"] = mediaItem
            self.adapter.params["convert"] = false

            let mediaItems = try self.adapter.load()

            for mediaItem in mediaItems {
              if let item = mediaItem as? [String: String] {
                let name = item["name"] ?? ""
                let id = item["id"] ?? ""

                items.append(AudioItem(name: name, id: id))
              }
            }

            return items
          }
        }

        default: break
      }
    }
  }
}
