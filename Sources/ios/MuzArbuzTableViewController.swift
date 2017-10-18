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
    items.append(MediaName(name: "Bookmarks", imageName: "Star"))
    items.append(MediaName(name: "History", imageName: "Bookmark"))
    items.append(MediaName(name: "Albums", imageName: "Book"))
    items.append(MediaName(name: "Artists", imageName: "Mark Twain"))
    items.append(MediaName(name: "Collections", imageName: "Microphone"))
    items.append(MediaName(name: "Genres", imageName: "Comedy"))
    items.append(MediaName(name: "Settings", imageName: "Engineering"))
    items.append(MediaName(name: "Search", imageName: "Search"))
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
//            destination.params["requestType"] = "Artists Letters"
//            destination.adapter = adapter
//          }

        case GenresTableViewController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? GenresTableViewController {
            let adapter = MuzArbuzServiceAdapter(mobile: true)

            adapter.pageLoader.enablePagination()
            adapter.pageLoader.pageSize = 20
            adapter.pageLoader.rowSize = 1

            destination.params["requestType"] = "Genres"
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
              destination.params["requestType"] =  name
              destination.params["parentName"] = localizer.localize(name)
            }

            destination.params["selectedItem"] = getItem(for: view)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        case SearchTableController.SegueIdentifier:
          if let destination = segue.destination.getActionController() as? SearchTableController {

            let adapter = MuzArbuzServiceAdapter(mobile: true)

            destination.params["requestType"] = "Search"
            destination.params["parentName"] = localizer.localize("Search Results")

            destination.adapter = adapter
          }

        default: break
      }
    }
  }

}
