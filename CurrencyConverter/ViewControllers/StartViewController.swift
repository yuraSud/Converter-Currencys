import UIKit


class StartViewController: UIViewController {
    
    var currencysArray = [Currency]()
    
    private let backgroundImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let lastUpdatedLabel = UILabel()
    private let nationalBankExchangeRateButton = UIButton(type: .system)
    private let currencyView = CurrencyView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        addTargetButtons()
    }
    
    
//MARK: - @objc functions:
    
    @objc func addCurrency(){
        let listCurrencyVC = CurrencyListViewController()
        let navContrroler = UINavigationController(rootViewController: listCurrencyVC)
        listCurrencyVC.completionChooseCurrency = { item in
            self.currencysArray.append(item)
        }
        navigationController?.present(navContrroler, animated: true)
    }
    
//MARK: - Functions:
    private func configureView(){
        configBackgroundImageView()
        configAppNameLabel()
        configLastUpdatedLabel()
        configNationalBankExchangeRateButton()
        configCurrencyView()
        setUpView()
        setConstraints()
    }
    
    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(nationalBankExchangeRateButton)
        view.addSubview(currencyView)
    }
    
    func addTargetButtons(){
        currencyView.addCurrencyButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
    }
    
    private func configBackgroundImageView() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.image = UIImage(named:  "image_background")
    }
    
    private func configAppNameLabel() {
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.text = "Currency Converter"
        appNameLabel.textColor = .white
        appNameLabel.textAlignment = .left
        appNameLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    private func configLastUpdatedLabel() {
        lastUpdatedLabel.translatesAutoresizingMaskIntoConstraints = false
        lastUpdatedLabel.text = "Last Updated\n26.04.2023 12:43"
        lastUpdatedLabel.textColor = .systemGray
        lastUpdatedLabel.numberOfLines = 2
        lastUpdatedLabel.textAlignment = .left
        lastUpdatedLabel.font = UIFont(name: "Regular", size: 12)
    }
    
    private func configNationalBankExchangeRateButton() {
        nationalBankExchangeRateButton.translatesAutoresizingMaskIntoConstraints = false
        nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        nationalBankExchangeRateButton.setTitleColor(UIColor.systemBlue, for: .normal)
        nationalBankExchangeRateButton.layer.borderWidth = 1
        nationalBankExchangeRateButton.layer.cornerRadius = 15
        nationalBankExchangeRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        nationalBankExchangeRateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
//        nationalBankExchangeRateButton.addTarget(self, action: #selector(), for: .touchUpInside)
        
    }
    
    private func configCurrencyView() {
        currencyView.translatesAutoresizingMaskIntoConstraints = false
    }
    
//MARK: - Constraints
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/4),
            
            appNameLabel.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor, constant: -20),
            appNameLabel.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 16),
            
            lastUpdatedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            lastUpdatedLabel.bottomAnchor.constraint(equalTo: nationalBankExchangeRateButton.topAnchor, constant: -40),
            
            nationalBankExchangeRateButton.heightAnchor.constraint(equalToConstant: 40),
            nationalBankExchangeRateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nationalBankExchangeRateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nationalBankExchangeRateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            
            currencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            currencyView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 20),
            currencyView.bottomAnchor.constraint(equalTo: lastUpdatedLabel.topAnchor, constant: -15)
        ])
    }
    
    
    
    
   
     


}

