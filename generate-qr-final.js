import QRCode from 'qrcode';

const url = 'https://drive.google.com/file/d/12HFg2awKNieGQVK7pRbfy0cIiGn_keyq/view?usp=sharing';

QRCode.toFile('QR_CONECTATIC_v2.3.0_FINAL.png', url, {
  errorCorrectionLevel: 'H',
  type: 'image/png',
  quality: 0.95,
  margin: 2,
  width: 500,
  color: {
    dark: '#000000',
    light: '#FFFFFF'
  }
}, (err) => {
  if (err) {
    console.error('❌ Error generando QR:', err);
  } else {
    console.log('✅ QR generado exitosamente: QR_CONECTATIC_v2.3.0_FINAL.png');
  }
});
