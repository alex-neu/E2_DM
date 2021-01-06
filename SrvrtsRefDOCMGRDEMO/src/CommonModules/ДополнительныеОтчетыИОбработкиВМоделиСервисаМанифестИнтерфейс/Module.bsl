///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
//
// Параметры:
//   Версия - Строка - если параметр задан, то в пространство имен включается указанная версия вместо текущей.
//
// Возвращаемое значение:
//   Строка - 
//
Функция Пакет(Знач Версия = "") Экспорт
	
	Если ПустаяСтрока(Версия) Тогда
		Версия = Версия();
	КонецЕсли;
	
	Возврат "http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/" + Версия;
	
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений
//
// Возвращаемое значение:
//   Строка - 
//
Функция Версия() Экспорт
	
	Возврат "1.0.0.2";
	
КонецФункции

// Возвращает название программного интерфейса сообщений
//
// Возвращаемое значение:
//   Строка - 
//
Функция ПрограммныйИнтерфейс() Экспорт
	
	Возврат "ApplicationExtensionsCore";
	
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
//
// Параметры:
//  МассивОбработчиков - Массив - общие модули или модули менеджеров.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
	
КонецПроцедуры

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionAssignmentObject
//
// Параметры:
//  ИспользуемыйПакет - строка, пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - 
//
Функция ТипОбъектНазначения(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionAssignmentObject");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionSubsystemsAssignment
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипНазначениеРазделам(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionSubsystemsAssignment");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCatalogsAndDocumentsAssignment
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипНазначениеСправочникамИДокументам(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCatalogsAndDocumentsAssignment");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCommand
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипКоманда(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCommand");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionReportVariantAssignment
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипНазначениеВариантаОтчета(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionReportVariantAssignment");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionReportVariant
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипВариантОтчета(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionReportVariant");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCommandSettings
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипНастройкиКоманды(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionCommandSettings");
	
КонецФункции

// Возвращает тип {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionManifest
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой
//    получается тип сообщения.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - 
//
Функция ТипМанифест(Знач ИспользуемыйПакет = Неопределено) Экспорт
	
	Возврат СоздатьТипСообщения(ИспользуемыйПакет, "ExtensionManifest");
	
КонецФункции

// Возвращает словарь соответствий значений перечисления ВидыДополнительныхОтчетовИОбработок
// значениям XDTO-типа {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionCategory
//
// Возвращаемое значение:
//  Структура - 
//
Функция СловарьВидыДополнительныхОтчетовИОбработок() Экспорт
	
	Словарь = Новый Структура();
	Менеджер = Перечисления.ВидыДополнительныхОтчетовИОбработок;
	
	Словарь.Вставить("AdditionalProcessor", Менеджер.ДополнительнаяОбработка);
	Словарь.Вставить("AdditionalReport", Менеджер.ДополнительныйОтчет);
	Словарь.Вставить("ObjectFilling", Менеджер.ЗаполнениеОбъекта);
	Словарь.Вставить("Report", Менеджер.Отчет);
	Словарь.Вставить("PrintedForm", Менеджер.ПечатнаяФорма);
	Словарь.Вставить("LinkedObjectCreation", Менеджер.СозданиеСвязанныхОбъектов);
	Словарь.Вставить("TemplatesMessages", Менеджер.ШаблонСообщения);
	
	Возврат Словарь;
	
КонецФункции

// Возвращает словарь соответствий значений перечисления СпособыВызоваДополнительныхОбработок
// значениям XDTO-типа {http://www.1c.ru/1cFresh/ApplicationExtensions/Core/a.b.c.d}ExtensionStartupType
//
// Возвращаемое значение:
//  Структура - 
//
Функция СловарьСпособыВызоваДополнительныхОтчетовИОбработок() Экспорт
	
	Словарь = Новый Структура();
	Менеджер = Перечисления.СпособыВызоваДополнительныхОбработок;
	
	Словарь.Вставить("ClientCall", Менеджер.ВызовКлиентскогоМетода);
	Словарь.Вставить("ServerCall", Менеджер.ВызовСерверногоМетода);
	Словарь.Вставить("FormOpen", Менеджер.ОткрытиеФормы);
	Словарь.Вставить("FormFill", Менеджер.ЗаполнениеФормы);
	Словарь.Вставить("SafeModeExtension", Менеджер.СценарийВБезопасномРежиме);
	
	Возврат Словарь;
	
КонецФункции

Функция СоздатьТипСообщения(Знач ИспользуемыйПакет, Знач Тип)
		
	Если ИспользуемыйПакет = Неопределено Тогда
		ИспользуемыйПакет = Пакет();
	КонецЕсли;
	
	Возврат ФабрикаXDTO.Тип(ИспользуемыйПакет, Тип);
	
КонецФункции

#КонецОбласти