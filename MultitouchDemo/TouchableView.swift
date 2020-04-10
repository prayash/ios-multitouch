import Foundation
import UIKit

class TouchableView: UIView {
    var viewMap = [UITouch: TouchSpotView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isMultipleTouchEnabled = true
        backgroundColor = .systemBlue
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            createViewForTouch(touch)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if let view = viewForTouch(touch) {
                let newLocation = touch.location(in: self)
                view.center = newLocation
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            removeViewForTouch(touch)
        }
    }

    private func createViewForTouch(_ t: UITouch) {
        let view = TouchSpotView()
        view.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
        view.center = t.location(in: self)

        addSubview(view)
        UIView.animate(withDuration: 0.2) {
            view.bounds.size = CGSize(width: 100, height: 100)
        }

        viewMap[t] = view
    }

    private func viewForTouch(_ t: UITouch) -> TouchSpotView? {
        return viewMap[t]
    }

    private func removeViewForTouch(_ t: UITouch) {
        if let view = viewMap[t] {
            view.removeFromSuperview()
            viewMap.removeValue(forKey: t)
        }
    }
}


class TouchSpotView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemYellow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var bounds: CGRect {
        get { return super.bounds }
        set(newBounds) {
            super.bounds = newBounds
            layer.cornerRadius = newBounds.size.width / 2.0
        }
    }
}
