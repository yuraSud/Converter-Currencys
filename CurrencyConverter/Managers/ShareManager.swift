
import Foundation
import UIKit

extension StartViewController {
    func shareScreenShotAndText(){
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
    
    private func createTextToShare(_ array:[Currency]?) -> String {
        var resultString = ""
        guard let array = array else {return ""}
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
