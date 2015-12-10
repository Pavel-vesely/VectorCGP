part of cgp;

abstract class CGPNode {
  final int order;
  Genotype gen;

  CGPNode(this.gen, this.order);
  void initialize();
  void printLog(Element target);
  CGPNode copy(Genotype iGen);
}

class GenoNode extends CGPNode {
  int in1;
  int in2;
  int funct;
  int param;

  GenoNode(Genotype iGen, int iOrder) : super(iGen, iOrder);

  void initialize() {
    var rng = new Random();
    in1 = rng.nextInt(order);
    in2 = rng.nextInt(order);
    funct = rng.nextInt(gen.functLen);
    param = rng.nextInt(gen.maxInt);
  }

  void printLog(Element target) {
    target.innerHtml += "N$order: in1=$in1, in2=$in2, p=$param, f=$funct <br>";
  }

  GenoNode copy(Genotype iGen) {
    GenoNode newNode = new GenoNode(iGen, this.order);
    newNode.in1 = this.in1;
    newNode.in2 = this.in2;
    newNode.funct = this.funct;
    newNode.param = this.param;
    return newNode;
  }
}


class InNode extends CGPNode {
  String meaning;
  InNode(Genotype iGen, int iOrder, String iMeaning) : super(iGen, iOrder) {
    this.meaning = iMeaning;
  }

  void initialize() {
    throw ("Input can't be initialized!");
  }

  void printLog(Element target) {
    target.innerHtml += "InN$order: meaning=$meaning <br>";
  }

  InNode copy(Genotype iGen) {
    InNode newNode = new InNode(iGen, this.order, this.meaning);
    return newNode;
  }

}

class OutNode extends CGPNode {
  String meaning;
  int in1;
  OutNode(Genotype iGen, int iOrder, String iMeaning) : super(iGen, iOrder) {
    this.meaning = iMeaning;
  }

  void initialize() {
    var rng = new Random();
    in1 = rng.nextInt(order);
  }

  void printLog(Element target) {
    target.innerHtml += "OutN$order: in1=$in1 meaning=$meaning <br>";
  }

  OutNode copy(Genotype iGen) {
    OutNode newNode = new OutNode(iGen, this.order, this.meaning);
    newNode.in1 = this.in1;
    return newNode;
  }

}
