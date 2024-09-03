import UIKit

class PopupTransitioningPresentationController: UIPresentationController {
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.alpha = 0.0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        if let containerView = containerView {
            containerView.insertSubview(dimmingView, at: 0)
            
            NSLayoutConstraint.activate([
                dimmingView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                dimmingView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor),
                dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }
        
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1.0
            })
        } else {
            dimmingView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
