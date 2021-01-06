////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает список объектов метаданных, имеющих свойства, для которых используется тип ХранилищеЗначения.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие - Описание:
//    * Ключ - Строка -  полное имя объекта метаданных,
//    * Значение - Массив из Структура - поля структуры:
//       * ИмяРеквизита - Строка - имя реквизита,
//       * ИмяТабличнойЧасти - Строка - имя табличной части (используется только для реквизитов табличных частей объектов).
//
Функция СписокОбъектовМетаданныхИмеющихХранилищеЗначения() Экспорт
	
	СписокМетаданных = Новый Соответствие;
	
	Для Каждого МетаданныеОбъекта Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеКонстанты() Цикл
		ДобавитьКонстантуВСписокМетаданных(МетаданныеОбъекта, СписокМетаданных);
	КонецЦикла;
	
	Для Каждого МетаданныеОбъекта Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеСсылочныеДанные() Цикл
		ДобавитьСсылочныйТипВСписокМетаданных(МетаданныеОбъекта, СписокМетаданных);
	КонецЦикла;
	
	Для Каждого МетаданныеОбъекта Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеНаборыЗаписей() Цикл
		ДобавитьРегистрВТаблицуМетаданных(МетаданныеОбъекта, СписокМетаданных);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СписокМетаданных);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Добавляет константу в список метаданных, если она содержит хранилище значений.
//
// Параметры:
//	Метаданные - ОбъектМетаданных - метаданные,
//	СписокМетаданных - см. СписокОбъектовМетаданныхИмеющихХранилищеЗначения
//
Процедура ДобавитьКонстантуВСписокМетаданных(Метаданные, СписокМетаданных)
	
	ТипХранилищеЗначения = Тип("ХранилищеЗначения");
	
	Если Не Метаданные.Тип.СодержитТип(ТипХранилищеЗначения) Тогда 
		Возврат;
	КонецЕсли;
	
	СписокМетаданных.Вставить(Метаданные.ПолноеИмя(), Новый Массив);
	
КонецПроцедуры

// Добавляет ссылочный тип в список метаданных, если он содержит хранилище значений.
//
// Параметры:
//	Метаданные - ОбъектМетаданных - метаданные.
//	СписокМетаданных - см. СписокОбъектовМетаданныхИмеющихХранилищеЗначения
//
Процедура ДобавитьСсылочныйТипВСписокМетаданных(Метаданные, СписокМетаданных)
	
	МассивСтруктур = Новый Массив;
	
	Для Каждого Реквизит Из Метаданные.Реквизиты Цикл 
		
		ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит);
		
	КонецЦикла;
	
	Для Каждого ТабличнаяЧасть Из Метаданные.ТабличныеЧасти Цикл 
		
		Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
			
			ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит, ТабличнаяЧасть);
			
		КонецЦикла;
		
	КонецЦикла;
	
	ВставитьОбъектМетаданныхСХранилищемЗначенияВСоответствие(Метаданные.ПолноеИмя(), СписокМетаданных, МассивСтруктур);
	
КонецПроцедуры

// Добавляет ссылочный тип в список метаданных, если он содержит хранилище значений.
//
// Параметры:
//	Метаданные - Метаданные - метаданные.
//	СписокМетаданных - см. СписокОбъектовМетаданныхИмеющихХранилищеЗначения
//
Процедура ДобавитьРегистрВТаблицуМетаданных(Знач МетаданныеОбъекта, Знач СписокМетаданных)
	
	МассивСтруктур = Новый Массив;
	
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл 
		
		Если Метаданные.РегистрыРасчета.Содержит(МетаданныеОбъекта.Родитель()) Тогда
			Измерение = Измерение.ИзмерениеРегистра;
		КонецЕсли;
		ДобавитьРеквизитВМассив(МассивСтруктур, Измерение);
		
	КонецЦикла;
	
	Если Метаданные.Последовательности.Содержит(МетаданныеОбъекта) 
		Или Метаданные.РегистрыРасчета.Содержит(МетаданныеОбъекта.Родитель()) Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл 
		
		ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит);
		
	КонецЦикла;
	
	Для Каждого Ресурс Из МетаданныеОбъекта.Ресурсы Цикл 
		
		ДобавитьРеквизитВМассив(МассивСтруктур, Ресурс);
		
	КонецЦикла;
	
	ВставитьОбъектМетаданныхСХранилищемЗначенияВСоответствие(МетаданныеОбъекта.ПолноеИмя(), СписокМетаданных, МассивСтруктур);
	
КонецПроцедуры

// Формирует массив структур с реквизитами, хранящими хранилище значений.
//
// Параметры:
//	МассивСтруктур - Массив - массив структур.
//	Реквизит - ОбъектМетаданных - реквизит.
//	ТабличнаяЧасть - ОбъектМетаданных - табличная часть.
//
Процедура ДобавитьРеквизитВМассив(МассивСтруктур, Реквизит, ТабличнаяЧасть = Неопределено)
	
	ТипХранилищеЗначения = Тип("ХранилищеЗначения");
	
	Если Не Реквизит.Тип.СодержитТип(ТипХранилищеЗначения) Тогда 
		Возврат;
	КонецЕсли;
	
	ИмяРеквизита      = Реквизит.Имя;
	ИмяТабличнойЧасти = ?(ТабличнаяЧасть = Неопределено, Неопределено, ТабличнаяЧасть.Имя);
	
	Структура = СтруктураРеквизитовСХранилищемЗначений();
	Структура.ИмяТабличнойЧасти = ИмяТабличнойЧасти;
	Структура.ИмяРеквизита      = ИмяРеквизита;
	
	МассивСтруктур.Добавить(Структура);
	
КонецПроцедуры

// Добавляет в список метаданных объект метаданных в реквизите которого есть хранилище значений.
//
// Параметры:
//	ПолноеИмяМетаданных - Строка - имя метаданных.
//	СписокМетаданных - см. СписокОбъектовМетаданныхИмеющихХранилищеЗначения
//	МассивСтруктур - Массив - см. СтруктураРеквизитовСХранилищемЗначений
//
Процедура ВставитьОбъектМетаданныхСХранилищемЗначенияВСоответствие(ПолноеИмяМетаданных, СписокМетаданных, МассивСтруктур)
	
	Если МассивСтруктур.Количество() = 0 Тогда 
		Возврат;
	КонецЕсли;
	
	СписокМетаданных.Вставить(ПолноеИмяМетаданных, МассивСтруктур);
	
КонецПроцедуры

// Возвращает структуру, которая хранит информацию о реквизите хранящем хранилище значений.
//
// Возвращаемое значение:
// 	Структура - Описание:
// * ИмяРеквизита - Строка -
// * ИмяТабличнойЧасти - Строка -
// 
Функция СтруктураРеквизитовСХранилищемЗначений()
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяТабличнойЧасти");
	Результат.Вставить("ИмяРеквизита");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти