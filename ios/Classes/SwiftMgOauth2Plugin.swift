import Flutter
import UIKit
import WebKit

public class SwiftMgOauth2Plugin: NSObject, FlutterPlugin {
    var myViewController: UIViewController?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "plugin.screen", binaryMessenger: registrar.messenger())
        
        var instance: SwiftMgOauth2Plugin?
        if let uiWindow = UIApplication.shared.delegate?.window, let viewController = uiWindow?.rootViewController {
            instance = SwiftMgOauth2Plugin(viewController)
        } else {
            instance = SwiftMgOauth2Plugin()
        }
        
        registrar.addMethodCallDelegate(instance!, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openLoginScreen":
            let arguments = (call.arguments as? String)?.replacingOccurrences(of: "\\", with: "").data(using: String.Encoding.utf8)
            var authorizeModel: AuthorizeModel?
            do {
                if let arguments = arguments {
                    authorizeModel = try JSONDecoder().decode(AuthorizeModel.self, from: arguments)
                }
            } catch let error {
                print("Parsing error: \(error)")
            }
            let myWebViewVC = MyWebViewVC.init()
            myWebViewVC.flutterResult = result
            myWebViewVC.authorizeModel = authorizeModel
            myWebViewVC.view.frame = myViewController?.view.frame ?? CGRect.zero
            myViewController?.present(myWebViewVC, animated: true, completion: nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    init(_ viewController: UIViewController) {
        super.init()
        
        myViewController = viewController
    }
    
    override init() {
        super.init()
    }
}

protocol MyWebViewDelegate {
    func testDelegate()
}

class MyWebViewVC: UIViewController, WKNavigationDelegate {
    var myWebView: WKWebView?
    var flutterResult: FlutterResult?
    var authorizeModel: AuthorizeModel?
    var closeImage: UIImageView = UIImageView.init(image: UIImage.init(named: "close"))
    
    // Setup the top part safe area value based on the device and if it has a notch or not
    var topSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            if UIDevice.current.hasNotch() {
                return (UIApplication.shared.keyWindow?.safeAreaInsets.top)!
            }
        }
        return 0
    }
    
    // Setup the bottom part safe area value based on the device and if it has a notch or not
    var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            if UIDevice.current.hasNotch() {
                return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
            }
        }
        return 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .red
        
        let configuration = WKWebViewConfiguration.init()
        myWebView = WKWebView.init(frame: view.frame, configuration: configuration)

        if let authorizeModel = authorizeModel {
        let urlRequest = URLRequest.init(url: authorizeModel.constructAuthorizeURL())
            myWebView?.navigationDelegate = self
            myWebView?.load(urlRequest)
            view.addSubview(myWebView!)
        }
        
        closeImage.frame = CGRect(x: view.frame.width - 55, y: topSafeArea + 15, width: 40, height: 40)
        closeImage.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tappedClose)))
        closeImage.isUserInteractionEnabled = true
        view.addSubview(closeImage)
    }
    
    @objc func tappedClose() {
        dismiss(animated: true) {
            self.flutterResult!("Bravo")
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let host = navigationResponse.response.url?.host
        let path = navigationResponse.response.url?.path
        let parameters = navigationResponse.response.url?.queryParamters
        if host == "login.microsoftonline.com" && path == "/common/oauth2/nativeclient" {
            if let resultString = parameters?["code"] {
                dismiss(animated: true) {
                    self.flutterResult!(resultString)
                }
            } else {
                dismiss(animated: true) {
                    self.flutterResult!("")
                }
            }
        }
        decisionHandler(.allow)
    }
}

class AuthorizeModel: Decodable {
    let url: String
    let clientID: String
    let response: String
    let redirectURI: String
    let responseMode: String
    let scope: String
    let state: String
    
    func constructAuthorizeURL() -> URL {
        let escapedRedirectURI = redirectURI.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let escapedScope = scope.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let constructedURL = "\(url)client_id=\(clientID)&response_type=\(response)&redirect_uri=\(escapedRedirectURI)&response_mode=\(responseMode)&scope=\(escapedScope)&state=\(state)"
        if let uri = URL.init(string: constructedURL) {
            return uri
        }
        
        return URL.init(string: "https://www.google.com/")!
    }
}

extension URL {
    var queryParamters: [String: String] {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return [:]
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}

extension UIDevice {
    enum Kind {
        case iPad
        case iPhone_unknown
        case iPhone_5_5S_5C
        case iPhone_6_6S_7_8
        case iPhone_6_6S_7_8_PLUS
        case iPhone_X_Xs
        case iPhone_Xs_Max
        case iPhone_Xr
    }
    
    var kind: Kind {
        if userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                return .iPhone_5_5S_5C
            case 1334:
                return .iPhone_6_6S_7_8
            case 1920, 2208:
                return .iPhone_6_6S_7_8_PLUS
            case 2436:
                return .iPhone_X_Xs
            case 2688:
                return .iPhone_Xs_Max
            case 1792:
                return .iPhone_Xr
            default:
                return .iPhone_unknown
            }
        }
        return .iPad
    }
    
    func hasNotch() -> Bool {
        switch kind {
        case .iPhone_X_Xs, .iPhone_Xs_Max, .iPhone_Xr:
            return true
        default:
            return false
        }
    }
}
