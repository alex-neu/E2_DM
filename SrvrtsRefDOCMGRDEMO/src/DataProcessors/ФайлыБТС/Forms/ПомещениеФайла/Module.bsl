
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаголовокДиалога = Параметры.ЗаголовокДиалогаВыбора;
	Если ЗначениеЗаполнено(ЗаголовокДиалога) Тогда
		ЭтотОбъект.Заголовок = ЗаголовокДиалога;
		ЭтотОбъект.АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	ИмяФайлаИлиАдрес = Параметры.ИмяФайлаИлиАдрес;
	Параметры.Свойство("ПутьФайлаWindows", ПутьФайлаWindows);
	Параметры.Свойство("ПутьФайлаLinux", ПутьФайлаLinux);
	
	ИмяФайлаНаКлиенте = Параметры.ИмяФайлаНаКлиенте;
	РазмерФайла = Параметры.РазмерФайла;
	
	Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = СтрШаблон(НСтр("ru = 'Загрузка файла %1'"), Параметры.ПредставлениеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("НачатьЗагрузкуФайла", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗагрузкаЗавершена Тогда
		Отказ = Истина;
		ОтменаЗагрузки = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьЗагрузкуФайла()
	
	Оповещение = Новый ОписаниеОповещения("ПослеОткрытияПотока", ЭтотОбъект, , "ПриОшибке", ЭтотОбъект);
	ФайловыеПотоки.НачатьОткрытие(Оповещение, ИмяФайлаНаКлиенте, РежимОткрытияФайла.Открыть, ДоступКФайлу.Чтение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияПотока(Поток, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Поток", Поток);
	ДополнительныеПараметры.Вставить("Буфер", Новый БуферДвоичныхДанных(ФайлыБТСКлиентСервер.РазмерПорцииОбработки(РазмерФайла)));
	
	ПрочитатьОчереднуюПорцию(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьОчереднуюПорцию(ДополнительныеПараметры)
	
	Если ОтменаЗагрузки Тогда
		ОтменитьЗагрузку();
		ЗагрузкаЗавершена = Истина;
		Закрыть();
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ОчереднаяЧастьПрочитана", ЭтотОбъект, ДополнительныеПараметры, "ПриОшибке", ЭтотОбъект);
	ДополнительныеПараметры.Поток.НачатьЧтение(Оповещение, ДополнительныеПараметры.Буфер, 0, ДополнительныеПараметры.Буфер.Размер);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчереднаяЧастьПрочитана(Количество, ДополнительныеПараметры) Экспорт
	
	Позиция = ДополнительныеПараметры.Поток.ТекущаяПозиция();
	
	Буфер = ?(ДополнительныеПараметры.Буфер.Размер = Количество, ДополнительныеПараметры.Буфер, ДополнительныеПараметры.Буфер.Прочитать(0, Количество));
	ОтправитьОчереднуюПорцию(ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(Буфер), Позиция - Количество, Позиция);
	
	Если Позиция = РазмерФайла Тогда
		ЗавершитьЗагрузку();
		Возврат;
	КонецЕсли;
	
	ПрочитатьОчереднуюПорцию(ДополнительныеПараметры);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьОчереднуюПорцию(ДвоичныеДанные, Начало, Конец)
	
	Прогресс = 100 * Начало / РазмерФайла;
	ОтправитьОчереднуюПорциюНаСервере(ИмяФайлаИлиАдрес, ПутьФайлаWindows, ПутьФайлаLinux, ДвоичныеДанные, Начало);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтправитьОчереднуюПорциюНаСервере(Знач ИмяФайлаИлиАдрес, Знач ПутьФайлаWindows, Знач ПутьФайлаLinux, Знач ДвоичныеДанные, Знач Начало)
	
	Если Начало = 0 Тогда
		РежимОткрытия = РежимОткрытияФайла.Создать;
	Иначе
		РежимОткрытия = РежимОткрытияФайла.Дописать;
	КонецЕсли;
	
	ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(ИмяФайлаИлиАдрес, ПутьФайлаWindows, ПутьФайлаLinux);
	ПотокЗаписи = ФайловыеПотоки.Открыть(ИмяФайлаНаСервере, РежимОткрытия, ДоступКФайлу.Запись);
	РазмерЗаписанногоФрагмента = ПотокЗаписи.Размер();
	Если РазмерЗаписанногоФрагмента <> Начало Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Размер файла %1 не соответствует ожидаемому %2'"), РазмерЗаписанногоФрагмента, Начало);
	КонецЕсли;
	
	ПотокДанных = ДвоичныеДанные.ОткрытьПотокДляЧтения();
	ПотокДанных.КопироватьВ(ПотокЗаписи);
	ПотокЗаписи.Закрыть();
	ПотокДанных.Закрыть();
	ПотокЗаписи = Неопределено;
	ПотокДанных = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьЗагрузку()
	
	Прогресс = 100;
	Состояние(НСтр("ru = 'Файл помещен'"));
	ЗагрузкаЗавершена = Истина;
	Закрыть(Новый Структура("ИмяФайлаИлиАдрес, ИмяФайлаНаКлиенте", ИмяФайлаИлиАдрес, ИмяФайлаНаКлиенте));
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьЗагрузку()
	
	ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(ИмяФайлаИлиАдрес, ПутьФайлаWindows, ПутьФайлаLinux);
	ИмяСобытияЖР = НСтр("ru = 'Удаление файла.Отмена загрузки'", ОбщегоНазначения.КодОсновногоЯзыка());
	ФайлыБТС.УдалитьФайлыВПопытке(ИмяФайлаНаСервере, ИмяСобытияЖР);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОшибке(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	ОтменитьЗагрузку();
	ЗагрузкаЗавершена = Истина;
	Закрыть();
		
КонецПроцедуры

#КонецОбласти
