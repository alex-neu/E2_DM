
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТолькоПросмотр = Константы.ЗапретитьРедактированиеСтатейДвиженияДенежныхСредств.Получить();
	
КонецПроцедуры