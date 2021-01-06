///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ПроверкаКонтрагентов

// Определение по имени события обработки оповещения необходимости выполнить запуск проверки контрагентов.
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения - Форма документа, в котором возникло событие обработки оповещения.
//  ИмяСобытия						 - Строка - Имя события обработки оповещения.
//  Параметр						 - Произвольный - Параметр обработки оповещения.
//  Источник						 - Произвольный - Источник обработки оповещения.
//  ТребуетсяПроверкаКонтрагентов	 - Булево - Результат определения необходимости выполнять проверку контрагента по
//                                            наступлению события.
Процедура ОпределитьНеобходимостьПроверкиКонтрагентовВОбработкеОповещения(
		Форма, ИмяСобытия, Параметр, Источник, ТребуетсяПроверкаКонтрагентов) Экспорт
		
	ТребуетсяПроверкаКонтрагентов =
		ИмяСобытия = "Запись_Контрагент";
	
КонецПроцедуры

// Позволяет заменить стандартное предложение включить проверку контрагентов.
//
// Параметры:
//  СтандартнаяОбработка  - Булево - Истина, если нужно сохранить стандартное поведение.
//
Процедура ПредложитьВключитьПроверкуКонтрагентов(СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
