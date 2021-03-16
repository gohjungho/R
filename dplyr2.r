# bind_cols( ) 함수: 테이블 열 붙이기

tmp_order_info_r <- order_info_r
bind_cols(order_info_r, tmp_order_info_r)
# order_info_r 테이블 값을 tmp_order_info_r 테이블에 담는다(복제한 효과).
# 열을 붙임으로 인해 열이 10개


# bind_rows( ) 함수: 테이블 행 붙이기

tmp_order_info_r <- order_info_r
bind_rows(order_info_r, tmp_order_info_r)
# 행이 뻥튀기 됨 ㄷㄷ 


# inner_join( ) 함수: 일치하는 데이터 연결하기
inner_join(reservation_r, order_info_r, by = "RESERV_NO") %>% arrange(RESERV_NO, ITEM_ID)
# 예약 정보를 담고 있는 reservation_r 테이블과 주문 정보를 담고 있는 order_info_r 테이블을 예약 번호 reserv_no 열을 키로 연결


inner_join(reservation_r, order_info_r, by = "RESERV_NO") %>% 
arrange(RESERV_NO, ITEM_ID) %>% 
select(RESERV_NO, CUSTOMER_ID, VISITOR_CNT, CANCEL, ORDER_NO, ITEM_ID, SALES)
# 예약 정보와 주문 정보를 이너 조인해서 각 주문 번호에 대한 고객 번호(customer_id)와 방문 고객 수(visitor_cnt) 정보, 주문 정보를 확인할 수 있다



# left_join( ) 함수: 왼쪽 기준 모든 데이터 연결하기
# right_join( ) 함수: 오른쪽 기준 모든 데이터 연결하기
left_join(reservation_r, order_info_r, by = "RESERV_NO") %>% 
arrange(RESERV_NO, ITEM_ID) %>% 
select(RESERV_NO, CUSTOMER_ID, VISITOR_CNT, CANCEL, ORDER_NO, ITEM_ID, SALES)


# full_join( ) 함수: 양쪽 모든 데이터 연결하기
table_added_row <- order_info_r %>% 
add_row(ORDER_NO = "1", ITEM_ID = "1", RESERV_NO = "1", SALES = 1)

full_join(reservation_r, table_added_row, by = "RESERV_NO") %>% 
arrange(RESERV_NO, ITEM_ID) %>% 
select(RESERV_NO, CUSTOMER_ID, VISITOR_CNT, CANCEL, ORDER_NO, ITEM_ID, SALES)
# add_row() 함수를 사용하여 order_info_r 테이블에 임의의 reserv_no인 1을 생성해서 full_join한 값
# 다른 쪽 테이블에 데이터가 없다면 NA 값으로 출력


# intersect( ) 함수: 데이터 교집합 구하기
# 양쪽 테이블에 똑같이 존재하는 데이터 집합을 추출. 교집합(∩)


# reservation_r의 reserv_no 추출
reservation_r_rsv_no <- select(reservation_r, RESERV_NO)
# order_info_r의 reserv_no 추출
order_info_r_rsv_no <- select(order_info_r, RESERV_NO)
# 양쪽 데이터셋에 존재하는 reserv_no
intersect(reservation_r_rsv_no, order_info_r_rsv_no)
# reservation_r과 order_info_r 테이블에서 reserv_no 중 총 337개가 같은 데이터 값인 것을 알 수 있다.


# setdiff( ) 함수: 데이터 빼기 
# 첫 번째 테이블에서 두 번째 테이블 집합의 데이터 집합을 뺀 결과를 출력합니다. -(차집합) 원리
setdiff(reservation_r_rsv_no, order_info_r_rsv_no)
# reservation_r 테이블에는 order_info_r과 일치하지 않는 reserv_no가 59개 있다는 것을 알 수 있다


# union( ) 함수: 중복을 제거해서 데이터 합치기
# 테이블의 데이터 집합을 하나로 묶을 때 사용하며, 합집합(∪) 원리와 같다. 
# 다만 중복 데이터는 하나만 남긴다.
union(reservation_r_rsv_no, order_info_r_rsv_no)
# 중복을 제거한 합집합 데이터가 총 396개라는 것을 알 수 있다


## 응용 
reservation_r %>% # reservation_r 테이블을 선택해서 데이터를 전달
group_by(CUSTOMER_ID) %>% # 고객 번호로 그룹화
summarise(avg = mean(VISITOR_CNT)) %>% # 방문 고객 수(visitor_cnt)의 평균을 avg라는 열로 요약
filter(avg >= 3) %>% # 요약된 값이 3 이상인 행만 선택
arrange(desc(avg)) # 큰 숫자에서 작은 숫자 순(내림차순)으로 정렬


# 응용 - 메뉴 아이템별 월 평균 매출
my_first_cook <- order_info_r %>%  # order_info_r 테이블을 my_first_cook에 담아 전달
mutate(RESERV_MONTH = substr(RESERV_NO, 1, 6)) %>% # substr(): reserv_no 값을 첫 번째부터 여섯 번째까지 선택(년 월이 됨) / mutate(): reserv_month라는 열을 생성
group_by(ITEM_ID, RESERV_MONTH) %>% # 메뉴 아이템과 년 월로 그룹화
summarise(AVG_SALES = mean(SALES)) %>% # 매출 평균을 요약하여 avg_sales라는 열에 담아
arrange(ITEM_ID, RESERV_MONTH) # 메뉴 이름과 년 월 빠르기 순으로 오름차순 출력

my_first_cook # 결과 출력 








