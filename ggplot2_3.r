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

my_first_cook <- order_info_r %>% # 읽어오기 
                 mutate(reserv_month = substr(reserv_no, 1, 6)) %>% # 계산 후 열을 생성
                 group_by(item_id, reserv_month) %>% # 그룹 생성
                 summarise(avg_sales = mean(sales)) %>% # 요약, 평균 계산 
                 arrange(item_id, reserv_month) # 정렬
head(my_first_cook)

ggplot(my_first_cook, aes(x = reserv_month, y = avg_sales, group = item_id, color = item_id)) + # 'x =' , 'y ='은 생략 가능
       geom_line(size = 1) + # 선 그래프
       geom_point(color = 'darkorange', size = 1.5) + # 점 찍기
       scale_color_brewer(palette = 'Paired') + # 색상표 적용 
       labs(title = '메뉴 아이템별 월 평균 매출 추이', x = '월', y = '매출') # 타이틀 명, x축, y축 이름 변경



# 평균, 편차, 분산, 표준편차

weight <- c(74,66,61,59,70)
mean(weight) # 평균
median(weight) # 중앙값
var(weight) # 분산 = 편차의 제곱의 평균
sd(weight) # 표준편차 = 분산에 제곱근 씌운 값

# 정규분포 

# 귀무 가설(사실이라고 가정하는 상황, H0): 차이가 없다.
# 대립 가설(우리가 새로 검증하고 싶은 상황, H1): 차이가 있다.

# 귀무 가설이 참이라는 가정하에 "기각(아니라고 결정)"할 수 있는지 여부를 판단한다. 
# 귀무 가설이 기각되면 연구자가 주장하고 싶은 대립 가설을 "채택"하는 식이다. 
# 연구자는 기존과 다른 현상을 밝히고 싶기 때문에 통계를 이용하여 귀무 가설을 기각하는 증거를 찾는다.

# 유의 수준(α): 가설 검정을 할 때 표본 자료에서 얻은 검정 통계량이 기각역(rejection area)(기각 구간)에 들어갈 확률, 즉 오차 가능성을 의미
# 연구자 목적에 따라 보통 1%, 5%, 10% 등으로 설정. (5%를 많이 사용)

# 유의 확률(p-value)은 귀무 가설을 지지하는 정도를 의미. 
# 보통 유의 확률이 낮아질수록 귀무 가설을 기각하는 데 설득력을 가지므로, 통계적으로 유의미하다(실제적으로는 유의미하지 않을 수도 있다).
# 즉, 유의 수준(확률)이 5%보다 낮으면 기존의 가설(귀무 가설)을 기각시키고 내 가설(대립 가설)을 채택할 수 있다. 




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
