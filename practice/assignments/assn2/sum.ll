define double @fabs(double %val) {
entry:
  %ltz.cond = fcmp olt double %val, 0.0
  br i1 %ltz.cond, label %neg, label %exit

neg:
  %nval = fneg double %val
  br label %exit

exit:
  %res = phi double [%nval, %neg], [%val, %entry]
  ret double %res
}

define void @sort.reverse(double* %ptr, i32 %n) {
entry:
  %init.cond = icmp sle i32 %n, 1
  br i1 %init.cond, label %exit, label %body

body:
  %dec = sub nsw i32 %n, 1
  call void @sort.reverse(double* %ptr, i32 %dec)
  %last.addr = getelementptr inbounds double, double* %ptr, i32 %dec
  %last = load double, double* %last.addr
  %last.abs = call double @fabs(double %last)
  %idx.init = sub nsw i32 %n, 2
  br label %loop.first.cond

loop.first.cond:
  %idx = phi i32 [%idx.dec, %loop.body], [%idx.init, %body]
  %first.cond = icmp sge i32 %idx, 0
  br i1 %first.cond, label %loop.second.cond, label %loop.exit

loop.second.cond:
  %val.addr = getelementptr inbounds double, double* %ptr, i32 %idx
  %val = load double, double* %val.addr
  %val.abs = call double @fabs(double %val)
  %second.cond = fcmp olt double %val.abs, %last.abs
  br i1 %second.cond, label %loop.body, label %loop.exit

loop.body:
  %idx.next = add nsw i32 %idx, 1
  %next.addr = getelementptr inbounds double, double* %ptr, i32 %idx.next
  store double %val, double* %next.addr
  %idx.dec = sub nsw i32 %idx, 1
  br label %loop.first.cond

loop.exit:
  %inc = add nsw i32 %idx, 1 
  %store.addr = getelementptr inbounds double, double* %ptr, i32 %inc
  store double %last, double* %store.addr
  br label %exit

exit:
  ret void
}



define double @sum(double* %ptr, i32 %n) {
entry:
  call void @sort.reverse(double* %ptr, i32 %n)
  br label %for.body

for.body:
  %sum = phi double [%res, %for.body], [0.0, %entry]
  %idx = phi i32 [%inc, %for.body], [0, %entry]
  %var.addr = getelementptr inbounds double, double* %ptr, i32 %idx
  %var = load double, double* %var.addr
  %res = fadd double %sum, %var
  %inc = add nuw i32 %idx, 1
  %loop.out.cond = icmp sge i32 %inc, %n
  br i1 %loop.out.cond, label %for.exit, label %for.body

for.exit:
  ret double %res
}