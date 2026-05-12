import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'gobike_bike_map_screen.dart';

class GoBikeBikePaymentScreen extends StatefulWidget {
  final BikeStation? station;
  const GoBikeBikePaymentScreen({super.key, this.station});
  @override State<GoBikeBikePaymentScreen> createState() => _PayState();
}

class _PayState extends State<GoBikeBikePaymentScreen> with SingleTickerProviderStateMixin {
  int _plan = 0;
  late final AnimationController _entry =
      AnimationController(vsync:this,duration:const Duration(milliseconds:600))..forward();

  static const _plans = [
    {'label':'🎁 30 min','price':'Gratuit','sub':'Parfait pour un tour rapide !','badge':'','dh':0.0},
    {'label':'☀️ 1 Journée','price':'50 DH','sub':'Roulez toute la journée !','badge':'POPULAIRE','dh':50.0},
    {'label':'🚀 Mensuel','price':'299 DH','sub':'Le deal du siècle 🤑','badge':'BEST VALUE','dh':299.0},
  ];

  double get _total => (_plans[_plan]['dh'] as double);
  BikeStation? get _st => widget.station;

  @override void dispose() { _entry.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFFF5F7FA),
      body: FadeTransition(
        opacity: CurvedAnimation(parent:_entry,curve:Curves.easeOut),
        child: Column(children:[

          // ── HEADER ────────────────────────────────────────────────────────
          Container(
            padding:const EdgeInsets.fromLTRB(20,52,20,24),
            decoration:BoxDecoration(
              gradient:LinearGradient(
                colors:_st!=null?[_st!.color.withOpacity(0.8),_st!.color,const Color(0xFF0F2D0F)]
                    :[const Color(0xFF0F2D0F),const Color(0xFF1A6B1A),const Color(0xFF22C55E)],
                begin:Alignment.topLeft,end:Alignment.bottomRight),
              borderRadius:const BorderRadius.vertical(bottom:Radius.circular(32))),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Row(children:[
                GestureDetector(onTap:()=>Navigator.pop(context),
                  child:Container(width:42,height:42,
                    decoration:BoxDecoration(color:Colors.white.withOpacity(0.15),borderRadius:BorderRadius.circular(14)),
                    child:const Icon(Icons.arrow_back_rounded,color:Colors.white,size:20))),
                const SizedBox(width:14),
                Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text('Déverrouillage',style:GoogleFonts.poppins(color:Colors.white70,fontSize:11)),
                  Text(_st?.name??'Station GoBike',style:GoogleFonts.poppins(color:Colors.white,fontSize:18,fontWeight:FontWeight.w800)),
                ])),
                Container(padding:const EdgeInsets.symmetric(horizontal:12,vertical:6),
                  decoration:BoxDecoration(color:Colors.white.withOpacity(0.15),borderRadius:BorderRadius.circular(16)),
                  child:Text('GoBike-047',style:GoogleFonts.poppins(color:Colors.white,fontSize:11,fontWeight:FontWeight.w700))),
              ]),
              const SizedBox(height:16),
              // Fun message
              Container(padding:const EdgeInsets.all(12),
                decoration:BoxDecoration(color:Colors.white.withOpacity(0.12),borderRadius:BorderRadius.circular(14)),
                child:Row(children:[
                  Text(_st?.fun??'Prêt à rouler !',style:GoogleFonts.nunito(color:Colors.white,fontSize:13,fontWeight:FontWeight.w800)),
                  const Spacer(),
                  Text(_st?.emoji??'🚲',style:const TextStyle(fontSize:22)),
                  const SizedBox(width:4),
                  Text('${_st?.typeLabel??'Vélo'} · ${_st?.distance??'--'}',
                    style:GoogleFonts.poppins(color:Colors.white70,fontSize:11)),
                ])),
            ]),
          ),

          Expanded(child:SingleChildScrollView(
            physics:const BouncingScrollPhysics(),
            padding:const EdgeInsets.all(20),
            child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[

              Text('Choisissez votre formule 👇',style:GoogleFonts.poppins(fontSize:16,fontWeight:FontWeight.w800,color:const Color(0xFF0F2D0F))),
              const SizedBox(height:14),

              // Plans
              ...List.generate(_plans.length,(i){
                final p=_plans[i]; final sel=_plan==i;
                return GestureDetector(
                  onTap:(){ setState(()=>_plan=i); HapticFeedback.lightImpact(); },
                  child:AnimatedContainer(
                    duration:const Duration(milliseconds:220),
                    margin:const EdgeInsets.only(bottom:12),
                    padding:const EdgeInsets.all(16),
                    decoration:BoxDecoration(
                      color:sel?const Color(0xFF0F2D0F):Colors.white,
                      borderRadius:BorderRadius.circular(20),
                      border:Border.all(color:sel?const Color(0xFF22C55E):Colors.grey.shade200,width:sel?2:1),
                      boxShadow:[BoxShadow(
                        color:sel?const Color(0xFF1A6B1A).withOpacity(0.25):Colors.black.withOpacity(0.04),
                        blurRadius:sel?20:8,offset:const Offset(0,4))]),
                    child:Row(children:[
                      AnimatedContainer(duration:const Duration(milliseconds:200),
                        width:22,height:22,
                        decoration:BoxDecoration(shape:BoxShape.circle,
                          color:sel?const Color(0xFF22C55E):Colors.transparent,
                          border:Border.all(color:sel?const Color(0xFF22C55E):Colors.grey.shade400,width:2)),
                        child:sel?const Icon(Icons.check,color:Colors.white,size:14):null),
                      const SizedBox(width:14),
                      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        Row(children:[
                          Text(p['label'] as String,style:GoogleFonts.poppins(fontSize:15,fontWeight:FontWeight.w800,
                            color:sel?Colors.white:const Color(0xFF0F2D0F))),
                          if((p['badge'] as String).isNotEmpty)...[
                            const SizedBox(width:8),
                            Container(padding:const EdgeInsets.symmetric(horizontal:8,vertical:2),
                              decoration:BoxDecoration(color:const Color(0xFF22C55E),borderRadius:BorderRadius.circular(8)),
                              child:Text(p['badge'] as String,style:GoogleFonts.poppins(fontSize:9,fontWeight:FontWeight.w800,color:Colors.white))),
                          ],
                        ]),
                        Text(p['sub'] as String,style:GoogleFonts.poppins(fontSize:11,color:sel?Colors.white60:Colors.grey.shade500)),
                      ])),
                      Text(p['price'] as String,style:GoogleFonts.nunito(fontSize:20,fontWeight:FontWeight.w900,
                        color:sel?const Color(0xFF22C55E):const Color(0xFF1A6B1A))),
                    ]),
                  ),
                );
              }),

              const SizedBox(height:8),
              Text('💳 Paiement',style:GoogleFonts.poppins(fontSize:16,fontWeight:FontWeight.w800,color:const Color(0xFF0F2D0F))),
              const SizedBox(height:14),

              // Card
              Container(padding:const EdgeInsets.all(16),
                decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(20),
                  border:Border.all(color:Colors.grey.shade200),
                  boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.04),blurRadius:8,offset:const Offset(0,2))]),
                child:Column(children:[
                  Row(children:[
                    Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),
                      decoration:BoxDecoration(color:const Color(0xFF1A1F71),borderRadius:BorderRadius.circular(6)),
                      child:Text('VISA',style:GoogleFonts.poppins(color:Colors.white,fontSize:11,fontWeight:FontWeight.w900))),
                    const SizedBox(width:12),
                    Text('•••• •••• •••• 4242',style:GoogleFonts.poppins(fontSize:15,fontWeight:FontWeight.w700,color:const Color(0xFF0F2D0F))),
                    const Spacer(),
                    Text('Défaut',style:GoogleFonts.poppins(fontSize:11,color:const Color(0xFF22C55E),fontWeight:FontWeight.w600)),
                  ]),
                  const SizedBox(height:14),
                  const Divider(height:1),
                  const SizedBox(height:14),
                  Row(children:[
                    Expanded(child:_Field('CVV','•••')),
                    const SizedBox(width:12),
                    Expanded(child:_Field('Expiration','12 / 26')),
                  ]),
                ])),

              const SizedBox(height:14),
              Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:10),
                decoration:BoxDecoration(color:const Color(0xFFE8F5E9),borderRadius:BorderRadius.circular(12),
                  border:Border.all(color:const Color(0xFF1A6B1A).withOpacity(0.2))),
                child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
                  const Icon(Icons.lock_rounded,size:14,color:Color(0xFF1A6B1A)),
                  const SizedBox(width:8),
                  Text('Paiement sécurisé par GoPay · SSL 256-bit',style:GoogleFonts.poppins(fontSize:11,color:const Color(0xFF1A6B1A),fontWeight:FontWeight.w600)),
                ])),

              const SizedBox(height:22),
              Row(children:[
                Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Text('Total à payer',style:GoogleFonts.poppins(fontSize:11,color:Colors.grey.shade500)),
                  Text(_total==0?'Gratuit 🎁':'${_total.toStringAsFixed(0)} DH',
                    style:GoogleFonts.nunito(fontSize:30,fontWeight:FontWeight.w900,color:const Color(0xFF0F2D0F))),
                ]),
                const SizedBox(width:16),
                Expanded(child:GestureDetector(
                  onTap:(){
                    HapticFeedback.mediumImpact();
                    Navigator.pushReplacementNamed(context,'/service/gobike/active-ride',arguments:widget.station);
                  },
                  child:Container(height:58,
                    decoration:BoxDecoration(
                      gradient:LinearGradient(
                        colors:_st!=null?[_st!.color,const Color(0xFF0F2D0F)]:[const Color(0xFF22C55E),const Color(0xFF0F2D0F)],
                        begin:Alignment.topLeft,end:Alignment.bottomRight),
                      borderRadius:BorderRadius.circular(29),
                      boxShadow:[BoxShadow(color:const Color(0xFF1A6B1A).withOpacity(0.4),blurRadius:20,offset:const Offset(0,8))]),
                    child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[
                      const Icon(Icons.electric_bolt_rounded,color:Colors.white,size:22),
                      const SizedBox(width:10),
                      Text('Hop on & Rouler !',style:GoogleFonts.nunito(color:Colors.white,fontSize:16,fontWeight:FontWeight.w900)),
                    ])),
                )),
              ]),
              const SizedBox(height:20),
            ]),
          )),
        ]),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String l,h; const _Field(this.l,this.h);
  @override Widget build(BuildContext context)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(l,style:GoogleFonts.poppins(fontSize:11,color:Colors.grey.shade500,fontWeight:FontWeight.w600)),
    const SizedBox(height:6),
    Container(height:44,padding:const EdgeInsets.symmetric(horizontal:14),
      decoration:BoxDecoration(color:const Color(0xFFF5F7FA),borderRadius:BorderRadius.circular(12),
        border:Border.all(color:Colors.grey.shade200)),
      child:Align(alignment:Alignment.centerLeft,
        child:Text(h,style:GoogleFonts.poppins(fontSize:14,fontWeight:FontWeight.w600,color:const Color(0xFF0F2D0F))))),
  ]);
}
