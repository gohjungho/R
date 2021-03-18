install.packages('ggplot2')

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

ggplot(data = pressure, aes(x = temperature, y = pressure)) +
geom_point() # 산점도 
# geom_line() # 선 그래프 
# geom_col() # 막대 그래프 

df_cfm_order <- inner_join(reservation_r, order_info_r, by = "reserv_no") %>% 
select(customer_id, reserv_no, visitor_cnt, cancel, order_no, item_id, sales) %>% 
arrange(customer_id, reserv_no, item_id)

head(df_cfm_order)


# 산점도 그래프 
## 산점도를 그리고자 고객별 총 방문 고객 수와 매출(천 원 단위)
df_sct_graph <- df_cfm_order %>% 
group_by(customer_id) %>% 
summarise(vst_cnt = sum(visitor_cnt), cust_amt = sum(sales/1000))

head(df_sct_graph)

ggplot(data = df_sct_graph, aes(x = vst_cnt, y = cust_amt)) +
geom_point() # 산점도 그리기 


# 세부 설정하기
ggplot(data = df_sct_graph, aes(x = vst_cnt, y = cust_amt)) +
geom_point() +
xlim(0,50) + ylim(0,500) # 축 조정으로 화면이 더 확대된 효과
## 방문객 수와 매출은 밀접한 관계(양의 상관관계)가 있다.


# 산점도 그래프에 색상 적용하기
## 고객 성별에 따라 그룹으로 묶어 색상을 칠해 보자. 
df_sct_graph2 <- inner_join(df_sct_graph, customer_r, by = "customer_id") %>%
select(vst_cnt, cust_amt, sex_code)

head(df_sct_graph2)

# color()가 색상 
ggplot(data = df_sct_graph2, aes(x = vst_cnt, y = cust_amt, color = sex_code)) + 
geom_point() +
xlim(0,50) +
ylim(0,500)
## 산점도 구성은 점이기 때문에 color로 색상 옵션을 적용하지만, 
## 막대 그래프는 막대이기 때문에 fill로 색상 옵션을 적용



# 막대 그래프
## 예약 완료, 주문 완료 데이터 연결
df_branch_sales_1 <- inner_join(reservation_r, order_info_r, by = 'reserv_no') %>% 
select(branch, sales) %>% 
arrange(branch, sales)

# 지점별로 매출 합산 
df_branch_sales_2 <- df_branch_sales_1 %>% 
group_by(branch) %>% 
summarise(amt = sum(sales) / 1000) %>% 
arrange(desc(amt))

df_branch_sales_2 # 데이터셋 확인 

# 막대그래프 그리기 
ggplot(df_branch_sales_2, aes(x = branch, , y = amt)) + geom_bar(stat = "identity")

# 매출이 큰 순서대로 내림차순 정렬 (-는 내림차순)
ggplot(df_branch_sales_2, aes(x = reorder(branch, -amt), y = amt)) +
geom_bar(stat = "identity")

# 색상 채우기 (fill)
ggplot(df_branch_sales_2, aes(x = reorder(branch, -amt), y = amt, fill = branch)) +
geom_bar(stat = "identity")

# 막대 그래프 일부만 선택하기
ggplot(df_branch_sales_2, aes(x = reorder(branch, -amt), y = amt, fill = branch)) +
geom_bar(stat = "identity") +
xlim(c('강남', '영등포', '종로', '용산', '서초', '성북'))

# 가로 막대 그래프 그리기
gg <- ggplot(df_branch_sales_2, aes(x = reorder(branch, -amt), y = amt, fill = branch)) +
geom_bar(stat = "identity") +
xlim(c('강남', '영등포', '종로', '용산', '서초', '성북'))

gg <- gg + coord_flip() # coord_flip()이 가로 방향으로 전환 
gg

# 범례(legend) 조정하기
gg <- ggplot(df_branch_sales_2, aes(x = reorder(branch, -amt), y = amt, fill = branch)) +
geom_bar(stat = "identity") +
xlim(c('강남', '영등포', '종로', '용산', '서초', '성북'))

gg <- gg + coord_flip() + 
            theme(legend.position = "bottom") +
            scale_fill_discrete(breaks = c("강남", "영등포", "종로", "용산", "서초","성북"))
gg





# 히스토그램 (도수 분포 확인)

# 지점 예약 건수 히스토그램
gg <- ggplot(data = reservation_r, aes(x = branch)) + 
      geom_bar(stat = "count")
gg

# 히스토그램 타이틀과 축 제목 변경하기
gg <- ggplot(data = reservation_r, aes(x = branch)) + 
      geom_bar(stat = "count") + 
      labs(title = '지점별 예약 건수', x = '지점', y = '예약건')
gg

# theme( ) 함수로 그래프 세부 조정하기

gg <- gg + theme(axis.title.x = element_text(size = 15,
                                             color = "blue",
                                             face = 'bold',
                                             angle = 0) ,
                 axis.title.y = element_text(size = 13,
                                             color = 'red',
                                             angle = 90))
gg 

# geom_histogram( ) 함수로 연속형 데이터의 히스토그램 그리기
ggplot(data = order_info_r, aes(x = sales/1000)) + 
geom_histogram(binwidth = 5) # binwidth는 구간 너비를 설정하는 옵션





# 파이 차트 (상대적 크기 확인)
df_pie_graph <- inner_join(order_info_r, item_r, by = 'item_id') %>% 
group_by(item_id, product_name) %>% 
summarise(amt_item = sum(sales / 1000)) %>% 
select(item_id, amt_item, product_name)

df_pie_graph

# 누적 막대 그래프 그리기
ggplot(df_pie_graph, aes(x = "", y = amt_item, fill = product_name)) +
       geom_bar(stat = "identity")

# 파이 차트 그리기
gg <- ggplot(df_pie_graph, aes(x = "", y = amt_item, fill = product_name)) +
    geom_bar(stat = "identity") +
    coord_polar("y", start = 0) # coord_polar이 파이 차트 그리는 함수. 
    # y축 값을 기준으로 0부터 시작하는 그래프  

# 자동으로 파이 차트에 팔레트 색상 채우기
## ggplot2에는 색상 자동 채움을 위한 다양한 팔레트(palette)가 있다.
## 색상을 특정 팔레트 색상으로 바꾸려면 scale_fill_brewer() 함수를 사용
gg <- gg + scale_fill_brewer(palette = "Spectral")
gg







