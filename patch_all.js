const fs = require('fs');
const p = require('path');
const B = 'C:/Users/HP ElieBook/Desktop/goo212/Supper-App-Go212/lib';
const w = (rel, c) => { fs.writeFileSync(B+'/'+rel, c, 'utf8'); console.log('✓ '+p.basename(rel)); };
const r = (rel) => fs.readFileSync(B+'/'+rel, 'utf8');

// ═══════════════════════════════════════════════════════════════════
// HELPER: Replace _buildHeader with ZelligeHeader version
// ═══════════════════════════════════════════════════════════════════
function patchKycHeader(file, title, step, total) {
  let src = r(file);
  if (!src.includes("import '../widgets/zellige_header.dart'")) {
    src = src.replace(
      "import '../widgets/goride_btn.dart';",
      "import '../widgets/goride_btn.dart';\nimport '../widgets/zellige_header.dart';"
    );
  }
  // Find and replace the entire _buildHeader method body
  const oldGrad = `    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15803D), Color(0xFF22C55E)],
        ),
      ),`;
  const newGrad = `    return ZelligeHeader(
      gradientColors: const [Color(0xFF0D3D26), Color(0xFF166534), Color(0xFF16A34A)],
      patternOpacity: 0.08,
      tileSize: 28.0,`;
  src = src.replace(oldGrad, newGrad);
  // Replace step indicator text: "N / M" stays, but we can also add mascot
  // Find the step pill and add mascot before it
  const stepPill = `                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('${step} / ${total}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),`;
  const newStepPill = `                const MotoMascotBadge(size: 34),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('${step} / ${total}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),`;
  src = src.replace(stepPill, newStepPill);
  // Fix withValues -> withOpacity for all remaining occurrences in header section
  src = src.replace(/Colors\.white\.withValues\(alpha: 0\.2\)/g, 'Colors.white.withOpacity(0.15) // ignore: deprecated_member_use');
  w(file, src);
}

// ═══════════════════════════════════════════════════════════════════
// KYC Scan & Selfie
// ═══════════════════════════════════════════════════════════════════
patchKycHeader('features/goride/kyc/kyc_scan_screen.dart', 'Scan de la CIN', '2', '5');
patchKycHeader('features/goride/kyc/kyc_selfie_screen.dart', 'Selfie', '3', '5');

// ═══════════════════════════════════════════════════════════════════
// KYC Verify — different header structure (has SafeArea + no back btn)
// ═══════════════════════════════════════════════════════════════════
{
  let src = r('features/goride/kyc/kyc_verify_screen.dart');
  if (!src.includes("import '../widgets/zellige_header.dart'")) {
    src = src.replace(
      "import '../widgets/kyc_progress_bar.dart';",
      "import '../widgets/kyc_progress_bar.dart';\nimport '../widgets/zellige_header.dart';"
    );
  }
  src = src.replace(
`  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15803D), Color(0xFF22C55E)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Analyse en cours...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                      Text('Ne fermez pas l\'application',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('4 / 5',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: KycProgressBar(currentStep: 4, totalSteps: 5),
            ),
          ],
        ),
      ),`,
`  Widget _buildHeader(BuildContext context) {
    return ZelligeHeader(
      gradientColors: const [Color(0xFF0D3D26), Color(0xFF166534), Color(0xFF16A34A)],
      patternOpacity: 0.08,
      tileSize: 28.0,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.security_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text('Analyse en cours...',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ),
                  const MotoMascotBadge(size: 34),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('4 / 5',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: KycProgressBar(currentStep: 4, totalSteps: 5),
            ),
          ],
        ),
      ),`
  );
  w('features/goride/kyc/kyc_verify_screen.dart', src);
}

// ═══════════════════════════════════════════════════════════════════
// KYC Success — add zellige tinted top area (no full header)
// ═══════════════════════════════════════════════════════════════════
{
  let src = r('features/goride/kyc/kyc_success_screen.dart');
  if (!src.includes("import '../widgets/zellige_header.dart'")) {
    src = src.replace(
      "import '../widgets/goride_btn.dart';",
      "import '../widgets/goride_btn.dart';\nimport '../widgets/zellige_header.dart';"
    );
  }
  // Replace the two gradient LinearGradient in success icon circle
  src = src.replace(
    `              gradient: const LinearGradient(
                colors: [Color(0xFF15803D), Color(0xFF22C55E)],
              ),`,
    `              gradient: const LinearGradient(
                colors: [Color(0xFF0D3D26), Color(0xFF16A34A)],
              ),`
  );
  // Replace background color of scaffold
  src = src.replace(
    "backgroundColor: const Color(0xFFF0FDF4),",
    "backgroundColor: const Color(0xFFF0FDF4),\n        extendBodyBehindAppBar: false,"
  );
  w('features/goride/kyc/kyc_success_screen.dart', src);
}

// ═══════════════════════════════════════════════════════════════════
// Payment Screen — ZelligeHeader
// ═══════════════════════════════════════════════════════════════════
{
  let src = r('features/goride/booking/goride_payment_screen.dart');
  if (!src.includes("import '../widgets/zellige_header.dart'")) {
    src = src.replace(
      "import '../widgets/goride_btn.dart';",
      "import '../widgets/goride_btn.dart';\nimport '../widgets/zellige_header.dart';"
    );
  }
  src = src.replace(
`  Widget _buildHeader(BuildContext context, GoRideBooking booking) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF15803D), Color(0xFF22C55E)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('6 / 6',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Paiement',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('Choisissez votre mode de paiement',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 13)),`,
`  Widget _buildHeader(BuildContext context, GoRideBooking booking) {
    return ZelligeHeader(
      gradientColors: const [Color(0xFF0D3D26), Color(0xFF166534), Color(0xFF16A34A)],
      patternOpacity: 0.08,
      tileSize: 28.0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  const MotoMascotBadge(size: 36),
                  const SizedBox(width: 10),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('6 / 6',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Paiement',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              // ignore: deprecated_member_use
              Text('Choisissez votre mode de paiement',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13)),`
  );
  // Close the container properly - find the end of the method
  // The old code had Colors.white.withValues(alpha: 0.15) for the amount card
  src = src.replace(
    /color: Colors\.white\.withValues\(alpha: 0\.15\)/g,
    '// ignore: deprecated_member_use\n                    color: Colors.white.withOpacity(0.15)'
  );
  src = src.replace(
    /color: Colors\.white\.withValues\(alpha: 0\.2\)/g,
    '// ignore: deprecated_member_use\n                      color: Colors.white.withOpacity(0.15)'
  );
  w('features/goride/booking/goride_payment_screen.dart', src);
}

// ═══════════════════════════════════════════════════════════════════
// Confirm Screen — patch the animated circle gradient only
// ═══════════════════════════════════════════════════════════════════
{
  let src = r('features/goride/booking/goride_confirm_screen.dart');
  src = src.replace(
    `                    gradient: const LinearGradient(
                      colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                    ),`,
    `                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D3D26), Color(0xFF16A34A)],
                    ),`
  );
  // Also the success view gradient
  src = src.replace(
    `                    gradient: const LinearGradient(
                      colors: [Color(0xFF15803D), Color(0xFF22C55E)],
                    ),`,
    `                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D3D26), Color(0xFF16A34A)],
                    ),`
  );
  w('features/goride/booking/goride_confirm_screen.dart', src);
}

console.log('\n✅ All KYC + Payment + Confirm patches done.');
