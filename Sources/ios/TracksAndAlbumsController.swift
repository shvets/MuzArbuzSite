import UIKit
import SwiftyJSON
import SwiftSoup
import WebAPI
import TVSetKit

class TracksAndAlbumsController: MuzArbuzBaseCollectionViewController {
  static let SegueIdentifier = "Tracks And Albums"

  override open var CellIdentifier: String { return "TrackAndAlbumCell" }
  override open var BundleId: String { return MuzArbuzServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    title = localizer.localize("Tracks And Albums")

    loadData()
  }

  func loadData() {
    items.append(Item(name: "All"))
    items.append(Item(name: "By Letter"))
    items.append(Item(name: "By Latin Letter"))
  }

  override open func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }

  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as? MediaItemCell {
      if adapter != nil && adapter.pageLoader.nextPageAvailable(dataCount: items.count, index: indexPath.row) {
        loadMoreData()
      }

      let item = items[indexPath.row]

      cell.configureCell(item: item, localizedName: getLocalizedName(item.name))

      CellHelper.shared.addTapGestureRecognizer(view: cell, target: self, action: #selector(self.tapped(_:)))

      return cell
    }
    else {
      return UICollectionViewCell()
    }
  }


//  override open func navigate(from view: UITableViewCell) {
//    let mediaItem = getItem(for: view)
//
//    let selection = mediaItem.name
//
//    if selection == "All" {
//      performSegue(withIdentifier: ArtistItemsController.SegueIdentifier, sender: view)
//    }
//    else {
//      performSegue(withIdentifier: ArtistsLetterTableViewController.SegueIdentifier, sender: view)
//    }
//  }
//
//  // MARK: - Navigation
//
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let identifier = segue.identifier {
//      switch identifier {
//      case ArtistsLetterTableViewController.SegueIdentifier:
//        if let destination = segue.destination as? ArtistsLetterTableViewController,
//           let view = sender as? MediaNameTableCell {
//
//          let mediaItem = getItem(for: view)
//
//          let adapter = MuzArbuzServiceAdapter(mobile: true)
//          destination.params["requestType"] = "Artists Letter"
//          destination.params["parentId"] = mediaItem.name
//          destination.adapter = adapter
//        }
//
//      case ArtistItemsController.SegueIdentifier:
//        if let destination = segue.destination.getActionController() as? ArtistItemsController,
//           let view = sender as? MediaNameTableCell {
//
//          let adapter = MuzArbuzServiceAdapter(mobile: true)
//
//          adapter.pageLoader.enablePagination()
//          adapter.pageLoader.pageSize = 20
//          adapter.pageLoader.rowSize = 1
//
//          let mediaItem = getItem(for: view)
//
//          destination.params["requestType"] =  "All Artists"
//          destination.params["parentName"] = localizer.localize(mediaItem.name!)
//          adapter.params["selectedItem"] = getItem(for: view)
//
//          destination.adapter = adapter
//        }
//
//      default: break
//      }
//    }
//  }
}
