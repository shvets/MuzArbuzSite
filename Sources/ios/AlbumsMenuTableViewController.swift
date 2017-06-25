import UIKit
import TVSetKit

class AlbumsMenuTableViewController: MuzArbuzBaseTableViewController {
  static let SegueIdentifier = "Albums Menu"

  override open var CellIdentifier: String { return "AlbumMenuTableCell" }
  override open var BundleId: String { return MuzArbuzServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("Albums Menu")

    tableView?.backgroundView = activityIndicatorView

    items.append(MediaItem(name: "All Albums"))
//    items.append(MediaItem(name: "Favorite Albums"))
//    items.append(MediaItem(name: "Favorite Double Albums"))
    items.append(MediaItem(name: "Albums Search"))
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    switch mediaItem.name! {
    case "All Albums":
      performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)

    default:
      break
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let identifier = segue.identifier {
      switch identifier {
      case MediaItemsController.SegueIdentifier:
        if let destination = segue.destination.getActionController() as? MediaItemsController,
           let view = sender as? MediaItemTableCell {

          let adapter = MuzArbuzServiceAdapter(mobile: true)

          adapter.params["requestType"] = "Albums"
          adapter.params["selectedItem"] = getItem(for: view)

          destination.adapter = adapter
        }

      default: break
      }
    }
  }

}
