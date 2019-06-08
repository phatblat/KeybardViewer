//
//  ViewController.swift
//  KeybardViewer
//
//  Created by Ben Chatelain on 6/7/19.
//  Copyright © 2019 Ben Chatelain. All rights reserved.
//

import AppKit

class ViewController : NSViewController {
    @IBOutlet var keyLabel: NSTextField!

    override func viewDidLoad() {
        _ = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { (event: NSEvent) in
            let key: KeyboardKey
            switch(event.type) {
            case .keyDown, .keyUp:
                key = CharacterKey(from: event)
            case .flagsChanged:
                key = ModifierKey(from: event)
            default:
                fatalError()
            }

            debugPrint("key: \(key)")
            return nil
        }
    }
}

protocol KeyboardKey {
    var keyName: String { get }
    var keyCode: UInt16 { get }
    var modifierFlags: NSEvent.ModifierFlags { get }
}

struct CharacterKey: KeyboardKey {
    var keyCode: UInt16
    var modifierFlags: NSEvent.ModifierFlags
    var characters: String?
    var charactersIgnoringModifiers: String?

    init(from event: NSEvent) {
        keyCode = event.keyCode
        modifierFlags = event.modifierFlags
        characters = event.characters
        charactersIgnoringModifiers = event.charactersIgnoringModifiers
    }

    var keyName: String {
        guard let chars = characters else { return "unknown" }
        return chars
    }
}

struct ModifierKey: KeyboardKey {
    var keyCode: UInt16
    var modifierFlags: NSEvent.ModifierFlags

    init(from event: NSEvent) {
        keyCode = event.keyCode
        modifierFlags = event.modifierFlags
    }

    var keyName: String {
        return "\(modifierFlags)"
    }
}

extension CharacterKey: CustomDebugStringConvertible {
    var debugDescription: String {
        if let chars = characters {
            return "KeyboardKey: keyCode=\(keyCode), flags=\(modifierFlags), chars='\(chars)'"
        }
        return "missing characters"
    }
}

extension ModifierKey: CustomDebugStringConvertible {
    var debugDescription: String {
        return "KeyboardKey: keyCode=\(keyCode), flags=\(modifierFlags)"
    }
}
