
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Макет = ПланыОбмена.ОбменУправлениеПроизводственнымПредприятиемДокументооборот20.ПолучитьМакет("ПодробнаяИнформация");
	
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru = 'Информация о синхронизации данных с 1С:Управление производственным предприятием'");

КонецПроцедуры
