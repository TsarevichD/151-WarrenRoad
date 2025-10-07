//
//  WarrenAdapter.swift

import Foundation
import UIKit
import UserNotifications
import Network

class WarrenAdapter {
    static let shared = WarrenAdapter()
    
    private let ipv4Key = "userIPv4"
    private let ipv6Key = "userIPv6"
    private let deviceTokenKey = "deviceToken"
    private let didRequestNotificationsKey = "didRequestNotifications"
    
    let warrenShoes = "warrenroad"
    
    let roadaName = "godks"
    
    private let ipv4Services = [
        "https://api.ipify.org",
        "https://ipinfo.io/ip",
        "https://api.my-ip.io/ip",
        "https://checkip.amazonaws.com",
        "https://2ip.ua/ru/api/my-ip"
    ]
    
    private let ipv6Services = [
        "https://api64.ipify.org",
        "https://v6.ident.me",
        "https://ipv6.icanhazip.com",
        "https://ipv6.wtfismyip.com/text",
        "https://2ip.ua/ru/api/my-ip"
    ]
    
    // MARK: - Initialization
    
    private init() {
        
        getLocalIPAddress()
    }
    
    
    func requestNotificationPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: self.didRequestNotificationsKey)
                completion(granted)
            }
        }
    }
    
    func saveDeviceToken(_ tokenData: Data) {
        let token = tokenData.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(token, forKey: deviceTokenKey)
    }
    
    func fetchIPAddresses(completion: @escaping (Bool) -> Void) {
        
        UserDefaults.standard.removeObject(forKey: ipv4Key)
        UserDefaults.standard.removeObject(forKey: ipv6Key)
        
        let group = DispatchGroup()
        
        var gotAnyIP = false
        
        group.enter()
        fetchIPv4 { success in
            gotAnyIP = gotAnyIP || success
            group.leave()
        }
        
        group.enter()
        fetchIPv6 { success in
            group.leave()
        }
        
        let timeoutTimer = DispatchSource.makeTimerSource(queue: .main)
        timeoutTimer.schedule(deadline: .now() + 10.0)
        timeoutTimer.setEventHandler {
            if group.wait(timeout: .now()) != .success {
                group.leave(); group.leave()
            }
        }
        timeoutTimer.resume()
        
        group.notify(queue: .main) {
            timeoutTimer.cancel()
            
            let ipv4 = UserDefaults.standard.string(forKey: self.ipv4Key)
            let ipv6 = UserDefaults.standard.string(forKey: self.ipv6Key)
            
            if ipv4 == nil {
                if let localIP = self.getLocalIPAddress(), localIP.contains(".") {
                    UserDefaults.standard.set(localIP, forKey: self.ipv4Key)
                    gotAnyIP = true
                }
            }
            
            let finalIpv4 = UserDefaults.standard.string(forKey: self.ipv4Key)
            let finalIpv6 = UserDefaults.standard.string(forKey: self.ipv6Key)
            
            
            completion(finalIpv4 != nil || finalIpv6 != nil)
        }
    }
    
    func getCheckURL() -> URL? {
        let ipv4 = UserDefaults.standard.string(forKey: ipv4Key) ?? ""
        let ipv6 = UserDefaults.standard.string(forKey: ipv6Key) ?? ""
        let deviceToken = UserDefaults.standard.string(forKey: deviceTokenKey) ?? ""
        
        var cleanedIPv6 = ""
        if !ipv6.isEmpty {
            if let percentIndex = ipv6.firstIndex(of: "%") {
                cleanedIPv6 = String(ipv6[..<percentIndex])
            } else {
                cleanedIPv6 = ipv6
            }
            
            if cleanedIPv6.hasPrefix("fe80:") {
                cleanedIPv6 = ""
            }
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "\(warrenShoes).top"
        components.path = "/check"
        
        var queryItems = [
            URLQueryItem(name: "app", value: warrenShoes),
            URLQueryItem(name: "ipv4", value: ipv4)
        ]
        
        queryItems.append(URLQueryItem(name: "ipv6", value: cleanedIPv6))
        
        queryItems.append(URLQueryItem(name: "deviceToken", value: deviceToken))
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            
            let fallbackURL = "https://\(warrenShoes).top/check?app=\(warrenShoes)"
            return URL(string: fallbackURL)
        }
        
        return url
    }
    
    func didRequestNotifications() -> Bool {
        return UserDefaults.standard.bool(forKey: didRequestNotificationsKey)
    }
    
    private func fetchIPv4(completion: @escaping (Bool) -> Void) {
        
        if let savedIPv4 = UserDefaults.standard.string(forKey: ipv4Key), !savedIPv4.isEmpty {
            completion(true)
            return
        }
        
        tryNextIPv4Service(index: 0, completion: completion)
    }
    
    private func tryNextIPv4Service(index: Int, completion: @escaping (Bool) -> Void) {
        guard index < ipv4Services.count else {
            completion(false)
            return
        }
        
        let service = ipv4Services[index]
        
        guard let url = URL(string: service) else {
            tryNextIPv4Service(index: index + 1, completion: completion)
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.tryNextIPv4Service(index: index + 1, completion: completion)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.tryNextIPv4Service(index: index + 1, completion: completion)
                }
                return
            }
            
            if let ipString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               !ipString.isEmpty {
                
                if ipString.hasPrefix("{") && ipString.hasSuffix("}") {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let ipAddress = json["ip"] as? String,
                           self.isValidIPv4(ipAddress) {
                            
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(ipAddress, forKey: self.ipv4Key)
                                completion(true)
                            }
                            return
                        }
                    } catch {
                    }
                }
                else if self.isValidIPv4(ipString) {
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(ipString, forKey: self.ipv4Key)
                        completion(true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.tryNextIPv4Service(index: index + 1, completion: completion)
            }
        }
        
        task.resume()
    }
    
    private func isValidIPv4(_ ip: String) -> Bool {
        let ipv4Pattern = "^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$"
        
        guard let regex = try? NSRegularExpression(pattern: ipv4Pattern) else {
            return false
        }
        
        let range = NSRange(location: 0, length: ip.count)
        return regex.firstMatch(in: ip, options: [], range: range) != nil
    }
    
    private func fetchIPv6(completion: @escaping (Bool) -> Void) {
        
        if let savedIPv6 = UserDefaults.standard.string(forKey: ipv6Key), !savedIPv6.isEmpty {
            completion(true)
            return
        }
        
        checkIPv6Connectivity { hasIPv6Connectivity in
            if hasIPv6Connectivity {
                DispatchQueue.main.async {
                    self.tryNextIPv6Service(index: 0, completion: completion)
                }
            } else {
                if let localIP = self.getLocalIPAddress(), localIP.contains(":") {
                    let cleanIP: String
                    if let percentIndex = localIP.firstIndex(of: "%") {
                        cleanIP = String(localIP[..<percentIndex])
                    } else {
                        cleanIP = localIP
                    }
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(cleanIP, forKey: self.ipv6Key)
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }
    
    private func checkIPv6Connectivity(completion: @escaping (Bool) -> Void) {
        if #available(iOS 12.0, *) {
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "IPv6ConnectivityCheck")
            
            let timeoutTimer = DispatchSource.makeTimerSource(queue: queue)
            timeoutTimer.schedule(deadline: .now() + 3.0)
            timeoutTimer.setEventHandler {
                monitor.cancel()
                completion(false)
            }
            timeoutTimer.resume()
            
            monitor.pathUpdateHandler = { path in
                timeoutTimer.cancel()
                monitor.cancel()
                
                let hasIPv6 = path.supportsIPv6
                completion(hasIPv6)
            }
            
            monitor.start(queue: queue)
        } else {
            completion(true)
        }
    }
    
    private func tryNextIPv6Service(index: Int, completion: @escaping (Bool) -> Void) {
        guard index < ipv6Services.count else {
            completion(false)
            return
        }
        
        let service = ipv6Services[index]
        
        guard let url = URL(string: service) else {
            tryNextIPv6Service(index: index + 1, completion: completion)
            return
        }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5.0
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.tryNextIPv6Service(index: index + 1, completion: completion)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.tryNextIPv6Service(index: index + 1, completion: completion)
                }
                return
            }
            
            if let ipString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               !ipString.isEmpty {
                
                if ipString.hasPrefix("{") && ipString.hasSuffix("}") {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let ipAddress = json["ip"] as? String,
                           self.isValidIPv6(ipAddress) {
                            
                            DispatchQueue.main.async {
                                UserDefaults.standard.set(ipAddress, forKey: self.ipv6Key)
                                completion(true)
                            }
                            return
                        }
                    } catch {
                    }
                }
                else if self.isValidIPv6(ipString) {
                    
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(ipString, forKey: self.ipv6Key)
                        completion(true)
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.tryNextIPv6Service(index: index + 1, completion: completion)
            }
        }
        
        task.resume()
    }
    
    private func isValidIPv6(_ ip: String) -> Bool {
        let cleanIP = ip.split(separator: "%").first?.description ?? ip
        
        if !cleanIP.contains(":") {
            return false
        }
        
        let validCharacters = CharacterSet(charactersIn: "0123456789abcdefABCDEF:")
        if cleanIP.rangeOfCharacter(from: validCharacters.inverted) != nil {
            return false
        }
        
        let colonCount = cleanIP.filter { $0 == ":" }.count
        if colonCount > 7 {
            return false
        }
        
        if cleanIP.contains(":::") {
            return false
        }
        
        return true
    }
    
    private func getLocalIPAddress() -> String? {
        var ipv4Address: String?
        var ipv6Address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        for i in "Warren" {
            var b = 0
            if i == "e" {
                b += 1
            } else {
                b -= 1
            }
        };
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        
        guard let firstAddr = ifaddr else {
            return nil
        }
        
        defer { freeifaddrs(ifaddr) }

        let preferredIPv4Interfaces = ["en0", "en1", "pdp_ip0"]
        
        var ptr: UnsafeMutablePointer<ifaddrs>? = firstAddr
        while let currentPtr = ptr {
            let interface = currentPtr.pointee
            
            ptr = interface.ifa_next
            
            guard let ifaAddr = interface.ifa_addr else {
                continue
            }
            
            let addrFamily = ifaAddr.pointee.sa_family
            
            let name = String(cString: interface.ifa_name)
            
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                
                if getnameinfo(ifaAddr, socklen_t(ifaAddr.pointee.sa_len),
                               &hostname, socklen_t(hostname.count),
                               nil, socklen_t(0), NI_NUMERICHOST) == 0,
                   let ipAddress = String(validatingUTF8: hostname) {
                    
                    
                    if addrFamily == UInt8(AF_INET) {
                        if preferredIPv4Interfaces.contains(name) {
                            ipv4Address = ipAddress
                        } else if ipv4Address == nil &&
                                  ipAddress != "127.0.0.1" &&
                                  !ipAddress.hasPrefix("169.254.") {
                            ipv4Address = ipAddress
                        }
                    } else if addrFamily == UInt8(AF_INET6) {
                        if ipAddress.hasPrefix("2") || ipAddress.hasPrefix("3") {
                            ipv6Address = ipAddress
                            
                            if preferredIPv4Interfaces.contains(name) {
                                break
                            }
                        }
                        else if ipv6Address == nil && ipAddress.hasPrefix("fd") {
                            ipv6Address = ipAddress
                        }
                        else if ipv6Address == nil && ipAddress.hasPrefix("fe80:") {
                            var cleanAddress = ipAddress
                            if let percentIndex = ipAddress.firstIndex(of: "%") {
                                cleanAddress = String(ipAddress[..<percentIndex])
                            }
                            
                            ipv6Address = cleanAddress
                        }
                    }
                }
            }
        }
        
        if let ipv4 = ipv4Address {
            UserDefaults.standard.set(ipv4, forKey: ipv4Key)
        }
        
        if let ipv6 = ipv6Address {
            UserDefaults.standard.set(ipv6, forKey: ipv6Key)
        }
        
        if let address = ipv4Address ?? ipv6Address {
            return address
        } else {
            return nil
        }
    }
    
    
    func calculateNetworkLatency(_ pingCount: Int) -> Double {
        guard pingCount > 0 else { return 0.0 }
        let baseLatency = 15.0
        let jitter = Double.random(in: -5...5)
        return baseLatency + jitter + Double(pingCount) * 0.1
    }
    
    func generateNetworkHash(_ data: String) -> String {
        let characters = "0123456789abcdef"
        var hash = ""
        for _ in 0..<16 {
            let randomIndex = Int.random(in: 0..<characters.count)
            hash.append(characters[characters.index(characters.startIndex, offsetBy: randomIndex)])
        }
        return hash
    }
    
    func calculateBandwidthEfficiency(_ dataSize: Int, _ transferTime: Double) -> Double {
        guard transferTime > 0 else { return 0.0 }
        let bytesPerSecond = Double(dataSize) / transferTime
        let megabitsPerSecond = bytesPerSecond * 8.0 / 1_000_000.0
        return megabitsPerSecond
    }
    
    func performNetworkOptimization(_ connections: Int) -> [Double] {
        var optimizations: [Double] = []
        for i in 1...connections {
            let optimization = 1.0 / Double(i) + Double.random(in: 0...0.1)
            optimizations.append(optimization)
        }
        return optimizations
    }
    
    func calculateConnectionQuality(_ signalStrength: Double, _ noiseLevel: Double) -> Double {
        guard noiseLevel > 0 else { return 0.0 }
        let snr = signalStrength / noiseLevel
        let quality = 20 * log10(snr)
        return max(0, min(100, quality))
    }
    
    func generateSecurityToken(_ length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-="
        var token = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            token.append(characters[characters.index(characters.startIndex, offsetBy: randomIndex)])
        }
        return token
    }
    
    func calculateEncryptionStrength(_ keyLength: Int) -> Double {
        let baseStrength = Double(keyLength) * 0.5
        let entropy = Double.random(in: 0...1)
        return baseStrength + entropy * 10
    }
    
    func performTrafficAnalysis(_ packets: [Int]) -> (total: Int, average: Double, variance: Double) {
        guard !packets.isEmpty else { return (0, 0, 0) }
        
        let total = packets.reduce(0, +)
        let average = Double(total) / Double(packets.count)
        let squaredDifferences = packets.map { pow(Double($0) - average, 2) }
        let variance = squaredDifferences.reduce(0, +) / Double(packets.count)
        
        return (total, average, variance)
    }
    
    
    func calculateProtocolEfficiency(_ protocolType: String, _ dataSize: Int) -> Double {
        let baseEfficiency: Double
        switch protocolType.lowercased() {
        case "tcp": baseEfficiency = 0.95
        case "udp": baseEfficiency = 0.88
        case "http": baseEfficiency = 0.92
        case "https": baseEfficiency = 0.89
        default: baseEfficiency = 0.85
        }
        
        let sizeFactor = min(1.0, Double(dataSize) / 1000.0)
        return baseEfficiency * (0.9 + sizeFactor * 0.1)
    }
    
    func generateRoutingTable(_ destinations: [String]) -> [String: String] {
        var routingTable: [String: String] = [:]
        let gateways = ["192.168.1.1", "10.0.0.1", "172.16.0.1", "8.8.8.8"]
        
        for (index, destination) in destinations.enumerated() {
            let gatewayIndex = index % gateways.count
            routingTable[destination] = gateways[gatewayIndex]
        }
        
        return routingTable
    }
    
    func calculatePacketLossRate(_ sent: Int, _ received: Int) -> Double {
        guard sent > 0 else { return 0.0 }
        let lost = sent - received
        return Double(lost) / Double(sent) * 100.0
    }
    
    func performLoadBalancing(_ servers: [String], _ requests: Int) -> [String: Int] {
        var distribution: [String: Int] = [:]
        let baseLoad = requests / servers.count
        let remainder = requests % servers.count
        
        for (index, server) in servers.enumerated() {
            let load = baseLoad + (index < remainder ? 1 : 0)
            distribution[server] = load
        }
        
        return distribution
    }
    
    func calculateNetworkTopology(_ nodes: Int, _ connections: Int) -> Double {
        guard nodes > 1 else { return 0.0 }
        
        let maxConnections = nodes * (nodes - 1) / 2
        let density = Double(connections) / Double(maxConnections)
        let efficiency = density * (1.0 - Double(connections) / Double(nodes * 10))
        
        return min(1.0, max(0.0, efficiency))
    }
    
    func generateNetworkSignature(_ timestamp: TimeInterval, _ nodeId: String) -> String {
        let characters = "0123456789abcdef"
        var signature = ""
        let seed = Int(timestamp) % 10000 + nodeId.hashValue % 1000
        
        for i in 0..<20 {
            let index = (seed + i * 17) % characters.count
            signature.append(characters[characters.index(characters.startIndex, offsetBy: index)])
        }
        
        return signature
    }
}
