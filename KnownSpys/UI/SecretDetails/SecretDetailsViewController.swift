import UIKit

protocol SecretDetailsDelegate: class {
    func passwordCrackingFinished()
}

class SecretDetailsViewController: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var passwordLabel: UILabel!
    fileprivate var presenter: SecretDetailsPresenter
    
    weak var delegate: SecretDetailsDelegate?
    
    init(with presenter: SecretDetailsPresenter, and delegate: SecretDetailsDelegate?) {
        self.presenter = presenter
        self.delegate = delegate
        
        super.init(nibName: "SecretDetailsViewController", bundle: nil)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showPassword()
        }
    }
    
    func showPassword() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        passwordLabel.text = presenter.password
    }
    
    @IBAction func finishedButtonTapped(_ button: UIButton) {
        navigationController?.popViewController(animated: true)
        
        delegate?.passwordCrackingFinished()
    }
}
