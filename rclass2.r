x <- c(1,2,3,4)

min(x) # 최솟값
max(x) # 최댓값

mean(x) # 평균

a <- mean(x)
a
class(a)

user_f <- function(x) {
    return (x * 2)
}

user_f(c(1:3))



install.packages("dplyr") # 데이터 처리 작업 특화 패키지 
# ggplot2: 그래프 작업 특화 패키지  
# data table: 데이터 처리 속도가 빠르므로 대용량 데이터를 다룰 때 유용
# shiny: R로 웹/앱 애플리케이션을 만들 수 있게 하는 패키지
# ggThemeAssist: 그래프를 그리는 패키지

library(dplyr)

# summarise(): 특정 데이터 값 요약 함수
summarise(iris, avg = mean(Sepal.Length))


install.packages("tidyr") # 데이터셋의 레이아웃을 바꿀 때 유용한 패키지
library(tidyr) 