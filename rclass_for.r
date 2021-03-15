# for 문 
for (i in 1:5) {
    print(i)
}




# for 문 응용 
sum <- 0
for (i in seq(1, 5, by = 1)) {
    sum <- sum + i
}
sum 


# while 문 
i <- 1
while (i <= 5) {
    print(i)
    i <- i + 1
}


# while + next 문 
i <- 1
while (i <= 5) {
    i <- i + 1
    if (i == 2) {
        next # i가 2이면 while 문 처음으로 돌아감 
    }
    print(i)
}



# repeat 문 
i <- 1
repeat {
    print(i)
    if (i >= 5) {
        break # 5보다 크거나 같으면 멈춤 
    }
    i <- i + 1
}



