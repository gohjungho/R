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
inner_join(reservation_r, order_info_r, by = "reserv_no") %>% arrange(RESERV_NO, ITEM_ID)
# 예약 정보를 담고 있는 reservation_r 테이블과 주문 정보를 담고 있는 order_info_r 테이블을 예약 번호 reserv_no 열을 키로 연결










