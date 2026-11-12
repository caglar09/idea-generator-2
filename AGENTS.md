# Idea Generator 2 — Ekip Anayasası ve Yönlendirme (AGENTS.md)

Bu dosya repo kökünde durur; Codex, Claude Code ve Antigravity tarafından proje talimatı olarak okunur. Ana oturum ve tüm ajanlar buradaki kuralları bağlayıcı kabul eder. Ajan tanımları:
- Antigravity için: `.agents/agents/`
- Claude Code için: `.claude/agents/`
- Codex için: `.codex/agents/`

## ⛔ Zorunlu Ajan Yönlendirme Kuralı (ATLANAMAZ)

Bu kural varsayılandır, her görev için geçerlidir ve **hiçbir koşulda atlanamaz**:

1. Kullanıcıdan gelen her talimatta ana ajan ilk adım olarak işin hangi alana ait olduğunu belirler ve aşağıdaki "Ekip ve yönlendirme" tablosundan sorumlu ajanı seçer.
2. İş, bu projede tanımlı ilgili ajan tarafından yürütülür. Ana oturum (tek chat) işi doğrudan yapmaz; yalnızca yönlendirir, koordine eder ve sonuçları birleştirir.
3. Görev birden fazla alana dokunuyorsa iş ilgili uzman ajanlara bölünür (bkz. Delegasyon kuralı).
4. Kullanıcı "direkt sen yap" dese bile tabloda karşılığı olan işler ilgili ajana devredilir; yalnızca tabloda karşılığı olmayan saf koordinasyon/sohbet ya da genel proje işleri ana oturumda kalabilir. Derin uzmanlık gerektiren sorularda ana ajan ilgili uzman ajana danışır, cevabı ondan alır ve kullanıcıya iletir.
5. Yanıtın başında seçilen ajan(lar) ve gerekçesi kısaca belirtilir.

## Değişmezler (pazarlık konusu değil)

1. **Node 25+ ve Sıfır Derleme Adımı.** Sunucu TypeScript dosyalarını (`node server/index.ts`) doğrudan çalıştırır; frontend vanilla ES modülleridir. Build step yoktur.
2. **Güvenli Çapraz-Site İşleme (`innerHTML` yasak).** Metin DOM'a daima text node olarak (`dom.js`) yazılır.
3. **Tahribatsız Proje Export'u.** `server/project.ts` içindeki `writeProject()` asla mevcut klasörün üzerine yazmaz; non-recursive `mkdir` ile oluşturulur ve doluysa `-2`, `-3` soneki alır.
4. **Yerel-Öncelikli Güvenlik ve Gizlilik.** Uygulamada giriş sistemi yoktur; API anahtarları tarayıcının `localStorage`'ında tutulur ve sunucu belleğinde geçici olarak yaşar, diske yazılmaz. Sunucu varsayılan olarak yalnızca `127.0.0.1` loopback üzerinde dinler (Docker'da port eşlemesi `127.0.0.1:8300:8300` olmalıdır).
5. **Madalya Koddan Gelir.** Jüri puanlaması ve madalyalar (bronze ≥ 9, silver ≥ 11, gold ≥ 13) modelin keyfine değil, kod içi hesaplamaya (`public/js/score.js`) dayanır.
6. **Kanıt Kuralı.** "Bitti" veya "geçti" demek için çalıştırılmış komut çıktısı (`npm test`, `docker compose` vb.) gereklidir.

## Ekip ve yönlendirme

| Konu | Ajan |
| --- | --- |
| Docker, Dockerfile, Docker Compose, volume/bind mount, Claude Code export dizin eşlemesi, Multi-LLM konteyner ağı (Ollama/LM Studio/MLX), deployment ve konteyner güvenliği | `devops-master` |

*(Proje büyüdükçe yeni uzman ajanlar `.agents/agents/`, `.claude/agents/` ve `.codex/agents/` dizinlerine eklenip bu tabloya kaydedilir.)*

## Devir (handoff) protokolü

Her ajan işini şu başlıklarla bitirir: **Özet**, **Değişen dosyalar**, **Kanıt** (çalıştırılan komut + çıktının ilgili kısmı), **Açık riskler**, **Devredilenler** (hangi ajana, ne için).

## Delegasyon kuralı

Bir görev tablodaki birden fazla alana dokunuyorsa ana ajan işi ilgili uzman ajanlara böler, her birinden yukarıdaki formatta özet ister ve sonuçları birleştirir. Aynı dosyaya paralel yazan iki ajan çalıştırılmaz; yazma işleri sırayla, okuma ve inceleme işleri paralel yürütülür.
