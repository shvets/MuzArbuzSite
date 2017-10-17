import TVSetKit
import SwiftyJSON
import AudioPlayer

open class ArtistItemsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  open class var SegueIdentifier: String { return "Artist Items" }
  //open class var StoryboardControllerId: String { return "ArtistItemsController" }

  open var CellIdentifier: String { return "ArtistItemCell" }

  var HeaderViewIdentifier: String { return "MediaItemsHeader" }

  let GroupNames = ["album", "collection", "artist_annotated", "audio_track"]

//  public let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//
//  var items = [Any]()
//
//  public var adapter: ServiceAdapter!
//
//  var localizer = Localizer("com.rubikon.MuzArbuzSite", bundleClass: MuzArbuzSite.self)
//  //var localizer = Localizer("com.rubikon.TVSetKit", bundleClass: TVSetKit.self)
//
//  override open func viewDidLoad() {
//    super.viewDidLoad()
//
//    collectionView?.backgroundView = activityIndicatorView
//    adapter.pageLoader.spinner = PlainSpinner(activityIndicatorView)
//  }
//
//  override open func viewWillAppear(_ animated: Bool) {
//    loadInitialData()
//  }
//
//  open func loadInitialData(_ onLoadCompleted: (([Any]) -> Void)?=nil) {
//    return adapter.pageLoader.loadData { result in
//      self.items = result
//
//      if let onLoadCompleted = onLoadCompleted {
//        onLoadCompleted(self.items)
//      }
//
//      self.collectionView?.reloadData()
//    }
//  }
//
//  override open func numberOfSections(in collectionView: UICollectionView) -> Int {
//    return items.count
//  }
//
//  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    if let groupItems = items[section] as? [Any] {
//      return groupItems.count
//    }
//    else {
//      return 0
//    }
//  }
//
//  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as? MediaItemCell {
//      let section = indexPath.section
//
//      if let sectionItems = items[section] as? [Any] {
//        let item = sectionItems[indexPath.row]
//        let mediaItem = MuzArbuzMediaItem(data: JSON(item))
//
//        cell.configureCell(item: mediaItem, localizedName: mediaItem.name!)
//
//        return cell
//      }
//      else {
//        return UICollectionViewCell()
//      }
//    }
//    else {
//      return UICollectionViewCell()
//    }
//  }
//
//  override open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String,
//                                    at indexPath: IndexPath) -> UICollectionReusableView {
//    if kind == "UICollectionElementKindSectionHeader" {
//      if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
//        withReuseIdentifier: HeaderViewIdentifier, for: indexPath as IndexPath) as? MediaItemsHeaderView {
//
//        print(indexPath.section)
//        if indexPath.section >= 0 {
//          let name = GroupNames[indexPath.section]
//
//          headerView.sectionLabel.text = name
//        }
//
//        return headerView
//      }
//    }
//
//    return UICollectionReusableView()
//  }
//
//  override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    if let location = collectionView.cellForItem(at: indexPath) {
//      let section = indexPath.section
//
//      if section == 0 {
//        performSegue(withIdentifier: AudioItemsController.SegueIdentifier, sender: location)
//      }
//    }
//  }
//
//  override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let identifier = segue.identifier,
//       let selectedCell = sender as? MediaItemCell {
//
//      if let indexPath = collectionView?.indexPath(for: selectedCell) {
//        switch identifier {
////          case MediaItemsController.SegueIdentifier:
////            if let destination = segue.destination.getActionController() as? MediaItemsController,
////               let view = sender as? MediaItemCell {
////
////              let adapter = MuzArbuzServiceAdapter(mobile: true)
////
////              adapter.pageLoader.enablePagination()
////              adapter.pageLoader.pageSize = 20
////              adapter.pageLoader.rowSize = 1
////
////              let mediaItem = getItem(for: view)
////
////              if let name = mediaItem.name {
////                destination.params["requestType"] =  name
////                destination.params["parentName"] = localizer.localize(name)
////              }
////
////              adapter.params["selectedItem"] = getItem(for: view)
////
////              destination.adapter = adapter
////            }
//
//          case AudioItemsController.SegueIdentifier:
//            if let destination = segue.destination as? AudioItemsController {
//              let section = indexPath.section
//
//              if let sectionItems = items[section] as? [Any] {
//                let item = sectionItems[indexPath.row]
//                let mediaItem = MuzArbuzMediaItem(data: JSON(item))
//
//                //            let mediaItem = getItem(for: view)
//
//              destination.name = mediaItem.name
//              destination.thumb = mediaItem.thumb
//              destination.id = mediaItem.id
//
//              destination.pageLoader.pageSize = adapter.pageLoader.pageSize
//              destination.pageLoader.rowSize = adapter.pageLoader.rowSize
//
//              if let requestType = adapter.params["requestType"] as? String {
//                if requestType != "History" {
//                  adapter.addHistoryItem(mediaItem)
//                }
//              }
//
//              destination.pageLoader.load = {
//                var items: [AudioItem] = []
//
//                self.destination.params["requestType"] = "Tracks"
//                self.adapter.params["selectedItem"] = mediaItem
//                self.adapter.params["convert"] = false
//
//                let mediaItems = try self.adapter.load()
//
//                for mediaItem in mediaItems {
//                  if let item = mediaItem as? [String: String] {
//                    let name = item["name"] ?? ""
//                    let id = item["id"] ?? ""
//
//                    items.append(AudioItem(name: name, id: id))
//                  }
//                }
//
//                return items
//              }
//            }
//          }
//
//          default:
//            print("aaa")
//            //super.prepare(for: segue, sender: sender)
//        }
//      }
//    }
//  }
//
//  public func getItem(for cell: UICollectionViewCell) -> Item {
//    if let indexPath = collectionView?.indexPath(for: cell) {
//      let section = indexPath.section
//
//      if let sectionItems = items[section] as? [Any] {
//        let item = sectionItems[indexPath.row]
//        let mediaItem = MuzArbuzMediaItem(data: JSON(item))
//
//        return mediaItem
//      }
//      else {
//        return MediaItem(data: JSON.null)
//      }
//    }
//    else {
//      return MediaItem(data: JSON.null)
//    }
//  }
}
