import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Model ────────────────────────────────────────────────────────────────────
class BikeStation {
  final String id, name, type, distance, fun;
  final double dx, dy;
  final int count, battery;
  final double pricePerMin;
  const BikeStation({required this.id, required this.name, required this.type,
      required this.distance, required this.fun,
      required this.dx, required this.dy,
      required this.count, required this.battery, required this.pricePerMin});
  String get emoji => type=='electric'?'⚡':type=='scooter'?'🛴':'🚲';
  String get typeLabel => type=='electric'?'Électrique':type=='scooter'?'Trottinette':'Vélo classique';
  Color get color => type=='electric'?const Color(0xFF1565C0):type=='scooter'?const Color(0xFFF57C00):const Color(0xFF1A6B1A);
  Color get light => type=='electric'?const Color(0xFFE3F2FD):type=='scooter'?const Color(0xFFFFF3E0):const Color(0xFFE8F5E9);
}

const _stations = [
  BikeStation(id:'s1',name:'Maarif Centre',   type:'bike',    fun:'Hop on! 🤸',dx:.42,dy:.52,count:8, battery:100,distance:'120m', pricePerMin:1.50),
  BikeStation(id:'s2',name:'Bd Zerktouni',    type:'electric',fun:'Chargé & prêt ⚡',dx:.58,dy:.60,count:5, battery:87, distance:'340m', pricePerMin:2.00),
  BikeStation(id:'s3',name:'Pl. Mohammed V',  type:'scooter', fun:'Vrooom! 🛴',dx:.70,dy:.38,count:6, battery:92, distance:'85m',  pricePerMin:1.80),
  BikeStation(id:'s4',name:'Corniche Aïn Diab',type:'bike',   fun:'Vue mer! 🌊',dx:.20,dy:.28,count:12,battery:100,distance:'600m', pricePerMin:1.50),
  BikeStation(id:'s5',name:'Mosquée Hassan II',type:'electric',fun:'Vue épique 🕌',dx:.68,dy:.18,count:3, battery:74, distance:'1.2km',pricePerMin:2.00),
  BikeStation(id:'s6',name:'Twin Center',     type:'scooter', fun:'Style urbain 😎',dx:.48,dy:.68,count:9, battery:95, distance:'250m', pricePerMin:1.80),
  BikeStation(id:'s7',name:'Anfa Place Mall', type:'bike',    fun:'Shopping ride 🛍️',dx:.28,dy:.62,count:7, battery:100,distance:'450m', pricePerMin:1.50),
];

// ─── Map Screen ───────────────────────────────────────────────────────────────
class GoBikeBikeMapScreen extends StatefulWidget {
  const GoBikeBikeMapScreen({super.key});
  @override State<GoBikeBikeMapScreen> createState() => _MapState();
}

class _MapState extends State<GoBikeBikeMapScreen> with TickerProviderStateMixin {
  BikeStation? _sel;
  String _filter = 'all';

  late final AnimationController _bounce =
      AnimationController(vsync:this, duration:const Duration(milliseconds:900))..repeat(reverse:true);
  late final AnimationController _pulse =
      AnimationController(vsync:this, duration:const Duration(seconds:2))..repeat(reverse:true);
  late final AnimationController _entry =
      AnimationController(vsync:this, duration:const Duration(milliseconds:700))..forward();

  static const _g = Color(0xFF1A6B1A);
  static const _d = Color(0xFF0F2D0F);

  List<BikeStation> get _f => _filter=='all'?_stations:_stations.where((s)=>s.type==_filter).toList();

  void _tap(BikeStation s) { HapticFeedback.lightImpact(); setState(()=>_sel=s); }

  @override void dispose() { _bounce.dispose(); _pulse.dispose(); _entry.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnimatedBuilder(
        animation: _entry,
        builder:(_,child) => FadeTransition(
          opacity: CurvedAnimation(parent:_entry,curve:Curves.easeOut),
          child: child,
        ),
        child: Stack(children: [

          // ── CITY MAP ──────────────────────────────────────────────────────
          GestureDetector(
            onTap: ()=>setState(()=>_sel=null),
            child: CustomPaint(size:size, painter:_CityPainter()),
          ),

          // ── CARTOON BIKE MARKERS ──────────────────────────────────────────
          ..._f.map((s) {
            final x = s.dx * size.width;
            final y = s.dy * size.height;
            final isSel = _sel?.id == s.id;
            return Positioned(
              left: x - 30,
              top:  y - (isSel ? 80 : 65),
              child: GestureDetector(
                onTap: ()=>_tap(s),
                child: AnimatedBuilder(
                  animation: _bounce,
                  builder:(_,__) {
                    final bounce = isSel ? math.sin(_bounce.value * math.pi) * 6 : 0.0;
                    return Transform.translate(
                      offset: Offset(0, -bounce),
                      child: Column(mainAxisSize:MainAxisSize.min, children: [
                        // Cartoon bubble marker
                        AnimatedContainer(
                          duration:const Duration(milliseconds:300),
                          width: isSel ? 66 : 54,
                          height: isSel ? 66 : 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color:s.color, width:isSel?3.5:2.5),
                            boxShadow: [
                              BoxShadow(color:s.color.withOpacity(0.35), blurRadius:isSel?20:10, offset:const Offset(0,4)),
                              BoxShadow(color:Colors.black.withOpacity(0.1), blurRadius:6, offset:const Offset(0,2)),
                            ],
                          ),
                          child: Center(child: _CartoonBike(type:s.type, size:isSel?36:28)),
                        ),
                        // Tail
                        Container(width:3, height:8, color:s.color),
                        // Count pill
                        AnimatedContainer(
                          duration:const Duration(milliseconds:300),
                          padding:const EdgeInsets.symmetric(horizontal:8,vertical:3),
                          decoration:BoxDecoration(color:s.color, borderRadius:BorderRadius.circular(10),
                            boxShadow:[BoxShadow(color:s.color.withOpacity(0.4),blurRadius:8,offset:const Offset(0,2))]),
                          child:Text('${s.count} vélos', style:GoogleFonts.nunito(color:Colors.white,fontSize:10,fontWeight:FontWeight.w900)),
                        ),
                        // Pulse ring when selected
                        if (isSel) AnimatedBuilder(
                          animation: _pulse,
                          builder:(_,__) => Container(
                            width:4,height:4,
                            decoration:BoxDecoration(shape:BoxShape.circle,
                              color:s.color.withOpacity(0.4+_pulse.value*0.4)),
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            );
          }),

          // ── TOP BAR ────────────────────────────────────────────────────────
          SafeArea(child:Column(children:[
            Padding(
              padding:const EdgeInsets.fromLTRB(16,12,16,0),
              child:Row(children:[
                _Fab(onTap:()=>Navigator.pop(context),
                    bg:Colors.white, child:const Icon(Icons.arrow_back_rounded,size:20,color:_d)),
                const SizedBox(width:10),
                Expanded(child:Container(
                  height:50,padding:const EdgeInsets.symmetric(horizontal:16),
                  decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(25),
                    boxShadow:[BoxShadow(color:Colors.black.withOpacity(.1),blurRadius:14,offset:const Offset(0,4))]),
                  child:Row(children:[
                    Icon(Icons.search_rounded,color:Colors.grey.shade400,size:18),
                    const SizedBox(width:8),
                    Expanded(child:Text('Chercher une station...',style:GoogleFonts.poppins(color:Colors.grey.shade400,fontSize:13))),
                    AnimatedBuilder(animation:_pulse, builder:(_,__)=>Container(
                      width:8,height:8,
                      decoration:BoxDecoration(shape:BoxShape.circle,
                        color:const Color(0xFF22C55E),
                        boxShadow:[BoxShadow(color:const Color(0xFF22C55E).withOpacity(0.3+_pulse.value*0.4),blurRadius:6)]),
                    )),
                    const SizedBox(width:6),
                    Text('LIVE',style:GoogleFonts.poppins(color:const Color(0xFF22C55E),fontSize:10,fontWeight:FontWeight.w800)),
                  ]),
                )),
              ]),
            ),
            const SizedBox(height:10),
            SingleChildScrollView(
              scrollDirection:Axis.horizontal,
              padding:const EdgeInsets.symmetric(horizontal:16),
              child:Row(children:[
                _Chip('🗺️ Tous',_filter=='all',()=>setState((){_filter='all';_sel=null;})),
                const SizedBox(width:8),
                _Chip('🚲 Vélo',_filter=='bike',()=>setState((){_filter='bike';_sel=null;})),
                const SizedBox(width:8),
                _Chip('⚡ Électrique',_filter=='electric',()=>setState((){_filter='electric';_sel=null;})),
                const SizedBox(width:8),
                _Chip('🛴 Scooter',_filter=='scooter',()=>setState((){_filter='scooter';_sel=null;})),
              ]),
            ),
          ])),

          // ── RIGHT FABs ────────────────────────────────────────────────────
          Positioned(right:16,bottom:_sel!=null?430:130,
            child:Column(children:[
              _Fab(onTap:(){},bg:_d,child:const Icon(Icons.my_location_rounded,color:Color(0xFF22C55E),size:20)),
              const SizedBox(height:10),
              _Fab(onTap:(){},bg:Colors.white,child:Icon(Icons.add_rounded,color:_d,size:20)),
              const SizedBox(height:10),
              _Fab(onTap:(){},bg:Colors.white,child:Icon(Icons.remove_rounded,color:_d,size:20)),
            ]),
          ),

          // ── STATION PILL (left) ───────────────────────────────────────────
          Positioned(left:16,bottom:_sel!=null?430:130,
            child:AnimatedBuilder(animation:_pulse,builder:(_,__)=>Container(
              padding:const EdgeInsets.symmetric(horizontal:14,vertical:9),
              decoration:BoxDecoration(color:_d,borderRadius:BorderRadius.circular(22),
                boxShadow:[BoxShadow(color:Colors.black.withOpacity(.25),blurRadius:12,offset:const Offset(0,4))]),
              child:Row(mainAxisSize:MainAxisSize.min,children:[
                Text('🚲',style:const TextStyle(fontSize:14)),
                const SizedBox(width:6),
                Text('${_f.length} stations',style:GoogleFonts.poppins(color:Colors.white,fontSize:12,fontWeight:FontWeight.w700)),
              ]),
            )),
          ),

          // ── CAROUSEL ─────────────────────────────────────────────────────
          if (_sel==null)
            Positioned(bottom:16,left:0,right:0,
              child:SizedBox(height:100,
                child:ListView.separated(
                  scrollDirection:Axis.horizontal,
                  padding:const EdgeInsets.symmetric(horizontal:16),
                  itemCount:_f.length,
                  separatorBuilder:(_,__)=>const SizedBox(width:12),
                  itemBuilder:(_,i){
                    final s=_f[i];
                    return GestureDetector(onTap:()=>_tap(s),
                      child:Container(width:195,padding:const EdgeInsets.all(13),
                        decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(22),
                          border:Border.all(color:s.color.withOpacity(0.2)),
                          boxShadow:[BoxShadow(color:Colors.black.withOpacity(.1),blurRadius:14,offset:const Offset(0,4))]),
                        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                          Row(children:[
                            Container(width:34,height:34,
                              decoration:BoxDecoration(color:s.light,shape:BoxShape.circle),
                              child:Center(child:_CartoonBike(type:s.type,size:20))),
                            const SizedBox(width:8),
                            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                              Text(s.name,style:GoogleFonts.poppins(fontSize:11,fontWeight:FontWeight.w800,color:_d),maxLines:1,overflow:TextOverflow.ellipsis),
                              Text(s.fun,style:GoogleFonts.poppins(fontSize:9,color:Colors.grey.shade500)),
                            ])),
                          ]),
                          const SizedBox(height:8),
                          Row(children:[
                            Container(padding:const EdgeInsets.symmetric(horizontal:6,vertical:2),
                              decoration:BoxDecoration(color:s.color,borderRadius:BorderRadius.circular(8)),
                              child:Text('${s.count} dispo',style:GoogleFonts.poppins(fontSize:9,fontWeight:FontWeight.w800,color:Colors.white))),
                            const Spacer(),
                            Text(s.distance,style:GoogleFonts.poppins(fontSize:10,color:Colors.grey.shade500)),
                            const SizedBox(width:4),
                            Container(width:6,height:6,decoration:const BoxDecoration(color:Color(0xFF22C55E),shape:BoxShape.circle)),
                          ]),
                        ]),
                      ));
                  },
                ),
              ),
            ),

          // ── BOTTOM SHEET ─────────────────────────────────────────────────
          AnimatedPositioned(
            duration:const Duration(milliseconds:400),curve:Curves.easeOutCubic,
            bottom:_sel!=null?0:-480,left:0,right:0,
            child:_sel!=null
                ?_Sheet(s:_sel!,pulse:_pulse,
                    onClose:()=>setState(()=>_sel=null),
                    onUnlock:()=>Navigator.pushNamed(context,'/service/gobike/bike-payment',arguments:_sel))
                :const SizedBox.shrink(),
          ),
        ]),
      ),
    );
  }
}

// ─── Cartoon bike drawn with widgets ─────────────────────────────────────────
class _CartoonBike extends StatelessWidget {
  final String type; final double size;
  const _CartoonBike({required this.type, required this.size});
  @override Widget build(BuildContext context) {
    if (type=='electric') return Text('⚡',style:TextStyle(fontSize:size*.7));
    if (type=='scooter')  return Text('🛴',style:TextStyle(fontSize:size*.7));
    return Text('🚲',style:TextStyle(fontSize:size*.7));
  }
}

// ─── City map painter ─────────────────────────────────────────────────────────
class _CityPainter extends CustomPainter {
  @override void paint(Canvas canvas, Size size) {
    final w=size.width; final h=size.height;
    canvas.drawRect(Rect.fromLTWH(0,0,w,h), Paint()..color=const Color(0xFFE8EBE5));
    // Parks
    for (final r in [[.04,.08,.2,.18],[.72,.48,.24,.22],[.28,.70,.18,.14]]) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r[0]*w,r[1]*h,r[2]*w,r[3]*h),const Radius.circular(10)),
          Paint()..color=const Color(0xFFC5DEC2));
    }
    // Water
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(w*.62,0,w*.38,h*.22),const Radius.circular(0)),
        Paint()..color=const Color(0xFFB8D8EC));
    // Blocks
    final bp = Paint()..color=const Color(0xFFDEE0D9);
    for (final b in [[.06,.28,.2,.12],[.30,.26,.2,.12],[.54,.27,.16,.11],[.74,.27,.18,.14],[.06,.44,.2,.14],[.30,.44,.2,.13],[.54,.44,.16,.12],[.74,.44,.18,.13],[.06,.62,.2,.12],[.30,.62,.16,.12],[.50,.64,.18,.12],[.72,.61,.2,.14],[.06,.78,.22,.12],[.32,.78,.18,.12],[.54,.78,.2,.12],[.78,.76,.16,.12]]) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(b[0]*w,b[1]*h,b[2]*w,b[3]*h),const Radius.circular(5)),bp);
    }
    // Roads
    final rp = Paint()..color=const Color(0xFFF5F6F2)..strokeWidth=12..style=PaintingStyle.stroke;
    for (final y in [.25,.42,.59,.76]) { canvas.drawLine(Offset(0,y*h),Offset(w,y*h),rp); }
    for (final x in [.27,.50,.71]) { canvas.drawLine(Offset(x*w,0),Offset(x*w,h),rp); }
    // Boulevard
    final blvd = Paint()..color=const Color(0xFFF5F6F2)..strokeWidth=16..style=PaintingStyle.stroke;
    final path = Path()..moveTo(0,h*.72)..quadraticBezierTo(w*.38,h*.52,w,h*.18);
    canvas.drawPath(path, blvd);
    // Street labels
    final tp = TextPainter(textDirection:TextDirection.ltr);
    void lbl(String t, double x, double y) {
      tp.text=TextSpan(text:t,style:const TextStyle(color:Color(0xFF9EAA9A),fontSize:9,fontWeight:FontWeight.w500));
      tp.layout(); tp.paint(canvas,Offset(x*w,y*h));
    }
    lbl('Bd Mohammed V',.29,.23); lbl('Rue Zerktouni',.52,.23);
    lbl('Bd d\'Anfa',.52,.58); lbl('Corniche',.07,.41);
    lbl('Av. Hassan II',.02,.59); lbl('Bd de Paris',.29,.41);
    // Park labels
    tp.text=const TextSpan(text:'🌿',style:TextStyle(fontSize:16));
    tp.layout(); tp.paint(canvas,Offset(w*.12,h*.14));
    tp.text=const TextSpan(text:'🌿',style:TextStyle(fontSize:14));
    tp.layout(); tp.paint(canvas,Offset(w*.78,h*.56));
  }
  @override bool shouldRepaint(_)=>false;
}

// ─── Station bottom sheet ─────────────────────────────────────────────────────
class _Sheet extends StatelessWidget {
  final BikeStation s; final Animation<double> pulse;
  final VoidCallback onClose, onUnlock;
  const _Sheet({required this.s,required this.pulse,required this.onClose,required this.onUnlock});
  @override Widget build(BuildContext context) => Container(
    decoration:const BoxDecoration(color:Colors.white,
      borderRadius:BorderRadius.vertical(top:Radius.circular(32)),
      boxShadow:[BoxShadow(color:Color(0x30000000),blurRadius:30,offset:Offset(0,-6))]),
    padding:const EdgeInsets.fromLTRB(22,0,22,32),
    child:Column(mainAxisSize:MainAxisSize.min,children:[
      // Handle
      Center(child:Container(margin:const EdgeInsets.symmetric(vertical:14),
        width:36,height:4,decoration:BoxDecoration(color:Colors.grey.shade300,borderRadius:BorderRadius.circular(2)))),
      // Fun tag
      Center(child:Container(
        padding:const EdgeInsets.symmetric(horizontal:14,vertical:5),
        decoration:BoxDecoration(color:s.light,borderRadius:BorderRadius.circular(20),
          border:Border.all(color:s.color.withOpacity(0.3))),
        child:Text(s.fun,style:GoogleFonts.nunito(color:s.color,fontSize:13,fontWeight:FontWeight.w800)))),
      const SizedBox(height:14),
      // Header
      Row(children:[
        Container(width:58,height:58,
          decoration:BoxDecoration(color:s.light,shape:BoxShape.circle,
            border:Border.all(color:s.color.withOpacity(0.3),width:2.5),
            boxShadow:[BoxShadow(color:s.color.withOpacity(0.2),blurRadius:12,offset:const Offset(0,4))]),
          child:Center(child:_CartoonBike(type:s.type,size:30))),
        const SizedBox(width:14),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text(s.name,style:GoogleFonts.poppins(fontSize:18,fontWeight:FontWeight.w800,color:const Color(0xFF0F2D0F))),
          Text('${s.typeLabel} · ${s.distance} de vous',style:GoogleFonts.poppins(fontSize:12,color:Colors.grey.shade500)),
          const SizedBox(height:4),
          Row(children:[
            Container(width:7,height:7,decoration:const BoxDecoration(color:Color(0xFF22C55E),shape:BoxShape.circle)),
            const SizedBox(width:5),
            Text('Disponible maintenant',style:GoogleFonts.poppins(fontSize:11,color:const Color(0xFF22C55E),fontWeight:FontWeight.w700)),
          ]),
        ])),
        GestureDetector(onTap:onClose,
          child:Container(width:32,height:32,
            decoration:BoxDecoration(color:Colors.grey.shade100,shape:BoxShape.circle),
            child:const Icon(Icons.close_rounded,size:16,color:Colors.grey))),
      ]),
      const SizedBox(height:18),
      // Stats
      Row(children:[
        Expanded(child:_SBox('${s.count}','Vélos dispo',Icons.pedal_bike_rounded,s.color)),
        const SizedBox(width:10),
        Expanded(child:_SBox('Gratuit','30 premières min',Icons.card_giftcard_rounded,const Color(0xFF22C55E))),
        const SizedBox(width:10),
        Expanded(child:_SBox('${s.battery}%','Batterie',Icons.battery_charging_full_rounded,const Color(0xFF1565C0))),
      ]),
      const SizedBox(height:14),
      // Price info
      Container(padding:const EdgeInsets.all(14),
        decoration:BoxDecoration(
          gradient:LinearGradient(colors:[s.light,Colors.white],begin:Alignment.topLeft,end:Alignment.bottomRight),
          borderRadius:BorderRadius.circular(16),
          border:Border.all(color:s.color.withOpacity(0.2))),
        child:Row(children:[
          Icon(Icons.info_outline_rounded,size:16,color:s.color),
          const SizedBox(width:10),
          Expanded(child:Text.rich(TextSpan(children:[
            TextSpan(text:'30 min gratuites ',style:GoogleFonts.poppins(fontSize:12,fontWeight:FontWeight.w700,color:const Color(0xFF22C55E))),
            TextSpan(text:'puis ',style:GoogleFonts.poppins(fontSize:12,color:Colors.grey.shade600)),
            TextSpan(text:'${s.pricePerMin.toStringAsFixed(2)} DH/min',style:GoogleFonts.poppins(fontSize:12,fontWeight:FontWeight.w700,color:const Color(0xFF0F2D0F))),
          ]))),
        ])),
      const SizedBox(height:16),
      // CTA
      GestureDetector(onTap:onUnlock,child:Container(height:58,
        decoration:BoxDecoration(
          gradient:LinearGradient(colors:[s.color.withOpacity(0.8),s.color,const Color(0xFF0F2D0F)],
            begin:Alignment.topLeft,end:Alignment.bottomRight),
          borderRadius:BorderRadius.circular(29),
          boxShadow:[BoxShadow(color:s.color.withOpacity(0.4),blurRadius:20,offset:const Offset(0,8))]),
        child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
          const Icon(Icons.electric_bolt_rounded,color:Colors.white,size:20),
          const SizedBox(width:10),
          Text('Déverrouiller maintenant !',style:GoogleFonts.nunito(color:Colors.white,fontSize:16,fontWeight:FontWeight.w900)),
        ]))),
    ]),
  );
}

class _Fab extends StatelessWidget {
  final VoidCallback onTap; final Widget child; final Color bg;
  const _Fab({required this.onTap,required this.child,required this.bg});
  @override Widget build(BuildContext context)=>GestureDetector(onTap:onTap,
    child:Container(width:46,height:46,
      decoration:BoxDecoration(color:bg,shape:BoxShape.circle,
        boxShadow:[BoxShadow(color:Colors.black.withOpacity(.12),blurRadius:12,offset:const Offset(0,4))]),
      child:Center(child:child)));
}

class _Chip extends StatelessWidget {
  final String l; final bool s; final VoidCallback t;
  const _Chip(this.l,this.s,this.t);
  @override Widget build(BuildContext context)=>GestureDetector(onTap:t,
    child:AnimatedContainer(duration:const Duration(milliseconds:200),
      padding:const EdgeInsets.symmetric(horizontal:16,vertical:9),
      decoration:BoxDecoration(
        color:s?const Color(0xFF1A6B1A):Colors.white,
        borderRadius:BorderRadius.circular(22),
        boxShadow:[BoxShadow(
          color:s?const Color(0xFF1A6B1A).withOpacity(.3):Colors.black.withOpacity(.08),
          blurRadius:s?12:6,offset:const Offset(0,3))]),
      child:Text(l,style:GoogleFonts.poppins(color:s?Colors.white:const Color(0xFF0F2D0F),fontSize:12,fontWeight:FontWeight.w700))));
}

class _SBox extends StatelessWidget {
  final String top,bot; final IconData icon; final Color col;
  const _SBox(this.top,this.bot,this.icon,this.col);
  @override Widget build(BuildContext context)=>Container(
    padding:const EdgeInsets.symmetric(vertical:12),
    decoration:BoxDecoration(color:col.withOpacity(.07),borderRadius:BorderRadius.circular(14),
      border:Border.all(color:col.withOpacity(.15))),
    child:Column(children:[
      Icon(icon,size:18,color:col),
      const SizedBox(height:4),
      Text(top,style:GoogleFonts.nunito(fontSize:13,fontWeight:FontWeight.w900,color:const Color(0xFF0F2D0F))),
      Text(bot,style:GoogleFonts.poppins(fontSize:8,color:Colors.grey.shade500),textAlign:TextAlign.center),
    ]));
}
