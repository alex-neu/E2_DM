///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем ПараметрыОбработкиПользователяИБ; // Параметры, заполняемые при обработке пользователя ИБ.
                                        // Используются в обработчике события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

Перем СтарыйОбъектАвторизации; // Значений объекта авторизации до изменения.
                               // Используются в обработчике события ПриЗаписи.

#КонецОбласти

// *Область ПрограммныйИнтерфейс.
//
// Программный интерфейс объекта реализован через ДополнительныеСвойства:
//
// ОписаниеПользователяИБ - Структура, как и в модуле объекта справочника Пользователи.
//
// *КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоНовый = ЭтоНовый();
	
	Если НЕ ЗначениеЗаполнено(ОбъектАвторизации) Тогда
		ВызватьИсключение НСтр("ru = 'У внешнего пользователя не задан объект авторизации.'");
	Иначе
		ТекстОшибки = "";
		Если ПользователиСлужебный.ОбъектАвторизацииИспользуется(
		         ОбъектАвторизации, Ссылка, , , ТекстОшибки) Тогда
			
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	КонецЕсли;
	
	// Проверка, что объект авторизации не изменен.
	Если ЭтоНовый Тогда
		СтарыйОбъектАвторизации = NULL;
	Иначе
		СтарыйОбъектАвторизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Ссылка, "ОбъектАвторизации");
		
		Если ЗначениеЗаполнено(СтарыйОбъектАвторизации)
		   И СтарыйОбъектАвторизации <> ОбъектАвторизации Тогда
			
			ВызватьИсключение НСтр("ru = 'Невозможно изменить ранее указанный объект авторизации.'");
		КонецЕсли;
	КонецЕсли;
	
	ПользователиСлужебный.НачатьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	// Обновление состава группы нового внешнего пользователя (если задана).
	Если ДополнительныеСвойства.Свойство("ГруппаНовогоВнешнегоПользователя")
	   И ЗначениеЗаполнено(ДополнительныеСвойства.ГруппаНовогоВнешнегоПользователя) Тогда
		
		Блокировка = Новый БлокировкаДанных;
		Блокировка.Добавить("Справочник.ГруппыВнешнихПользователей");
		Блокировка.Заблокировать();
		
		ОбъектГруппы = ДополнительныеСвойства.ГруппаНовогоВнешнегоПользователя.ПолучитьОбъект();
		ОбъектГруппы.Состав.Добавить().ВнешнийПользователь = Ссылка;
		ОбъектГруппы.Записать();
	КонецЕсли;
	
	// Обновление состава автоматической группы "Все внешние пользователи".
	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;
	
	ПользователиСлужебный.ОбновитьСоставыГруппВнешнихПользователей(
		Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи,
		Ссылка,
		УчастникиИзменений,
		ИзмененныеГруппы);
	
	ПользователиСлужебный.ОбновитьИспользуемостьСоставовГруппПользователей(
		Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(
		ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
	ПользователиСлужебный.ПослеОбновленияСоставовГруппВнешнихПользователей(
		УчастникиИзменений,
		ИзмененныеГруппы);
	
	Если СтарыйОбъектАвторизации <> ОбъектАвторизации Тогда
		ИнтеграцияПодсистемБСП.ПослеИзмененияОбъектаАвторизацииВнешнегоПользователя(
			Ссылка, СтарыйОбъектАвторизации, ОбъектАвторизации);
	КонецЕсли;
	
	ПользователиСлужебный.ВключитьЗаданиеКонтрольАктивностиПользователейПриНеобходимости(Ссылка);
	
	ИнтеграцияПодсистемБСП.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбщиеДействияПередУдалениемВОбычномРежимеИПриОбменеДанными();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДополнительныеСвойства.Вставить("ЗначениеКопирования", ОбъектКопирования.Ссылка);
	
	ИдентификаторПользователяИБ = Неопределено;
	ИдентификаторПользователяСервиса = Неопределено;
	Подготовлен = Ложь;
	
	Комментарий = "";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Процедура ОбщиеДействияПередУдалениемВОбычномРежимеИПриОбменеДанными() Экспорт
	
	// Требуется удалить пользователя ИБ, иначе он попадет в список ошибок в форме ПользователиИБ,
	// кроме того, вход под этим пользователем ИБ приведет к ошибке.
	
	ОписаниеПользователяИБ = Новый Структура;
	ОписаниеПользователяИБ.Вставить("Действие", "Удалить");
	ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
	
	ПользователиСлужебный.НачатьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ, Истина);
	ПользователиСлужебный.ЗавершитьОбработкуПользователяИБ(ЭтотОбъект, ПараметрыОбработкиПользователяИБ);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли