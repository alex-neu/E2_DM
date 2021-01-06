///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РасшифровкаИзОтчета = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "РасшифровкаИзОтчета");
	Если РасшифровкаИзОтчета <> Неопределено Тогда
		Отчет = Отчеты.АнализЖурналаРегистрации.РасшифровкаРегламентногоЗадания(РасшифровкаИзОтчета).Отчет;
		
		ИмяРегламентногоЗадания = РасшифровкаИзОтчета.Получить(1);
		НаименованиеСобытия = РасшифровкаИзОтчета.Получить(2);
		Заголовок = НаименованиеСобытия;
		Если ИмяРегламентногоЗадания <> "" Тогда
			НазваниеСобытия = СтрЗаменить(ИмяРегламентногоЗадания, "РегламентноеЗадание.", "");
			
			УстановитьПривилегированныйРежим(Истина);
			ОтборПоРегламентнымЗаданиям = Новый Структура;
			МетаданныеРегламентногоЗадания = Метаданные.РегламентныеЗадания.Найти(НазваниеСобытия);
			Если МетаданныеРегламентногоЗадания <> Неопределено Тогда
				ОтборПоРегламентнымЗаданиям.Вставить("Метаданные", МетаданныеРегламентногоЗадания);
				Если НаименованиеСобытия <> Неопределено Тогда
					ОтборПоРегламентнымЗаданиям.Вставить("Наименование", НаименованиеСобытия);
				КонецЕсли;
				РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ОтборПоРегламентнымЗаданиям);
				Если ЗначениеЗаполнено(РегЗадание) Тогда
					ИдентификаторРегламентногоЗадания = РегЗадание[0].УникальныйИдентификатор;
				КонецЕсли;
			КонецЕсли;
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
	Иначе
		Отчет = Параметры.Отчет;
		ИдентификаторРегламентногоЗадания = Параметры.ИдентификаторРегламентногоЗадания;
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Элементы.ИзменитьРасписание.Видимость = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РегламентныеЗадания");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтчетОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДатаНачала = Расшифровка.Получить(0);
	ДатаОкончания = Расшифровка.Получить(1);
	СеансРегламентногоЗадания.Очистить();
	СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(2)); 
	ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗадания(Команда)
	
	Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
		
		Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ПолучитьРасписание());
		
		ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеРегламентногоЗаданияЗавершение", ЭтотОбъект);
		Диалог.Показать(ОписаниеОповещения);
		
	Иначе
		ПоказатьПредупреждение(,НСтр("ru = 'Невозможно получить расписание регламентного задания: регламентное задание было удалено или не указано его наименование.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКЖурналуРегистрации(Команда)
	
	Для Каждого Область Из Отчет.ВыделенныеОбласти Цикл
		Если Область.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
			Расшифровка = Область.Расшифровка;
		Иначе
			Расшифровка = Неопределено;
		КонецЕсли;
		Если Расшифровка = Неопределено
			ИЛИ Область.Верх <> Область.Низ Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Выберите строку или ячейку нужного сеанса задания'"));
			Возврат;
		КонецЕсли;
		ДатаНачала = Расшифровка.Получить(0);
		ДатаОкончания = Расшифровка.Получить(1);
		СеансРегламентногоЗадания.Очистить();
		СеансРегламентногоЗадания.Добавить(Расшифровка.Получить(2));
		
		КлючУникальности = Строка(ДатаНачала) + "-" + ДатаОкончания + "-" + Расшифровка.Получить(2);
		ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации, , КлючУникальности);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьРасписание()
	
	УстановитьПривилегированныйРежим(Истина);
	
	МодульРегламентныеЗаданияСервер = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСервер");
	Возврат МодульРегламентныеЗаданияСервер.РасписаниеРегламентногоЗадания(ИдентификаторРегламентногоЗадания);
	
КонецФункции

&НаКлиенте
Процедура НастроитьРасписаниеРегламентногоЗаданияЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	
	Если Расписание <> Неопределено Тогда
		УстановитьРасписаниеРегламентногоЗадания(Расписание);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеРегламентногоЗадания(Расписание)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", Расписание);
	МодульРегламентныеЗаданияСервер = ОбщегоНазначения.ОбщийМодуль("РегламентныеЗаданияСервер");
	МодульРегламентныеЗаданияСервер.ИзменитьЗадание(ИдентификаторРегламентногоЗадания, ПараметрыЗадания);
	
КонецПроцедуры

#КонецОбласти
