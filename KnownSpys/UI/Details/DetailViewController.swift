import UIKit

class DetailViewController: UIViewController, SecretDetailsDelegate {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    var spy: Spy!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func configure(with spy: Spy) {
        self.spy = spy
    }
    
    func setupView() {
        profileImage.image = UIImage(named: spy.imageName)
        nameLabel.text = spy.name
        ageLabel.text  = String(spy.age)
        genderLabel.text = spy.gender
    }
}

//MARK: - Touch Events
extension DetailViewController {
    @IBAction func briefcaseTapped(_ button: UIButton) {
        let vc = SecretDetailsViewController(with: spy, and: self as SecretDetailsDelegate)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - SecretDetailsDelegate
extension DetailViewController {
    func passwordCrackingFinished() {
        //close middle layer too
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Helper Methods
extension DetailViewController {
    static func fromStoryboard(with spy: Spy) -> DetailViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.configure(with: spy)
        
        return vc
    }
}

