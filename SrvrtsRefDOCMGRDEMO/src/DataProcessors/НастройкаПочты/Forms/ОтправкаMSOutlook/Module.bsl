&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Использовать", Использовать);
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ВидПочтовогоКлиента = ПредопределенноеЗначение("Перечисление.ВидыПочтовыхКлиентов.MSOutlook");
	Наименование = Строка(ВидПочтовогоКлиента);
	
	Результат = Новый Структура;
	Результат.Вставить("Наименование", Наименование);
	Результат.Вставить("ВидПочтовогоКлиента", ВидПочтовогоКлиента);
	Результат.Вставить("Использовать", Использовать);
	Результат.Вставить("Данные", Новый Структура);
	Закрыть(Результат);
КонецПроцедуры

