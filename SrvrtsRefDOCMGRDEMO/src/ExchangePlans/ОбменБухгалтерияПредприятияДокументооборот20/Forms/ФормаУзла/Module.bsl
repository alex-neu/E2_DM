///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаУзлаПриСозданииНаСервере(ЭтотОбъект, Отказ);
	
	Если Не ПолучитьФункциональнуюОпцию("ДокументооборотИспользоватьОграничениеПравДоступа") Тогда
		Элементы.ГруппаСтраницыНастроек.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ОграничиватьВыгрузку =
		ТекущийОбъект.Стороны.Количество() <> 0;
	ТекущийОбъект.ВыгружатьДоговоры =
		ТекущийОбъект.Договоры.Количество() <> 0;
	ТекущийОбъект.ВыгружатьЗаявкиНаОплату =
		ТекущийОбъект.ЗаявкиНаОплату.Количество() <> 0;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменДаннымиСервер.ФормаУзлаПриЗаписиНаСервере(ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УзелПланаОбмена");
	
КонецПроцедуры

#КонецОбласти