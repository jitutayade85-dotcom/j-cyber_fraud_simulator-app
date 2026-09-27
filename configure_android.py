from pathlib import Path

manifest = Path('android/app/src/main/AndroidManifest.xml')
c = manifest.read_text()
perms = (
    '    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>\n'
    '    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>\n'
    '    <uses-permission android:name="android.permission.WAKE_LOCK"/>\n'
    '    <uses-permission android:name="android.permission.VIBRATE"/>\n'
)
if 'POST_NOTIFICATIONS' not in c:
    c = c.replace('<application', perms + '<application', 1)
c = c.replace('android:label="cyber_fraud_simulator"', 'android:label="Cyber Fraud Simulator"')
manifest.write_text(c)
print('Manifest OK - permissions added')
