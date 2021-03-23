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


# RFM 분석: 우리 회사의 고객 현황은 어떨까?
# 가설: 우리 레스토랑은 여러 번 방문하는 고객이 다수이며 이들이 많은 매출을 일으킬 것이다.

# 테이블조인
# reserv_no를 키로 예약, 주문 테이블 연결
df_rfm_join_1 <- inner_join(reservation_r, order_info_r, by = "reserv_no")


# 고객 번호별 방문 횟수(F)와 매출(M) 정리
df_rfm_data <- df_rfm_join_1 %>%
    group_by(customer_id) %>%
    summarise(visit_sum = n_distinct(reserv_no), sales_sum = sum(sales) / 1000) %>%
    arrange(customer_id)

summary(df_rfm_data)     # df_rfm_data 요약 통계 값 확인

# 상자 그림 그리기
ggplot(df_rfm_data, aes(x = "", y = visit_sum)) +
    geom_boxplot(width = 0.8, outlier.size = 2, outlier.colour = "red") +
    labs(title = "방문 횟수 상자그림", x = "빈도", y = "방문횟수")
 
# 매출 상자 그림 
ggplot(df_rfm_data, aes(x = "", y = sales_sum)) +
    geom_boxplot(width = 0.8, outlier.size = 2, outlier.colour = "red") +
    labs(title = "매출 상자그림", x = "매출", y = "금액")
 
# 방문 횟수 60%와 90%에 해당하는 분위수 찾기
quantile(df_rfm_data$visit_sum, probs = c(0.6, 0.9))

# 매출 60%와 90%에 해당하는 분위수 찾기
quantile(df_rfm_data$sales_sum, probs = c(0.6, 0.9))

# 총 방문 횟수와 총 매출 합
total_sum_data <- df_rfm_data %>%
    summarise(t_visit_sum = sum(visit_sum), t_sales_sum = sum(sales_sum))

# 우수 고객 이상의 방문 횟수와 매출 합
loyalty_sum_data <- df_rfm_data %>%
    summarise(l_visit_sum = sum(ifelse(visit_sum > 2, visit_sum, 0)), l_sales_sum = sum(ifelse(sales_sum > 135, sales_sum, 0)))

# 차지하는 비율 확인
loyalty_sum_data / total_sum_data
