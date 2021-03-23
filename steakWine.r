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



# 상관 분석: 스테이크와 와인은 관계가 있을까?

# reserv_no를 키로 예약, 주문 테이블 연결
df_f_join_1 <- inner_join(reservation_r, order_info_r, by = "reserv_no")

# item_id를 키로 df_f_join_1, 메뉴 정보 테이블 연결
df_f_join_2 <- inner_join(df_f_join_1, item_r, by = "item_id")

target_item <- c("M0005", "M0009")               # 스테이크와 와인

# 스테이크와 메뉴 아이템 동시 주문 여부 확인
df_stime_order <- df_f_join_2 %>%
    filter((item_id %in% target_item)) %>%       # 스테이크나 와인을 주문한 경우 선택
    group_by(reserv_no) %>%                      # 예약 번호로 그룹화
    mutate(order_cnt = n()) %>%                  # 그룹화된 행 세기
    distinct(branch, reserv_no, order_cnt) %>%   # 중복 예약 번호는 하나만 출력
    filter(order_cnt == 2) %>%                   # 2인 경우 선택(스테이크와 와인을 동시 주문한 경우)
    arrange(branch)

# 동시 주문인 경우의 예약 번호 데이터셋(12건)
df_stime_order

# 동시 주문한 예약 번호만 담는 stime_order 변수 생성
stime_order_rsv_no <- df_stime_order$reserv_no # 예약 번호만 선택

# 동시 주문 예약 번호이면서 스테이크와 와인일 경우만 선택
df_stime_sales <- df_f_join_2 %>%
    filter((reserv_no %in% stime_order_rsv_no) & (item_id %in% target_item)) %>%
    group_by(reserv_no, product_name) %>%          # 예약 번호와 메뉴 아이템으로 그룹화
    summarise(sales_amt = sum(sales) / 1000) %>%   # 매출 합계 요약 계산
    arrange(product_name, reserv_no)               # 메뉴 아이템, 예약 번호 기준으로 정렬

# 동시 주문 12건이므로 매출 합계 24개 생성(스테이크+와인)
df_stime_sales

steak <- df_stime_sales %>% filter(product_name == "STEAK")   # 스테이크 정보만 담음
wine <- df_stime_sales %>% filter(product_name == "WINE")     # 와인 정보만 담음
 
plot(steak$sales_amt, wine$sales_amt)     # 스테이크와 와인의 매출 상관도 그리기

cor.test(steak$sales_amt, wine$sales_amt)     # 상관관계 확인. p-value가 유의확률(유의수준)


