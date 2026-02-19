/// Prefecture and city data for Japan (都道府県 + 主要市区町村).
///
/// Data source: JIS X 0401 (都道府県コード), 総務省統計局
/// https://www.soumu.go.jp/
///
/// Includes: 47 prefectures with major cities
/// (特別区 23 区, 政令指定都市の区, 県庁所在地, 人口 10 万以上の市).
library;

class Prefecture {
  final String code; // JIS X 0401 (e.g., "13")
  final String nameJa; // 東京都
  final String nameEn; // Tokyo
  final List<City> cities;

  const Prefecture({
    required this.code,
    required this.nameJa,
    required this.nameEn,
    required this.cities,
  });
}

class City {
  final String nameJa; // 新宿区
  final String nameEn; // Shinjuku

  const City({required this.nameJa, required this.nameEn});
}

const List<Prefecture> prefectures = [
  // ── 01 北海道 ──────────────────────────────────────────
  Prefecture(
    code: '01',
    nameJa: '北海道',
    nameEn: 'Hokkaido',
    cities: [
      City(nameJa: '札幌市中央区', nameEn: 'Sapporo Chuo'),
      City(nameJa: '札幌市北区', nameEn: 'Sapporo Kita'),
      City(nameJa: '札幌市東区', nameEn: 'Sapporo Higashi'),
      City(nameJa: '札幌市白石区', nameEn: 'Sapporo Shiroishi'),
      City(nameJa: '札幌市豊平区', nameEn: 'Sapporo Toyohira'),
      City(nameJa: '札幌市南区', nameEn: 'Sapporo Minami'),
      City(nameJa: '札幌市西区', nameEn: 'Sapporo Nishi'),
      City(nameJa: '札幌市厚別区', nameEn: 'Sapporo Atsubetsu'),
      City(nameJa: '札幌市手稲区', nameEn: 'Sapporo Teine'),
      City(nameJa: '札幌市清田区', nameEn: 'Sapporo Kiyota'),
      City(nameJa: '旭川市', nameEn: 'Asahikawa'),
      City(nameJa: '函館市', nameEn: 'Hakodate'),
      City(nameJa: '釧路市', nameEn: 'Kushiro'),
      City(nameJa: '苫小牧市', nameEn: 'Tomakomai'),
      City(nameJa: '帯広市', nameEn: 'Obihiro'),
      City(nameJa: '小樽市', nameEn: 'Otaru'),
      City(nameJa: '北見市', nameEn: 'Kitami'),
      City(nameJa: '江別市', nameEn: 'Ebetsu'),
    ],
  ),

  // ── 02 青森県 ──────────────────────────────────────────
  Prefecture(
    code: '02',
    nameJa: '青森県',
    nameEn: 'Aomori',
    cities: [
      City(nameJa: '青森市', nameEn: 'Aomori'),
      City(nameJa: '八戸市', nameEn: 'Hachinohe'),
      City(nameJa: '弘前市', nameEn: 'Hirosaki'),
    ],
  ),

  // ── 03 岩手県 ──────────────────────────────────────────
  Prefecture(
    code: '03',
    nameJa: '岩手県',
    nameEn: 'Iwate',
    cities: [
      City(nameJa: '盛岡市', nameEn: 'Morioka'),
      City(nameJa: '一関市', nameEn: 'Ichinoseki'),
      City(nameJa: '奥州市', nameEn: 'Oshu'),
    ],
  ),

  // ── 04 宮城県 ──────────────────────────────────────────
  Prefecture(
    code: '04',
    nameJa: '宮城県',
    nameEn: 'Miyagi',
    cities: [
      City(nameJa: '仙台市青葉区', nameEn: 'Sendai Aoba'),
      City(nameJa: '仙台市宮城野区', nameEn: 'Sendai Miyagino'),
      City(nameJa: '仙台市若林区', nameEn: 'Sendai Wakabayashi'),
      City(nameJa: '仙台市太白区', nameEn: 'Sendai Taihaku'),
      City(nameJa: '仙台市泉区', nameEn: 'Sendai Izumi'),
      City(nameJa: '石巻市', nameEn: 'Ishinomaki'),
      City(nameJa: '大崎市', nameEn: 'Osaki'),
    ],
  ),

  // ── 05 秋田県 ──────────────────────────────────────────
  Prefecture(
    code: '05',
    nameJa: '秋田県',
    nameEn: 'Akita',
    cities: [
      City(nameJa: '秋田市', nameEn: 'Akita'),
      City(nameJa: '横手市', nameEn: 'Yokote'),
    ],
  ),

  // ── 06 山形県 ──────────────────────────────────────────
  Prefecture(
    code: '06',
    nameJa: '山形県',
    nameEn: 'Yamagata',
    cities: [
      City(nameJa: '山形市', nameEn: 'Yamagata'),
      City(nameJa: '鶴岡市', nameEn: 'Tsuruoka'),
      City(nameJa: '酒田市', nameEn: 'Sakata'),
    ],
  ),

  // ── 07 福島県 ──────────────────────────────────────────
  Prefecture(
    code: '07',
    nameJa: '福島県',
    nameEn: 'Fukushima',
    cities: [
      City(nameJa: '福島市', nameEn: 'Fukushima'),
      City(nameJa: '郡山市', nameEn: 'Koriyama'),
      City(nameJa: 'いわき市', nameEn: 'Iwaki'),
      City(nameJa: '会津若松市', nameEn: 'Aizuwakamatsu'),
    ],
  ),

  // ── 08 茨城県 ──────────────────────────────────────────
  Prefecture(
    code: '08',
    nameJa: '茨城県',
    nameEn: 'Ibaraki',
    cities: [
      City(nameJa: '水戸市', nameEn: 'Mito'),
      City(nameJa: 'つくば市', nameEn: 'Tsukuba'),
      City(nameJa: '日立市', nameEn: 'Hitachi'),
      City(nameJa: 'ひたちなか市', nameEn: 'Hitachinaka'),
      City(nameJa: '土浦市', nameEn: 'Tsuchiura'),
      City(nameJa: '古河市', nameEn: 'Koga'),
      City(nameJa: '取手市', nameEn: 'Toride'),
    ],
  ),

  // ── 09 栃木県 ──────────────────────────────────────────
  Prefecture(
    code: '09',
    nameJa: '栃木県',
    nameEn: 'Tochigi',
    cities: [
      City(nameJa: '宇都宮市', nameEn: 'Utsunomiya'),
      City(nameJa: '小山市', nameEn: 'Oyama'),
      City(nameJa: '栃木市', nameEn: 'Tochigi'),
      City(nameJa: '足利市', nameEn: 'Ashikaga'),
    ],
  ),

  // ── 10 群馬県 ──────────────────────────────────────────
  Prefecture(
    code: '10',
    nameJa: '群馬県',
    nameEn: 'Gunma',
    cities: [
      City(nameJa: '前橋市', nameEn: 'Maebashi'),
      City(nameJa: '高崎市', nameEn: 'Takasaki'),
      City(nameJa: '太田市', nameEn: 'Ota'),
      City(nameJa: '伊勢崎市', nameEn: 'Isesaki'),
      City(nameJa: '桐生市', nameEn: 'Kiryu'),
    ],
  ),

  // ── 11 埼玉県 ──────────────────────────────────────────
  Prefecture(
    code: '11',
    nameJa: '埼玉県',
    nameEn: 'Saitama',
    cities: [
      City(nameJa: 'さいたま市西区', nameEn: 'Saitama Nishi'),
      City(nameJa: 'さいたま市北区', nameEn: 'Saitama Kita'),
      City(nameJa: 'さいたま市大宮区', nameEn: 'Saitama Omiya'),
      City(nameJa: 'さいたま市見沼区', nameEn: 'Saitama Minuma'),
      City(nameJa: 'さいたま市中央区', nameEn: 'Saitama Chuo'),
      City(nameJa: 'さいたま市桜区', nameEn: 'Saitama Sakura'),
      City(nameJa: 'さいたま市浦和区', nameEn: 'Saitama Urawa'),
      City(nameJa: 'さいたま市南区', nameEn: 'Saitama Minami'),
      City(nameJa: 'さいたま市緑区', nameEn: 'Saitama Midori'),
      City(nameJa: 'さいたま市岩槻区', nameEn: 'Saitama Iwatsuki'),
      City(nameJa: '川口市', nameEn: 'Kawaguchi'),
      City(nameJa: '川越市', nameEn: 'Kawagoe'),
      City(nameJa: '所沢市', nameEn: 'Tokorozawa'),
      City(nameJa: '越谷市', nameEn: 'Koshigaya'),
      City(nameJa: '草加市', nameEn: 'Soka'),
      City(nameJa: '春日部市', nameEn: 'Kasukabe'),
      City(nameJa: '上尾市', nameEn: 'Ageo'),
      City(nameJa: '熊谷市', nameEn: 'Kumagaya'),
      City(nameJa: '新座市', nameEn: 'Niiza'),
      City(nameJa: '狭山市', nameEn: 'Sayama'),
      City(nameJa: '久喜市', nameEn: 'Kuki'),
      City(nameJa: '入間市', nameEn: 'Iruma'),
      City(nameJa: '深谷市', nameEn: 'Fukaya'),
      City(nameJa: '三郷市', nameEn: 'Misato'),
      City(nameJa: '朝霞市', nameEn: 'Asaka'),
      City(nameJa: '戸田市', nameEn: 'Toda'),
      City(nameJa: '富士見市', nameEn: 'Fujimi'),
      City(nameJa: 'ふじみ野市', nameEn: 'Fujimino'),
    ],
  ),

  // ── 12 千葉県 ──────────────────────────────────────────
  Prefecture(
    code: '12',
    nameJa: '千葉県',
    nameEn: 'Chiba',
    cities: [
      City(nameJa: '千葉市中央区', nameEn: 'Chiba Chuo'),
      City(nameJa: '千葉市花見川区', nameEn: 'Chiba Hanamigawa'),
      City(nameJa: '千葉市稲毛区', nameEn: 'Chiba Inage'),
      City(nameJa: '千葉市若葉区', nameEn: 'Chiba Wakaba'),
      City(nameJa: '千葉市緑区', nameEn: 'Chiba Midori'),
      City(nameJa: '千葉市美浜区', nameEn: 'Chiba Mihama'),
      City(nameJa: '船橋市', nameEn: 'Funabashi'),
      City(nameJa: '松戸市', nameEn: 'Matsudo'),
      City(nameJa: '市川市', nameEn: 'Ichikawa'),
      City(nameJa: '柏市', nameEn: 'Kashiwa'),
      City(nameJa: '市原市', nameEn: 'Ichihara'),
      City(nameJa: '八千代市', nameEn: 'Yachiyo'),
      City(nameJa: '流山市', nameEn: 'Nagareyama'),
      City(nameJa: '佐倉市', nameEn: 'Sakura'),
      City(nameJa: '習志野市', nameEn: 'Narashino'),
      City(nameJa: '浦安市', nameEn: 'Urayasu'),
      City(nameJa: '野田市', nameEn: 'Noda'),
      City(nameJa: '木更津市', nameEn: 'Kisarazu'),
      City(nameJa: '我孫子市', nameEn: 'Abiko'),
      City(nameJa: '成田市', nameEn: 'Narita'),
    ],
  ),

  // ── 13 東京都 ──────────────────────────────────────────
  Prefecture(
    code: '13',
    nameJa: '東京都',
    nameEn: 'Tokyo',
    cities: [
      // 23 特別区
      City(nameJa: '千代田区', nameEn: 'Chiyoda'),
      City(nameJa: '中央区', nameEn: 'Chuo'),
      City(nameJa: '港区', nameEn: 'Minato'),
      City(nameJa: '新宿区', nameEn: 'Shinjuku'),
      City(nameJa: '文京区', nameEn: 'Bunkyo'),
      City(nameJa: '台東区', nameEn: 'Taito'),
      City(nameJa: '墨田区', nameEn: 'Sumida'),
      City(nameJa: '江東区', nameEn: 'Koto'),
      City(nameJa: '品川区', nameEn: 'Shinagawa'),
      City(nameJa: '目黒区', nameEn: 'Meguro'),
      City(nameJa: '大田区', nameEn: 'Ota'),
      City(nameJa: '世田谷区', nameEn: 'Setagaya'),
      City(nameJa: '渋谷区', nameEn: 'Shibuya'),
      City(nameJa: '中野区', nameEn: 'Nakano'),
      City(nameJa: '杉並区', nameEn: 'Suginami'),
      City(nameJa: '豊島区', nameEn: 'Toshima'),
      City(nameJa: '北区', nameEn: 'Kita'),
      City(nameJa: '荒川区', nameEn: 'Arakawa'),
      City(nameJa: '板橋区', nameEn: 'Itabashi'),
      City(nameJa: '練馬区', nameEn: 'Nerima'),
      City(nameJa: '足立区', nameEn: 'Adachi'),
      City(nameJa: '葛飾区', nameEn: 'Katsushika'),
      City(nameJa: '江戸川区', nameEn: 'Edogawa'),
      // 多摩地域の主要市
      City(nameJa: '八王子市', nameEn: 'Hachioji'),
      City(nameJa: '町田市', nameEn: 'Machida'),
      City(nameJa: '府中市', nameEn: 'Fuchu'),
      City(nameJa: '調布市', nameEn: 'Chofu'),
      City(nameJa: '西東京市', nameEn: 'Nishi-Tokyo'),
      City(nameJa: '三鷹市', nameEn: 'Mitaka'),
      City(nameJa: '立川市', nameEn: 'Tachikawa'),
      City(nameJa: '日野市', nameEn: 'Hino'),
      City(nameJa: '武蔵野市', nameEn: 'Musashino'),
      City(nameJa: '多摩市', nameEn: 'Tama'),
      City(nameJa: '青梅市', nameEn: 'Ome'),
      City(nameJa: '小平市', nameEn: 'Kodaira'),
      City(nameJa: '東村山市', nameEn: 'Higashimurayama'),
    ],
  ),

  // ── 14 神奈川県 ─────────────────────────────────────────
  Prefecture(
    code: '14',
    nameJa: '神奈川県',
    nameEn: 'Kanagawa',
    cities: [
      City(nameJa: '横浜市鶴見区', nameEn: 'Yokohama Tsurumi'),
      City(nameJa: '横浜市神奈川区', nameEn: 'Yokohama Kanagawa'),
      City(nameJa: '横浜市西区', nameEn: 'Yokohama Nishi'),
      City(nameJa: '横浜市中区', nameEn: 'Yokohama Naka'),
      City(nameJa: '横浜市南区', nameEn: 'Yokohama Minami'),
      City(nameJa: '横浜市保土ケ谷区', nameEn: 'Yokohama Hodogaya'),
      City(nameJa: '横浜市磯子区', nameEn: 'Yokohama Isogo'),
      City(nameJa: '横浜市金沢区', nameEn: 'Yokohama Kanazawa'),
      City(nameJa: '横浜市港北区', nameEn: 'Yokohama Kohoku'),
      City(nameJa: '横浜市戸塚区', nameEn: 'Yokohama Totsuka'),
      City(nameJa: '横浜市港南区', nameEn: 'Yokohama Konan'),
      City(nameJa: '横浜市旭区', nameEn: 'Yokohama Asahi'),
      City(nameJa: '横浜市緑区', nameEn: 'Yokohama Midori'),
      City(nameJa: '横浜市瀬谷区', nameEn: 'Yokohama Seya'),
      City(nameJa: '横浜市栄区', nameEn: 'Yokohama Sakae'),
      City(nameJa: '横浜市泉区', nameEn: 'Yokohama Izumi'),
      City(nameJa: '横浜市青葉区', nameEn: 'Yokohama Aoba'),
      City(nameJa: '横浜市都筑区', nameEn: 'Yokohama Tsuzuki'),
      City(nameJa: '川崎市川崎区', nameEn: 'Kawasaki Kawasaki'),
      City(nameJa: '川崎市幸区', nameEn: 'Kawasaki Saiwai'),
      City(nameJa: '川崎市中原区', nameEn: 'Kawasaki Nakahara'),
      City(nameJa: '川崎市高津区', nameEn: 'Kawasaki Takatsu'),
      City(nameJa: '川崎市多摩区', nameEn: 'Kawasaki Tama'),
      City(nameJa: '川崎市宮前区', nameEn: 'Kawasaki Miyamae'),
      City(nameJa: '川崎市麻生区', nameEn: 'Kawasaki Asao'),
      City(nameJa: '相模原市緑区', nameEn: 'Sagamihara Midori'),
      City(nameJa: '相模原市中央区', nameEn: 'Sagamihara Chuo'),
      City(nameJa: '相模原市南区', nameEn: 'Sagamihara Minami'),
      City(nameJa: '横須賀市', nameEn: 'Yokosuka'),
      City(nameJa: '藤沢市', nameEn: 'Fujisawa'),
      City(nameJa: '平塚市', nameEn: 'Hiratsuka'),
      City(nameJa: '茅ヶ崎市', nameEn: 'Chigasaki'),
      City(nameJa: '大和市', nameEn: 'Yamato'),
      City(nameJa: '厚木市', nameEn: 'Atsugi'),
      City(nameJa: '小田原市', nameEn: 'Odawara'),
      City(nameJa: '鎌倉市', nameEn: 'Kamakura'),
      City(nameJa: '秦野市', nameEn: 'Hadano'),
      City(nameJa: '座間市', nameEn: 'Zama'),
      City(nameJa: '海老名市', nameEn: 'Ebina'),
      City(nameJa: '伊勢原市', nameEn: 'Isehara'),
    ],
  ),

  // ── 15 新潟県 ──────────────────────────────────────────
  Prefecture(
    code: '15',
    nameJa: '新潟県',
    nameEn: 'Niigata',
    cities: [
      City(nameJa: '新潟市北区', nameEn: 'Niigata Kita'),
      City(nameJa: '新潟市東区', nameEn: 'Niigata Higashi'),
      City(nameJa: '新潟市中央区', nameEn: 'Niigata Chuo'),
      City(nameJa: '新潟市江南区', nameEn: 'Niigata Konan'),
      City(nameJa: '新潟市秋葉区', nameEn: 'Niigata Akiha'),
      City(nameJa: '新潟市南区', nameEn: 'Niigata Minami'),
      City(nameJa: '新潟市西区', nameEn: 'Niigata Nishi'),
      City(nameJa: '新潟市西蒲区', nameEn: 'Niigata Nishikan'),
      City(nameJa: '長岡市', nameEn: 'Nagaoka'),
      City(nameJa: '上越市', nameEn: 'Joetsu'),
    ],
  ),

  // ── 16 富山県 ──────────────────────────────────────────
  Prefecture(
    code: '16',
    nameJa: '富山県',
    nameEn: 'Toyama',
    cities: [
      City(nameJa: '富山市', nameEn: 'Toyama'),
      City(nameJa: '高岡市', nameEn: 'Takaoka'),
    ],
  ),

  // ── 17 石川県 ──────────────────────────────────────────
  Prefecture(
    code: '17',
    nameJa: '石川県',
    nameEn: 'Ishikawa',
    cities: [
      City(nameJa: '金沢市', nameEn: 'Kanazawa'),
      City(nameJa: '白山市', nameEn: 'Hakusan'),
      City(nameJa: '小松市', nameEn: 'Komatsu'),
    ],
  ),

  // ── 18 福井県 ──────────────────────────────────────────
  Prefecture(
    code: '18',
    nameJa: '福井県',
    nameEn: 'Fukui',
    cities: [
      City(nameJa: '福井市', nameEn: 'Fukui'),
    ],
  ),

  // ── 19 山梨県 ──────────────────────────────────────────
  Prefecture(
    code: '19',
    nameJa: '山梨県',
    nameEn: 'Yamanashi',
    cities: [
      City(nameJa: '甲府市', nameEn: 'Kofu'),
    ],
  ),

  // ── 20 長野県 ──────────────────────────────────────────
  Prefecture(
    code: '20',
    nameJa: '長野県',
    nameEn: 'Nagano',
    cities: [
      City(nameJa: '長野市', nameEn: 'Nagano'),
      City(nameJa: '松本市', nameEn: 'Matsumoto'),
      City(nameJa: '上田市', nameEn: 'Ueda'),
      City(nameJa: '飯田市', nameEn: 'Iida'),
    ],
  ),

  // ── 21 岐阜県 ──────────────────────────────────────────
  Prefecture(
    code: '21',
    nameJa: '岐阜県',
    nameEn: 'Gifu',
    cities: [
      City(nameJa: '岐阜市', nameEn: 'Gifu'),
      City(nameJa: '大垣市', nameEn: 'Ogaki'),
      City(nameJa: '各務原市', nameEn: 'Kakamigahara'),
      City(nameJa: '多治見市', nameEn: 'Tajimi'),
    ],
  ),

  // ── 22 静岡県 ──────────────────────────────────────────
  Prefecture(
    code: '22',
    nameJa: '静岡県',
    nameEn: 'Shizuoka',
    cities: [
      City(nameJa: '静岡市葵区', nameEn: 'Shizuoka Aoi'),
      City(nameJa: '静岡市駿河区', nameEn: 'Shizuoka Suruga'),
      City(nameJa: '静岡市清水区', nameEn: 'Shizuoka Shimizu'),
      City(nameJa: '浜松市中央区', nameEn: 'Hamamatsu Chuo'),
      City(nameJa: '浜松市浜名区', nameEn: 'Hamamatsu Hamana'),
      City(nameJa: '浜松市天竜区', nameEn: 'Hamamatsu Tenryu'),
      City(nameJa: '沼津市', nameEn: 'Numazu'),
      City(nameJa: '富士市', nameEn: 'Fuji'),
      City(nameJa: '磐田市', nameEn: 'Iwata'),
      City(nameJa: '焼津市', nameEn: 'Yaizu'),
      City(nameJa: '藤枝市', nameEn: 'Fujieda'),
      City(nameJa: '富士宮市', nameEn: 'Fujinomiya'),
    ],
  ),

  // ── 23 愛知県 ──────────────────────────────────────────
  Prefecture(
    code: '23',
    nameJa: '愛知県',
    nameEn: 'Aichi',
    cities: [
      City(nameJa: '名古屋市千種区', nameEn: 'Nagoya Chikusa'),
      City(nameJa: '名古屋市東区', nameEn: 'Nagoya Higashi'),
      City(nameJa: '名古屋市北区', nameEn: 'Nagoya Kita'),
      City(nameJa: '名古屋市西区', nameEn: 'Nagoya Nishi'),
      City(nameJa: '名古屋市中村区', nameEn: 'Nagoya Nakamura'),
      City(nameJa: '名古屋市中区', nameEn: 'Nagoya Naka'),
      City(nameJa: '名古屋市昭和区', nameEn: 'Nagoya Showa'),
      City(nameJa: '名古屋市瑞穂区', nameEn: 'Nagoya Mizuho'),
      City(nameJa: '名古屋市熱田区', nameEn: 'Nagoya Atsuta'),
      City(nameJa: '名古屋市中川区', nameEn: 'Nagoya Nakagawa'),
      City(nameJa: '名古屋市港区', nameEn: 'Nagoya Minato'),
      City(nameJa: '名古屋市南区', nameEn: 'Nagoya Minami'),
      City(nameJa: '名古屋市守山区', nameEn: 'Nagoya Moriyama'),
      City(nameJa: '名古屋市緑区', nameEn: 'Nagoya Midori'),
      City(nameJa: '名古屋市名東区', nameEn: 'Nagoya Meito'),
      City(nameJa: '名古屋市天白区', nameEn: 'Nagoya Tempaku'),
      City(nameJa: '豊田市', nameEn: 'Toyota'),
      City(nameJa: '岡崎市', nameEn: 'Okazaki'),
      City(nameJa: '一宮市', nameEn: 'Ichinomiya'),
      City(nameJa: '豊橋市', nameEn: 'Toyohashi'),
      City(nameJa: '春日井市', nameEn: 'Kasugai'),
      City(nameJa: '安城市', nameEn: 'Anjo'),
      City(nameJa: '豊川市', nameEn: 'Toyokawa'),
      City(nameJa: '西尾市', nameEn: 'Nishio'),
      City(nameJa: '刈谷市', nameEn: 'Kariya'),
      City(nameJa: '小牧市', nameEn: 'Komaki'),
      City(nameJa: '稲沢市', nameEn: 'Inazawa'),
      City(nameJa: '瀬戸市', nameEn: 'Seto'),
      City(nameJa: '半田市', nameEn: 'Handa'),
      City(nameJa: '東海市', nameEn: 'Tokai'),
      City(nameJa: '江南市', nameEn: 'Konan'),
      City(nameJa: '大府市', nameEn: 'Obu'),
    ],
  ),

  // ── 24 三重県 ──────────────────────────────────────────
  Prefecture(
    code: '24',
    nameJa: '三重県',
    nameEn: 'Mie',
    cities: [
      City(nameJa: '津市', nameEn: 'Tsu'),
      City(nameJa: '四日市市', nameEn: 'Yokkaichi'),
      City(nameJa: '鈴鹿市', nameEn: 'Suzuka'),
      City(nameJa: '松阪市', nameEn: 'Matsusaka'),
      City(nameJa: '桑名市', nameEn: 'Kuwana'),
      City(nameJa: '伊勢市', nameEn: 'Ise'),
    ],
  ),

  // ── 25 滋賀県 ──────────────────────────────────────────
  Prefecture(
    code: '25',
    nameJa: '滋賀県',
    nameEn: 'Shiga',
    cities: [
      City(nameJa: '大津市', nameEn: 'Otsu'),
      City(nameJa: '草津市', nameEn: 'Kusatsu'),
      City(nameJa: '長浜市', nameEn: 'Nagahama'),
      City(nameJa: '東近江市', nameEn: 'Higashiomi'),
      City(nameJa: '彦根市', nameEn: 'Hikone'),
    ],
  ),

  // ── 26 京都府 ──────────────────────────────────────────
  Prefecture(
    code: '26',
    nameJa: '京都府',
    nameEn: 'Kyoto',
    cities: [
      City(nameJa: '京都市北区', nameEn: 'Kyoto Kita'),
      City(nameJa: '京都市上京区', nameEn: 'Kyoto Kamigyo'),
      City(nameJa: '京都市左京区', nameEn: 'Kyoto Sakyo'),
      City(nameJa: '京都市中京区', nameEn: 'Kyoto Nakagyo'),
      City(nameJa: '京都市東山区', nameEn: 'Kyoto Higashiyama'),
      City(nameJa: '京都市下京区', nameEn: 'Kyoto Shimogyo'),
      City(nameJa: '京都市南区', nameEn: 'Kyoto Minami'),
      City(nameJa: '京都市右京区', nameEn: 'Kyoto Ukyo'),
      City(nameJa: '京都市伏見区', nameEn: 'Kyoto Fushimi'),
      City(nameJa: '京都市山科区', nameEn: 'Kyoto Yamashina'),
      City(nameJa: '京都市西京区', nameEn: 'Kyoto Nishikyo'),
      City(nameJa: '宇治市', nameEn: 'Uji'),
    ],
  ),

  // ── 27 大阪府 ──────────────────────────────────────────
  Prefecture(
    code: '27',
    nameJa: '大阪府',
    nameEn: 'Osaka',
    cities: [
      City(nameJa: '大阪市都島区', nameEn: 'Osaka Miyakojima'),
      City(nameJa: '大阪市福島区', nameEn: 'Osaka Fukushima'),
      City(nameJa: '大阪市此花区', nameEn: 'Osaka Konohana'),
      City(nameJa: '大阪市西区', nameEn: 'Osaka Nishi'),
      City(nameJa: '大阪市港区', nameEn: 'Osaka Minato'),
      City(nameJa: '大阪市大正区', nameEn: 'Osaka Taisho'),
      City(nameJa: '大阪市天王寺区', nameEn: 'Osaka Tennoji'),
      City(nameJa: '大阪市浪速区', nameEn: 'Osaka Naniwa'),
      City(nameJa: '大阪市西淀川区', nameEn: 'Osaka Nishiyodogawa'),
      City(nameJa: '大阪市東淀川区', nameEn: 'Osaka Higashiyodogawa'),
      City(nameJa: '大阪市東成区', nameEn: 'Osaka Higashinari'),
      City(nameJa: '大阪市生野区', nameEn: 'Osaka Ikuno'),
      City(nameJa: '大阪市旭区', nameEn: 'Osaka Asahi'),
      City(nameJa: '大阪市城東区', nameEn: 'Osaka Joto'),
      City(nameJa: '大阪市阿倍野区', nameEn: 'Osaka Abeno'),
      City(nameJa: '大阪市住吉区', nameEn: 'Osaka Sumiyoshi'),
      City(nameJa: '大阪市東住吉区', nameEn: 'Osaka Higashisumiyoshi'),
      City(nameJa: '大阪市西成区', nameEn: 'Osaka Nishinari'),
      City(nameJa: '大阪市淀川区', nameEn: 'Osaka Yodogawa'),
      City(nameJa: '大阪市鶴見区', nameEn: 'Osaka Tsurumi'),
      City(nameJa: '大阪市住之江区', nameEn: 'Osaka Suminoe'),
      City(nameJa: '大阪市平野区', nameEn: 'Osaka Hirano'),
      City(nameJa: '大阪市北区', nameEn: 'Osaka Kita'),
      City(nameJa: '大阪市中央区', nameEn: 'Osaka Chuo'),
      City(nameJa: '堺市堺区', nameEn: 'Sakai Sakai'),
      City(nameJa: '堺市中区', nameEn: 'Sakai Naka'),
      City(nameJa: '堺市東区', nameEn: 'Sakai Higashi'),
      City(nameJa: '堺市西区', nameEn: 'Sakai Nishi'),
      City(nameJa: '堺市南区', nameEn: 'Sakai Minami'),
      City(nameJa: '堺市北区', nameEn: 'Sakai Kita'),
      City(nameJa: '堺市美原区', nameEn: 'Sakai Mihara'),
      City(nameJa: '東大阪市', nameEn: 'Higashiosaka'),
      City(nameJa: '枚方市', nameEn: 'Hirakata'),
      City(nameJa: '豊中市', nameEn: 'Toyonaka'),
      City(nameJa: '吹田市', nameEn: 'Suita'),
      City(nameJa: '高槻市', nameEn: 'Takatsuki'),
      City(nameJa: '茨木市', nameEn: 'Ibaraki'),
      City(nameJa: '八尾市', nameEn: 'Yao'),
      City(nameJa: '寝屋川市', nameEn: 'Neyagawa'),
      City(nameJa: '岸和田市', nameEn: 'Kishiwada'),
      City(nameJa: '和泉市', nameEn: 'Izumi'),
      City(nameJa: '守口市', nameEn: 'Moriguchi'),
      City(nameJa: '箕面市', nameEn: 'Minoh'),
      City(nameJa: '門真市', nameEn: 'Kadoma'),
      City(nameJa: '大東市', nameEn: 'Daito'),
      City(nameJa: '松原市', nameEn: 'Matsubara'),
      City(nameJa: '富田林市', nameEn: 'Tondabayashi'),
      City(nameJa: '羽曳野市', nameEn: 'Habikino'),
      City(nameJa: '河内長野市', nameEn: 'Kawachinagano'),
    ],
  ),

  // ── 28 兵庫県 ──────────────────────────────────────────
  Prefecture(
    code: '28',
    nameJa: '兵庫県',
    nameEn: 'Hyogo',
    cities: [
      City(nameJa: '神戸市東灘区', nameEn: 'Kobe Higashinada'),
      City(nameJa: '神戸市灘区', nameEn: 'Kobe Nada'),
      City(nameJa: '神戸市兵庫区', nameEn: 'Kobe Hyogo'),
      City(nameJa: '神戸市長田区', nameEn: 'Kobe Nagata'),
      City(nameJa: '神戸市須磨区', nameEn: 'Kobe Suma'),
      City(nameJa: '神戸市垂水区', nameEn: 'Kobe Tarumi'),
      City(nameJa: '神戸市北区', nameEn: 'Kobe Kita'),
      City(nameJa: '神戸市中央区', nameEn: 'Kobe Chuo'),
      City(nameJa: '神戸市西区', nameEn: 'Kobe Nishi'),
      City(nameJa: '姫路市', nameEn: 'Himeji'),
      City(nameJa: '西宮市', nameEn: 'Nishinomiya'),
      City(nameJa: '尼崎市', nameEn: 'Amagasaki'),
      City(nameJa: '明石市', nameEn: 'Akashi'),
      City(nameJa: '加古川市', nameEn: 'Kakogawa'),
      City(nameJa: '宝塚市', nameEn: 'Takarazuka'),
      City(nameJa: '伊丹市', nameEn: 'Itami'),
      City(nameJa: '川西市', nameEn: 'Kawanishi'),
      City(nameJa: '三田市', nameEn: 'Sanda'),
      City(nameJa: '芦屋市', nameEn: 'Ashiya'),
    ],
  ),

  // ── 29 奈良県 ──────────────────────────────────────────
  Prefecture(
    code: '29',
    nameJa: '奈良県',
    nameEn: 'Nara',
    cities: [
      City(nameJa: '奈良市', nameEn: 'Nara'),
      City(nameJa: '橿原市', nameEn: 'Kashihara'),
      City(nameJa: '生駒市', nameEn: 'Ikoma'),
    ],
  ),

  // ── 30 和歌山県 ─────────────────────────────────────────
  Prefecture(
    code: '30',
    nameJa: '和歌山県',
    nameEn: 'Wakayama',
    cities: [
      City(nameJa: '和歌山市', nameEn: 'Wakayama'),
    ],
  ),

  // ── 31 鳥取県 ──────────────────────────────────────────
  Prefecture(
    code: '31',
    nameJa: '鳥取県',
    nameEn: 'Tottori',
    cities: [
      City(nameJa: '鳥取市', nameEn: 'Tottori'),
      City(nameJa: '米子市', nameEn: 'Yonago'),
    ],
  ),

  // ── 32 島根県 ──────────────────────────────────────────
  Prefecture(
    code: '32',
    nameJa: '島根県',
    nameEn: 'Shimane',
    cities: [
      City(nameJa: '松江市', nameEn: 'Matsue'),
      City(nameJa: '出雲市', nameEn: 'Izumo'),
    ],
  ),

  // ── 33 岡山県 ──────────────────────────────────────────
  Prefecture(
    code: '33',
    nameJa: '岡山県',
    nameEn: 'Okayama',
    cities: [
      City(nameJa: '岡山市北区', nameEn: 'Okayama Kita'),
      City(nameJa: '岡山市中区', nameEn: 'Okayama Naka'),
      City(nameJa: '岡山市東区', nameEn: 'Okayama Higashi'),
      City(nameJa: '岡山市南区', nameEn: 'Okayama Minami'),
      City(nameJa: '倉敷市', nameEn: 'Kurashiki'),
      City(nameJa: '津山市', nameEn: 'Tsuyama'),
    ],
  ),

  // ── 34 広島県 ──────────────────────────────────────────
  Prefecture(
    code: '34',
    nameJa: '広島県',
    nameEn: 'Hiroshima',
    cities: [
      City(nameJa: '広島市中区', nameEn: 'Hiroshima Naka'),
      City(nameJa: '広島市東区', nameEn: 'Hiroshima Higashi'),
      City(nameJa: '広島市南区', nameEn: 'Hiroshima Minami'),
      City(nameJa: '広島市西区', nameEn: 'Hiroshima Nishi'),
      City(nameJa: '広島市安佐南区', nameEn: 'Hiroshima Asaminami'),
      City(nameJa: '広島市安佐北区', nameEn: 'Hiroshima Asakita'),
      City(nameJa: '広島市安芸区', nameEn: 'Hiroshima Aki'),
      City(nameJa: '広島市佐伯区', nameEn: 'Hiroshima Saeki'),
      City(nameJa: '福山市', nameEn: 'Fukuyama'),
      City(nameJa: '呉市', nameEn: 'Kure'),
      City(nameJa: '東広島市', nameEn: 'Higashihiroshima'),
      City(nameJa: '尾道市', nameEn: 'Onomichi'),
    ],
  ),

  // ── 35 山口県 ──────────────────────────────────────────
  Prefecture(
    code: '35',
    nameJa: '山口県',
    nameEn: 'Yamaguchi',
    cities: [
      City(nameJa: '山口市', nameEn: 'Yamaguchi'),
      City(nameJa: '下関市', nameEn: 'Shimonoseki'),
      City(nameJa: '周南市', nameEn: 'Shunan'),
      City(nameJa: '岩国市', nameEn: 'Iwakuni'),
    ],
  ),

  // ── 36 徳島県 ──────────────────────────────────────────
  Prefecture(
    code: '36',
    nameJa: '徳島県',
    nameEn: 'Tokushima',
    cities: [
      City(nameJa: '徳島市', nameEn: 'Tokushima'),
    ],
  ),

  // ── 37 香川県 ──────────────────────────────────────────
  Prefecture(
    code: '37',
    nameJa: '香川県',
    nameEn: 'Kagawa',
    cities: [
      City(nameJa: '高松市', nameEn: 'Takamatsu'),
      City(nameJa: '丸亀市', nameEn: 'Marugame'),
    ],
  ),

  // ── 38 愛媛県 ──────────────────────────────────────────
  Prefecture(
    code: '38',
    nameJa: '愛媛県',
    nameEn: 'Ehime',
    cities: [
      City(nameJa: '松山市', nameEn: 'Matsuyama'),
      City(nameJa: '今治市', nameEn: 'Imabari'),
      City(nameJa: '新居浜市', nameEn: 'Niihama'),
      City(nameJa: '西条市', nameEn: 'Saijo'),
    ],
  ),

  // ── 39 高知県 ──────────────────────────────────────────
  Prefecture(
    code: '39',
    nameJa: '高知県',
    nameEn: 'Kochi',
    cities: [
      City(nameJa: '高知市', nameEn: 'Kochi'),
    ],
  ),

  // ── 40 福岡県 ──────────────────────────────────────────
  Prefecture(
    code: '40',
    nameJa: '福岡県',
    nameEn: 'Fukuoka',
    cities: [
      City(nameJa: '福岡市東区', nameEn: 'Fukuoka Higashi'),
      City(nameJa: '福岡市博多区', nameEn: 'Fukuoka Hakata'),
      City(nameJa: '福岡市中央区', nameEn: 'Fukuoka Chuo'),
      City(nameJa: '福岡市南区', nameEn: 'Fukuoka Minami'),
      City(nameJa: '福岡市西区', nameEn: 'Fukuoka Nishi'),
      City(nameJa: '福岡市城南区', nameEn: 'Fukuoka Jonan'),
      City(nameJa: '福岡市早良区', nameEn: 'Fukuoka Sawara'),
      City(nameJa: '北九州市門司区', nameEn: 'Kitakyushu Moji'),
      City(nameJa: '北九州市若松区', nameEn: 'Kitakyushu Wakamatsu'),
      City(nameJa: '北九州市戸畑区', nameEn: 'Kitakyushu Tobata'),
      City(nameJa: '北九州市小倉北区', nameEn: 'Kitakyushu Kokura Kita'),
      City(nameJa: '北九州市小倉南区', nameEn: 'Kitakyushu Kokura Minami'),
      City(nameJa: '北九州市八幡東区', nameEn: 'Kitakyushu Yahata Higashi'),
      City(nameJa: '北九州市八幡西区', nameEn: 'Kitakyushu Yahata Nishi'),
      City(nameJa: '久留米市', nameEn: 'Kurume'),
      City(nameJa: '飯塚市', nameEn: 'Iizuka'),
      City(nameJa: '大牟田市', nameEn: 'Omuta'),
      City(nameJa: '春日市', nameEn: 'Kasuga'),
      City(nameJa: '大野城市', nameEn: 'Onojo'),
      City(nameJa: '筑紫野市', nameEn: 'Chikushino'),
      City(nameJa: '糸島市', nameEn: 'Itoshima'),
    ],
  ),

  // ── 41 佐賀県 ──────────────────────────────────────────
  Prefecture(
    code: '41',
    nameJa: '佐賀県',
    nameEn: 'Saga',
    cities: [
      City(nameJa: '佐賀市', nameEn: 'Saga'),
      City(nameJa: '唐津市', nameEn: 'Karatsu'),
    ],
  ),

  // ── 42 長崎県 ──────────────────────────────────────────
  Prefecture(
    code: '42',
    nameJa: '長崎県',
    nameEn: 'Nagasaki',
    cities: [
      City(nameJa: '長崎市', nameEn: 'Nagasaki'),
      City(nameJa: '佐世保市', nameEn: 'Sasebo'),
    ],
  ),

  // ── 43 熊本県 ──────────────────────────────────────────
  Prefecture(
    code: '43',
    nameJa: '熊本県',
    nameEn: 'Kumamoto',
    cities: [
      City(nameJa: '熊本市中央区', nameEn: 'Kumamoto Chuo'),
      City(nameJa: '熊本市東区', nameEn: 'Kumamoto Higashi'),
      City(nameJa: '熊本市西区', nameEn: 'Kumamoto Nishi'),
      City(nameJa: '熊本市南区', nameEn: 'Kumamoto Minami'),
      City(nameJa: '熊本市北区', nameEn: 'Kumamoto Kita'),
      City(nameJa: '八代市', nameEn: 'Yatsushiro'),
    ],
  ),

  // ── 44 大分県 ──────────────────────────────────────────
  Prefecture(
    code: '44',
    nameJa: '大分県',
    nameEn: 'Oita',
    cities: [
      City(nameJa: '大分市', nameEn: 'Oita'),
      City(nameJa: '別府市', nameEn: 'Beppu'),
    ],
  ),

  // ── 45 宮崎県 ──────────────────────────────────────────
  Prefecture(
    code: '45',
    nameJa: '宮崎県',
    nameEn: 'Miyazaki',
    cities: [
      City(nameJa: '宮崎市', nameEn: 'Miyazaki'),
      City(nameJa: '都城市', nameEn: 'Miyakonojo'),
      City(nameJa: '延岡市', nameEn: 'Nobeoka'),
    ],
  ),

  // ── 46 鹿児島県 ─────────────────────────────────────────
  Prefecture(
    code: '46',
    nameJa: '鹿児島県',
    nameEn: 'Kagoshima',
    cities: [
      City(nameJa: '鹿児島市', nameEn: 'Kagoshima'),
      City(nameJa: '霧島市', nameEn: 'Kirishima'),
      City(nameJa: '鹿屋市', nameEn: 'Kanoya'),
      City(nameJa: '薩摩川内市', nameEn: 'Satsumasendai'),
    ],
  ),

  // ── 47 沖縄県 ──────────────────────────────────────────
  Prefecture(
    code: '47',
    nameJa: '沖縄県',
    nameEn: 'Okinawa',
    cities: [
      City(nameJa: '那覇市', nameEn: 'Naha'),
      City(nameJa: '沖縄市', nameEn: 'Okinawa'),
      City(nameJa: 'うるま市', nameEn: 'Uruma'),
      City(nameJa: '浦添市', nameEn: 'Urasoe'),
      City(nameJa: '宜野湾市', nameEn: 'Ginowan'),
      City(nameJa: '名護市', nameEn: 'Nago'),
    ],
  ),
];
