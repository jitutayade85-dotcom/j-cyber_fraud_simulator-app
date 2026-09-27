class ScamScenario {
  final String id, category, sender, message, safeAction;
  final List<String> redFlags;
  final bool isScam;
  const ScamScenario({
    required this.id, required this.category, required this.sender,
    required this.message, required this.redFlags,
    required this.safeAction, required this.isScam,
  });
}

const List<ScamScenario> kScenarios = [
  ScamScenario(
    id: 'electricity',
    category: 'Fake Electricity Bill',
    sender: 'VE-838291',
    message: 'Aapka bijli connection aaj raat 9 baje PERMANENTLY disconnect ho jayega. Turant payment karein: bit.ly/paybijli-fast',
    redFlags: [
      'Bijli board kabhi SMS se link bhej kar payment nahi maangta',
      'Short-link (bit.ly) asli sarkari website nahi hoti',
      'Raat me disconnect ki dhamki = classic scam line',
    ],
    safeAction: 'Koi link na khole. Bijli bill sirf official app/website ya CSC center se bhare.',
    isScam: true,
  ),
  ScamScenario(
    id: 'upi_pin',
    category: 'UPI Receive-Money Scam',
    sender: '+91 98765 43210',
    message: 'Beta, main 5000 rupaye bhej raha hu. Pehle WhatsApp pe bheja hua QR scan karo aur UPI PIN enter kar do, paise turant aa jayenge.',
    redFlags: [
      'Paise LENE ke liye kabhi PIN nahi dalna padta',
      'PIN dalne par aapke account se paise JATE hain',
      'WhatsApp QR + urgency = fraud ka pakka nishan',
    ],
    safeAction: 'UPI PIN sirf paise BHARTE waqt dalté hain. Call cut karo aur 1930 par report karo.',
    isScam: true,
  ),
  ScamScenario(
    id: 'digital_arrest',
    category: 'Digital Arrest Scam',
    sender: '+91 78900 12345 (Video Call)',
    message: 'Main CBI officer Verma bol raha hu. Aapke naam par money laundering case hai. Camera ON rakho, ghar se bahar mat jao, aur is "RBI secure account" me apne paise transfer karo.',
    redFlags: [
      'Police/CBI kabhi video call par arrest nahi karte',
      'Asli officer kabhi paise transfer nahi maangta',
      'Camera ON rakhna aur ghar se na nikalna = "digital arrest" ka trap',
    ],
    safeAction: 'Call cut karo. Ye 100% scam hai. 1930 par ya cybercrime.gov.in par report karo.',
    isScam: true,
  ),
  ScamScenario(
    id: 'task_job',
    category: 'Fake Task/Job Scam',
    sender: 'Telegram: EarnDaily India',
    message: 'Congrats! Aapko part-time job mili. Ghar baithe 5000-8000 daily. Sirf 99 rs registration fee bharo aur pehla task complete karo!',
    redFlags: [
      'Job ke liye pehle paise dene paden = scam',
      'Bahut zyada paisa, bahut kam mehnat - unrealistic offer',
      'Telegram par anonymous "company"',
    ],
    safeAction: 'Koi fee na bharo. Asli job kabhi registration fee nahi maangti.',
    isScam: true,
  ),
  ScamScenario(
    id: 'kyc',
    category: 'Fake Bank KYC Scam',
    sender: 'SBI-ALERT',
    message: 'Dear customer, aapka SBI account aaj shaam 5 baje tak block ho jayega. KYC update karein: sbi-kyc-update.info',
    redFlags: [
      'Sender ka naam SBI hai par website .info hai - bank kabhi aisi site nahi use karta',
      'Account block hone ki dhamki',
      'KYC ke liye link wala SMS asli bank kabhi nahi bhejta',
    ],
    safeAction: 'Kuch na kholo. KYC sirf bank branch ya official app me hota hai.',
    isScam: true,
  ),
  ScamScenario(
    id: 'genuine_credit',
    category: 'Normal Bank Message (Safe)',
    sender: 'AXISBK',
    message: 'Rs 2500.00 credited to your a/c XX4412 on 26-09-26 by NEFT-RAKESH KUMAR. Ref no 88219302. -Axis Bank',
    redFlags: [
      'Koi link nahi hai',
      'Koi PIN/OTP maangne ki baat nahi',
      'Koi dhamki ya urgency nahi',
    ],
    safeAction: 'Ye normal bank information hai - safe hai. Aage badh sakte ho.',
    isScam: false,
  ),
];
