
#Область НастройкиОтчетаПоУмолчанию

//Выполняет заполнение категорий и разделов в зависимости от варианта отчета
//Параметры:КлючВариантаОтчета - Строковое название варианта отчета
//			СписокКатегорий - в список добавляются необходимые категории
//			СписокРазделов - в список добавляются необходимые категории
Процедура ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов) Экспорт
		
	СписокРазделов.Добавить(ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
			Метаданные.Подсистемы.ДокументыИФайлы));
	
	Если КлючВариантаОтчета = "СписокОбращенийГраждан" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОбращенияГражданСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоОбращениямГраждан);
		
	ИначеЕсли КлючВариантаОтчета = "ДинамикаКоличестваОбращений" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		
	ИначеЕсли КлючВариантаОтчета = "СтруктураОбращенийЗаПериод" Тогда
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.Статистические);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоОбращениямГраждан);
		
	ИначеЕсли КлючВариантаОтчета = "ИсполнениеОбращенийГраждан" Тогда
		
		СписокРазделов.Добавить(Перечисления.РазделыОтчетов.ОбращенияГражданСписок);
		
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоИсполнителям);
		СписокКатегорий.Добавить(Справочники.КатегорииОтчетов.ПоОбращениямГраждан);
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти


