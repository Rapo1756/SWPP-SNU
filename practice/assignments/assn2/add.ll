define void @add(i32* %ptr1, i32* %ptr2, i32* %val) {
  %ptr1.data = load i32, i32* %ptr1, align 4
  %ptr2.data = load i32, i32* %ptr2, align 4
  %val.data = load i32, i32* %val, align 4
  %ptr1.data.add = add i32 %ptr1.data, %val.data
  %ptr2.data.add = add i32 %ptr2.data, %val.data
  store i32 %ptr1.data.add, i32* %ptr1, align 4
  store i32 %ptr2.data.add, i32* %ptr2, align 4
  ret void
}
