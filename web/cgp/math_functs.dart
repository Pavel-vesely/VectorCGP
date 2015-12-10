part of cgp;

final f_ashmil0 = [(x, y, p) => "($x | $y)",
                  (x, y, p) => "($p & $x)",
                  (x, y, p) => "($x / (1.0+$y+$p))",
                  (x, y, p) => "(($x * $y)%$MODULO)",
                  (x, y, p) => "(($x + $y)%$MODULO)",
                  (x, y, p) => "(Math.abs($x - $y))",
                  (x, y, p) => "(($MODULO - $x)%$MODULO)",
                  (x, y, p) => "(Math.abs(Math.cos($x)*$MODULO))",
                  (x, y, p) => "(Math.abs(Math.tan(($x%45)*Math.PI/180.0*$MODULO)))",
                  (x, y, p) => "(Math.abs(Math.tan(($x)*$MODULO)%$MODULO))",
                  (x, y, p) => "(Math.sqrt((($x-$p)*($x-$p))+(($y-$p)*($y-$p)))%$MODULO)",
                  (x, y, p) => "(($x%($p+1))+$MODULO-$p)",
                  (x, y, p) => "(($x + $y) / 2)",
                  (x, y, p) => "(($x>$y)?(255*(($y+1)/($x+1))):($MODULO*(($x+1)/($y+1))))",
                  (x, y, p) => "(Math.abs(Math.sqrt((($x*$x)+($y*$y)-(2*($p*$p)))%$MODULO+$MODULO)%$MODULO))",];//"(Math.abs(Math.sqrt((($x*$x)+($y*$y)-(2*($p*$p)))%$MODULO+$MODULO)%$MODULO)"
final List<String> in_ashmil0 = ["x","y"];