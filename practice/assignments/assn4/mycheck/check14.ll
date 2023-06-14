define i32 @test3(i32 %a, i32 %b) {
; CHECK-LABEL: @test3(i32 %a, i32 %b)
; CHECK-NEXT:    br label [[BB_LOOP1:%.*]]

; CHECK:       bb_loop1:
; CHECK-NEXT:    [[C:%.*]] = add nuw i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[COND1:%.*]] = icmp eq i32 [[A]], [[C]]
; CHECK-NEXT:    br i1 [[COND1]], label [[BB_EXIT1:%.*]], label [[BB_LOOP2:%.*]]

; CHECK:       bb_loop2:
; CHECK-NEXT:    [[D:%.*]] = add nuw i32 [[B]], [[C]]
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[C]])
; CHECK-NEXT:    [[COND2:%.*]] = icmp eq i32 [[B]], [[D]]
; CHECK-NEXT:    br i1 [[COND2]], label [[BB_LOOP3:%.*]], label [[BB_EXIT2:%.*]]

; CHECK:       bb_loop3:
; CHECK-NEXT:    [[E:%.*]] = add nuw i32 [[C]], [[B]]
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[COND3:%.*]] = icmp eq i32 [[C]], [[E]]
; CHECK-NEXT:    br i1 [[COND3]], label [[BB_EXIT3:%.*]], label [[BB_LOOP4:%.*]]
; CHECK:       bb_loop4:
; CHECK-NEXT:    [[F:%.*]] = add nuw i32 [[B]], [[E]]
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[E]])
; CHECK-NEXT:    [[COND4:%.*]] = icmp eq i32 [[B]], [[F]]
; CHECK-NEXT:    br i1 [[COND4]], label [[BB_LOOP1]], label [[BB_EXIT4:%.*]]
; CHECK:       bb_exit1:
; CHECK-NEXT:    call void @g(i32 [[B]], i32 [[A]])
; CHECK-NEXT:    ret i32 [[A]]
; CHECK:       bb_exit2:
; CHECK-NEXT:    call void @g(i32 [[B]], i32 [[D]])
; CHECK-NEXT:    ret i32 [[D]]
; CHECK:       bb_exit3:
; CHECK-NEXT:    call void @g(i32 [[B]], i32 [[C]])
; CHECK-NEXT:    ret i32 [[C]]
; CHECK:       bb_exit4:
; CHECK-NEXT:    call void @g(i32 [[B]], i32 [[F]])
; CHECK-NEXT:    [[G:%.*]] = add nuw i32 [[E]], [[F]]
; CHECK-NEXT:    [[COND5:%.*]] = icmp eq i32 [[F]], [[G]]
; CHECK-NEXT:    br i1 [[COND5]], label [[BB_PARALLEL:%.*]], label [[BB_PARALLEL]]
; CHECK:       bb_parallel:
; CHECK-NEXT:    call void @g(i32 [[F]], i32 [[G]])
; CHECK-NEXT:    ret i32 [[G]]
;
  br label %bb_loop1

bb_loop1:
  %c = add nuw i32 %a, %b
  call void @g(i32 %a, i32 %b)
  %cond1 = icmp eq i32 %a, %c
  br i1 %cond1, label %bb_exit1, label %bb_loop2

bb_loop2:
  %d = add nuw i32 %b, %c
  call void @g(i32 %a, i32 %c)
  %cond2 = icmp eq i32 %b, %d
  br i1 %cond2, label %bb_loop3, label %bb_exit2

bb_loop3:
  %e = add nuw i32 %c, %d
  call void @g(i32 %a, i32 %d)
  %cond3 = icmp eq i32 %c, %e
  br i1 %cond3, label %bb_exit3, label %bb_loop4

bb_loop4:
  %f = add nuw i32 %d, %e
  call void @g(i32 %a, i32 %e)
  %cond4 = icmp eq i32 %d, %f
  br i1 %cond4, label %bb_loop1, label %bb_exit4

bb_exit1:
  call void @g(i32 %b, i32 %c)
  ret i32 %c

bb_exit2:
  call void @g(i32 %b, i32 %d)
  ret i32 %d

bb_exit3:
  call void @g(i32 %b, i32 %e)
  ret i32 %e

bb_exit4:
  call void @g(i32 %b, i32 %f)
  %g = add nuw i32 %e, %f
  %cond5 = icmp eq i32 %f, %g
  br i1 %cond5, label %bb_parallel, label %bb_parallel

bb_parallel:
  call void @g(i32 %f, i32 %g)
  ret i32 %g

}

declare void @g(i32, i32)
