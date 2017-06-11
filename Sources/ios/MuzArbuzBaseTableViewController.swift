import TVSetKit

open class MuzArbuzBaseTableViewController: BaseTableViewController {
  let service = MuzArbuzService.shared

  override open func viewDidLoad() {
    super.viewDidLoad()

    localizer = Localizer(MuzArbuzServiceAdapter.BundleId, bundleClass: MuzArbuzSite.self)
  }

}
