
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПустаяСтрока = Новый ФорматированнаяСтрока(" ");
	
	МассивСтрок = Новый Массив;
	
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Черный,,,, "000000"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Черный1,,,, "444444"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Черный2,,,,"666666"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Черный3,,,,"999999"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Серый,,,,"CCCCCC"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Серый1,,,,"EEEEEE"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Серый2,,,,"F3F3F3"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Белый,,,,"FFFFFF"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Символы.ПС);
	
	МассивСтрок.Добавить(Символы.ПС);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Красный,,,, "EB3541"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Оранжевый,,,, "EB9635"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Желтый,,,,"EBDE35"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Зеленый,,,,"41EB35"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Голубой,,,,"35EBDE"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Синий,,,,"3541EB"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Фиолетовый,,,,"9635EB"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Сиреневый,,,,"DE35EB"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Символы.ПС);
	
	МассивСтрок.Добавить(Символы.ПС);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Красный1,,,, "E5717C"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Оранжевый1,,,, "F9AC75"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Желтый1,,,,"FFCE73"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Зеленый1,,,,"A1CA86"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Голубой1,,,,"81B3B7"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Синий1,,,,"79BAE1"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Фиолетовый1,,,,"9085C9"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Сиреневый1,,,,"C884AE"));
	МассивСтрок.Добавить(ПустаяСтрока);
	
	МассивСтрок.Добавить(Символы.ПС);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Красный2,,,, "D31225"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Оранжевый2,,,, "EB8A46"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Желтый2,,,,"F5B640"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Зеленый2,,,,"7EB15C"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Голубой2,,,,"539399"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Синий2,,,,"4B9CCD"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Фиолетовый2,,,,"6B5BB0"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Сиреневый2,,,,"AF5A8D"));
	МассивСтрок.Добавить(ПустаяСтрока);
	
	МассивСтрок.Добавить(Символы.ПС);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Красный3,,,, "B10E1E"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Оранжевый3,,,, "CB5B11"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Желтый3,,,,"D78F0A"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Зеленый3,,,,"518B2B"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Голубой3,,,,"246B72"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Синий3,,,,"1871AA"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Фиолетовый3,,,,"3B2B8A"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Сиреневый3,,,,"892A61"));
	МассивСтрок.Добавить(ПустаяСтрока);
	
	МассивСтрок.Добавить(Символы.ПС);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Красный4,,,, "680910"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Оранжевый4,,,, "7B310B"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Желтый4,,,,"845008"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Зеленый4,,,,"2E4D17"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Голубой4,,,,"133B3F"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Синий4,,,,"0E3D63"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Фиолетовый4,,,,"1D164C"));
	МассивСтрок.Добавить(ПустаяСтрока);
	МассивСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.Палитра_Сиреневый4,,,,"4B1635"));
	
	СтрокаЦвета = Новый ФорматированнаяСтрока(МассивСтрок);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаЦветаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Закрыть(Строка(НавигационнаяСсылка));
	
КонецПроцедуры

#КонецОбласти
