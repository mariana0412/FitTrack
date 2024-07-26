import UIKit

class PopupTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PopupTransitioningPresentationController(presentedViewController: presented,
                                                        presenting: presenting)
    }
}
