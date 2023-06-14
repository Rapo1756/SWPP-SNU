define i32 @test1(i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @test1(i32 %a, i32 %b, i32 %c, i32 %d)
; CHECK-NEXT:    [[E:%.*]] = add nuw i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = add nuw i32 [[C:%.*]], [[D:%.*]]
; CHECK-NEXT:    [[G:%.*]] = add nuw i32 [[A]], [[D]]
; CHECK-NEXT:    [[H:%.*]] = add nuw i32 [[B]], [[C]]
; CHECK-NEXT:    [[COND1:%.*]] = icmp eq i32 [[A]], [[B]]
; CHECK-NEXT:    [[COND2:%.*]] = icmp eq i32 [[E]], [[F]]
; CHECK-NEXT:    [[COND3:%.*]] = icmp eq i32 [[B]], [[D]]
; CHECK-NEXT:    [[COND4:%.*]] = icmp eq i32 [[F]], [[H]]
; CHECK-NEXT:    [[COND5:%.*]] = icmp eq i32 [[D]], [[G]]
; CHECK-NEXT:    [[COND6:%.*]] = icmp eq i32 [[C]], [[G]]
; CHECK-NEXT:    [[COND7:%.*]] = icmp eq i32 [[C]], [[H]]
; CHECK-NEXT:    br i1 [[COND1]], label [[BB_TRUE1:%.*]], label [[BB_FALSE1:%.*]]
; CHECK:       bb_true1:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[A]], i32 [[C]], i32 [[D]], i32 [[E]], i32 [[F]], i32 [[G]], i32 [[H]])
; CHECK-NEXT:    ret i32 [[A]]
; CHECK:       bb_false1:
; CHECK-NEXT:    br i1 [[COND2]], label [[BB_TRUE2:%.*]], label [[BB_FALSE2:%.*]]
; CHECK:       bb_true2:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[D]], i32 [[E]], i32 [[E]], i32 [[G]], i32 [[H]])
; CHECK-NEXT:    ret i32 [[B]]
; CHECK:       bb_false2:
; CHECK-NEXT:    br i1 [[COND3]], label [[BB_TRUE3:%.*]], label [[BB_FALSE3:%.*]]
; CHECK:       bb_true3:
; CHECK-NEXT:    br i1 [[COND4]], label [[BB_TRUE4:%.*]], label [[BB_FALSE4:%.*]]
; CHECK:       bb_false3:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[D]], i32 [[E]], i32 [[F]], i32 [[G]], i32 [[H]])
; CHECK-NEXT:    ret i32 [[C]]
; CHECK:       bb_true4:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[B]], i32 [[E]], i32 [[F]], i32 [[G]], i32 [[F]])
; CHECK-NEXT:    ret i32 [[B]]
; CHECK:       bb_false4:
; CHECK-NEXT:    br i1 [[COND5]], label [[BB_TRUE5:%.*]], label [[BB_FALSE5:%.*]]
; CHECK:       bb_true5:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[B]], i32 [[E]], i32 [[F]], i32 [[D]], i32 [[H]])
; CHECK-NEXT:    ret i32 [[E]]
; CHECK:       bb_false5:  
; CHECK-NEXT:    br i1 [[COND6]], label [[BB_TRUE6:%.*]], label [[BB_FALSE6:%.*]]
; CHECK: bb_true6:
; CHECK-NEXT:    br i1 [[COND7]], label [[BB_TRUE7:%.*]], label [[BB_FALSE7:%.*]]
; CHECK:       bb_false6:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[B]], i32 [[E]], i32 [[F]], i32 [[G]], i32 [[H]])
; CHECK-NEXT:    ret i32 [[F]]
; CHECK:       bb_true7:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[B]], i32 [[E]], i32 [[F]], i32 [[C]], i32 [[C]])
; CHECK-NEXT:    ret i32 [[C]]
; CHECK:       bb_false7:
; CHECK-NEXT:    call void @g(i32 [[A]], i32 [[B]], i32 [[C]], i32 [[B]], i32 [[E]], i32 [[F]], i32 [[C]], i32 [[H]])
; CHECK-NEXT:    ret i32 [[H]]
;
  %e = add nuw i32 %a, %b
  %f = add nuw i32 %c, %d
  %g = add nuw i32 %a, %d
  %h = add nuw i32 %b, %c
  %cond1 = icmp eq i32 %a, %b
  %cond2 = icmp eq i32 %e, %f
  %cond3 = icmp eq i32 %b, %d
  %cond4 = icmp eq i32 %f, %h
  %cond5 = icmp eq i32 %d, %g
  %cond6 = icmp eq i32 %c, %g
  %cond7 = icmp eq i32 %c, %h
  br i1 %cond1, label %bb_true1, label %bb_false1
bb_true1:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %a
bb_false1:
  br i1 %cond2, label %bb_true2, label %bb_false2
bb_true2:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %b
bb_false2:
  br i1 %cond3, label %bb_true3, label %bb_false3
bb_true3:
  br i1 %cond4, label %bb_true4, label %bb_false4
bb_false3:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %c
bb_true4:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %d
bb_false4:
  br i1 %cond5, label %bb_true5, label %bb_false5
bb_true5:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %e
bb_false5:
  br i1 %cond6, label %bb_true6, label %bb_false6
bb_true6:
  br i1 %cond7, label %bb_true7, label %bb_false7
bb_false6:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %f
bb_true7:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %g
bb_false7:
  call void @g(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i32 %h)
  ret i32 %h
}

declare void @g(i32, i32, i32, i32, i32, i32, i32, i32)