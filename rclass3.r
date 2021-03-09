# 벡터의 산술 연산
x <- c(1,2,3,4)
y <- c(2,2,2,2)
z <- x + y
z

z <- x * y
z

# 길이가 다를 경우
x <- c(1,2,3,4)
y <- c(1,2)
z <- x + y
z

z <- x * y
z

# 응용
y <- c(1,2)
10 - y

# 벡터의 비교
x <- c(1, 2, 3)
y <- c(1, 2, 5)
x < y      # 각각 비교

# 논리연산 
x <- c(TRUE, TRUE)
y <- c(TRUE, FALSE)

x & y # 둘다 만족해야 TRUE 
x | y # 둘 중 하나만 만족해도 TRUE 

TRUE & TRUE # TRUE
TRUE & FALSE # FALSE
FALSE & TRUE # FALSE
FALSE & FALSE # FALSE

FALSE && TRUE # FALSE / 뒤를 확인하나마자 FALSE
FALSE && FALSE # FALSE

TRUE | TRUE # TRUE
TRUE | FALSE # TRUE
FALSE | TRUE # TRUE
FALSE | FALSE # FALSE

TRUE || TRUE # TRUE / 뒤를 확인하나마자 TRUE 
TRUE || FALSE # TRUE

x <- c("a","b")
"a" %in% x # x에 a가 있는지 확인 


# 가져오기와 내보내기 

# csv()는 .을 사용 
# excel()은 _를 사용 
