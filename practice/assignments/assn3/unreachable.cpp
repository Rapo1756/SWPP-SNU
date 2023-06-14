#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <cstddef>
#include <string>
using namespace llvm;

void mark_reachable(BasicBlock *BB, std::set<BasicBlock *> &reachable) {
    if (!BB || reachable.count(BB)) {
        return;
    }
    reachable.insert(BB);
    for (auto *succ : successors(BB)) {
        mark_reachable(succ, reachable);
    }
}

namespace {
class MyUnreachablePass : public PassInfoMixin<MyUnreachablePass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    std::set<BasicBlock *> reachable;
    mark_reachable(&F.getEntryBlock(), reachable);
    for (auto &BB : F) {
      if (!reachable.count(&BB)) 
        outs() << BB.getName() << "\n";
      }
    return PreservedAnalyses::all();
  }
}; 
} // namespace

extern "C" ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "MyUnreachablePass", "v0.1",
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "my-unreachable") {
                    FPM.addPass(MyUnreachablePass());
                    return true;
                  }
                  return false;
                });
          }};
}
