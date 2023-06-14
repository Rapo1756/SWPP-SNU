#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/IR/Argument.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Operator.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/raw_ostream.h"
#include <functional>

using namespace llvm;
using namespace std;

namespace {
class PropagateIntegerEquality
    : public PassInfoMixin<PropagateIntegerEquality> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    DominatorTree &DT = FAM.getResult<DominatorTreeAnalysis>(F);
    
    for (auto &BB : F) {
      if (auto *branch = dyn_cast<BranchInst>(BB.getTerminator())) {
        if (branch->isConditional()) {
          if (auto *condInst = dyn_cast<ICmpInst>(branch->getCondition())) {
            if (condInst->getPredicate() == CmpInst::ICMP_EQ) {
              auto *trueBB = branch->getSuccessor(0);
              auto *x = condInst->getOperand(0);
              auto *y = condInst->getOperand(1);
              bool replaceX = replaceXtoY(x, y, DT);
              SmallVector<BasicBlock *> descendants;
              BasicBlockEdge BBE(&BB, trueBB);
              DT.getDescendants(&BB, descendants);
              for (auto *desc : descendants) {
                if (DT.dominates(BBE, desc)) {
                  for (auto &inst : *desc) {
                    if (replaceX)
                      inst.replaceUsesOfWith(x, y);
                    else
                      inst.replaceUsesOfWith(y, x);
                  }
                }
              }
            }
          }
        }
      }
    }
    return PreservedAnalyses::all();
  }

  bool dominates(Instruction *A, Instruction *B, DominatorTree &DT) {
    auto *AParent = A->getParent();
    auto *BParent = B->getParent();
    return DT.properlyDominates(AParent, BParent) || ((AParent == BParent) && A->comesBefore(B));
  }

  bool replaceXtoY(Value *x, Value *y, DominatorTree &DT) {
    if (auto *xInst = dyn_cast<Instruction>(x)) {
      if (auto *yInst = dyn_cast<Instruction>(y))
        return dominates(yInst, xInst, DT);
      else
        return isa<Argument>(y);
    }
    else if (auto *xArg = dyn_cast<Argument>(x)) {
      if (auto *yArg = dyn_cast<Argument>(y))
        return xArg->getArgNo() > yArg->getArgNo();
      else
        return !isa<Instruction>(y);
    }
    return false;
  }
};
} // namespace

extern "C" ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "PropagateIntegerEquality", "v0.1",
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "prop-int-eq") {
                    FPM.addPass(PropagateIntegerEquality());
                    return true;
                  }
                  return false;
                });
          }};
}
