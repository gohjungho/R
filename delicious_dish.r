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



# 더 맛있는 요리하기: 멤버십 기획 프로젝트
# 빈도 분석(frequency analysis): 데이터 빈도나 분포 등 대략적인 특성을 알아보는 분석 방법

table(reservation_r$branch)
head(reservation_r)

no_cancel_data <- reservation_r %>% filter(cancel == "N")
table(no_cancel_data$branch)

df_f_join_1 <- inner_join(reservation_r, order_info_r, by = "reserv_no")
df_f_join_2 <- inner_join(df_f_join_1, item_r, by = "item_id")
head(df_f_join_2)

df_branch_sales <- df_f_join_2 %>%
                   filter(branch == "강남" | branch == "마포" | branch == "서초") %>%
                   group_by(branch, product_name) %>%           # 부서 이름과 메뉴 이름으로 그룹화
                   summarise(sales_amt = sum(sales) / 1000)     # 매출 합산
df_branch_sales

# reserv_no를 키로 예약, 주문 테이블 연결
df_f_join_1 <- inner_join(reservation_r, order_info_r, by = "reserv_no")

# item_id를 키로 df_f_join_1, 메뉴 정보 테이블 연결
df_f_join_2 <- inner_join(df_f_join_1, item_r, by = "item_id")

# 주요 지점만 선택
df_branch_items <- df_f_join_2 %>% 
filter(branch == "강남" | branch == "마포" | branch == "서초")

# 교차 빈도표 생성
table(df_branch_items$branch, df_branch_items$product_name)

# 데이터 프레임 형태로 구조형 변환
df_branch_items_table <- as.data.frame(table(df_branch_items$branch, df_branch_items$product_name))

# 데이터 분석을 위해 데이터 가공
df_branch_items_percent <- df_branch_items_table %>%
                           group_by(df_branch_items_table$Var1) %>%
                           mutate(percent_items = Freq/sum(Freq) * 100) # 주문 비율을 계산해서 열 생성 

# 누적 막대 그래프를 그려 gg 변수에 담음
gg <- ggplot(df_branch_items_percent, aes(x = Var1, y = percent_items, group = Var1, fill = Var2)) +
      geom_bar(stat = "identity")

# 제목과 범례 이름 지정
gg <- gg +
      labs(title = "지점별 주문 건수 그래프", x = "지점", y = "메뉴 아이템 판매비율", fill = "메뉴 아이템")


