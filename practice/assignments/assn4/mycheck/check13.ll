define i32 @test2(i32 %a, i32 %b) {
; CHECK-LABEL: @test2(i32 %a, i32 %b)
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB_TRUE:%.*]], label [[BB_FALSE:%.*]]
; CHECK:       bb_true:
; CHECK-NEXT:    [[C:%.*]] = add nuw i32 [[A]], 1
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[COND2:%.*]] = icmp eq i32 [[A]], [[C:%.*]]
; CHECK-NEXT:    br i1 [[COND2]], label [[BB_EXIT:%.*]], label [[BB_INTER:%.*]]
; CHECK:       bb_false:
; CHECK-NEXT:    br label [[BB_INTER]]
; CHECK:       bb_inter:
; CHECK-NEXT:    br label [[BB_TRUE]]
; CHECK:       bb_exit:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[A]])
; CHECK-NEXT:    ret i32 [[A]]
;
  %cond = icmp eq i32 %a, %b
  br i1 %cond, label %bb_true, label %bb_false

bb_true:
  %c = add nuw i32 %a, 1
  call void @g(i32 %a, i32 %b)
  %cond2 = icmp eq i32 %a, %c
  br i1 %cond2, label %bb_exit, label %bb_inter

bb_false:
  br label %bb_inter

bb_inter:
  br label %bb_true

bb_exit:
  call void @g(i32 %a, i32 %c)
  ret i32 %c

}

declare void @g(i32, i32)
