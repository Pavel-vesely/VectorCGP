library cgp;

import 'dart:html';
import 'dart:math';
import 'dart:js';
part 'genotype.dart';
part 'node.dart';
part 'math_functs.dart';


//Nastaveni
const MAXINT = 256;
const MODULO = 256;
const RESOLUTION = 256;
const CANVSONSCREEN = 9;
final funcList = f_ashmil0;
List<String> inMeans = in_ashmil0;
final List<String> outMeans = ["getX = ", "getY = ", "getXSize = ", "getYSize = ", "getRed = ", "getGreen = ", "getBlue = ", "getShape = ", "getRotation = "];


//Genotype rootGentp = null;
List<Genotype>gentps = null;//, 
List<Genotype>prevGentps = null;
int genIndex = 0;
bool isStepBack = false;
int speedMul;

void main() {
  
  querySelector("#startButton").onClick.listen((MouseEvent e) => start());
  querySelector("#redrawButton").onClick.listen((MouseEvent e) => drawGens());
  querySelector("#backButton").onClick.listen((MouseEvent e) => stepBack());
//  InputElement mutScaleIn = querySelector("#mutScaleIn");
//  mutScaleIn.onFocus.listen((MouseEvent e) => context.callMethod("focusAllText", [mutScaleIn]));
//  var obj = context['config'];
  context.callMethod("initialize", []);
  for (int i = 0; i < CANVSONSCREEN; i++) 
      querySelector("#innerWrap$i").onClick.listen((MouseEvent e) => mutate(i));
  start();
}

void start() {
  genIndex = 0;
  int numOfNodes;
  try {
      InputElement numOfNodesIn = querySelector("#numOfNodesIn");
      numOfNodes = int.parse(numOfNodesIn.value);  
    } catch(e) {
      window.alert("Zadejte počet nodů - číslo 10-80");
          querySelector("#numOfNodesIn").focus();
          return;
    }
    
    if (numOfNodes < 10 || numOfNodes > 80) {
        window.alert("Zadejte počet nodů - číslo 10-80");
        querySelector("#numOfNodesIn").focus();
        return;
      }
//  InputElement mutScaleIn = querySelector("#mutScaleIn");
//  mutScaleIn.value = (numOfNodes/3).truncate().toString();
  speedMul = (numOfNodes/12).truncate();
  prevGentps = new List<Genotype>(CANVSONSCREEN);
  isStepBack = false;
  context.callMethod("disable",["backButton"]);
  gentps = new List<Genotype>(CANVSONSCREEN);
  for (int i = 0; i < CANVSONSCREEN; i++){
    gentps[i] = new Genotype(MAXINT, funcList, inMeans, numOfNodes, outMeans);
    gentps[i].initialize();
  }
  drawGens();
}

mutate(i){
  for (int i = 0; i < CANVSONSCREEN; i++){
      prevGentps[i] = gentps[i].deepCopy();
  }
  isStepBack = true;
  context.callMethod("enable",["backButton"]);
  genIndex++;
  Genotype rootGentp = gentps[i];
  InputElement mutScaleIn = querySelector("#mutScaleIn");
  int mutScale = int.parse(mutScaleIn.value) * speedMul;
//  try {
//    InputElement mutScaleIn = querySelector("#mutScaleIn");
//    mutScale = int.parse(mutScaleIn.value);  
//  } catch(e) {
//    window.alert("Zadejte rychlost mutace - číslo 1-50");
//        querySelector("#mutScaleIn").focus();
//        return;
//  }
//  
//  if (mutScale < 0 || mutScale > 50) {
//      window.alert("Zadejte rychlost mutace - číslo 1-50");
//      querySelector("#mutScaleIn").focus();
//      return;
//    }
  
    
  for (int i = 0; i < CANVSONSCREEN; i++){
    gentps[i] = rootGentp.deepCopy();
//    querySelector("#logbox1").innerHtml = mutScale.toString();
    gentps[i].mutate(mutScale);
  }
//  Genotype newGen = gentps[i].deepCopy();
  drawGens();
  
}

void stepBack() {  
  if (isStepBack == false) {
    return;
  }
  isStepBack = false;
  context.callMethod("disable",["backButton"]);
  genIndex--;
  for (int i = 0; i < CANVSONSCREEN; i++){
    gentps[i] = prevGentps[i].deepCopy();
    }
  drawGens();
}

void drawGens() {
  Element genIndexSpan = querySelector("#genIndexSpan");
  genIndexSpan.text = genIndex.toString();
//  int yMul;
//  try {
//      InputElement yMulIn = querySelector("#yMulIn");
//      yMul = int.parse(yMulIn.value);  
//    } catch(e) {
//      window.alert("Zadejte y-multiplikátor - číslo 1-32");
//          querySelector("#yMulIn").focus();
//          return;
//    }
//    
//    if (yMul < 0 || yMul > 32) {
//        window.alert("Zadejte y-multiplikátor - číslo 1-32");
//        querySelector("#yMulIn").focus();
//        return;
//      }
  for (int i = 0; i < CANVSONSCREEN; i++){
    List<String> resolved = resolve(gentps[i]);
//    var obj = context['config'];
    //querySelector("#logbox1").innerHtml = "";
    for (String func in resolved) {
      context.callMethod("eval", [func]);
      //querySelector("#logbox1").innerHtml  += func + "<br>";
    }
    
    context.callMethod("draw", [i]);
  }
  
}

  
List<String> resolve(Genotype gen) {
  List<String> ret = new List<String>();
  ret.addAll(outMeans);
  int i = 0;
  for (CGPNode out in gen.outNodes) {
    ret[i] += "function(x,y){return ";
    ret[i] += oneUp(out, gen);
    ret[i] += "}";
    i++;
  }
  return ret;
}

String oneUp(CGPNode node, Genotype gen) {
  if (node is InNode) {
    return node.meaning;
  }
  if (node is OutNode) {
    return oneUp(gen.allNodes[node.in1], gen);
  }
  if (node is GenoNode) {
    String in1val = oneUp(gen.allNodes[node.in1], gen);
    String in2val = oneUp(gen.allNodes[node.in2], gen);
    return funcList[node.funct](in1val, in2val, node.param);
  }
  return null;
}
