module.exports =
  render : ()->
    div """
      d3d? или свои?
      !!! Нужно тщательно отобрать только те варианты, которые не искажают восприятие !!!
        TODO Перечитать статью на хабре
      
      Гистограмма
        Хорошо для распределения вероятности/частоты по категориям и грубым квантованиям
        Вертикальная для числовых значений
        Горизонтальная к таблице (для категорий)
        Нужно иметь возможность представлять отрицательные значения для некоторых случаев
          Спец случай для сравнения 2. 2 разлета в разные стороны с opacity. Разница solid
      Линейный график
        Также прикольно для равномерных распределений и графиков функции
        Идеально подходит для изменений по времени
      
      Возможно стоит включить
        Дерево и/или плоское дерево
          Проценты по каждой категории для иерархических категорий и для принятия решений
          Плоское идеально для занятого места на диске
      
      Какие диаграммы не вижу смысл
        Гистограммы с несколькими типами столбиков и склеенный столбик
          Заменяется линейным графиком
        Круговая
          Что мне даст графическое представление лучше чем аналогичное табличное отсортированное?
          Только искажения и нерационально занятое место
          Плюс смотреть на легенду т.к. подписано всё не там где отображается (особенно для мелких процентов)
          На крайний случай делается таблица и гистограмма справа
        Лепестковая
          Если вам надо лепестковая диаграмма, то вы в любом случае представите данные плохо, потому что на вход уже мусор
          Невозможно сравнить много конкурсантов.
          Для сравнения 2 заменяется гистограммной с возможностью отрицательных значений
          ?? Заменяется линейным графиком
      """