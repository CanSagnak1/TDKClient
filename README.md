# TDKClient

**Türk Dil Kurumu (TDK) Sözlükleri için Swift Package Manager (SPM) Kütüphanesi**

TDK'nın resmi sozluk.gov.tr API'sine erişim sağlayan, modern Swift Concurrency (async/await) destekli, tip-güvenli (type-safe) bir Swift kütüphanesidir.

---

## Özellikler

- **7 Farklı Sözlük Desteği**: GTS, Atasözleri, Derleme, Terim, Batı Kökenli, Yabancı Karşılıklar, Etimolojik
- **Modern Swift Concurrency**: async/await pattern ile asenkron API çağrıları
- **Paralel Arama**: TaskGroup ile tüm sözlüklerde eş zamanlı arama
- **Tip-Güvenli Modeller**: Codable uyumlu, strongly-typed veri modelleri
- **Cross-Platform**: iOS, macOS, tvOS, watchOS desteği
- **Bağımlılık Yok**: Saf Swift, harici bağımlılık gerektirmez
- **Test Edilmiş**: XCTest ile kapsamlı unit test coverage

---

## Gereksinimler

| Platform | Minimum Versiyon |
|----------|------------------|
| iOS      | 13.0+            |
| macOS    | 10.15+           |
| tvOS     | 13.0+            |
| watchOS  | 6.0+             |
| Swift    | 5.9+             |

---

## Kurulum

### Swift Package Manager (SPM)

`Package.swift` dosyanıza aşağıdaki dependency'yi ekleyin:

```swift
dependencies: [
    .package(url: "https://github.com/CanSagnak1/TDKAPI.git", from: "1.0.0")
]
```

Veya Xcode'da:

1. **File** → **Add Package Dependencies...**
2. Repository URL'ini girin
3. **Add Package** butonuna tıklayın

---

## Kullanım

### Import

```swift
import TDKAPI
```

### TDKClient Singleton

Kütüphane, singleton pattern ile kullanılabilir:

```swift
let client = TDKClient.shared
```

Veya özel URLSession ile:

```swift
let customSession = URLSession(configuration: .ephemeral)
let client = TDKClient(session: customSession)
```

---

## API Referansı

### 1. Güncel Türkçe Sözlük (GTS)

Türkçe kelimelerin tanımları, örnekleri ve dilbilgisi özellikleri.

```swift
func fetchGTS(word: String) async throws -> [TDKGTSResult]?
```

**Örnek Kullanım:**

```swift
do {
    if let results = try await TDKClient.shared.fetchGTS(word: "kalem") {
        for result in results {
            print("Kelime: \(result.madde ?? "")")
            print("Köken: \(result.lisan ?? "")")
            
            if let meanings = result.anlamlarListe {
                for (index, meaning) in meanings.enumerated() {
                    print("\(index + 1). \(meaning.anlam ?? "")")
                }
            }
        }
    }
} catch {
    print("Hata: \(error)")
}
```

**Dönen Model:**

```swift
TDKGTSResult
├── madde: String?          // Kelime
├── lisan: String?          // Dilsel köken
├── telaffuz: String?       // Telaffuz
├── birlesikler: String?    // Bileşik kelimeler
└── anlamlarListe: [TDKMeaning]?
    ├── anlam: String?      // Anlam açıklaması
    ├── orneklerListe: [TDKExample]?
    │   ├── ornek: String?  // Örnek cümle
    │   └── yazar: [TDKAuthor]?
    └── ozelliklerListe: [TDKProperty]?
```

---

### 2. Atasözleri ve Deyimler Sözlüğü

Türkçe atasözleri ve deyimlerin anlamları.

```swift
func fetchProverbs(word: String) async throws -> [TDKProverb]?
```

**Örnek Kullanım:**

```swift
if let proverbs = try await TDKClient.shared.fetchProverbs(word: "aç") {
    for proverb in proverbs {
        print("Söz: \(proverb.sozum ?? "")")
        print("Anlamı: \(proverb.anlami ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKProverb
├── sozId: String?    // Benzersiz ID
├── sozum: String?    // Atasözü/deyim metni
├── anlami: String?   // Anlam açıklaması
├── anahtar: String?  // Anahtar kelime
└── turu2: String?    // Tür bilgisi
```

---

### 3. Derleme Sözlüğü

Anadolu ağızlarından derlenen kelimeler.

```swift
func fetchCompilation(word: String) async throws -> [TDKCompilationResult]?
```

**Örnek Kullanım:**

```swift
if let compilations = try await TDKClient.shared.fetchCompilation(word: "ana") {
    for item in compilations {
        print("Madde: \(item.madde ?? "")")
        print("Anlam: \(item.anlam ?? "")")
        print("Şehir: \(item.sehir ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKCompilationResult
├── maddeId: String?  // Benzersiz ID
├── madde: String?    // Kelime
├── anlam: String?    // Anlam
└── sehir: String?    // Derlendiği şehir
```

---

### 4. Bilim ve Sanat Terimleri Sözlüğü

Bilimsel ve sanatsal terimler.

```swift
func fetchTerms(word: String) async throws -> [TDKTermResult]?
```

**Örnek Kullanım:**

```swift
if let terms = try await TDKClient.shared.fetchTerms(word: "yazılım") {
    for term in terms {
        print("Terim: \(term.soz ?? "")")
        print("Bilim Dalı: \(term.bilimDali ?? "")")
        print("Anlam: \(term.anlam ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKTermResult
├── id: String?        // Benzersiz ID
├── soz: String?       // Terim
├── anlam: String?     // Anlam
├── bilimDali: String? // Bilim dalı
└── turu: String?      // Tür (isim, fiil vb.)
```

---

### 5. Türkçede Batı Kökenli Kelimeler Sözlüğü

Batı dillerinden Türkçeye geçmiş kelimeler.

```swift
func fetchWestOpposite(word: String) async throws -> [TDKWestResult]?
```

**Örnek Kullanım:**

```swift
if let westWords = try await TDKClient.shared.fetchWestOpposite(word: "telefon") {
    for word in westWords {
        print("Kelime: \(word.kelime ?? "")")
        print("Köken: \(word.koken ?? "")")
        print("Anlam: \(word.anlam ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKWestResult
├── id: String?     // Benzersiz ID
├── kelime: String? // Kelime
├── anlam: String?  // Anlam
└── koken: String?  // Köken dili
```

---

### 6. Yabancı Sözlere Karşılıklar Kılavuzu

Yabancı kelimelerin Türkçe karşılıkları.

```swift
func fetchGuide(word: String) async throws -> [TDKForeignEquivalentResult]?
```

**Örnek Kullanım:**

```swift
if let equivalents = try await TDKClient.shared.fetchGuide(word: "meeting") {
    for equiv in equivalents {
        print("Yabancı: \(equiv.kelime ?? "")")
        print("Karşılık: \(equiv.karsilik ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKForeignEquivalentResult
├── id: String?       // Benzersiz ID
├── kelime: String?   // Yabancı kelime
├── karsilik: String? // Türkçe karşılık
└── anlami: String?   // Anlam açıklaması
```

---

### 7. Eren Türk Dilinin Etimolojik Sözlüğü

Kelimelerin köken bilgisi.

```swift
func fetchEtymological(word: String) async throws -> [TDKEtymologicalResult]?
```

**Örnek Kullanım:**

```swift
if let etymology = try await TDKClient.shared.fetchEtymological(word: "kitap") {
    for item in etymology {
        print("Kelime: \(item.kelime ?? "")")
        print("Etimoloji: \(item.etimoloji ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKEtymologicalResult
├── kelime: String?    // Kelime
└── etimoloji: String? // Etimolojik açıklama
```

---

## Toplu Arama (Aggregated Search)

Tüm sözlüklerde paralel arama yaparak tek bir sonuç döndürür.

```swift
func search(word: String) async throws -> TDKAggregatedResult
```

**Örnek Kullanım:**

```swift
let result = try await TDKClient.shared.search(word: "yazılım")

// GTS Sonuçları
print("Kelime: \(result.word ?? "")")
print("Köken: \(result.lisan ?? "")")

if let meanings = result.means {
    for meaning in meanings {
        print("Anlam: \(meaning.anlam ?? "")")
    }
}

// Bileşik Kelimeler
if let compounds = result.compounds {
    print("Bileşikler: \(compounds.joined(separator: ", "))")
}

// Terimler
if let terms = result.glossaryOfScienceAndArtTerms {
    for term in terms {
        print("Terim: \(term.soz ?? "") - \(term.bilimDali ?? "")")
    }
}
```

**Dönen Model:**

```swift
TDKAggregatedResult
├── word: String?                              // Aranan kelime
├── lisan: String?                             // Dilsel köken
├── means: [TDKMeaning]?                       // Anlamlar (GTS)
├── compounds: [String]?                       // Bileşik kelimeler
├── proverbs: [TDKProverb]?                    // Atasözleri
├── compilation: [TDKCompilationResult]?       // Derleme sonuçları
├── glossaryOfScienceAndArtTerms: [TDKTermResult]? // Terimler
├── westOpposite: [TDKWestResult]?             // Batı kökenli
├── guide: [TDKForeignEquivalentResult]?       // Yabancı karşılıklar
└── etymological: [TDKEtymologicalResult]?     // Etimoloji
```

---

## Proje Yapısı

```
TDKAPI/
├── Package.swift                    # SPM manifest
├── Sources/
│   └── TDKAPI/
│       ├── TDKClient.swift          # Ana API istemcisi
│       └── Models/
│           ├── TDKGTSResult.swift   # GTS veri modelleri
│           ├── TDKProverb.swift     # Atasözleri modeli
│           ├── TDKTerm.swift        # Terim modelleri
│           ├── TDKOtherResults.swift # Diğer sözlük modelleri
│           └── TDKAggregatedResult.swift # Toplu sonuç modeli
└── Tests/
    └── TDKAPITests/
        └── TDKAPITests.swift        # Unit testler
```

---

## Testleri Çalıştırma

```bash
swift test
```

Veya Xcode'da: **Product** → **Test** (Cmd+U)

### Mevcut Test Senaryoları

| Test                        | Açıklama                              |
|-----------------------------|---------------------------------------|
| `testGTS_Kalem`             | GTS API'si ile "kalem" kelimesi testi |
| `testProverbs_Ac`           | Atasözleri API'si testi               |
| `testAggregated_Yazilim`    | Toplu arama fonksiyonelliği testi     |
| `testInvalidWord`           | Geçersiz kelime hata yönetimi testi   |

---

## Hata Yönetimi

Kütüphane, Swift'in native error handling mekanizmasını kullanır:

```swift
do {
    let results = try await TDKClient.shared.fetchGTS(word: "örnek")
    // Sonuçları işle
} catch URLError.notConnectedToInternet {
    print("İnternet bağlantısı yok")
} catch URLError.badURL {
    print("Geçersiz URL")
} catch {
    print("Beklenmeyen hata: \(error.localizedDescription)")
}
```

**Önemli**: API, sonuç bulunamadığında hata fırlatmak yerine `nil` döndürür.

---

## Performans Notları

### TaskGroup ile Paralel İstekler

`search(word:)` metodu, tüm sözlükleri paralel olarak sorgular:

```swift
await withTaskGroup(of: Void.self) { group in
    group.addTask { /* GTS */ }
    group.addTask { /* Atasözleri */ }
    group.addTask { /* Derleme */ }
    // ... diğer sözlükler
}
```

Bu yaklaşım, sıralı isteklere göre yaklaşık **7 kat** daha hızlı sonuç alınmasını sağlar.

### Türkçe Karakter Normalizasyonu

Tüm aramalar otomatik olarak Türkçe locale ile küçük harfe dönüştürülür:

```swift
word.lowercased(with: Locale(identifier: "tr"))
```

Bu, "İstanbul" → "istanbul" gibi Türkçe'ye özgü dönüşümlerin doğru yapılmasını sağlar.

---

## API Endpoint'leri

| Endpoint     | Path        | Sözlük                                |
|--------------|-------------|---------------------------------------|
| GTS          | `/gts`      | Güncel Türkçe Sözlük                  |
| Atasözleri   | `/atasozu`  | Atasözleri ve Deyimler Sözlüğü        |
| Derleme      | `/derleme`  | Derleme Sözlüğü                       |
| Terim        | `/terim`    | Bilim ve Sanat Terimleri Sözlüğü      |
| Batı         | `/bati`     | Türkçede Batı Kökenli Kelimeler       |
| Kılavuz      | `/kilavuz`  | Yabancı Sözlere Karşılıklar Kılavuzu  |
| Etimoloji    | `/etms`     | Eren Türk Dilinin Etimolojik Sözlüğü  |

Base URL: `https://sozluk.gov.tr`

---

## Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun: `git checkout -b feature/yeni-ozellik`
3. Değişikliklerinizi commit edin: `git commit -m 'Yeni özellik eklendi'`
4. Branch'i push edin: `git push origin feature/yeni-ozellik`
5. Pull Request açın

### Kod Standartları

- Swift API Design Guidelines'a uyun
- Tüm public API'ler için dokümantasyon yorumları ekleyin
- Yeni özellikler için unit test yazın

---

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## Yazar

**Celal Can Sagnak**

- GitHub: [@cansagnak](https://github.com/cansagnak1)

---

## Teşekkürler

- [Türk Dil Kurumu](https://www.tdk.gov.tr) - Resmi sözlük API'si
- [halituzan/tdk-all-api](https://github.com/halituzan/tdk-all-api) - JavaScript referans implementasyonu

---

## Sürüm Geçmişi

### v1.0.0 (2026-01-06)

- İlk stable sürüm
- 7 TDK sözlüğü desteği
- async/await API
- Cross-platform desteği
- Kapsamlı unit testler
