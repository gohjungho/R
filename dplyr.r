# 파이프 연산자(%>%) : ctrl + shift + m

install.packages("dplry")
library("dplry") 

# 제대로 작동을 안하니 주피터에서 합시다 ....

# install.packages("readxl")
library(readxl)

customer_r <- read_xlsx("customer_r.xlsx")
customer_r %>% count() # n/183

order_info_r <- read_xlsx("order_info_r.xlsx")

dim(order_info_r) # 391 5 

summarise(order_info_r, avg = mean(SALES)) # 63828.64 

# sales 열의 최솟값과 최댓값 출력
summarise(order_info_r, min_value = min(SALES), max_value = max(SALES)) 

# 파이프 연산자를 사용해 sales 열의 최솟값과 최댓값 출력
order_info_r %>% summarise(min_value = min(SALES), max_value = max(SALES)) 


# readxl이 작동이 안될때... xlsx 패키지 사용
# 그러나 한글이 깨짐...... 되도록 쓰지 말자...
install.packages("xlsx")
library(xlsx)

customer_r <- read.xlsx("customer_r.xlsx", 1) # 시트별로 불러오는 것이므로 마지막에 번호가 붙음 
customer_r # 한글 와장창...... 


# group_by( ) 함수: 행 그룹화하기 

# reservation_r <- read_xlsx("reservation_r.xlsx")
# head(reservation_r)
reservation_r %>% group_by(CUSTOMER_ID) %>% summarise(avg = mean(VISITOR_CNT))


# filter( ) 함수: 조건으로 행 선택하기

#head(order_info_r)
order_info_r %>% filter(ITEM_ID == "M0001")

# 논리 연산자로 조건을 추가할 수도 있다

order_info_r %>% filter(ITEM_ID == "M0001" & SALES >= 150000)


# distinct( ) 함수: 유일 값 행 선택하기
# 중복 행 값을 제거하여 반환

#head(order_info_r)
order_info_r %>% distinct(ITEM_ID)



# slice( ) 함수: 선택 행 자르기
# 해당 위치의 행을 잘라서 선택

order_info_r %>% slice(2:4) # 2~4행을 잘라서 반환 
order_info_r %>% slice(1,3) # 1, 3행만 잘라서 반환 


# arrange( ) 함수: 행 정렬하기
# 행을 작은 값에서 큰 값으로 정렬(오름차순)하거나 큰 값에서 작은 값으로 정렬(내림차순)한다. 
# 기본은 오름차순

order_info_r %>% arrange(SALES)
order_info_r %>% arrange(desc(SALES)) # 내림차순
order_info_r %>% arrange(RESERV_NO, ITEM_ID) # reserv_no 순서대로 오름차순 정렬한 후 다시 item_id로 오름차순 정렬


# add_row( ) 함수: 행 추가하기
table_added_row <- order_info_r %>% add_row(ORDER_NO = "1", ITEM_ID = "1", RESERV_NO = "1")
table_added_row %>% arrange(ORDER_NO)



# sample_frac( ), sample_n( ) 함수: 무작위로 샘플 행 뽑기
order_info_r %>% sample_frac(0.1, replace = TRUE) # sample_frac() 함수를 사용해 order_info_r 테이블에서 샘플 데이터를 추출
# sample_n() 함수는 비율 대신 행 개수로 추출한다는 점 외에 사용법은 동일


# select( ) 함수: 열 선택하기
order_info_r %>% select(RESERV_NO, SALES) # reserv_no 열과 sales 열 선택


# mutate( ) 함수: 열 조작해서 새로운 열 생성하기
# 조작에는 함수를 적용할 수 있으며, 같은 행 길이의 열이 생성됩니다.
order_info_r %>% group_by(RESERV_NO) %>% mutate(avg = mean(SALES))



# transmute( ) 함수: 원래 열 빼고 새로운 열 생성하기
# mutate() 함수와 기능이 동일하지만, 기존 테이블의 열을 반환하지 않는다는 차이가 있다
order_info_r %>% group_by(RESERV_NO) %>% transmute(avg = mean(SALES))
# avg 열을 출력했지만, 그룹화된 열인 reserv_no 외 기존 테이블의 열들은 출력되지 않은 것을 확인할 수 있다


# mutate_all( ) 함수: 모든 열 조작해서 새로운 열 생성하기
order_info_r %>% mutate_all(funs(max)) # 테이블의 각 열 값에 대한 최댓값을 찾는다.


# mutate_if( ) 함수: 특정 조건 열만 조작해서 새로운 열 생성하기
order_info_r %>% mutate_if(is.numeric, funs(log(.))) # 열이 숫자형일 경우 로그(log)로 바꿈 
# 숫자형(is.numeric 결과가 TRUE)7인 열만 로그 함수가 적용되었다.


# mutate_at( ) 함수: 특정 열만 조작해서 새로운 열 생성하기
# mutate_all() 함수가 모든 열에 대해 조작하는 함수라면, mutate_at() 함수는 지정한 열만 조작한다.
order_info_r %>% mutate_at(vars(SALES), funs(max))


# rename( ) 함수: 열 이름 바꾸기
order_info_r %>% rename(amt = SALES) # 열 이름 sales가 열 이름 amt로 바뀜






