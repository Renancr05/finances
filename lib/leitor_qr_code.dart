import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class LeitorQrCode extends StatefulWidget {
  const LeitorQrCode({super.key});

  @override
  State<LeitorQrCode> createState() => _LeitorQrCodeState();
}

class _LeitorQrCodeState extends State<LeitorQrCode> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _codigoLido = false;

  // --- Janela para inserção manual do Pix Copia e Cola ---
  void _exibirDialogoCodigoManual() {
    final TextEditingController txtCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Digitar Pix Copia e Cola', 
          style: TextStyle(color: Color(0xFF143D36), fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: txtCtrl,
          maxLines: 3,
          style: const TextStyle(color: Color(0xFF143D36)),
          decoration: InputDecoration(
            hintText: 'Cole ou digite do Pix aqui.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final codigo = txtCtrl.text.trim();
              if (codigo.isNotEmpty) {
                _codigoLido = true;
                Navigator.pop(dialogContext); // Fecha o pop-up de inserção
                Navigator.pop(context, codigo); // Retorna a string direto para a tela de Transferência
              }
            },
            child: const Text(
              'Confirmar', 
              style: TextStyle(color: Color(0xFF48D6C5), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Escanear Pix'),
        backgroundColor: const Color(0xFF143D36),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_codigoLido) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _codigoLido = true;
                  final String codigoCapturado = barcode.rawValue!;
                  Navigator.pop(context, codigoCapturado);
                  break;
                }
              }
            },
          ),
          
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF48D6C5), width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Aponte para o QR Code Pix',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF143D36),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: const BorderSide(color: Color(0xFF48D6C5), width: 1),
                      elevation: 4,
                    ),
                    onPressed: _exibirDialogoCodigoManual,
                    icon: const Icon(Icons.keyboard),
                    label: const Text(
                      'Digitar Pix Copia e Cola',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
