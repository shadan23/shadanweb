module comp(l,e,g,a,b);
input [3:0] a,b;
output l,e,g;


wire [3:0] equal;
xnor X5[3:0] (equal, a, b);
and(e, equal[3],equal[2],equal[1],equal[0]);


wire[3:0] notA, less;
not mynot[3:0](notA, a);
and(less[3],notA[3],b[3]);
and(less[2],notA[2],b[2],equal[3],equal[2]);
and(less[1],notA[1],b[1],equal[3],equal[2],equal[1]);
and(less[0],notA[0],b[0],equal[3],equal[2],equal[1],equal[0]);
xor(l, less[3],less[2],less[1],less[0]);

wire[3:0] notB, greater;
not mynotB[3:0] (notB, b);
and(greater[3],notB[3],a[3]);
and(greater[2],notB[2],a[2],equal[3]);
and(greater[1],notB[1],a[1],equal[3],equal[2]);
and(greater[0],notB[0],a[0],equal[3],equal[2],equal[1]);
xor(g, greater[3],greater[2],greater[1],greater[0]);



endmodule

module compmux(r,a,b,c);
input[3:0] a,b;
input[1:0] c;
output r;
wire echeck, lcheck, gcheck;
comp comp1(l,e,g,a,b);
wire [1:0] notC;
notmyNot[1:0] (notC,c);
and(echeck, notC[1], notC[0], e);
and(lcheck, notC[0], c[1], l);
and(gcheck, notC[1],  c[0], g);
or(r, echeck, lcheck, gcheck);
endmodule


module main;
reg[3:0] a,b;
wire l,e,g;
comp com(a,b,l,e,g);
compmux MyMux(result,a,b,c);
initial begin
$monitor("a=%b b=%b l=%b e=%b g=%b c=%b result = %b",a,b,l,e,g,c,result);
    a=0000; b=0000; c=00;
#10 a=1000; b=0001; c=10;
#15 a=0101; b=0001; c=11;
#20 a=1110; b=1010; c=01;

#10 $finish;

end
endmodule
