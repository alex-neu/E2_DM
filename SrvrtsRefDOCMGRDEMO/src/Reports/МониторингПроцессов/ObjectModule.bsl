#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура-обработчик события ПриСозданииНаСервере. Устанавливает отбор по показателю процесса.
//
Процедура ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка) Экспорт
	
	Если ЭтотОбъект.Параметры.Свойство("ПоказательПроцесса") Тогда
		ЭтотОбъект.Параметры.Отбор.Вставить("ПоказательПроцесса", ЭтотОбъект.Параметры.ПоказательПроцесса);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Процедура-обработчик события ПриКомпоновкеРезультата. Устанавливает цвета диаграмм.
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДокументРезультат.Очистить();
	
	Настройки = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки);

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ОбщегоНазначенияДокументооборот.УстановитьЦветаДиаграмм(ДокументРезультат);

КонецПроцедуры

#КонецОбласти

#КонецЕсли