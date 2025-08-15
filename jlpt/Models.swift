import Foundation

enum JLPTLevel: String, CaseIterable, Identifiable, Codable {
    case n5 = "N5"
    case n4 = "N4"
    case n3 = "N3"
    case n2 = "N2"
    case n1 = "N1"
    
    var id: String { rawValue }
    
    var color: String {
        switch self {
        case .n5: return "green"
        case .n4: return "blue"
        case .n3: return "orange"
        case .n2: return "purple"
        case .n1: return "red"
        }
    }
    
    var description: String {
        switch self {
        case .n5: return "初级"
        case .n4: return "初中级"
        case .n3: return "中级"
        case .n2: return "中高级"
        case .n1: return "高级"
        }
    }
}

struct ExampleSentence: Identifiable, Codable {
    let id = UUID()
    let japanese: String
    let reading: String
    let chinese: String
    let audioFileName: String?
    
    enum CodingKeys: String, CodingKey {
        case japanese, reading, chinese, audioFileName
    }
    
    init(japanese: String, reading: String, chinese: String, audioFileName: String?) {
        self.japanese = japanese
        self.reading = reading
        self.chinese = chinese
        self.audioFileName = audioFileName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        japanese = try container.decode(String.self, forKey: .japanese)
        reading = try container.decode(String.self, forKey: .reading)
        chinese = try container.decode(String.self, forKey: .chinese)
        audioFileName = try container.decodeIfPresent(String.self, forKey: .audioFileName)
    }
}

struct Vocabulary: Identifiable, Codable {
    let id = UUID()
    let word: String
    let reading: String
    let meaning: String
    let partOfSpeech: String
    let level: JLPTLevel
    let examples: [ExampleSentence]
    let audioFileName: String?
    
    enum CodingKeys: String, CodingKey {
        case word, reading, meaning, partOfSpeech, level, examples, audioFileName
    }
    
    init(word: String, reading: String, meaning: String, partOfSpeech: String, level: JLPTLevel, examples: [ExampleSentence], audioFileName: String?) {
        self.word = word
        self.reading = reading
        self.meaning = meaning
        self.partOfSpeech = partOfSpeech
        self.level = level
        self.examples = examples
        self.audioFileName = audioFileName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        word = try container.decode(String.self, forKey: .word)
        reading = try container.decode(String.self, forKey: .reading)
        meaning = try container.decode(String.self, forKey: .meaning)
        partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        level = try container.decode(JLPTLevel.self, forKey: .level)
        examples = try container.decode([ExampleSentence].self, forKey: .examples)
        audioFileName = try container.decodeIfPresent(String.self, forKey: .audioFileName)
    }
}

class VocabularyStore: ObservableObject {
    @Published var vocabularies: [Vocabulary] = []
    
    init() {
        loadSampleData()
    }
    
    func vocabularies(for level: JLPTLevel) -> [Vocabulary] {
        return vocabularies.filter { $0.level == level }
    }
    
    private func loadSampleData() {
        vocabularies = [
            // N5 Level
            Vocabulary(
                word: "こんにちは",
                reading: "こんにちは",
                meaning: "你好",
                partOfSpeech: "感叹词",
                level: .n5,
                examples: [
                    ExampleSentence(
                        japanese: "こんにちは、元気ですか。",
                        reading: "こんにちは、げんきですか。",
                        chinese: "你好，你好吗？",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "ありがとう",
                reading: "ありがとう",
                meaning: "谢谢",
                partOfSpeech: "感叹词",
                level: .n5,
                examples: [
                    ExampleSentence(
                        japanese: "ありがとうございます。",
                        reading: "ありがとうございます。",
                        chinese: "谢谢您。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "学校",
                reading: "がっこう",
                meaning: "学校",
                partOfSpeech: "名词",
                level: .n5,
                examples: [
                    ExampleSentence(
                        japanese: "学校に行きます。",
                        reading: "がっこうにいきます。",
                        chinese: "去学校。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "食べる",
                reading: "たべる",
                meaning: "吃",
                partOfSpeech: "动词",
                level: .n5,
                examples: [
                    ExampleSentence(
                        japanese: "朝ご飯を食べます。",
                        reading: "あさごはんをたべます。",
                        chinese: "吃早饭。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "水",
                reading: "みず",
                meaning: "水",
                partOfSpeech: "名词",
                level: .n5,
                examples: [
                    ExampleSentence(
                        japanese: "水を飲みたいです。",
                        reading: "みずをのみたいです。",
                        chinese: "想喝水。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            
            // N4 Level
            Vocabulary(
                word: "理解",
                reading: "りかい",
                meaning: "理解",
                partOfSpeech: "名词・他动词",
                level: .n4,
                examples: [
                    ExampleSentence(
                        japanese: "この問題を理解できません。",
                        reading: "このもんだいをりかいできません。",
                        chinese: "不理解这个问题。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "会議",
                reading: "かいぎ",
                meaning: "会议",
                partOfSpeech: "名词",
                level: .n4,
                examples: [
                    ExampleSentence(
                        japanese: "明日会議があります。",
                        reading: "あした かいぎが あります。",
                        chinese: "明天有会议。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "準備",
                reading: "じゅんび",
                meaning: "准备",
                partOfSpeech: "名词・他动词",
                level: .n4,
                examples: [
                    ExampleSentence(
                        japanese: "試験の準備をしています。",
                        reading: "しけんのじゅんびをしています。",
                        chinese: "在准备考试。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            
            // N3 Level
            Vocabulary(
                word: "経験",
                reading: "けいけん",
                meaning: "经验",
                partOfSpeech: "名词・他动词",
                level: .n3,
                examples: [
                    ExampleSentence(
                        japanese: "貴重な経験をしました。",
                        reading: "きちょうなけいけんをしました。",
                        chinese: "有了宝贵的经验。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            Vocabulary(
                word: "環境",
                reading: "かんきょう",
                meaning: "环境",
                partOfSpeech: "名词",
                level: .n3,
                examples: [
                    ExampleSentence(
                        japanese: "環境問題について話し合いました。",
                        reading: "かんきょうもんだいについてはなしあいました。",
                        chinese: "讨论了环境问题。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            
            // N2 Level
            Vocabulary(
                word: "効率",
                reading: "こうりつ",
                meaning: "效率",
                partOfSpeech: "名词",
                level: .n2,
                examples: [
                    ExampleSentence(
                        japanese: "効率を上げるために新しい方法を試しました。",
                        reading: "こうりつをあげるためにあたらしいほうほうをためしました。",
                        chinese: "为了提高效率尝试了新方法。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            ),
            
            // N1 Level
            Vocabulary(
                word: "抽象的",
                reading: "ちゅうしょうてき",
                meaning: "抽象的",
                partOfSpeech: "形容动词",
                level: .n1,
                examples: [
                    ExampleSentence(
                        japanese: "この概念は非常に抽象的で理解が困難です。",
                        reading: "このがいねんはひじょうにちゅうしょうてきでりかいがこんなんです。",
                        chinese: "这个概念非常抽象，理解困难。",
                        audioFileName: nil
                    )
                ],
                audioFileName: nil
            )
        ]
    }
}