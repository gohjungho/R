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


# 선 그래프 (시간 변화에 따른 데이터를 표현)
## 환율, 기업의 매출 추이나 제품의 판매 실적 추세, 매출, 예약 번호 순서(시간 순서대로) 등

# 예약 번호(reserv_no)별로 매출 합계 구하기 
total_amt <- order_info_r %>% 
group_by(reserv_no) %>% 
summarise(amt_daily = sum(sales/1000)) %>% 
arrange(reserv_no)

head(total_amt) # 데이터셋 확인

# 예약 번호(reserv_no) 순서를 x축으로 해서 선 그래프 그리기
ggplot(total_amt, aes(x = reserv_no, y = amt_daily, group = 1)) +
geom_line()


# 예약 번호(reserv_no) 1~6번째 자리를 선택해서(뭘로 만듦) 그룹핑
total_amt <- order_info_r %>% 
mutate(month = substr(reserv_no, 1, 6)) %>% # mutate()은 열 하나 생성 
group_by(month) %>% 
summarise(amt_monthly = sum(sales/1000))

total_amt # 데이터셋 확인 

# 월별 전체 매출 선 그래프
ggplot(total_amt, aes(x = month, y = amt_monthly, group = 1)) + # geom_line(선 그래프) 그릴 때, 반드시 group을 지정해야 한다! 
geom_line()

# 선 그래프 꾸미기 (점 그리기) 
ggplot(total_amt, aes(x = month, y = amt_monthly, group = 1)) +
geom_line() +
geom_point()

# 선 그래프 색상 추가, 레이블(텍스트 데이터) 추가 
ggplot(total_amt, aes(x = month, y = amt_monthly, group = 1, label = amt_monthly)) + # label: 레이블 추가
geom_line(color = "red", size = 1) +
geom_point(color = "darkred", size = 3) + 
geom_text(vjust = 1.5, hjust = 0.5) # 레이블을 표현할 수직(vertical) 위치, 수평(horizon) 위치 지정


############# review ###############
df <- ToothGrowth %>% 
      group_by(dose) %>% # 투여량 별로 그룹화
      summarise(sd = sd(len), len = mean(len)) # len 값의 표준편차, 평균

df

ggplot(df, aes(dose,len)) +
geom_line(aes(group = 1)) + # geom_line 그래프를 그릴 때는 반드시 group을 지정해야 한다.
geom_point(size=2)

df2 <- ToothGrowth %>% 
       group_by(dose, supp) %>% 
       summarise(sd = sd(len), len = mean(len))

# 두 개의 그래프 동시에 그리기 
ggplot(df2, aes(dose,len)) +
       geom_line(aes(group = supp)) # group을 supp(의 개수)으로 지정

# 옵션 부여
ggplot(df2, aes(dose,len)) +
       geom_line(aes(group = supp, color = supp, linetype = supp)) + # supp 값 마다 다른 색상, 다른 형태의 선을 지정
       geom_point(size = 2) +
       theme_classic() # 배경 격자 삭제 

####################################

# 상자 그림 
## 최솟값, 1사분위수(Q1), 2사분위수(Q2), 3사분위수(Q3), 최댓값 등 다섯 가지 수치를 표현하는 데 유용
## 상자 그림을 이용하여 전체 데이터 값의 분포를 확인할 수 있다. 
## 도수 분포를 표현하는 히스토그램과 다르게 집단이 여러 개일 때도 한 공간에 나타낼 수 있어 유용하다.

# 아이템 메뉴 이름 연결(조인)
df_boxplot_graph <- inner_join(order_info_r, item_r, by = "item_id")
df_boxplot_graph

# 그래프 그리기
ggplot(df_boxplot_graph, aes(product_name, sales/1000)) + 
geom_boxplot(width = 0.8, outlier.size = 2, outlier.colour = "red") + # width가 커질수록 상자들이 밀집한다. outlier는 점을 가리킨다.
labs(title = "메뉴아이템 상자 그림", x = "메뉴", y = "매출") # x, y축의 이름을 부여

