import UIKit
import CoreData

class StartViewController: UIViewController {
    
    private var currencysFromInternet: [Currency]?
    private var arrayCurrencysFromCoreData = [String]()
    private let currencyView = CurrencyView()
    private var datepicker: DatePickerView!
    private let backgroundImageView = UIImageView()
    private let appNameLabel = UILabel()
    private let lastUpdatedLabel = UILabel()
    private let nationalBankExchangeRateButton = UIButton(type: .system)
    private let coreData = CoreDataManager.instance
    private var valueTF: Double = 1
    
    private var currencysArray = [Currency]() {
        didSet{
            DispatchQueue.main.async {
                self.currencyView.addCurrencyButton.isHidden = self.currencysArray.count == 5 ? true : false
            }
            reloadTable()
        }
    }
    private var saleCourse = true {
        didSet{
            reloadTable()
        }
    }
    private var nbuCourse = false {
        didSet{
            reloadTable()
        }
    }
    private var dateFetchToLabel: Date! {
        didSet{
            updateDateLabel(dateUpdate: dateFetchToLabel)
        }
    }
    
    
//MARK: - Life cycle App:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
        addTargetButtons()
        fetchDataSourceForTableFromCoreData(Date())
    }
    
    
    //MARK: - @objc functions:
    
    @objc private func addCurrency(){
        let listCurrencyVC = CurrencyListViewController()
        let navContrroler = UINavigationController(rootViewController: listCurrencyVC)
        listCurrencyVC.completionChooseCurrency = { item in
            if self.currencysArray.count < 5 {
                self.currencysArray.append(item)
                self.coreData.newCurrencyCore(item)
            }
        }
        listCurrencyVC.currencys = currencysFromInternet
        navigationController?.present(navContrroler, animated: true)
    }
    
    @objc private func segmentAction(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
           saleCourse = true
        } else if sender.selectedSegmentIndex == 1 {
            saleCourse = false
        }
    }
    
    @objc private func currencyNbuFromDate(){
        if !nbuCourse {
            datepicker = DatePickerView(frame: self.view.frame)
            datepicker.cancelButton.addTarget(self, action: #selector(closeDatePicker), for: .touchUpInside)
            datepicker.okButton.addTarget(self, action: #selector(pushDateFromPicker), for: .touchUpInside)
            view.addSubview(datepicker)
        } else {
            nbuCourse = false
            nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        }
    }
    
    @objc private func pushDateFromPicker(){
        print(datepicker.datePicker.date.formateDateToJsonRequest(), "берем новую дату")
        nationalBankExchangeRateButton.setTitle("Return to course PB", for: .normal)
        nbuCourse = true
        fetchDataSourceForTableFromCoreData(datepicker.datePicker.date)
        closeDatePicker()
    }
    
    @objc private func closeDatePicker(){
        datepicker.removeFromSuperview()
    }
    
    @objc private func choiseShared(){
        let alert = UIAlertController(title: "Choose what you want to share", message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share ", style: .destructive){_ in
            self.shareScreenShotAndText()
        }
        let textAction = UIAlertAction(title: "Share text", style: .default){_ in
            self.shareText()
        }
        let imageAction = UIAlertAction(title: "Share image", style: .default){_ in
            self.shareScreenShotImage()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
       
        alert.addAction(shareAction)
        alert.addAction(textAction)
        alert.addAction(imageAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
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
        setDelegateTable()
    }
    
    private func setUpView() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(appNameLabel)
        view.addSubview(lastUpdatedLabel)
        view.addSubview(nationalBankExchangeRateButton)
        view.addSubview(currencyView)
    }
    
    func setDelegateTable(){
        currencyView.currencyTable.dataSource = self
        currencyView.currencyTable.delegate = self
    }
    
    func addTargetButtons(){
        currencyView.addCurrencyButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
        currencyView.exchangeRateSegmentedControl.addTarget(self, action: #selector(segmentAction), for: .valueChanged)
        nationalBankExchangeRateButton.addTarget(self, action: #selector(currencyNbuFromDate), for: .touchUpInside)
        currencyView.shareButton.addTarget(self, action: #selector(choiseShared), for: .touchUpInside)
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.currencyView.currencyTable.reloadData()
        }
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
        lastUpdatedLabel.font = .systemFont(ofSize: 14)
    }
    private func updateDateLabel(dateUpdate: Date){
        DispatchQueue.main.async {
            self.lastUpdatedLabel.text = "Last Updated\n\(dateUpdate.formateDateToUpdateLabel())"
        }
    }
    
    private func configNationalBankExchangeRateButton() {
        nationalBankExchangeRateButton.translatesAutoresizingMaskIntoConstraints = false
        nationalBankExchangeRateButton.setTitle("National Bank Exchange Rate", for: .normal)
        nationalBankExchangeRateButton.setTitleColor(UIColor.systemBlue, for: .normal)
        nationalBankExchangeRateButton.layer.borderWidth = 1
        nationalBankExchangeRateButton.layer.cornerRadius = 15
        nationalBankExchangeRateButton.layer.borderColor = UIColor.systemBlue.cgColor
        nationalBankExchangeRateButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
    }
    
    private func configCurrencyView() {
        currencyView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func fetchDataSourceForTableFromInternet(_ date: Date) {
        FetchWeatherManager().fetchCurrency(for: date) { data, error  in
            self.coreData.newjsonCurrencys(jsonCurrencyData: data, date: date)
            self.transformDataToCurrencyModel(data)
            self.addStoreCurrencystoArrayTable(self.arrayCurrencysFromCoreData)
            self.dateFetchToLabel = date
        }
    }
    
    private func fetchDataSourceForTableFromCoreData(_ dateToFetch: Date) {
        //Проверка на то что в хранилище есть данные
       
        let jsonCurrencys = coreData.getJsonCurrencysForDate(date: dateToFetch)
        arrayCurrencysFromCoreData = coreData.getCurrencyFromCore()
        
        print(arrayCurrencysFromCoreData, "Array bykv")
       
        guard let jsonData = jsonCurrencys?.jsonData else {
            print("дата не получил с коре")
        //Если отсутствуют то берем данные с интернета
            fetchDataSourceForTableFromInternet(dateToFetch)
            return}
        
        // Берем данные с кореДата и трансформируем их
        dateFetchToLabel = jsonCurrencys?.dateFetch
        transformDataToCurrencyModel(jsonData)
        addStoreCurrencystoArrayTable(arrayCurrencysFromCoreData)
    }
    
    private func transformDataToCurrencyModel(_ jsonData: Data?) {
        FetchWeatherManager().parseCurrency(jsonData) { model in
            self.currencysFromInternet = model?.currencys
            print(model?.currencys[8].purchaseRate ?? "jjj", "euro")
        }
    }
    
    private func addStoreCurrencystoArrayTable(_ arrayCurrencysFromCoreData:[String]){
        
        guard let fullArrayCurrency = currencysFromInternet else {return}
        currencysArray.removeAll()
        
        arrayCurrencysFromCoreData.forEach{ item in
            for currency in fullArrayCurrency {
                if currency.currency == item {
                    currencysArray.append(currency)
                }
            }
        }
    }
    
     private func shareScreenShotAndText(){
        //1: Вам нужно определить контекст. например:
        UIGraphicsBeginImageContextWithOptions(currencyView.frame.size, true, 1.0 )
        //2: Нарисуйте изображение в контекст:
        currencyView.drawHierarchy(in: CGRect(x: 0, y: 0, width: currencyView.bounds.width, height: self.currencyView.bounds.height), afterScreenUpdates: false)
        //3: Использовать только что нарисованное изображение
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {return}
        UIGraphicsEndImageContext()
        
        //альтернативное получение скрина через расширение UIView
//         let newImage = currencyView.takeScreenShot()
         
        // text to share
        let text = createTextToShare(currencysArray)
        
        // set up activity view controller
        let obectsToShare = [ text, newImage ] as [Any]
        let activityViewController = UIActivityViewController(activityItems: obectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func shareText(){
        let text = createTextToShare(currencysArray)
        let obectsToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: obectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareScreenShotImage(){
        //Create the UIImage
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        view.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        
        let obectsToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: obectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func createTextToShare(_ array:[Currency]) -> String {
        var resultString = ""
        for item in array {
            if item.currency != "UAH" {
                let str = "1 \(item.currency) = \(String(format: "%.3f", item.saleRateNB ?? 0)) UAH\n"
                resultString.append(str)
            }
        }
        resultString.append(lastUpdatedLabel.text ?? "")
        return resultString
    }
}
    
//MARK: - UITableViewDelegate

extension StartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //guard indexPath.row == 0 else {return}
        let cell = tableView.cellForRow(at: indexPath) as! MainCell
        guard cell.currency?.currency == "UAH" else {return}
        cell.currencyTextField.becomeFirstResponder()
        cell.currencyTextField.delegate = self
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        guard let cellCurrency = (tableView.cellForRow(at: indexPath) as! MainCell).currency else {return}
        
        if editingStyle == .delete && indexPath.row != 0 {
            print("delete row")
            currencysArray.remove(at: indexPath.row)
            coreData.deleteCurrencyCore(currencyToDelete: cellCurrency)
        }
    }
}

//MARK: - UITableViewDataSource

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableView.mainCellID, for: indexPath) as? MainCell else { return UITableViewCell() }
        
        let currenc = currencysArray[indexPath.row]
        cell.currency = currenc
        cell.setLabel(currency: currenc, sell: saleCourse,nbu: nbuCourse, valueFromTF: valueTF)
        return cell
    }
}

//MARK: - TextFieldDelegate
extension StartViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let value = textField.text,
              let valueTFDouble = Double(value)
        else {return true}
        valueTF = valueTFDouble
        reloadTable()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

//MARK: - Constraints
extension StartViewController {
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

