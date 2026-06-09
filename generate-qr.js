import QRCode from 'qrcode';

const url = 'https://drive.google.com/file/d/1GVUGqiQjo0eXvu1TMYRKV4YM6M6X222c/view?usp=sharing';

QRCode.toFile('QR_CONECTATIC_APK_v2.3.0.png', url, {
  errorCorrectionLevel: 'H',
  type: 'image/png',
  quality: 0.95,
  margin: 1,
  width: 500,
  color: {
    dark: '#000000',
    light: '#FFFFFF'
  }
}, (err) => {
  if (err) {
    console.error('❌ Error generando QR:', err);
  } else {
    console.log('✅ QR generado exitosamente: QR_CONECTATIC_APK_v2.3.0.png');
  }
});
