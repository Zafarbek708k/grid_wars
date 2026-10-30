# Game Hub — Farmstead mini-o‘yini: texnik topshiriq

**Sana:** 2026-10-30  
**Holat:** qurishni boshlash uchun loyiha spetsifikatsiyasi; hali implementatsiya qilinmagan.  
**Ilova:** Game Hub, hozir Google Play orqali chiqariladi. Dart paketi `grid_wars` bo‘lib qoladi.  
**Ishchi nom:** Farmstead; yakuniy nom chiqarishdan oldin alohida tanlanadi.  
**Modul ID:** `farmstead`. **Asosiy platforma:** Android. **Ekran:** portraitUp.

## 1. Maqsad va chegaralar

Game Hub ichiga tez o‘ynaladigan, to‘liq offline ferma boshqaruv o‘yini qo‘shiladi. O‘yinchi quduqdan suv oladi, o‘t ekadi, hayvonlarni boqadi, mahsulot yig‘adi, omborni boshqaradi va mashina orqali sotadi. Ayiqlar fermaga xavf tug‘diradi; it himoya qiladi, mushuk yig‘ishda yordam beradi.

Farm Frenzy umumiy janr va foydalanuvchi tasvirlagan mexanikalar uchun reference. Quyidagi qoidalar bizning o‘yin uchun taklif etilgan mustaqil dizayndir; ular original o‘yinning aniq qoidalari deb taqdim etilmaydi. Kod, nom, level xaritasi, interfeys, rasm va ovozlar ko‘chirilmaydi. Faqat o‘zimiz yaratgan yoki litsenziyasi aniq assetlardan foydalaniladi.

### Birinchi release ichida

- Quduq, suv, ekiladigan o‘t va hayvonlarning ochlik tizimi.
- O‘rdak → tuxum; qo‘y → jun; sigir → sut.
- Mushuk → avtomatik mahsulot tashish; it → ayiqni to‘xtatish.
- Ayiq paydo bo‘lishi, ogohlantirish, katakka olish va sotish.
- Ombor sig‘imi, yerda qolgan mahsulotlarning eskirishi.
- Mahsulot va uy hayvonlarini mashina bilan sotish.
- Hayvon sotib olish, quduq/ombor/mashina upgrade’lari.
- 12 ta oldindan yozilgan level, tutorial, medal va qayta o‘ynash.
- Local autosave, davom ettirish, sound/vibration sozlamalari.
- Home tile, Profile natijalari va Daily Challenge integratsiyasi.

### Keyingi release uchun

Zavodlar va mahsulot qayta ishlash, cheksiz sandbox, fasllar, yangi hayvonlar, dekoratsiyalar, bir nechta mashina. Birinchi release’da reklama, IAP, server, login, multiplayer va internetga bog‘liq mukofot bo‘lmaydi.

## 2. O‘yinchining asosiy yo‘li

1. Home’dagi Farmstead kartasini bosadi.
2. Menyudan **Davom etish** yoki **Level tanlash** orqali kiradi.
3. Level boshlanishidan oldin vazifalar, mavjud hayvonlar va boshlang‘ich pul ko‘rinadi.
4. Quduqni bosib suv chiqaradi; bo‘sh yerga bosib o‘t ekadi.
5. Hayvonlar o‘tga yuradi, yeydi va mahsulot chiqaradi.
6. O‘yinchi mahsulotni bosib omborga oladi; mushuk bo‘lsa o‘zi tashiydi.
7. Ombordagi mahsulot/hayvonlardan yuk tuzib mashinani bozorga yuboradi.
8. Mashina qaytgach pul tushadi. Shu pulga suv, hayvon va upgrade oladi.
9. Ayiq kelganda it vaqt yutadi; o‘yinchi ayiqni tez-tez bosib katakka oladi.
10. Barcha vazifa bajarilgach level yakunlanadi, medal va natija saqlanadi.

Mahsulot tanlash uchun alohida drag kerak emas: **bosish — yig‘ish**, **yerga bosish — o‘t ekish**, **ayiqni takror bosish — katakka olish**. Har bir muvaffaqiyatli amal ko‘rinadigan animatsiya bilan tasdiqlanadi.

## 3. Vaqt, holatlar va simulyatsiya

`FarmStatus`: `menu`, `loading`, `playing`, `paused`, `completed`, `failed`. Tutorial va savdo panellari alohida UI holatidir. Savdo, upgrade, hayvon tanlash va tutorial dialogi ochilganda simulyatsiya to‘xtaydi; yopilganda faqat oldin playing bo‘lgan run davom etadi.

- Game logic sobit 1/30 s qadam bilan yuradi; render qurilma frame rate’ida ishlaydi.
- Katta `dt` uchun accumulator cheklanadi: fon vaqtini yoki sekundlab qolgan frame’ni birdan simulyatsiya qilmaslik.
- Suv chiqarish, ishlab chiqarish, eskirish, mashina safari, ayiqlar va it cooldown’i faqat playing vaqtida yuradi.
- Ilova inactive/paused/hidden bo‘lsa pauza va snapshot. Qaytganda avtomatik davom etmaydi.
- Offline vaqt uchun daromad ham, ochlik jazosi ham yo‘q. Resume aynan saqlangan gameplay vaqtidan davom etadi.
- Android Back playing vaqtida pauza ochadi; pauzadan chiqishda saqlab menyuga qaytish mumkin.
- Bir level natijasi bir marta yakunlanadi. Bir frame’dagi ko‘p event dublikat mukofot bermaydi.

## 4. Ferma hududi va boshqaruv

Portrait uchun 360×640 mantiqiy dizayn maydoni asos olinadi. Katta ekranlarda aspect ratio saqlanadi, qo‘shimcha joy dekorativ fon bilan to‘ldiriladi. Safe area ichida HUD, pastda 48 dp dan kichik bo‘lmagan boshqaruv tugmalari joylashadi.

- Yuqori qism: pul, suv, vazifalar progress’i, vaqt va pause.
- O‘rta qism: hayvonlar, mahsulotlar, o‘t, ayiq uchun ochiq maydon.
- Yuqori/yon chetlar: quduq, ombor va mashina darvozasi; ular yurish hududiga kirmaydi.
- Pastki qism: Hayvonlar, Ombor/Sotish, Upgrade va yordam tugmalari.
- Tap ustuvorligi: modal UI → ayiq/katak → mahsulot → bino → bo‘sh yer.
- Har event bitta nishonga ishlaydi. Mahsulot yoki hayvon ustini bosish uning tagida o‘t ekmaydi.
- Hayvon sotish faqat savdo panelida ID bo‘yicha tanlanadi; tasodifiy tap bilan hayvon yo‘qolmaydi.
- Mahsulot uchun 48 dp gacha kengaytirilgan hit area; yaqin obyektlardan eng yaqin markaz tanlanadi.

## 5. Quduq, suv va o‘t

### Quduq

Suv darhol ishlatishga tayyor zaxira sifatida saqlanadi. Quduq tugmasi narx, qolgan vaqt va suv sig‘imini ko‘rsatadi.

1. Zaxira to‘la bo‘lsa hech qanday pul olinmaydi.
2. Pul yetmasa yoki quduq band bo‘lsa yangi buyruq rad etiladi va sabab ko‘rsatiladi.
3. Buyruq qabul qilinganda narx bir marta olinadi, taymer boshlanadi.
4. Taymer tugaganda zaxira sig‘imgacha to‘ldiriladi. Bir vaqtda faqat bitta refill.

### O‘t

- Ferma maydoni kichik navigatsiya kataklariga bo‘linadi; har katakka bitta o‘t patch’i ekiladi.
- 1 suv → bitta patch. Bo‘sh va yurish mumkin bo‘lgan katakka ekiladi.
- O‘t yo‘q bo‘lsa hayvon eng yaqin o‘tni qidiradi, topilmasa wandering holatiga o‘tadi.
- Bitta patch’ni faqat bitta hayvon band qiladi. Yetib kelguncha patch yo‘qolsa qayta nishon tanlaydi.
- Patch 3 porsiya oziq beradi; har yeyishdan keyin kichrayadi. Ishlatilmagan patch vaqt o‘tishi bilan quriydi.

## 6. Hayvonlar va mahsulotlar

Har hayvonning `id`, `type`, `position`, `state`, `hunger`, `productionProgress` va `targetId` qiymati bor. Harakatlar Flame’da ko‘rinsa ham, barcha iqtisodiy qarorlar engine ichida amalga oshadi.

| Hayvon | Vazifa | Oziq | Boshlang‘ich cheklov |
|---|---|---|---|
| O‘rdak | Tuxum chiqaradi | O‘t | Level bo‘yicha ochiladi |
| Qo‘y | Jun chiqaradi | O‘t | Level 4 dan |
| Sigir | Sut chiqaradi | O‘t | Level 7 dan |
| Mushuk | Yerdagi mahsulotni omborga tashiydi | Ochlik tizimi yo‘q | Level 3 dan, max 2 |
| It | Ayiqni vaqtincha ushlab turadi | Ochlik tizimi yo‘q | Level 6 dan, max 2 |
| Ayiq | Xavf; katakka olinib sotilishi mumkin | — | Level 5 dan |

### Oziqlanish va ishlab chiqarish

- O‘rdak, qo‘y va sigir ochligi 100 dan boshlanadi; 60 dan pastda ovqat qidiradi.
- O‘t yeyish 2 s davom etadi va 35 ochlik tiklaydi, maksimum 100.
- Ochlik >20 bo‘lganda ishlab chiqarish taymeri yuradi; undan pastda to‘xtaydi, progress yo‘qolmaydi.
- Ochlik 0 bo‘lsa 12 s ogohlantirish grace davri boshlanadi. Shu davrda ovqatlansa tiklanadi; bo‘lmasa hayvon fermadan ketadi.
- Ketish vizual chiqish animatsiyasi bilan bo‘ladi; hayvonlar o‘lgan ko‘rinishda tasvirlanmaydi.
- Mahsulot hayvon yaqinidagi bo‘sh joyda bitta instance sifatida paydo bo‘ladi. Keyingi sikl qaytadan boshlanadi.
- Yer to‘lib qolsa production taymeri to‘lgan holda kutadi; progress yoki mahsulot yashirincha yo‘qolmaydi.

### Mahsulot yig‘ish

- Tuxum/jun/sut bosilganda omborda joy bo‘lsa atomar ravishda o‘chadi va inventory’ga qo‘shiladi.
- Joy yo‘q bo‘lsa mahsulot yerda qoladi, “Ombor to‘la” ko‘rsatiladi; yig‘ildi hisoblanmaydi.
- Har mahsulot 45 s yerda turadi, oxirgi 8 s’da miltillaydi, keyin yo‘qoladi.
- Bir obyektga takror bosish yoki mushuk bilan bir vaqtdagi tap faqat bitta mahsulot beradi.

### Mushuk

- Eng yaqin bo‘sh mahsulotni band qiladi → yetib boradi → oladi → omborga boradi → topshiradi.
- Yo‘lga chiqishdan oldin ombor joyini reserve qiladi; yo‘lda yangi yig‘ish bu joyni olib qo‘ymaydi.
- Qo‘lda yig‘ish rezervlangan mahsulotni ham olsa bo‘ladi: mushukning target’i va sig‘im rezervi bo‘shatiladi.
- Mushukning qo‘lidagi mahsulot endi eskirmaydi; holat snapshot ichida saqlanadi.
- Mushuk sotuvga tanlanayotganda olib ketayotgan mahsulot avval omborga topshiriladi; topshirilmasa sotish rad etiladi.

## 7. Ayiq va it himoyasi

1. Ayiq uchun 2 s oldindan ogohlantirish belgisi va ixtiyoriy ovoz.
2. Ferma ichidagi xavfsiz spawn joyiga tushadi; darhol hayvon ustiga tushib zarar bermaydi.
3. 3 s kirish grace’idan keyin eng yaqin ishlab chiqaruvchi hayvonga yuradi.
4. Yetib olsa hayvon fermadan qochadi; it/mushukni nishonlamaydi. Har zarar orasida 5 s cooldown.
5. O‘yinchi ayiqni bosib cage progress’ini to‘ldiradi: 5 tap. 2 s bosilmasa progress asta kamayadi.
6. Cage to‘lganda ayiq harakati to‘xtaydi; “katakni yig‘ish” tap’i bilan omborga olinadi.
7. Ombor to‘la bo‘lsa cage yerda qoladi; 20 s ichida olinmasa ayiq ozod bo‘ladi va progress tozalanadi.

It bo‘lsa eng yaqin bo‘sh it ayiqni 8 s ushlab turadi, shu davrda ayiq zarar bermaydi. It yo‘qolmaydi; keyin 20 s dam oladi. Bir ayiqni bir vaqtda faqat bitta it ushlaydi. It ushlab turganda ham o‘yinchi cage yasashi kerak. It to‘qnashuvi hech qanday pul yoki mahsulot yaratmaydi.

Bir vaqtda maksimum 2 ayiq; spawn joyi xavfsiz bo‘lmasa keyingi urinish kechiktiriladi. Faol himoyadagi itni sotuvga yuklab bo‘lmaydi.

## 8. Ombor, mashina va savdo

### Ombor

Sig‘im mahsulot soni bilan emas, **hajm birligi** bilan o‘lchanadi. Tuxum 1, jun 2, sut 3, cage bear 6 birlik oladi. Uy hayvonlari fermada turadi, ombor sig‘imini olmaydi. HUD ishlatilgan/reservlangan/umumiy joyni ko‘rsatadi.

### Savdo paneli

- Mahsulotlar uchun −/+, mavjud son, narx va hajm; hayvonlar uchun tur/son va tasdiqlash.
- Loading draft pulga yoki inventory’ga ta’sir qilmaydi. Bekor qilish holatni o‘zgartirmaydi.
- “Jo‘natish” bosilganda draft qayta tekshiriladi: son yetishi, mashina sig‘imi, hayvon mavjudligi va busy holati.
- Qabul qilingach yuk bir operatsiyada inventory/fermadan olinadi, mashina `away` bo‘ladi va manifest snapshot’da saqlanadi.
- Sotilgan hayvonlar shu zahoti ishlab chiqarishni to‘xtatadi. Pul faqat mashina qaytganda tushadi.
- Mashina band bo‘lsa ikkinchi yuk jo‘natilmaydi. Bo‘sh yuk jo‘natish mumkin emas.
- Mashina qaytganda manifest summasi aynan bir marta beriladi, so‘ng manifest tozalanadi.
- Zero hayvon qolsa ham mashina qaytishini kutib yangisini sotib olish mumkin.
- Restart level boshlang‘ich holatga qaytaradi; eski manifest ham, undan pul olish huquqi ham qolmaydi.

Uy hayvonlarini sotish mumkin: o‘rdak, qo‘y, sigir, mushuk, it. Sotib olish narxi sotish narxidan yuqori; buy/sell orqali cheksiz pul topib bo‘lmaydi. O‘yinchi so‘nggi ishlab chiqaruvchi hayvonni sotayotganida qisqa tasdiqlash ko‘rsatiladi.

## 9. Boshlang‘ich balans — playtest’da sozlanadi

Barcha qiymatlar bitta `FarmBalance` va level konfiguratsiyalarida saqlanadi; bu yakuniy balans emas.

| Parametr | Dastlabki qiymat |
|---|---|
| Quduq sig‘imi / refill narxi / vaqt | 10 suv / 20 coin / 3 s |
| O‘t ekish / qurish | 1 suv / 30 s |
| Ochlik kamayishi | Har s’da 1.5 birlik |
| O‘rdak: sotib olish / sotish / production | 100 / 50 coin / 12 s |
| Qo‘y: sotib olish / sotish / production | 500 / 250 coin / 20 s |
| Sigir: sotib olish / sotish / production | 1500 / 750 coin / 30 s |
| Mushuk: sotib olish / sotish | 250 / 125 coin |
| It: sotib olish / sotish | 300 / 150 coin |
| Tuxum / jun / sut / cage bear sotilishi | 25 / 100 / 250 / 150 coin |
| Ombor sig‘imi / mashina sig‘imi | 20 / 10 birlik |
| Mashina safari | 12 s |
| Maksimum ishlab chiqaruvchi hayvon | 12 |
| Yerda mahsulot / o‘t patch limiti | 30 / 24 |

Upgrade darajalari level ichida ishlaydi va keyingi levelga ko‘chmaydi. Quduq: sig‘im 10→15→20, narx 100/200; ombor: 20→35→50, narx 150/300; mashina: 10→18→26 hajm va 12→10→8 s, narx 200/400. Upgrade tugmasi natija va narxni oldindan ko‘rsatadi; sig‘im hech qachon kamaymaydi. Quduq upgrade’i qo‘shimcha bepul suv bermaydi.

## 10. Level, vazifa va medal qoidalari

- 1-level ochiq; level yutilsa keyingisi ochiladi. Ochilgan levelni qayta o‘ynash mumkin.
- Pul, ferma hayvonlari va upgrade’lar har level konfiguratsiyasidan boshlanadi. Doimiy global coin wallet yo‘q.
- Bir leveldagi barcha maqsadlar AND bilan tekshiriladi.
- `collectProduct`: omborga muvaffaqiyatli topshirilgan mahsulotlar yig‘indisi; keyin sotish progress’ni kamaytirmaydi.
- `sellProduct` / `sellAnimal`: faqat mashina qaytib savdo yakunlanganda hisoblanadi.
- `ownAnimal`: ayni paytdagi fermadagi son; yuklangan/sotilgan hayvonlar kirmaydi.
- `captureBear`: cage yasalganda hisoblanadi, bir bear ID uchun bir marta.
- `earnCoins`: faqat savdodan kelgan umumiy tushum; boshlang‘ich coin kirmaydi. `haveCoins` alohida joriy balans.
- Vazifalar tugashi har simulyatsiya qadamida tekshiriladi; completed bo‘lgach taymer va iqtisod to‘xtaydi.
- Gold/silver chegarasi levelda beriladi; undan sekinroq bajarilgan run bronze oladi. Vaqt o‘tishi avtomatik failure emas.
- Yaxshiroq medal va tezroq completion time saqlanadi; yomonroq replay rekordni buzmaydi.
- Failure faqat yutib bo‘lmaydigan holatda: ishlab chiqaruvchi hayvon, yig‘iladigan mahsulot, savdo yuki yo‘q va pul eng arzon ochilgan ishlab chiqaruvchiga yetmaydi. Statik level validator’i boshlang‘ich holat bunday emasligini tekshiradi.

### 12 levelning dastlabki kontenti

Jadvaldagi vaqtlar **gold / silver**, sekundlarda. Boshlang‘ich suv 10; boshlang‘ich o‘t 6 patch. Qo‘shimcha shart yozilmasa ombor/mashina/quduq 1-darajada. Har levelning to‘liq typed konfiguratsiyasi implementatsiyada alohida faylda bo‘ladi.

| № | Boshlang‘ich hayvon / coin | Maqsadlar | Ayiq jadvali | Vaqt |
|---|---|---|---|---|
| 1 | 2 o‘rdak / 80 | 4 tuxum yig‘ish | Yo‘q | 50 / 90 |
| 2 | 2 o‘rdak / 100 | 6 tuxum sotish | Yo‘q | 90 / 140 |
| 3 | 3 o‘rdak, 1 mushuk / 100 | 10 tuxum yig‘ish, 150 coin tushum | Yo‘q | 100 / 160 |
| 4 | 2 o‘rdak, 1 qo‘y / 150 | 3 jun sotish, 6 tuxum yig‘ish | Yo‘q | 110 / 180 |
| 5 | 3 o‘rdak, 1 qo‘y / 150 | 1 ayiq tutish, 8 tuxum yig‘ish | 35 s’da 1 | 100 / 170 |
| 6 | 3 o‘rdak, 1 it / 200 | 2 ayiq tutish, 10 tuxum sotish | 30, 70 s | 140 / 210 |
| 7 | 2 o‘rdak, 1 sigir / 200 | 3 sut sotish, 6 tuxum yig‘ish | Yo‘q | 140 / 220 |
| 8 | 2 o‘rdak, 1 qo‘y, 1 sigir, 1 mushuk / 250 | 1000 coin tushum | 45 s’da 1 | 170 / 260 |
| 9 | 4 o‘rdak, 1 mushuk / 300 | 1 qo‘yga ega bo‘lish, 4 jun yig‘ish | 40 s’dan har 60 s | 190 / 290 |
| 10 | 2 qo‘y, 1 sigir, 1 it / 250 | 6 jun sotish, 4 sut sotish | 40 s’dan har 55 s | 200 / 300 |
| 11 | 3 o‘rdak, 2 qo‘y, 1 sigir / 500 | 1 o‘rdak sotish, 2 ayiq tutish, 1200 coin tushum | 35 s’dan har 50 s | 220 / 330 |
| 12 | 3 o‘rdak, 2 qo‘y, 1 sigir, 1 mushuk, 1 it / 400 | 2000 coin tushum, 4 ayiq tutish, 1 sigirga ega bo‘lish | 30 s’dan har 45 s | 260 / 380 |

Tutorial level 1’da suv/o‘t/yig‘ish; level 2’da savdo; level 3’da mushuk; level 4’da jun; level 5’da ayiq; level 6’da it; level 7’da sutni tanishtiradi. Tutorial bosqichida tegishli target ajratiladi, boshqa simulyatsiya pauzada turadi. Skip bor, keyin Help’dan qayta ko‘rish mumkin.

## 11. UI va animatsiya talablari

**Uslub:** original yumshoq 2D/cartoon ferma; yashil maydon, yog‘och ombor, moviy quduq. Game Hub’dagi clay tugmalar va modal panellardan foydalaniladi. Gameplay maydonida qalin blur effektlar bo‘lmaydi.

Ekranlar: menu → level select → brief → farm → pause → result. Farm ichida warehouse/truck sheet, animal shop, upgrade sheet va help mavjud. Modal panel ortidagi obyektlar bosilmaydi.

- Hayvonlar: idle, walk, eat, produce, hungry, flee; mushukda carry, itda defend/rest.
- Suv: quduq arqoni/chelak, progress halqa; suv to‘lganda yengil splash.
- O‘t: paydo bo‘lish scale animatsiyasi, yeyilganda kichrayish.
- Mahsulot: tug‘ilganda pop; olinganda omborga uchish, +son bildirishi.
- Mashina: yuklangan ko‘rinish → chiqib ketish → countdown → qaytish → +coin.
- Ayiq: warning → kirish → walk → cage qurilishi → escape yoki omborga olish.
- Result: bajarilgan vazifalar, vaqt, medal, rekord, replay/next/menu.
- Reduce-motion mavjud bo‘lsa bezak animatsiyalari qisqaradi; o‘yin feedback’i tushunarli qoladi.
- Ovoz va vibration mustaqil o‘chiriladi; toggle darhol ta’sir qiladi. Yo‘q yoki buzilgan audio o‘yinni yiqitmaydi.
- “Ombor to‘la”, “Suv yo‘q”, “Mashina safarda”, “Pul yetmaydi” sababli rad etilgan amallar aniq xabar beradi; takror xabar spam qilinmaydi.

## 12. Mavjud loyiha bilan texnik moslashuv

Local source tekshirildi: `flame`, `flame_audio`, `flutter_bloc`, `equatable`, `shared_preferences`, `easy_localization`, `json_serializable` allaqachon bor. Routing `AppRouter.onGenerateRoute` orqali; yangi global router yoki DI migratsiyasi kerak emas. Hozirgi UI nomi Game Hub, lekin import prefiksi `package:grid_wars/` bo‘lib qoladi.

### Qatlamlar va ma’lumot oqimi

`Flutter UI / Flame input → FarmCommand → FarmEngine → FarmSnapshot + FarmEvent → FarmSessionCubit → UI / Flame renderer`.

- **FarmEngine:** Flutter/Flame’siz Dart. Pul, taymer, hayvon, vazifa, inventar va barcha qoidalar shu yerda. Test uchun seeded Random va simulyatsiya clock’i beriladi.
- **Flame:** ko‘rinish, kamera, input koordinatalari va animatsiyalar. Alohida iqtisodiy state saqlamaydi. Entity ID orqali engine obyektlariga mos keladi.
- **FarmSessionCubit:** command qabul qiladi, engine’ni yurgizadi, event va UI snapshot’ni e’lon qiladi. UI uchun 5–10 Hz kifoya; muhim amal darhol chiqariladi.
- **FarmProgressCubit:** save, unlock, medal va best-time o‘qish/yozish, saqlash xatosini ko‘rsatish.
- **FarmSaveRepository:** injected storage adapter orqali mavjud `StorageRepository`dan foydalanadi; engine statik storage’ga murojaat qilmaydi.
- Flame komponentlariga `BuildContext` berilmaydi. Shared state mutable list sifatida qayta ishlatilmaydi.
- FlameGame instance `initState`da bir marta yaratiladi; rebuild’da qayta yaratilmaydi.
- Rasm va hitbox ajratiladi: ko‘rinadigan `PositionComponent` ichida child hitbox; barcha hitbox’lar valid parent’ga ega bo‘ladi.
- Obuna/audio/input resurslari dispose/onRemove’da bo‘shatiladi. Pause’da lifecycle ishlashi uchun engine boshqaruvi aniq sinovdan o‘tadi.
- Obyekt limitlari, target reservation va oddiy navigatsiya grid’i ishlatiladi; og‘ir physics kutubxonasi shart emas.

### Taklif etilgan papka tuzilmasi

```text
lib/feature/farmstead/
  domain/
    entities/
      farm_snapshot.dart, farm_command.dart, farm_event.dart
      animal_state.dart, product_state.dart, grass_patch.dart
      warehouse_state.dart, truck_state.dart, well_state.dart
      level_definition.dart, level_goal.dart, level_result.dart
    services/
      farm_engine.dart, farm_economy.dart, farm_navigation.dart
      animal_system.dart, product_system.dart, bear_system.dart
      grass_system.dart, truck_system.dart, goal_system.dart
    config/
      farm_balance.dart
      levels/farm_levels.dart, tutorial_levels.dart, advanced_levels.dart
  data/
    models/farm_save_model.dart, farm_progress_model.dart
    repositories/farm_save_repository.dart
  game/
    farm_game.dart, farm_input.dart, farm_feedback.dart
    components/farm_background.dart, animal_view.dart, product_view.dart
    components/grass_view.dart, building_view.dart, bear_view.dart
    components/truck_view.dart, farm_effects.dart
  presentation/
    blocs/farm_session_cubit/, farm_progress_cubit/
    pages/farmstead_page.dart
    overlays/farm_menu.dart, farm_hud.dart, farm_pause.dart, farm_result.dart
    sheets/animal_shop.dart, warehouse_sheet.dart, upgrade_sheet.dart
    widgets/goal_progress.dart, level_tile.dart, farm_tutorial.dart
assets/images/farmstead/
assets/audio/farmstead/
assets/CREDITS.md
test/farmstead/
docs/FARM_GAME_TECHNICAL_TASK_UZ.md
```

Fayllar odatda 250–300 qatordan kichik, maksimum 350 qator; generated `.g.dart` bu limitdan chiqariladi. Barcha systems bitta ulkan engine fayliga yig‘ilmaydi.

### Game Hub integratsiya nuqtalari

1. `lib/core/enums/home_screen_apps.dart`: `farmstead`, aniq farm icon’i va display name.
2. `lib/core/constants/game_accent_colors.dart`: ferma uchun alohida mos accent.
3. `lib/core/router/app_router.dart`: `/farmstead` va route-scoped Cubit’lar.
4. `lib/feature/home/presentation/pages/home_screen.dart`: 3 ustunli grid’ga karta; active flag bilan bir xil ro‘yxat ishlashi kerak.
5. `lib/feature/game_stats/domain/entities/game_stat_definition.dart`: Levels completed counter. Har unique run completion bir marta yoziladi; replay ham yangi run sifatida sanaladi.
6. `GameStatsService.recordCompletion('farmstead')`: level yutilganda. Turli level vaqtlarini bitta global best’ga solishtirmaslik; level best’lari farm progress ichida.
7. Daily Challenge: “Istalgan bitta ferma levelini bajaring”; `notifyGameCompleted('farmstead')` faqat successful completion’da.
8. Profile: farm card orqali ochilgan level, medallar va har levelning best time’ini ko‘rish.

## 13. Local saqlash va tiklash

`shared_preferences` kichik JSON snapshot uchun ishlatiladi. Asset fayllari, frame history yoki cheksiz event log saqlanmaydi. JSON schema version bilan yoziladi; model uchun json_serializable ishlatiladi.

| Kalit | Turi | Mazmun |
|---|---|---|
| `farmstead.save.v1` | JSON String | active run + progress + settings bo‘lgan bitta to‘liq envelope |
| `farmstead.save.backup.v1` | JSON String | oxirgi valid envelope |

Envelope: `schemaVersion`, `contentVersion`, `revision`, `savedAt`, `settings`, `progress`, `activeRun`. Run: `runId`, `levelId`, `seed/rngState`, elapsed simulation time, coins, water/refill, barcha hayvon/product/grass ID va holati, ombor inventory/reservations, truck manifest/timer, bear schedule/cage state, upgrade darajalari, maqsad counter’lari, tutorial step.

- RNG’ni tiklash uchun serializable deterministic generator state’i saqlanadi; seed’ning o‘zi yetarli emas.
- Entity ID monoton counter’i ham saqlanadi; qaytishda ID collision bo‘lmaydi.
- Autosave: muhim savdo/upgrade/level transition’da va playing vaqtida har 5 s’da, ketma-ket queue orqali.
- Yozishdan oldin envelope validatsiya qilinadi; avvalgi valid nusxa backup’ga, yangi nusxa primary’ga yoziladi. Bu database transaction kafolati emas; xatoda recovery yo‘li kerak.
- Snapshot yozilmagan bo‘lsa “Saqlandi” deyilmaydi; retry va oxirgi valid holatdan continue mavjud.
- Buzilgan JSON, noto‘g‘ri field type, noma’lum entity/level, manfiy son va invalid capacity tekshiriladi. Primary buzilsa backup’dan tiklanadi; ikkisi ham buzilsa yangi o‘yin taklif qilinadi, crash bo‘lmaydi.
- Future schema avtomatik overwrite qilinmaydi; mos kelmaydigan save uchun tushunarli xabar.
- Completed run uchun medal/progress va activeRun tozalanishi bitta envelope’da yoziladi; reload dublikat mukofot bermaydi.
- Savdo puli alohida callback/real timer orqali emas, engine manifest state transition orqali beriladi.
- Save uninstallation/app data clear’da yo‘qolishi mumkin; birinchi release cloud sync va boshqa qurilmaga transfer qilmaydi.

## 14. Lokalizatsiya

Mavjud `easy_localization` ishlatiladi: `assets/translations/en.json`, `uz.json`, `ru.json`; yangi ARB tizimi kiritilmaydi. Barcha yangi matnlar uch tilda va `LocaleKeys` orqali, placeholder’lar named args bilan yoziladi.

Kalitlar `farmstead.*` namespace’ida: title, start, continue, level, goals, coins, water, refill, growGrass, warehouse, truck, dispatch, returnIn, sell, buy, upgrade, capacity, full, insufficientCoins, noWater, busy, pause, resume, restart, menu, completed, failed, medal, bestTime, saveError, bearWarning, cage, animals.*, products.*, tutorial.* va help.*.

Misollar: uz “Quduqni bosib suv oling”, en “Tap the well to draw water”; uz “Ombor to‘la”, en “Warehouse full”; uz “Mashina {seconds} s’da qaytadi”, en “Truck returns in {seconds}s”. Son, valyuta, vaqt va ko‘plik locale’ga mos chiqariladi. Nickname kerak emas: mavjud offline profil yetarli.

## 15. Asset, audio va app hajmi

- Dastlab ishlaydigan prototip original canvas shakllari bilan; ular ko‘rinadigan render va haqiqiy input nishonlariga ega bo‘lishi shart.
- Release uchun original animated sprites: 6 hayvon, 3 mahsulot, cage, quduq, ombor, mashina, o‘t, fon va UI ikonkalari.
- Animal atlas’lari o‘lchami ekran ehtiyojiga mos; katta fotografik rasm va ortiqcha fontlar qo‘shilmaydi.
- Qisqa effektlar: suv, o‘t ekish, yig‘ish, coin, mashina, bear warning, cage, success/fail; optional bitta loop musiqasi.
- Har asset uchun file/author/license/source `assets/CREDITS.md`ga yoziladi; o‘zimiz chizgan fayl ham qayd etiladi.
- Target: yangi modulning compressed asset budget’i 5 MB gacha. Yakuniy Play AAB/download hajmi release tekshiruvida o‘lchanadi; bu kafolatlangan raqam emas.
- Assetlar faqat farm sahifasi ochilganda yuklanadi. Yuklash paneli va xatoda retry bor; app startup’da katta atlas preload qilinmaydi.
- Papkalar `pubspec.yaml`ga aniq kiritiladi; yo‘q audio qayta-qayta har frame’da yuklanmaydi.

## 16. Test va qabul qilish mezonlari

### Avtomatik test vazifalari

- Quduq: pul yetmasligi, to‘liq suv, parallel refill rad etilishi, pause/resume.
- Grass/animal: reservation, ovqat yetmasligi, ishlab chiqarish, ochlik grace’i, max limit.
- Collection: manual/cat bir vaqtda — bir item, bitta inventory increment; to‘la omborda yo‘qolmaslik.
- Cat: target yo‘qolishi, joy reservation’ini qaytarish, carry snapshot va sotishni rad etish.
- Truck: sig‘im, manifest, cancel, sotilgan hayvonning ishlab chiqarmasligi; reload’dan keyin pul bir marta.
- Bear/dog: ogohlantirish/grace, cage 5 tap, cage escape, stun/cooldown, ikki it bitta bear’ni band qilmasligi.
- Goals: collect va sell farqi, spend’dan keyin cumulative earn, own counter, medal chegaralari, repeat completion.
- Save: round-trip barcha taymerlar, buzilgan JSON/type, backup, migration, kelajak schema, interrupted write va takror resume.
- Seeded simulation: bir xil command+dt ketma-ketligi bir xil natija beradi; pause/offline vaqt hech narsani o‘zgartirmaydi.
- UI tests: asosiy action tugmalari, input layer, fullscreen canvas, dialog provider scope, kichik ekran/text scaling overflow.

### Release uchun qabul qilish ro‘yxati

- [ ] Android airplane mode’da yangi run va resume ishlaydi.
- [ ] Quduq → o‘t → oziqlanish → mahsulot → ombor → savdo sikli to‘liq ishlaydi.
- [ ] O‘rdak, qo‘y, sigir mahsulotlari alohida va taniqli ko‘rinadi.
- [ ] Mushuk yig‘adi, it ayiqdan vaqtincha himoya qiladi, ayiq qo‘lda cage’lanadi.
- [ ] Uy hayvoni va cage bear sotilishi to‘g‘ri; cargo/pul ko‘paytirish bug’i yo‘q.
- [ ] Barcha 12 level starter config’dan bajarilishi mumkin; manual balans tekshiruvi o‘tgan.
- [ ] App background va Back gameplay’ni xavfsiz pauza qiladi.
- [ ] Kill/reopen’dan keyin inventory, hayvonlar va mashina safar holati tiklanadi.
- [ ] UI English/Uzbek/Russian’da to‘liq; 320–430 dp telefonlarda asosiy tugmalar ochiq.
- [ ] Animatsiya, collect feedback va hit target joylari ko‘rinish bilan mos.
- [ ] O‘rtacha Android qurilmada 60 FPS target; DevTools profilida uzoq stall yo‘q.
- [ ] Farm fayllari 350 qatordan oshmaydi; scoped analyzer va tegishli testlar clean.
- [ ] Asset license credits bor, modul asset budget’i tekshirilgan.
- [ ] Game Hub Home/Profile/Daily Challenge integratsiyasi ishlaydi.

**Joriy foydalanuvchi cheklovi:** agent ilovani/simulatorni ishga tushirmaydi. Qurish vaqtida code review va ruxsat etilgan static analyze bajariladi; device, FPS, release size va manual gameplay mezonlari foydalanuvchi tekshiruvigacha “verified” deb belgilanmaydi. Mavjud `test/widget_test.dart` counter smoke failure’i alohida eski muammo sifatida ajratiladi.

## 17. Bosqichma-bosqich ishlar va Definition of Done

| Bosqich | Aniq ish | Tugallanish sharti |
|---|---|---|
| F01 — Poydevor | Module skeleton, route, Home tile, config/model, original canvas prototype | Menu/level/farm UI kodda ulangan; analyze clean |
| F02 — Core loop | Well, grass, duck, egg, hunger, tap collect | Birinchi level sikli deterministic engine test’lari bilan qoplangan |
| F03 — Iqtisod | Warehouse, truck draft/manifest, buy/sell, upgrades | Capacity/coin/dispatch invariant test’lari clean |
| F04 — Barcha hayvonlar | Sheep/cow, cat collection, dog protection, bear cage | Olti animal turi va ularning asosiy scenariylari to‘liq |
| F05 — Progress/save | Schema, queue, autosave, resume, migration, medal/unlock | Save/reload va duplicate-reward test’lari clean |
| F06 — Kontent/UI | 12 level, tutorials, barcha sheets, uz/en/ru, help | Level konfiguratsiyalari valid, barcha action’lar tushunarli |
| F07 — Sayqal | Original sprites/audio, batching, animation, accessibility | Credits va asset budget; foydalanuvchi manual review’i |
| F08 — Release | Profile/Daily, regression, Android manual QA, release notes | Qabul qilish ro‘yxati bajarilgan; Play release uchun tayyor |

Bosqichlar birma-bir bajariladi. Har bosqich review qilinadigan kichik natija beradi; butun ferma bitta tekshirilmagan katta o‘zgarishga yig‘ilmaydi. Muddat asset tayyorligi va foydalanuvchi device review’iga bog‘liq, hozir qat’iy kun va’da qilinmaydi.

## 18. Birinchi qurish vazifasi

**Keyingi ish:** F01 va F02 — Game Hub ichida original Farmstead sahifasi, ko‘rinadigan quduq/o‘t/o‘rdak/tuxum/ombor prototipi, tap-to-collect, suv sarfi va birinchi tutorial level. Engine qoidalari bilan rendering boshidan ajratiladi. Shu vertikal bo‘lak tayyor bo‘lgach iqtisod va qolgan hayvonlar ketma-ket qo‘shiladi.

Ushbu hujjat hozirgi dizayn qarorlarini belgilaydi. Narx, vaqt va level medal chegaralari haqiqiy o‘ynash natijasiga ko‘ra config orqali sozlanadi; user aytgan asosiy mexanikalar — suv, olti hayvon, mahsulotlar, ombor va savdo — birinchi release scope’ida qoladi.
