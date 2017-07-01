import UIKit
import SwiftyJSON
import TVSetKit

open class MuzArbuzTableViewController: MuzArbuzBaseTableViewController {
  static let SegueIdentifier = "Muz Arbuz"

  override open var CellIdentifier: String { return "MuzArbuzTableCell" }
  override open var BundleId: String { return MuzArbuzServiceAdapter.BundleId }

  override open func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("MuzArbuz")

    loadData()
  }

  func loadData() {
    items.append(MediaItem(name: "Bookmarks", imageName: "Star"))
    items.append(MediaItem(name: "History", imageName: "Bookmark"))
    items.append(MediaItem(name: "Albums", imageName: "Book"))
    items.append(MediaItem(name: "Artists", imageName: "Mark Twain"))
    items.append(MediaItem(name: "Collections", imageName: "Microphone"))
    items.append(MediaItem(name: "Genres", imageName: "Comedy"))
    items.append(MediaItem(name: "Settings", imageName: "Engineering"))
    items.append(MediaItem(name: "Search", imageName: "Search"))
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
      case "Albums":
        performSegue(withIdentifier: "Media Items", sender: view)

      case "Artists":
        performSegue(withIdentifier: "Artists Menu", sender: view)

      case "Collections":
        performSegue(withIdentifier: "Media Items", sender: view)

      case "Genres":
        performSegue(withIdentifier: "Genres", sender: view)

      case "Settings":
        performSegue(withIdentifier: "Settings", sender: view)

      case "Search":
        performSegue(withIdentifier: SearchTableController.SegueIdentifier, sender: view)

      default:
        performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
    }
  }

  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
//        case ArtistsMenuTableViewController.SegueIdentifier:
//          if let destination = segue.destination.getActionController() as? ArtistsMenuTableViewController {
//            let adapter = MuzArbuzServiceAdapter(mobile: true)
//
//            adapter.params["requestType"] = "Artists Letters"
//            destination.adapter = adapter
//          }

        case GenresTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? GenresTableViewController {
            let adapter = MuzArbuzServiceAdapter(mobile: true)

            adapter.pageLoader.enablePagination()
            adapter.pageLoader.pageSize = 20
            adapter.pageLoader.rowSize = 1

            adapter.params["requestType"] = "Genres"
            destination.adapter = adapter
          }

        case MediaItemsController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? MediaItemsController,
             let view = sender as? MediaNameTableCell {

            let adapter = MuzArbuzServiceAdapter(mobile: true)

            adapter.pageLoader.enablePagination()
            adapter.pageLoader.pageSize = 20
            adapter.pageLoader.rowSize = 1

            let mediaItem = getItem(for: view)

            if let name = mediaItem.name {
              adapter.params["requestType"] =  name
              adapter.params["parentName"] = localizer.localize(name)
            }

            adapter.params["selectedItem"] = getItem(for: view)

            destination.adapter = adapter
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {

            let adapter = MuzArbuzServiceAdapter(mobile: true)

            adapter.params["requestType"] = "Search"
            adapter.params["parentName"] = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
