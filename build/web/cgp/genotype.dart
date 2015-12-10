part of cgp;


class Genotype {
  int maxInt;
  List functs;
  List<String> inMeans;
  int nds;
  List<String> outMeans;
  get functLen => functs.length;
  List<CGPNode> inNodes;
  List<CGPNode> nodes;
  List<CGPNode> outNodes;


  Genotype(this.maxInt, this.functs, this.inMeans, this.nds, this.outMeans) {
    inNodes = new List<CGPNode>(inMeans.length);
    for (int i = 0; i < inMeans.length; i++) {
      inNodes[i] = new InNode(this, i, inMeans[i]);
    }
    int ordShift = inMeans.length;
    nodes = new List<CGPNode>(nds);
    for (int i = 0; i < nds; i++) {
      nodes[i] = new GenoNode(this, i + ordShift);
    }
    ordShift += nds;
    outNodes = new List<CGPNode>(outMeans.length);
    for (int i = 0; i < outMeans.length; i++) {
      outNodes[i] = new OutNode(this, i + ordShift, outMeans[i]);
    }
  }

  void initialize() {
    for (CGPNode n in nodes) {
      n.initialize();
    }
    for (CGPNode n in outNodes) {
      n.initialize();
    }
  }

  void printLog(Element target) {

    target.innerHtml = "Gen: maxInt=$maxInt, funcLen=$functLen, NONodes=" + (inNodes.length + nodes.length + outNodes.length).toString() + "<br>";
    for (CGPNode n in inNodes) {
      n.printLog(target);
    }
    for (CGPNode n in nodes) {
      n.printLog(target);
    }
    for (CGPNode n in outNodes) {
      n.printLog(target);
    }

  }

  Genotype deepCopy() {
    Genotype newGen = new Genotype(this.maxInt, this.functs, this.inMeans, this.nds, this.outMeans);
    newGen.inNodes = new List<CGPNode>();
    for (CGPNode node in inNodes) newGen.inNodes.add(node.copy(newGen));
    newGen.nodes = new List<CGPNode>();
    for (CGPNode node in nodes) newGen.nodes.add(node.copy(newGen));
    newGen.outNodes = new List<CGPNode>();
    for (CGPNode node in outNodes) newGen.outNodes.add(node.copy(newGen));

    return newGen;
  }

  void mutate(int scale) {
    var rng = new Random();
    int typeOfMut;
    for (int i = 0; i < scale; i++) {
      typeOfMut = rng.nextInt(4); //typeOfMut = int 0..3
      switch (typeOfMut) {
        case 0:
          int o = rng.nextInt(nodes.length + outNodes.length);
          if (o < nodes.length) { //Naprasene, ale chci snizit statistic. sanci zmeny u vystup. nodu
            GenoNode n = nodes[o];
            n.in1 = rng.nextInt(n.order);
          } else {
            o -= nodes.length;
            OutNode n = outNodes[o];
            n.in1 = rng.nextInt(n.order);
          }
          break;
        case 1:
          int o = rng.nextInt(nodes.length);
          GenoNode n = nodes[o];
          n.in2 = rng.nextInt(n.order);
          break;
        case 2:
          int o = rng.nextInt(nodes.length);
          GenoNode n = nodes[o];
          n.funct = rng.nextInt(this.functLen);
          break;
        case 3:
          int o = rng.nextInt(nodes.length);
          GenoNode n = nodes[o];
          n.param = rng.nextInt(this.maxInt);
          break;
      }
    }
  }

  get allNodes {
    List<CGPNode> ls = new List<CGPNode>();
    ls.addAll(inNodes);
    ls.addAll(nodes);
    ls.addAll(outNodes);
    return ls;
  }

}
