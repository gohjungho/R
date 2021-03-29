library(readxl)
library(dplyr)
library(ggplot2)

customer_r <- read_excel("customer_r.xlsx")
reservation_r <- read_excel("reservation_r.xlsx")
order_info_r <- read_excel("order_info_r.xlsx")
item_r <- read_excel("item_r.xlsx")

# 열 이름이 대문자로 인식되는 것을 소문자로 변경 
colnames(customer_r) <- tolower(colnames(customer_r))
colnames(reservation_r) <- tolower(colnames(reservation_r))
colnames(order_info_r) <- tolower(colnames(order_info_r))
colnames(item_r) <- tolower(colnames(item_r))


# 의사 결정 나무(decision rule): 어떤 고객이 스테이크를 주문할까?

# 데이터 처리하기: 고객별 스테이크 주문 여부(종속 변수 생성)

# 고객별 스테이크 주문 여부 확인
# (A) 모든 고객의 예약 번호 데이터셋 생성
df_rsv_customer <- reservation_r %>%
select(customer_id, reserv_no) %>%    # 고객별 모든 예약 번호 선택
    arrange(customer_id, reserv_no)

head(df_rsv_customer)                 # 고객별 예약 번호 확인

# (B) 스테이크 주문 예약 번호 데이터셋 생성
df_steak_order_rsv_no <- order_info_r %>%
    filter(item_id == "M0005") %>%   # 스테이크 주문이면
    mutate(steak_order = "Y") %>%    # steak_order 열 데이터를 ‘Y’로 만듦
    arrange(reserv_no)

head(df_steak_order_rsv_no)          # 데이터셋 확인
 
# 고객의 모든 예약 번호(A)에 대해 스테이크 주문한 예약 번호(B)를 레프트 조인
df_steak_order_1 <- left_join(df_rsv_customer, df_steak_order_rsv_no, by = "reserv_no") %>%
    group_by(customer_id) %>%                                       # 고객 번호로 그룹화하여(182명)
    mutate(steak_order = ifelse(is.na(steak_order), "N", "Y")) %>%  # 주문 여부가 NA이면 N, Y이면 Y로 바꿈
    summarise(steak_order = max (steak_order)) %>%                  # 최댓값만 취함
    arrange(customer_id)

# 최종 정리된 고객별 스테이크 주문 여부
df_dpd_var <- df_steak_order_1

# 종속 변수, 최종 고객 182명의 스테이크 주문 여부 결과 확인
df_dpd_var 


# 데이터 처리하기: 고객의 성별, 방문 횟수, 방문객 수, 매출 요약하기(독립 변수 생성)

# 결측치 제거
df_customer <- customer_r %>% filter(!is.na(sex_code))
# 성별이 없으면(NA) 고객 번호 제거

# 고객 테이블과 예약 테이블 customer_id를 키로 이너 조인
df_table_join_1 <- inner_join(df_customer, reservation_r, by = "customer_id")

# df_table_join_1과 주문 테이블의 reserv_no를 키로 이너 조인
df_table_join_2 <- inner_join(df_table_join_1, order_info_r, by = "reserv_no")
str(df_table_join_2)     # df_table_join_2 테이블 구조 확인

# 고객 정보, 성별 정보와 방문 횟수, 방문객 수, 매출 합을 요약(코드 풀이에서 자세히 설명)
df_table_join_3 <- df_table_join_2 %>%
    group_by(customer_id, sex_code, reserv_no, visitor_cnt) %>% # ⓐ
    summarise(sales_sum = sum(sales)) %>%
    group_by(customer_id, sex_code) %>%                         # ⓑ
    summarise(visit_sum = n_distinct(reserv_no), visitor_sum = sum(visitor_cnt), sales_sum = sum(sales_sum) / 1000) %>%     # ⓒ
    arrange(customer_id)
    # distinct(): 중복이 아닌 값(고유한 값)을 카운팅하는 함수. 여기에서는 중복이 아닌(고유한) 주문 예약 번호. 즉, 방문 횟수

df_idp_var <- df_table_join_3   # 독립 변수

df_idp_var                      # 독립 변수 확인(142행)


# 데이터 처리하기: 최종 정리

# 독립 변수 데이터셋(①-2)에 종속 변수 데이터셋(①-1) 이너 조인
df_final_data <- inner_join(df_idp_var, df_dpd_var, by = "customer_id")

# 의사 결정 나무 함수를 사용하려고 열 구조를 팩터형으로 바꿈
df_final_data$sex_code <- as.factor(df_final_data$sex_code)
df_final_data$steak_order <- as.factor(df_final_data$steak_order)

df_final_data <- df_final_data[, c(2:6)]   # 의사 결정 나무에 필요한 열만 선택
df_final_data                              # 최종 분석용 데이터셋 확인

##############################################################

# 패키지 설치 
# 쥬피터의 경우 R은 상관없지만 파이썬은 패키지 설치할 때 앞에 !를 붙여줘야한다.
install.packages("rpart") # 
install.packages("caret") # 예측과 머신러닝 함수들. 훈련과 실험 데이터셋 나누기
install.packages("e1071") # 모델의 정확도를 계산 

library(rpart)
library(caret)
library(e1071)

# 난수를 생성할 때 계속 무작위수를 생성하지 않고 1만 번대 값을 고정으로 가져옴
set.seed(10000)
# 80% 데이터는 train을 위해 준비하고, 20% 데이터는 test를 위해 준비함
train_data <- createDataPartition(y = df_final_data$steak_order, p = 0.8, list = FALSE)
train <- df_final_data[train_data, ]
test <- df_final_data[train_data, ]
# rpart를 사용해서 의사 결정 나무 생성
decision_tree <- rpart(steak_order~., data = train)
# decision_tree 내용 확인
decision_tree

# 만들어진 모델의 정확도를 확인
predicted <- predict(decision_tree, test, type = 'class')
confusionMatrix(predicted, test$steak_order)

plot(decision_tree, margin = 0.1)   # 의사 결정 나무 그리기
text(decision_tree)                 # 의사 결정 나무 텍스트 쓰기
 
# 예쁘게 그리기 
install.packages("rattle")  # 패키지 설치
library(rattle)             # 패키지 로딩
fancyRpartPlot(decision_tree)    # 의사 결정 나무 깔끔하게 그리기

