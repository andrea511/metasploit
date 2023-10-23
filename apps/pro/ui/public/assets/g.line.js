/*
 * g.Raphael 0.4.2 - Charting library, based on Raphaël
 *
 * Copyright (c) 2009 Dmitry Baranovskiy (http://g.raphaeljs.com)
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
 */

Raphael.fn.g.linechart=function(M,L,b,d,t,s,F){function E(x,ae){var i=x.length/ae,y=0,a=i,Y=0,X=[];while(y<x.length){a--;if(a<0){Y+=x[y]*(1+a);X.push(Y/i);Y=x[y++]*-a;a+=i}else{Y+=x[y++]}}return X}function P(j,i,aj,ah,ae,Y){var y=(aj-j)/2,x=(ae-aj)/2,ak=Math.atan((aj-j)/Math.abs(ah-i)),ai=Math.atan((ae-aj)/Math.abs(ah-Y));ak=i<ah?Math.PI-ak:ak;ai=Y<ah?Math.PI-ai:ai;var X=Math.PI/2-((ak+ai)%(Math.PI*2))/2,am=y*Math.sin(X+ak),ag=y*Math.cos(X+ak),al=x*Math.sin(X+ai),af=x*Math.cos(X+ai);return{x1:aj-am,y1:ah+ag,x2:aj+al,y2:ah+af}}F=F||{};if(!this.raphael.is(t[0],"array")){t=[t]}if(!this.raphael.is(s[0],"array")){s=[s]}var m=F.gutter||10,u=Math.max(t[0].length,s[0].length),o=F.symbol||"",Q=F.colors||Raphael.fn.g.colors,K=this,q=null,l=null,ab=this.set(),R=[];for(var aa=0,H=s.length;aa<H;aa++){u=Math.max(u,s[aa].length)}var ac=this.set();for(aa=0,H=s.length;aa<H;aa++){if(F.shade){ac.push(this.path().attr({stroke:"none",fill:Q[aa],opacity:F.nostroke?1:0.3}))}if(s[aa].length>b-2*m){s[aa]=E(s[aa],b-2*m);u=b-2*m}if(t[aa]&&t[aa].length>b-2*m){t[aa]=E(t[aa],b-2*m)}}var U=Array.prototype.concat.apply([],t),S=Array.prototype.concat.apply([],s),p=this.g.snapEnds(Math.min.apply(Math,U),Math.max.apply(Math,U),t[0].length-1),z=p.from,k=p.to,J=this.g.snapEnds(Math.min.apply(Math,S),Math.max.apply(Math,S),s[0].length-1),v=J.from,h=J.to,V=(b-m*2)/((k-z)||1),T=(d-m*2)/((h-v)||1);var B=this.set();if(F.axis){var g=(F.axis+"").split(/[,\s]+/);+g[0]&&B.push(this.g.axis(M+m,L+m,b-2*m,z,k,F.axisxstep||Math.floor((b-2*m)/20),2));+g[1]&&B.push(this.g.axis(M+b-m,L+d-m,d-2*m,v,h,F.axisystep||Math.floor((d-2*m)/20),3));+g[2]&&B.push(this.g.axis(M+m,L+d-m,b-2*m,z,k,F.axisxstep||Math.floor((b-2*m)/20),0));+g[3]&&B.push(this.g.axis(M+m,L+d-m,d-2*m,v,h,F.axisystep||Math.floor((d-2*m)/20),1))}var I=this.set(),W=this.set(),n;for(aa=0,H=s.length;aa<H;aa++){if(!F.nostroke){I.push(n=this.path().attr({stroke:Q[aa],"stroke-width":F.width||2,"stroke-linejoin":"round","stroke-linecap":"round","stroke-dasharray":F.dash||""}))}var c=this.raphael.is(o,"array")?o[aa]:o,C=this.set();R=[];for(var Z=0,r=s[aa].length;Z<r;Z++){var f=M+m+((t[aa]||t[0])[Z]-z)*V,e=L+d-m-(s[aa][Z]-v)*T;(Raphael.is(c,"array")?c[Z]:c)&&C.push(this.g[Raphael.fn.g.markers[this.raphael.is(c,"array")?c[Z]:c]](f,e,(F.width||2)*3).attr({fill:Q[aa],stroke:"none"}));if(F.smooth){if(Z&&Z!=r-1){var O=M+m+((t[aa]||t[0])[Z-1]-z)*V,A=L+d-m-(s[aa][Z-1]-v)*T,N=M+m+((t[aa]||t[0])[Z+1]-z)*V,w=L+d-m-(s[aa][Z+1]-v)*T;var ad=P(O,A,f,e,N,w);R=R.concat([ad.x1,ad.y1,f,e,ad.x2,ad.y2])}if(!Z){R=["M",f,e,"C",f,e]}}else{R=R.concat([Z?"L":"M",f,e])}}if(F.smooth){R=R.concat([f,e,f,e])}W.push(C);if(F.shade){ac[aa].attr({path:R.concat(["L",f,L+d-m,"L",M+m+((t[aa]||t[0])[0]-z)*V,L+d-m,"z"]).join(",")})}!F.nostroke&&n.attr({path:R.join(",")})}function G(ak){var ah=[];for(var ai=0,am=t.length;ai<am;ai++){ah=ah.concat(t[ai])}ah.sort();var an=[],ae=[];for(ai=0,am=ah.length;ai<am;ai++){ah[ai]!=ah[ai-1]&&an.push(ah[ai])&&ae.push(M+m+(ah[ai]-z)*V)}ah=an;am=ah.length;var Y=ak||K.set();for(ai=0;ai<am;ai++){var y=ae[ai]-(ae[ai]-(ae[ai-1]||M))/2,al=((ae[ai+1]||M+b)-ae[ai])/2+(ae[ai]-(ae[ai-1]||M))/2,a;ak?(a={}):Y.push(a=K.rect(y-1,L,Math.max(al+1,1),d).attr({stroke:"none",fill:"#000",opacity:0}));a.values=[];a.symbols=K.set();a.y=[];a.x=ae[ai];a.axis=ah[ai];for(var ag=0,aj=s.length;ag<aj;ag++){an=t[ag]||t[0];for(var af=0,x=an.length;af<x;af++){if(an[af]==ah[ai]){a.values.push(s[ag][af]);a.y.push(L+d-m-(s[ag][af]-v)*T);a.symbols.push(ab.symbols[ag][af])}}}ak&&ak.call(a)}!ak&&(q=Y)}function D(ai){var ae=ai||K.set(),a;for(var ag=0,ak=s.length;ag<ak;ag++){for(var af=0,ah=s[ag].length;af<ah;af++){var y=M+m+((t[ag]||t[0])[af]-z)*V,aj=M+m+((t[ag]||t[0])[af?af-1:1]-z)*V,x=L+d-m-(s[ag][af]-v)*T;ai?(a={}):ae.push(a=K.circle(y,x,Math.abs(aj-y)/2).attr({stroke:"none",fill:"#000",opacity:0}));a.x=y;a.y=x;a.value=s[ag][af];a.line=ab.lines[ag];a.shade=ab.shades[ag];a.symbol=ab.symbols[ag][af];a.symbols=ab.symbols[ag];a.axis=(t[ag]||t[0])[af];ai&&ai.call(a)}}!ai&&(l=ae)}ab.push(I,ac,W,B,q,l);ab.lines=I;ab.shades=ac;ab.symbols=W;ab.axis=B;ab.hoverColumn=function(i,a){!q&&G();q.mouseover(i).mouseout(a);return this};ab.clickColumn=function(a){!q&&G();q.click(a);return this};ab.hrefColumn=function(X){var Y=K.raphael.is(arguments[0],"array")?arguments[0]:arguments;if(!(arguments.length-1)&&typeof X=="object"){for(var a in X){for(var j=0,y=q.length;j<y;j++){if(q[j].axis==a){q[j].attr("href",X[a])}}}}!q&&G();for(j=0,y=Y.length;j<y;j++){q[j]&&q[j].attr("href",Y[j])}return this};ab.hover=function(i,a){!l&&D();l.mouseover(i).mouseout(a);return this};ab.click=function(a){!l&&D();l.click(a);return this};ab.each=function(a){D(a);return this};ab.eachColumn=function(a){G(a);return this};return ab};
