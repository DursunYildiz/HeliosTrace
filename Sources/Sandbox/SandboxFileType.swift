//
//  SandboxFileType.swift
//  HeliosTrace
//
//  Created by Dursun  Yıldızon 13.11.2025.
//

import Foundation

enum SandboxFileType: Equatable {
    case unknown
    case directory
    case image(ImageKind)
    case audio(AudioKind)
    case video(VideoKind)
    case apple(AppleKind)
    case google(GoogleKind)
    case microsoft(MicrosoftKind)
    case document(DocumentKind)
    case programming(ProgrammingKind)
    case adobe(AdobeKind)
    case other(OtherKind)

    enum ImageKind: String {
        case jpg, png, gif, svg, bmp, tif
    }

    enum AudioKind: String {
        case mp3, aac, wav, ogg
    }

    enum VideoKind: String {
        case mp4, avi, flv, midi, mov, mpg, wmv
    }

    enum AppleKind: String {
        case dmg, ipa, numbers, pages, key
    }

    enum GoogleKind: String {
        case apk
    }

    enum MicrosoftKind: String {
        case doc, docx, xls, xlsx, ppt, pptx, exe, dll
    }

    enum DocumentKind: String {
        case txt, rtf, pdf, zip, _7z = "7z", csv = "cvs", md
    }

    enum ProgrammingKind: String {
        case swift, java, c, cpp, php, json, plist, xml, db, js, html, css, bin, dat, sql, jar
    }

    enum AdobeKind: String {
        case fla, psd, eps
    }

    enum OtherKind: String {
        case ttf, torrent
    }
}

extension SandboxFileType {
    init(fileExtension: String, isDirectory: Bool) {
        guard !isDirectory else {
            self = .directory
            return
        }

        let ext = fileExtension.lowercased()

        // Image
        if let kind = SandboxFileType.ImageKind(rawValue: ext) {
            self = .image(kind)
            return
        }

        // Audio
        if let kind = SandboxFileType.AudioKind(rawValue: ext) {
            self = .audio(kind)
            return
        }

        // Video
        if let kind = SandboxFileType.VideoKind(rawValue: ext) {
            self = .video(kind)
            return
        }

        // Apple
        if let kind = SandboxFileType.AppleKind(rawValue: ext) {
            self = .apple(kind)
            return
        }

        // Google
        if let kind = SandboxFileType.GoogleKind(rawValue: ext) {
            self = .google(kind)
            return
        }

        // Microsoft
        if let kind = SandboxFileType.MicrosoftKind(rawValue: ext) {
            self = .microsoft(kind)
            return
        }

        // Document
        if let kind = SandboxFileType.DocumentKind(rawValue: ext) {
            self = .document(kind)
            return
        }

        // Programming
        if let kind = SandboxFileType.ProgrammingKind(rawValue: ext) {
            self = .programming(kind)
            return
        }

        // Adobe
        if let kind = SandboxFileType.AdobeKind(rawValue: ext) {
            self = .adobe(kind)
            return
        }

        // Other
        if let kind = SandboxFileType.OtherKind(rawValue: ext) {
            self = .other(kind)
            return
        }

        self = .unknown
    }

    var icon: ImageResource {
        switch self {
        case .unknown:
            return .iconFileTypeDefault

        case .directory:
            return .iconFileTypeFolderNotEmpty

        case .image(let kind):
            switch kind {
            case .jpg: return .iconFileTypeJpg
            case .png: return .iconFileTypePng
            case .gif: return .iconFileTypeGif
            case .svg: return .iconFileTypeSvg
            case .bmp: return .iconFileTypeBmp
            case .tif: return .iconFileTypeTif
            }

        case .audio(let kind):
            switch kind {
            case .mp3: return .iconFileTypeMp3
            case .aac: return .iconFileTypeAac
            case .wav: return .iconFileTypeWav
            case .ogg: return .iconFileTypeOgg
            }

        case .video(let kind):
            switch kind {
            case .mp4: return .iconFileTypeMp4
            case .avi: return .iconFileTypeAvi
            case .flv: return .iconFileTypeFlv
            case .midi: return .iconFileTypeMidi
            case .mov: return .iconFileTypeMov
            case .mpg: return .iconFileTypeMpg
            case .wmv: return .iconFileTypeWmv
            }

        case .apple(let kind):
            switch kind {
            case .dmg: return .iconFileTypeDmg
            case .ipa: return .iconFileTypeIpa
            case .numbers: return .iconFileTypeNumbers
            case .pages: return .iconFileTypePages
            case .key: return .iconFileTypeKeynote
            }

        case .google:
            return .iconFileTypeApk

        case .microsoft(let kind):
            switch kind {
            case .doc, .docx: return .iconFileTypeDoc
            case .xls, .xlsx: return .iconFileTypeXls
            case .ppt, .pptx: return .iconFileTypePpt
            case .exe: return .iconFileTypeDefault
            case .dll: return .iconFileTypeDll
            }

        case .document(let kind):
            switch kind {
            case .txt: return .iconFileTypeTxt
            case .rtf: return .iconFileTypeDefault
            case .pdf: return .iconFileTypePdf
            case .zip: return .iconFileTypeZip
            case ._7z: return .iconFileType7Z
            case .csv: return .iconFileTypeDefault
            case .md: return .iconFileTypeMd
            }

        case .programming(let kind):
            switch kind {
            case .swift: return .iconFileTypeSwift
            case .java: return .iconFileTypeJava
            case .c: return .iconFileTypeDefault
            case .cpp: return .iconFileTypeDefault
            case .php: return .iconFileTypePhp
            case .json: return .iconFileTypeJson
            case .plist: return .iconFileTypePlist
            case .xml: return .iconFileTypeXml
            case .db: return .iconFileTypeDb
            case .js: return .iconFileTypeJs
            case .html: return .iconFileTypeHtml
            case .css: return .iconFileTypeCss
            case .bin: return .iconFileTypeBin
            case .dat: return .iconFileTypeDat
            case .sql: return .iconFileTypeSql
            case .jar: return .iconFileTypeJar
            }

        case .adobe(let kind):
            switch kind {
            case .fla: return .iconFileTypeFla
            case .psd: return .iconFileTypePsd
            case .eps: return .iconFileTypeEps
            }

        case .other(let kind):
            switch kind {
            case .ttf: return .iconFileTypeTtf
            case .torrent: return .iconFileTypeTorrent
            }
        }
    }

    var supportsWebPreview: Bool {
        switch self {
        case .image(.png), .image(.jpg), .image(.gif), .image(.svg), .image(.bmp),
             .audio(.wav),
             .apple(.numbers), .apple(.pages), .apple(.key),
             .microsoft(.doc), .microsoft(.docx), .microsoft(.xls), .microsoft(.xlsx),
             .document(.txt), .document(.pdf), .document(.md),
             .programming(.java), .programming(.swift), .programming(.css),
             .adobe(.psd):
            return true
        default:
            return false
        }
    }
}
