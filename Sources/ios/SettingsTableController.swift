import UIKit
import TVSetKit

class SettingsTableController: MuzArbuzBaseTableViewController {
  static let SegueIdentifier = "Settings"

  override open var CellIdentifier: String { return "SettingTableCell" }
  override open var BundleId: String { return MuzArbuzServiceAdapter.BundleId }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false

    adapter = MuzArbuzServiceAdapter(mobile: true)

    loadSettingsMenu()
  }

  func loadSettingsMenu() {
    let resetHistory = MediaItem(name: "Reset History")
    let resetQueue = MediaItem(name: "Reset Bookmarks")

    items = [
      resetHistory, resetQueue
    ]
  }

  override open func navigate(from view: UITableViewCell) {
    let mediaItem = getItem(for: view)

    let settingsMode = mediaItem.name

    if settingsMode == "Reset History" {
      present(buildResetHistoryController(), animated: false, completion: nil)
    }
    else if settingsMode == "Reset Bookmarks" {
      present(buildResetQueueController(), animated: false, completion: nil)
    }
  }

  func buildResetHistoryController() -> UIAlertController {
    let title = localizer.localize("History Will Be Reset")
    let message = localizer.localize("Please Confirm Your Choice")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      let history = (self.adapter as! MuzArbuzServiceAdapter).history

      history.clear()
      history.save()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(okAction)

    return alertController
  }

  func buildResetQueueController() -> UIAlertController {
    let title = localizer.localize("Bookmarks Will Be Reset")
    let message = localizer.localize("Please Confirm Your Choice")

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      let bookmarks = (self.adapter as! MuzArbuzServiceAdapter).bookmarks

      bookmarks.clear()
      bookmarks.save()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alertController.addAction(cancelAction)
    alertController.addAction(okAction)

    return alertController
  }

}
