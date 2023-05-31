import UIKit

extension UIView {
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //UIGraphicsEndImageContext()
        
        if let imageScreen = image {
            return imageScreen
        }
        return UIImage()
    }
}
