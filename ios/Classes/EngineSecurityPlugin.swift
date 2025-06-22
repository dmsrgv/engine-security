import Flutter
import UIKit
import CoreLocation
import Foundation

public class EngineSecurityPlugin: NSObject, FlutterPlugin {
    private let locationManager = CLLocationManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "engine_security/gps_fake", binaryMessenger: registrar.messenger())
        let instance = EngineSecurityPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkMockLocationEnabled":
            result(checkMockLocationEnabled())
        case "getInstalledApps":
            result(getInstalledFakeGpsApps())
        case "checkJailbreakStatus":
            result(checkJailbreakStatus())
        case "checkLocationServicesReliability":
            checkLocationServicesReliability(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func checkMockLocationEnabled() -> Bool {
        // No iOS, verificamos se o device está jailbroken
        // Devices jailbroken podem ter location spoofing
        return checkJailbreakStatus()
    }
    
    private func getInstalledFakeGpsApps() -> [String] {
        let fakeLocationApps = [
            "com.iospirit.gpx",
            "com.lexa.fakegps", 
            "LocationFaker",
            "iSpoofer",
            "PokeGO++",
            "GPS JoyStick",
            "Fake GPS Pro",
            "Location Spoofer"
        ]
        
        var detectedApps: [String] = []
        
        for app in fakeLocationApps {
            if canOpenApp(scheme: app) {
                detectedApps.append(app)
            }
        }
        
        return detectedApps
    }
    
    private func canOpenApp(scheme: String) -> Bool {
        guard let url = URL(string: "\(scheme)://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    private func checkJailbreakStatus() -> Bool {
        // Verificar arquivos comuns de jailbreak
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd", 
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/private/var/tmp/cydia.log",
            "/Applications/Icy.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/blackra1n.app",
            "/Applications/SBSettings.app",
            "/Applications/FakeCarrier.app",
            "/Applications/WinterBoard.app",
            "/Applications/IntelliScreen.app"
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        // Tentar escrever em diretório restrito
        do {
            let testString = "test"
            let testPath = "/private/test_jailbreak"
            try testString.write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true // Se conseguiu escrever, device está jailbroken
        } catch {
            // Não conseguiu escrever - comportamento normal
        }
        
        // Verificar se consegue executar comandos do sistema
        if system("ls") == 0 {
            return true
        }
        
        return false
    }
    
    private func checkLocationServicesReliability(result: @escaping FlutterResult) {
        guard CLLocationManager.locationServicesEnabled() else {
            result([
                "accuracy": -1,
                "isReliable": false,
                "reason": "Location services disabled"
            ])
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
        
        // Verificar se o Core Location está funcionando adequadamente
        let authStatus = CLLocationManager.authorizationStatus()
        
        var reliability: [String: Any] = [:]
        reliability["authorizationStatus"] = authStatusToString(authStatus)
        reliability["locationServicesEnabled"] = CLLocationManager.locationServicesEnabled()
        reliability["significantLocationChangeMonitoring"] = CLLocationManager.significantLocationChangeMonitoringAvailable()
        reliability["headingAvailable"] = CLLocationManager.headingAvailable()
        reliability["regionMonitoring"] = CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self)
        
        // Verificar se há sinais de spoofing baseado nos serviços disponíveis
        var suspiciousCount = 0
        
        // Em devices jailbroken, alguns serviços podem estar comprometidos
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            suspiciousCount += 1
        }
        
        if !CLLocationManager.headingAvailable() && !checkIfIsPad() {
            suspiciousCount += 1
        }
        
        reliability["suspiciousCount"] = suspiciousCount
        reliability["isReliable"] = suspiciousCount == 0 && authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways
        
        result(reliability)
    }
    
    private func authStatusToString(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        @unknown default:
            return "unknown"
        }
    }
    
    private func checkIfIsPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
} 