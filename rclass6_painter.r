# 데이터 그리기


# plot(): 산점도 그리기
# 산점도(scatter plot)는 데이터를 x축과 y축에 점으로 표시하는 그래프
# 실제 값들을 표현해서 데이터 분포나 관계를 확인하는 데 유용하다.
plot(iris$Petal.Length) # 꽃잎 길이(Petal.Length)의 산점도

plot(iris$Petal.Length, iris$Petal.Width) # iris 꽃잎의 길이와 넓이를 x축, y축을 기준으로 한 산점도

plot(iris$Petal.Length, iris$Petal.Width, main = "iris data",
xlab = "Petal Length", ylab = "Petal Width", col = iris$Species)
# 꽃잎 길이(Petal.Length)와 넓이(Petal.Width)를 축으로 그린 산점도. 
# 그래프 제목으로 ‘iris data’, x축과 y축에 이름을 부여. 또 품종(Species)별로 색상을 입힘

# pairs(): 행렬 산점도 그리기. 
# 산점 행렬도는 산점도 그래프를 변수 여러 개로 조합하여 나타내는 행렬 형태의 그래프 
# 변수 간 관계를 파악하여 산점도를 그리므로 변수 간 특징을 쉽게 찾을 수 있습니다.
pairs(~ Sepal.Width + Sepal.Length + Petal.Width + Petal.Length, 
data = iris, col = iris$Species)


# hist(): 히스토그램 그리기 
# 히스토그램은 값의 범위마다 빈도를 표현한 것. 
# 데이터가 모여 있는 정도(분포)를 확인하기에 좋다.
hist(iris$Sepal.Width) # iris의 꽃받침 넓이(Sepal.Width)의 빈도를 그리는 히스토그램

hist(iris$Sepal.Width, freq = FALSE) 
# 각 구간에 얼마큼 데이터가 속해 있는지 나타내고, 각 구간을 합친 확률 밀도의 합은 1이다.


# barplot(): 막내 그래프 그리기 
# 막대 그래프는 데이터 크기를 막대 길이로 표현한 것.
# 집단 간 차이를 확인하고자 할 때 유용하다. 
# hist()와 다른 점은 막내 사이에 간격의 유무이다. 

x <- aggregate(Petal.Length ~ Species, iris, mean) # 품종별 꽃잎 길이의 평균을 구함
barplot(x$Petal.Length, names = x$Species) # 막대 그래프 이름으로 품종 지정 


# pie(): 파이 차트 그리기 
# 파이 차트는 데이터 비율을 표현하는 데 유용하다. 

x <- aggregate(Petal.Length ~ Species, iris, sum) # 품종별로 꽃잎 길이 합산 
pie(x$Petal.Length, labels = x$Species) # 품종 이름을 붙여 파이 그래프 그리기 



