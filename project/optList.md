## Optimizations: Ideas & Tips for Implementation

Here is the list of optimizations in LLVM that might be helpful for your
project. This isn't exhaustive; you can find more optimizations from LLVM.

You can call Function/Loop/ModulePassManager::addPass(PassName()) to
add the pass to your compiler.

```
  FunctionPassManager FPM;
  FPM.addPass(InstCombinePass());
```

#### 1. Branch-related optimizations including br -> switch
https://godbolt.org/z/fTvKGW

- `SimplifyCFGPass` (include/llvm/Transforms/Scalar/SimplifyCFG.h) will do the transformations.

#### 2. Constant folding, removing identical instructions
https://godbolt.org/z/rVLBcf

- You can use `GVN` pass (include/llvm/Transforms/Scalar/GVN.h)

#### 3. Arithmetic optimizations

- `InstCombinePass` (include/llvm/Transforms/InstCombine/InstCombine.h)
- Naively using this will work in some cases but not in general, because our 
cost model is inversed (multiply is cheaper than add)
- You can implement by yourself using matchers.
- Don’t copy & paste patterns!!

#### 4. Dead code elimination

- `ADCEPass` will work (include/llvm/Transforms/Scalar/ADCE.h)

#### 5. Loop invariant code motion

- `LICMPass` , include/llvm/Transforms/Scalar/LICM.h
- Adding it to your pass manager can be a bit non-trivial; Please invest 
some time, and you’ll find how to use it. :)

#### 6. Dead argument elimination
https://godbolt.org/z/2a8M72

- You can use `DeadArgumentEliminationPass` (include/llvm/Transforms/IPO/DeadArgumentElimination.h)
- You’ll need to attach keyword ‘internal’ to functions.

#### 7. Inlining:
https://godbolt.org/z/MW-JJT

You can either:
- Use an existing pass: InlinerPass, include/llvm/Transforms/IPO/Inliner.h .
- Or you can use which functions to inline carefully, by inspecting individually 
and calling InlineFunction() from Transforms/Utils/Cloning.h :
```
InlineResult InlineFunction(CallBase *CB, InlineFunctionInfo &IFI, ...);

(CallBase is a function call to inline.
InlineFunctionInfo is a class that stores info about the inlining; 
you can simply ignore an empty object.
All the remaining arguments are just for better performance;
giving empty objects will work.)
```
- Or you can implement it by yourself!

#### 8. Loop unrolling:
https://godbolt.org/z/P6n97ffnT

- `LoopUnrollPass` , include/llvm/Transforms/Scalar/LoopUnrollPass.h
- However, I suggest you to implement it by yourself rather than using existing 
pass; Loop unroll is activated in certain cases only. Having a fine-grained
tuning will be really, really a pain. It requires much background knowledge 
about loop analysis.

#### 9. Tail call elimination:
https://godbolt.org/z/FiPXm3

You can either:
- Use `TailCallElimPass`,
include/llvm/Transforms/Scalar/TailRecursionElimination.h
- Or you can implement it by yourself (e.g. if the pass does not consider
some cases). It won’t be a discount in your grade.
