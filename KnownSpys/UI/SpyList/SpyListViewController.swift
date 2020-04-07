import UIKit
import Toaster
import Foundation


class SpyListViewController: UIViewController, UITableViewDataSource ,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    fileprivate var presenter: SpyListPresenter!
    fileprivate var detailViewControllerMaker: DependencyRegistry.DetailViewControllerMaker!
    fileprivate var spyCellMaker: DependencyRegistry.SpyCellMaker!
    
    func configure(with presenter: SpyListPresenter,
                   detailViewControllerMaker: @escaping DependencyRegistry.DetailViewControllerMaker,
                   spyCellMaker: @escaping DependencyRegistry.SpyCellMaker) {
        self.presenter = presenter
        self.detailViewControllerMaker = detailViewControllerMaker
        self.spyCellMaker = spyCellMaker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        SpyCell.register(with: tableView)
        presenter.loadData { [weak self] source in
            self?.newDataReceived(from: source)
        }
    }
    
    func newDataReceived(from source: Source) {
        Toast(text: "New Data from \(source)").show()
        tableView.reloadData()
    }
}


//MARK: - UITableViewDataSource
extension SpyListViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let spy = presenter.data[indexPath.row]
        let cell = spyCellMaker(tableView, indexPath, spy)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SpyListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spy = presenter.data[indexPath.row]
        
        let detailViewController = detailViewControllerMaker(spy)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
