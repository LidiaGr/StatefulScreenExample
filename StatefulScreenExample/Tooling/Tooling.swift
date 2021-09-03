//
//  Tooling.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import UIKit

public typealias VoidClosure = () -> Void

public protocol Namespace: CaseIterable {}

public protocol IOTransformer: AnyObject {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}

public protocol BindableView: AnyObject {
  associatedtype Input
  associatedtype Output

  func getOutput() -> Output
  func bindWith(_ input: Input)
}

public struct TitledText: Hashable {
  public let title: String
  public let text: String

  public init(title: String, text: String) {
    self.title = title
    self.text = text
  }

  public static func makeEmpty() -> Self {
    .init(title: "", text: "")
  }
}

/// Для случаев, когда для отображения в UI'е нужна модель, дополненная заголовоком или пояснением
public struct TitledOptionalText: Hashable {
  public let title: String
  public let maybeText: String?

  public init(title: String, maybeText: String?) {
    self.title = title
    self.maybeText = maybeText
  }
}

public struct Empty: Hashable, Codable {
  public init() {}
}

/// Generic решение для closured-based инициализации
/// For class instances only. Value-types are not supported
public func configured<T: AnyObject>(object: T, closure: (_ object: T) -> Void) -> T {
  closure(object)
  return object
}

// MARK: - Extensions

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension String {
    /// mask example: `+X (XXX) XXX-XXXX`
    func formatPhoneNumber(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}


// MARK: - CharacterSet

extension CharacterSet {
    /// "0123456789"
    public static let arabicNumerals = CharacterSet(charactersIn: "0123456789")
    
    public static let russianLetters = CharacterSet(charactersIn: "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ")
}

extension String {
    /// Удалятся все символы (Unicode Scalar'ы) кроме символов из указанного CharacterSet. Например все кроме цифр
    public func removingCharacters(except characterSet: CharacterSet) -> String {
        let scalars = unicodeScalars.filter(characterSet.contains(_:))
        return String(scalars)
    }
    
    /// Удалятся все символы (Unicode Scalar'ы), которые соответствуют указанному CharacterSet.
    /// Например все точки и запятые
    public func removingCharacters(in characterSet: CharacterSet) -> String {
        let scalars = unicodeScalars.filter { !characterSet.contains($0) }
        return String(scalars)
    }
}


// MARK: - HideKeyboard
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
  @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

