import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class ArtistsLetterTableViewController: MuzArbuzBaseTableViewController {
  static let SegueIdentifier = "Artists Letter"

  override open var CellIdentifier: String { return "ArtistLetterTableCell" }
  override open var BundleId: String { return MuzArbuzServiceAdapter.BundleId }

  var letter: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    loadInitialData()
  }

  override open func navigate(from view: UITableViewCell) {
    performSegue(withIdentifier: MediaItemsController.SegueIdentifier, sender: view)
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

            destination.params["requestType"] =  "Artists"
            destination.params["parentName"] = localizer.localize(mediaItem.name!)
            destination.params["selectedItem"] = getItem(for: view)

            destination.adapter = adapter
            destination.configuration = adapter.getConfiguration()
          }

        default: break
      }
    }
  }

}
