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

    var icon: String {
        switch self {
        case .unknown:
            return "icon_file_type_default"

        case .directory:
            return "icon_file_type_folder_not_empty"

        case .image(let kind):
            switch kind {
            case .jpg: return "icon_file_type_jpg"
            case .png: return "icon_file_type_png"
            case .gif: return "icon_file_type_gif"
            case .svg: return "icon_file_type_svg"
            case .bmp: return "icon_file_type_bmp"
            case .tif: return "icon_file_type_tif"
            }

        case .audio(let kind):
            switch kind {
            case .mp3: return "icon_file_type_mp3"
            case .aac: return "icon_file_type_aac"
            case .wav: return "icon_file_type_wav"
            case .ogg: return "icon_file_type_ogg"
            }

        case .video(let kind):
            switch kind {
            case .mp4: return "icon_file_type_mp4"
            case .avi: return "icon_file_type_avi"
            case .flv: return "icon_file_type_flv"
            case .midi: return "icon_file_type_midi"
            case .mov: return "icon_file_type_mov"
            case .mpg: return "icon_file_type_mpg"
            case .wmv: return "icon_file_type_wmv"
            }

        case .apple(let kind):
            switch kind {
            case .dmg: return "icon_file_type_dmg"
            case .ipa: return "icon_file_type_ipa"
            case .numbers: return "icon_file_type_numbers"
            case .pages: return "icon_file_type_pages"
            case .key: return "icon_file_type_keynote"
            }

        case .google:
            return "icon_file_type_apk"

        case .microsoft(let kind):
            switch kind {
            case .doc, .docx: return "icon_file_type_doc"
            case .xls, .xlsx: return "icon_file_type_xls"
            case .ppt, .pptx: return "icon_file_type_ppt"
            case .exe: return "icon_file_type_default"
            case .dll: return "icon_file_type_dll"
            }

        case .document(let kind):
            switch kind {
            case .txt: return "icon_file_type_txt"
            case .rtf: return "icon_file_type_default"
            case .pdf: return "icon_file_type_pdf"
            case .zip: return "icon_file_type_zip"
            case ._7z: return "icon_file_type_7z"
            case .csv: return "icon_file_type_default"
            case .md: return "icon_file_type_md"
            }

        case .programming(let kind):
            switch kind {
            case .swift: return "icon_file_type_swift"
            case .java: return "icon_file_type_java"
            case .c: return "icon_file_type_default"
            case .cpp: return "icon_file_type_default"
            case .php: return "icon_file_type_php"
            case .json: return "icon_file_type_json"
            case .plist: return "icon_file_type_plist"
            case .xml: return "icon_file_type_xml"
            case .db: return "icon_file_type_db"
            case .js: return "icon_file_type_js"
            case .html: return "icon_file_type_html"
            case .css: return "icon_file_type_css"
            case .bin: return "icon_file_type_bin"
            case .dat: return "icon_file_type_dat"
            case .sql: return "icon_file_type_sql"
            case .jar: return "icon_file_type_jar"
            }

        case .adobe(let kind):
            switch kind {
            case .fla: return "icon_file_type_fla"
            case .psd: return "icon_file_type_psd"
            case .eps: return "icon_file_type_eps"
            }

        case .other(let kind):
            switch kind {
            case .ttf: return "icon_file_type_ttf"
            case .torrent: return "icon_file_type_torrent"
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
