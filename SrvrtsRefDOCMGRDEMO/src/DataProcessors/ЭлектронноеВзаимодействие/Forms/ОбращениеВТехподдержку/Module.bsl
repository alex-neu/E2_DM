
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не Параметры.Свойство("ТекстОбращения", ТекстОбращения) Тогда
		Элементы.ТекстОбращения.Видимость = Ложь;
		Элементы.ТекстОбращенияНадпись.Видимость = Ложь;
		Элементы.ТекстОбращенияНадписьНеизвестнаяОшибка.Видимость = Истина;
	КонецЕсли;
	
	Параметры.Свойство("КонтекстОперации", КонтекстОперации);
	Параметры.Свойство("АдресФайлаДляТехПоддержки", АдресФайлаДляТехПоддержки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ОбменСКонтрагентами") Тогда
		МодульОбменСКонтрагентамиСлужебныйКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменСКонтрагентамиСлужебныйКлиент");
		МодульОбменСКонтрагентамиСлужебныйКлиент.ЗаполнитьДанныеСлужбыПоддержки(ТелефонСлужбыПоддержки, АдресЭлектроннойПочтыСлужбыПоддержки);
		Элементы.Техподдержка.Заголовок =
			МодульОбменСКонтрагентамиСлужебныйКлиент.СформироватьГиперссылкуДляОбращенияВСлужбуПоддержки(НСтр("ru = 'Вопросы и ответы'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресЭлектроннойПочтыСлужбыПоддержкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ФайловаяСистемаКлиент.ОткрытьНавигационнуюСсылку("mailto://" + АдресЭлектроннойПочтыСлужбыПоддержки);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОбращенияНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектронноеВзаимодействиеСлужебныйКлиент.СкопироватьВБуферОбмена(ТекстОбращения,
		НСтр("ru = 'Текст обращения скопирован в буфер обмена'"));
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивСТехИнформациейНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолучитьФайл(АдресФайлаДляТехПоддержки, НСтр("ru = 'Отчет об ошибках.zip'"), Истина);
	
КонецПроцедуры

#КонецОбласти
