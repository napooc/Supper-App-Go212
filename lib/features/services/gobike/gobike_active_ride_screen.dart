import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gobike_bike_map_screen.dart';

class GoBikeActiveRideScreen extends StatefulWidget {
  final BikeStation? station;
  const GoBikeActiveRideScreen({super.key, this.station});
  @override State<GoBikeActiveRideScreen> createState() => _RideState();
}

class _RideState extends State<GoBikeActiveRideScreen> with TickerProviderStateMixin {
  Timer? _timer;
  int _secs = 0;
  double _dist = 0.0;
  double _cost = 0.0;
  int _battery = 87;

  late final AnimationController _pulse =
      AnimationController(vsync:this,duration:const Duration(seconds:2))..repeat(reverse:true);
  late final AnimationController _wheel =
      AnimationController(vsync:this,duration:const Duration(milliseconds:800))..repeat();
  late final AnimationController _entry =
      AnimationController(vsync:this,duration:const Duration(milliseconds:800))..forward();

  BikeStation? get _st => widget.station;
  static const _g = Color(0xFF22C55E);
  static const _d = Color(0xFF0F2D0F);

  @override void initState() {
    super.initState();
    HapticFeedback.mediumImpact();
    _timer = Timer.periodic(const Duration(seconds:1),(_){
      if(!mounted)return;
      setState((){
        _secs++;
        _dist = (_secs*15.0/3600).clamp(0,999);
        final billable=((_secs/60)-30).clamp(0.0,double.infinity);
        _cost = billable*(_st?.pricePerMin??1.5);
        _battery=(87-(_secs/120).floor()).clamp(0,100);
      });
    });
  }

  @override void dispose(){ _timer?.cancel(); _pulse.dispose(); _wheel.dispose(); _entry.dispose(); super.dispose(); }

  bool get _free => _secs<1800;
  String get _time {
    final h=_secs~/3600; final m=(_secs%3600)~/60; final s=_secs%60;
    return h>0
        ?'${h.toString().padLeft(2,'0')}:${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}'
        :'${m.toString().padLeft(2,'0')}:${s.toString().padLeft(2,'0')}';
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:_d,
      body: ScaleTransition(
        scale:CurvedAnimation(parent:_entry,curve:Curves.easeOutBack),
        child:Stack(children:[

          // Background glow blobs
          AnimatedBuilder(animation:_pulse, builder:(_,__)=>Stack(children:[
            Positioned(top:-60,left:-60,
              child:Container(width:280,height:280,
                decoration:BoxDecoration(shape:BoxShape.circle,
                  gradient:RadialGradient(colors:[_g.withOpacity(0.12+_pulse.value*0.06),Colors.transparent])))),
            Positioned(bottom:-40,right:-40,
              child:Container(width:220,height:220,
                decoration:BoxDecoration(shape:BoxShape.circle,
                  gradient:RadialGradient(colors:[(_st?.color??_g).withOpacity(0.1+_pulse.value*0.05),Colors.transparent])))),
          ])),

          SafeArea(child:Column(children:[

            // ── HEADER ────────────────────────────────────────────────────
            Padding(padding:const EdgeInsets.fromLTRB(20,16,20,0),
              child:Row(children:[
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text('🚴 En route !',style:GoogleFonts.poppins(color:Colors.white54,fontSize:12,fontWeight:FontWeight.w500)),
                  Text(_st?.name??'GoBike Session',style:GoogleFonts.poppins(color:Colors.white,fontSize:18,fontWeight:FontWeight.w800)),
                ])),
                AnimatedBuilder(animation:_pulse,builder:(_,__)=>Container(
                  padding:const EdgeInsets.symmetric(horizontal:12,vertical:7),
                  decoration:BoxDecoration(
                    color:_g.withOpacity(0.15+_pulse.value*0.05),
                    borderRadius:BorderRadius.circular(20),
                    border:Border.all(color:_g.withOpacity(0.3))),
                  child:Row(mainAxisSize:MainAxisSize.min,children:[
                    Container(width:7,height:7,
                      decoration:BoxDecoration(shape:BoxShape.circle,color:_g,
                        boxShadow:[BoxShadow(color:_g.withOpacity(0.4+_pulse.value*0.4),blurRadius:8)])),
                    const SizedBox(width:7),
                    Text('GoBike-047 · Actif',style:GoogleFonts.poppins(color:_g,fontSize:11,fontWeight:FontWeight.w700)),
                  ]))),
              ])),

            const SizedBox(height:28),

            // ── SPINNING WHEEL ─────────────────────────────────────────────
            AnimatedBuilder(animation:_wheel, builder:(_,__)=>Transform.rotate(
              angle:_wheel.value*2*math.pi,
              child:Container(width:80,height:80,
                decoration:BoxDecoration(shape:BoxShape.circle,
                  border:Border.all(color:Colors.white.withOpacity(0.08),width:3)),
                child:Stack(children:[
                  Positioned.fill(child:CustomPaint(painter:_WheelPainter(_wheel.value))),
                  Center(child:Text(_st?.emoji??'🚲',style:const TextStyle(fontSize:28))),
                ])),
            )),

            const SizedBox(height:20),

            // ── BIG TIMER ─────────────────────────────────────────────────
            AnimatedBuilder(animation:_pulse, builder:(_,__)=>Column(children:[
              Transform.scale(
                scale:0.98+_pulse.value*0.02,
                child:Text(_time,style:GoogleFonts.nunito(fontSize:72,fontWeight:FontWeight.w900,
                  color:Colors.white,letterSpacing:-2,height:1))),
              const SizedBox(height:10),
              Container(padding:const EdgeInsets.symmetric(horizontal:18,vertical:7),
                decoration:BoxDecoration(
                  color:(_free?_g:Colors.orange).withOpacity(0.15),
                  borderRadius:BorderRadius.circular(20),
                  border:Border.all(color:(_free?_g:Colors.orange).withOpacity(0.4))),
                child:Text(
                  _free
                    ?'🎉 Gratuit encore ${((1800-_secs)/60).ceil()} min — Profitez !'
                    :'💸 ${_st?.pricePerMin.toStringAsFixed(2)??'1.50'} DH/min · Continuez à rouler !',
                  style:GoogleFonts.poppins(color:_free?_g:Colors.orange,fontSize:11,fontWeight:FontWeight.w700))),
            ])),

            const SizedBox(height:24),

            // ── LIVE STATS ─────────────────────────────────────────────────
            Padding(padding:const EdgeInsets.symmetric(horizontal:20),
              child:Container(padding:const EdgeInsets.all(18),
                decoration:BoxDecoration(
                  color:Colors.white.withOpacity(0.06),
                  borderRadius:BorderRadius.circular(24),
                  border:Border.all(color:Colors.white.withOpacity(0.1))),
                child:Row(children:[
                  Expanded(child:_Stat('${_dist.toStringAsFixed(2)}','km','Route',Icons.route_rounded,const Color(0xFF60A5FA))),
                  Container(width:1,height:50,color:Colors.white.withOpacity(0.1)),
                  Expanded(child:_Stat('$_battery','%','Batterie',Icons.battery_charging_full_rounded,_battery>30?_g:Colors.orange)),
                  Container(width:1,height:50,color:Colors.white.withOpacity(0.1)),
                  Expanded(child:_Stat(_cost==0?'0':_cost.toStringAsFixed(2),_cost==0?'DH':'DH','Coût',Icons.attach_money_rounded,_free?_g:Colors.orange)),
                ]))),

            const SizedBox(height:20),

            // ── FREE PERIOD BAR ────────────────────────────────────────────
            Padding(padding:const EdgeInsets.symmetric(horizontal:20),
              child:Column(children:[
                Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
                  Text('Période gratuite',style:GoogleFonts.poppins(color:Colors.white60,fontSize:12)),
                  Text('${((_secs/1800)*100).clamp(0,100).toInt()}% utilisé',
                    style:GoogleFonts.poppins(color:_g,fontSize:12,fontWeight:FontWeight.w700)),
                ]),
                const SizedBox(height:8),
                ClipRRect(borderRadius:BorderRadius.circular(6),
                  child:LinearProgressIndicator(
                    value:(_secs/1800).clamp(0.0,1.0),
                    backgroundColor:Colors.white.withOpacity(0.08),
                    valueColor:AlwaysStoppedAnimation<Color>(_free?_g:Colors.orange),
                    minHeight:8)),
              ])),

            const Spacer(),

            // ── BUTTONS ───────────────────────────────────────────────────
            Padding(padding:const EdgeInsets.fromLTRB(20,0,20,36),child:Column(children:[
              GestureDetector(
                onTap:(){
                  HapticFeedback.mediumImpact();
                  showDialog(context:context,builder:(_)=>_EndDialog(
                    time:_time,dist:_dist,cost:_cost,
                    onConfirm:()=>Navigator.pushNamedAndRemoveUntil(context,'/service/gobike/review',(r)=>r.isFirst)));
                },
                child:Container(height:58,
                  decoration:BoxDecoration(
                    color:Colors.red.shade700,
                    borderRadius:BorderRadius.circular(29),
                    boxShadow:[BoxShadow(color:Colors.red.withOpacity(0.35),blurRadius:20,offset:const Offset(0,8))]),
                  child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
                    const Icon(Icons.stop_circle_rounded,color:Colors.white,size:22),
                    const SizedBox(width:10),
                    Text('Terminer le trajet 🏁',style:GoogleFonts.nunito(color:Colors.white,fontSize:16,fontWeight:FontWeight.w900)),
                  ]))),
              const SizedBox(height:10),
              GestureDetector(
                onTap:(){},
                child:Container(height:46,
                  decoration:BoxDecoration(
                    color:Colors.white.withOpacity(0.07),
                    borderRadius:BorderRadius.circular(23),
                    border:Border.all(color:Colors.white.withOpacity(0.12))),
                  child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
                    const Icon(Icons.pause_circle_outline_rounded,color:Colors.white60,size:18),
                    const SizedBox(width:8),
                    Text('Mettre en pause',style:GoogleFonts.poppins(color:Colors.white60,fontSize:13,fontWeight:FontWeight.w600)),
                  ]))),
            ])),
          ])),
        ]),
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final double t; _WheelPainter(this.t);
  @override void paint(Canvas canvas, Size size) {
    final c=Offset(size.width/2,size.height/2);
    final r=size.width/2-4;
    final p=Paint()..color=const Color(0x2222C55E)..strokeWidth=2..style=PaintingStyle.stroke;
    for(int i=0;i<8;i++){
      final a=(i/8)*2*math.pi+t*2*math.pi;
      canvas.drawLine(c,Offset(c.dx+r*math.cos(a),c.dy+r*math.sin(a)),p);
    }
  }
  @override bool shouldRepaint(_WheelPainter o)=>o.t!=t;
}

class _Stat extends StatelessWidget {
  final String v,u,l; final IconData i; final Color c;
  const _Stat(this.v,this.u,this.l,this.i,this.c);
  @override Widget build(BuildContext context)=>Column(children:[
    Icon(i,color:c,size:18),
    const SizedBox(height:4),
    RichText(text:TextSpan(children:[
      TextSpan(text:v,style:GoogleFonts.nunito(fontSize:18,fontWeight:FontWeight.w900,color:Colors.white)),
      TextSpan(text:' $u',style:GoogleFonts.poppins(fontSize:10,color:Colors.white54)),
    ])),
    Text(l,style:GoogleFonts.poppins(fontSize:9,color:Colors.white38)),
  ]);
}

class _EndDialog extends StatelessWidget {
  final String time; final double dist,cost; final VoidCallback onConfirm;
  const _EndDialog({required this.time,required this.dist,required this.cost,required this.onConfirm});
  @override Widget build(BuildContext context)=>Dialog(
    shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(28)),
    child:Padding(padding:const EdgeInsets.all(24),
      child:Column(mainAxisSize:MainAxisSize.min,children:[
        Text('🏁',style:const TextStyle(fontSize:48)),
        const SizedBox(height:12),
        Text('Terminer le trajet ?',style:GoogleFonts.poppins(fontSize:18,fontWeight:FontWeight.w800,color:const Color(0xFF0F2D0F))),
        const SizedBox(height:8),
        Text('Durée: $time',style:GoogleFonts.poppins(fontSize:13,color:Colors.grey.shade600)),
        Text('Distance: ${dist.toStringAsFixed(2)} km',style:GoogleFonts.poppins(fontSize:13,color:Colors.grey.shade600)),
        const SizedBox(height:4),
        Container(padding:const EdgeInsets.symmetric(horizontal:16,vertical:8),
          decoration:BoxDecoration(color:const Color(0xFFE8F5E9),borderRadius:BorderRadius.circular(12)),
          child:Text(cost==0?'💚 Trajet gratuit ':'💰 Total: ${cost.toStringAsFixed(2)} DH',
            style:GoogleFonts.poppins(fontSize:14,color:const Color(0xFF1A6B1A),fontWeight:FontWeight.w800))),
        const SizedBox(height:24),
        Row(children:[
          Expanded(child:GestureDetector(onTap:()=>Navigator.pop(context),
            child:Container(height:48,
              decoration:BoxDecoration(color:Colors.grey.shade100,borderRadius:BorderRadius.circular(24)),
              child:Center(child:Text('Annuler',style:GoogleFonts.poppins(fontWeight:FontWeight.w600,color:Colors.grey.shade700)))))),
          const SizedBox(width:12),
          Expanded(child:GestureDetector(
            onTap:(){Navigator.pop(context);onConfirm();},
            child:Container(height:48,
              decoration:BoxDecoration(gradient:const LinearGradient(colors:[Color(0xFF22C55E),Color(0xFF1A6B1A)]),
                borderRadius:BorderRadius.circular(24)),
              child:Center(child:Text('Confirmer 🏆',style:GoogleFonts.poppins(color:Colors.white,fontWeight:FontWeight.w800)))))),
        ]),
      ])),
  );
}
