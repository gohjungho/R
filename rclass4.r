# read.csv() read.excel()

x <- read.csv("reservation_r_csv.csv")
head(x)

install.packages("readxl")
library(readxl)

y <- read_excel("reservation_r_excel.xlsx")
head(y)

# 데이터 파일(csv, excel) 경로 확인!

# write.csv() write.excel() 
# - 오류로 실습 못함...

write.csv(reservation_r_csv, "csv_output.csv")

install.packages("writexl")
library(writexl)

write_xlsx(reservation_r_excel, "excel_output.xlsx")

# save() load() 

x <- c(1,2,3)

y <- c(4,5,6)

save(x,y,file = "save.Rdata") # x, y의 값 저장
rm(list = ls())
x # 값이 삭제되고 없음

load("save.Rdata") # 저장된 x값을 불러오기

# 모든 변수 저장하기 

x <- c(1, 2, 3)
y <- c(4, 5, 6)
z <- c(7, 8, 9)
save(list = ls(), file = "save2.Rdata") # 현재 변수들을 저장


# R 메모리에 있는 모든 변수 삭제하기 
rm(list = ls()) # rm()은 변수를 삭제하는 함수, ls()는 모든 목록 이름을 반환하는 함수 


# sink() cat()

connect <- file("result.txt","w") # 파일 설정
x <- iris$Sepal.Length # iris의 길이값을 변수에 적용
cat(summary(x),file = connect) #summary 함수의 결과를 파일에 기록 
close(connect) # 파일 종료 
## result.txt를 열어보면 값이 정상적으로 저장된 걸 볼 수 있다.

# 데이터셋 확인하기 주요 함수 

head() # 데이터셋 앞부분 출력. head(x,[출력행 개수]). 6개가 기본값
tail() # 데이터셋 뒷부분 출력. tail(x,[출력행 개수]). 6개가 기본값
str() # 데이터셋 구조 출력. str(x)
summary() # 요약 통계량 출력. summary(x)
## Min: 최솟값 / 1st Qu: 1사분위수 / Median: 중앙값 / Mean: 평균 / 3rd Qu: 3사분위수 / Max: 최댓값
View() # 소스 창으로 데이터와 구조 확인. View(x)
dim() # 열과 행, 차원의 개수를 셈. dim(x)
ncol() # 열 개수를 셈. ncol(x)
nrow() # 행 개수를 셈. nrow(x)
length() # 벡터 길이(열의 길이)를 반환, 리스트나 데이터 프레임에서도 사용 가능. length(x)
ls() # 목록. 지정된 전체 변수(객체)를 보여줌. ls()
object.size() # 메모리상에서 변수(객체) 데이터의 크기 확인. object.size(x)

# iris 

library(help = datasets) # R에 어떤 기본 데이터셋들이 있는지 확인할 수 있다.

summary(iris$Sepal.Length) # Sepal.Length 열에 대한 요약 통계량
str(iris) # 데이터 구조 보기 

# head(), tail(), str()은 데이터 분석 작업을 할 때 매우 빈번하게 사용한다. 

# 데이터의 자료형과 데이터 구조를 확인하는 함수들

is.na() # 데이터가 NA(결측치)인지 확인, 개별 데이터 값에 대해 TRUE/FALSE를 반환. TRUE가 나오면 NA. is.na(x)
## 분명 NA는 문자이나 숫자의 일종으로 취급한다.
is.null() # 데이터셋이 null인지 확인. is.null(x)
is.numeric() # 데이터셋이 숫자형인지 확인. is.numeric(x)
is.character() # 데이터셋이 문자형인지 확인. is.character(x)
is.logical() # 데이터셋이 논리형인지 확인. is.logical(x)
is.factor() # 데이터 구조가 팩터형인지 확인. is.factor(x)
is.data.frame() # 데이터 구조가 데이터 프레임인지 확인. is.data.frame(x)

is.na(iris) # 전부 FALSE 출력 
is.factor(iris) # FALSE 
is.data.frame(iris) # TRUE 



