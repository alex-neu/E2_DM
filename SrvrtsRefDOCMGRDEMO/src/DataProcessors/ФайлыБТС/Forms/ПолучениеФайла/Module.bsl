#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяФайлаИлиАдрес = Параметры.ИмяФайлаИлиАдрес;
	Параметры.Свойство("ПутьФайлаWindows", ПутьФайлаWindows);
	Параметры.Свойство("ПутьФайлаLinux", ПутьФайлаLinux);
	
	ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(ИмяФайлаИлиАдрес, ПутьФайлаWindows, ПутьФайлаLinux);
		
	ОбъектФС = Новый Файл(ИмяФайлаНаСервере);
	Если НЕ ОбъектФС.Существует() ИЛИ НЕ ОбъектФС.ЭтоФайл() Тогда
		ВызватьИсключение НСтр("ru = 'Файл на сервере не найден'");
	КонецЕсли;
	
	Параметры.Свойство("ИмяФайлаДиалогаСохранения", ИмяФайла);
	Если ПустаяСтрока(ИмяФайла) Тогда 
		ИмяФайла = ОбъектФС.Имя;
	КонецЕсли;
	РазмерФайла = ОбъектФС.Размер();
	РазмерПорции = ФайлыБТСКлиентСервер.РазмерПорцииОбработки(РазмерФайла);
	
	Параметры.Свойство("ЗаголовокДиалогаСохранения", ЗаголовокДиалога);
	Если ЗначениеЗаполнено(ЗаголовокДиалога) Тогда
		ЭтотОбъект.Заголовок = ЗаголовокДиалога;
		ЭтотОбъект.АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	Параметры.Свойство("ФильтрДиалогаСохранения", ФильтрДиалога);
	
	Если Параметры.Свойство("ИмяФайлаНаКлиенте", ИмяФайлаНаКлиенте) Тогда
		ПредставлениеФайла = ФайлыБТСКлиентСервер.ПредставлениеФайла(ИмяФайлаНаКлиенте, РазмерФайла);
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПрогресс;
	Иначе
		ПредставлениеФайла = ФайлыБТСКлиентСервер.ПредставлениеФайла(ИмяФайла, РазмерФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ИмяФайлаНаКлиенте) Тогда
		ЗаписатьФайл(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ПрерватьЗапись = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОткрыть(Команда)
	
	СкачатьФайл(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СкачатьФайл(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СкачатьФайл(Открыть)
	
	Если Открыть Тогда
		
		НачатьПолучениеКаталогаВременныхФайлов(Новый ОписаниеОповещения("ПослеПолученияВременногоКаталога", ЭтотОбъект));
		
	Иначе
		
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
		Диалог.Заголовок = ЗаголовокДиалога;
		Диалог.ПолноеИмяФайла = ИмяФайла;
		Диалог.Фильтр = ФильтрДиалога;
		Диалог.Показать(Новый ОписаниеОповещения("ПослеВыбораИмениФайла", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПолученияВременногоКаталога(Каталог, ДополнительныеПараметры) Экспорт
	
	Если Не СтрЗаканчиваетсяНа(Каталог, ПолучитьРазделительПути()) Тогда
		Каталог = Каталог + ПолучитьРазделительПути();
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Каталог", Каталог);
	ДополнительныеПараметры.Вставить("НомерФайла", -1);
	ДополнительныеПараметры.Вставить("ИмяФайла", "");
	ПослеПроверкиСуществованияВременногоФайла(Истина, ДополнительныеПараметры);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиСуществованияВременногоФайла(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		ДополнительныеПараметры.НомерФайла = ДополнительныеПараметры.НомерФайла + 1;
		Файл = Новый Файл(ИмяФайла);
		Части = Новый Массив;
		Части.Добавить(ДополнительныеПараметры.Каталог);
		Части.Добавить(Файл.ИмяБезРасширения);
		Если ДополнительныеПараметры.НомерФайла > 0 Тогда
			Части.Добавить("~");
			Части.Добавить(Формат(ДополнительныеПараметры.НомерФайла, "ЧГ=0"));
		КонецЕсли;
		Части.Добавить(Файл.Расширение);
		ДополнительныеПараметры.ИмяФайла = СтрСоединить(Части);
		Файл = Новый Файл(ДополнительныеПараметры.ИмяФайла);
		Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПослеПроверкиСуществованияВременногоФайла", ЭтотОбъект, ДополнительныеПараметры));
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПрогресс;
		ИмяФайлаНаКлиенте = ДополнительныеПараметры.ИмяФайла;
		ЗаписатьФайл(Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораИмениФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Закрыть();
		Возврат;
	КонецЕсли;
	
	ИмяФайлаНаКлиенте = ВыбранныеФайлы[0];
	ПредставлениеФайла = ФайлыБТСКлиентСервер.ПредставлениеФайла(ИмяФайлаНаКлиенте, РазмерФайла);
	Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаПрогресс;
	ЗаписатьФайл(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайл(Открыть)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Открыть", Открыть);
	
	Файл = Новый Файл(ИмяФайлаНаКлиенте);
	Файл.НачатьПроверкуСуществования(Новый ОписаниеОповещения("ПослеПроверкиСуществованияФайла", ЭтотОбъект, ДополнительныеПараметры));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПроверкиСуществованияФайла(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует Тогда
		Оповещение = Новый ОписаниеОповещения("ПослеУдаленияФайла", ЭтотОбъект, ДополнительныеПараметры);
		НачатьУдалениеФайлов(Оповещение, ИмяФайлаНаКлиенте);
	Иначе
		ЗаписатьФайлПослеПроверки(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеУдаленияФайла(ДополнительныеПараметры) Экспорт
	
	ЗаписатьФайлПослеПроверки(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьФайлПослеПроверки(ДополнительныеПараметры)
	
	КоличествоПорций = Цел(РазмерФайла / РазмерПорции) + ?(РазмерФайла % РазмерПорции > 0, 1, 0);
	
	Оповещение = Новый ОписаниеОповещения("ПослеОткрытияПотока", ЭтотОбъект, ДополнительныеПараметры, "ПриОшибке", ЭтотОбъект);
	ФайловыеПотоки.НачатьОткрытиеДляЗаписи(Оповещение, ИмяФайлаНаКлиенте);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияПотока(Поток, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("НомерПорции", 0);
	ДополнительныеПараметры.Вставить("ПотокЗаписи", Поток);
	ДополнительныеПараметры.Вставить("Адрес", ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор));
	
	ЗаписатьПорцию(ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьПорцию(ДополнительныеПараметры) Экспорт
	
	Если ПрерватьЗапись Тогда
		ДополнительныеПараметры.ПотокЗаписи.НачатьЗакрытие(Новый ОписаниеОповещения("ПослеЗакрытияПотока", ЭтотОбъект, ДополнительныеПараметры));
		Возврат;
	КонецЕсли;
	
	Прогресс = Окр(ДополнительныеПараметры.НомерПорции * РазмерПорции / РазмерФайла * 100, 0);
	
	Если ДополнительныеПараметры.НомерПорции = КоличествоПорций Тогда
		ДополнительныеПараметры.ПотокЗаписи.НачатьЗакрытие(Новый ОписаниеОповещения("ПослеЗакрытияПотока", ЭтотОбъект, ДополнительныеПараметры));
		Возврат;
	КонецЕсли;
	
	ПолучитьПорцию(ИмяФайлаИлиАдрес, ПутьФайлаWindows, ПутьФайлаLinux, ДополнительныеПараметры.НомерПорции, ДополнительныеПараметры.Адрес, РазмерПорции);
	Порция = ПолучитьИзВременногоХранилища(ДополнительныеПараметры.Адрес);
	
	ДополнительныеПараметры.НомерПорции = ДополнительныеПараметры.НомерПорции + 1;
	Оповещение = Новый ОписаниеОповещения("ЗаписатьПорцию", ЭтотОбъект, ДополнительныеПараметры, "ПриОшибке", ЭтотОбъект);
	Буфер = ПолучитьБуферДвоичныхДанныхИзДвоичныхДанных(Порция);
	ДополнительныеПараметры.ПотокЗаписи.НачатьЗапись(Оповещение, Буфер, 0, Буфер.Размер);
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияПотока(ДополнительныеПараметры) Экспорт
	
	Если ПрерватьЗапись Тогда
		НачатьУдалениеФайлов(Новый ОписаниеОповещения, ИмяФайлаНаКлиенте);
	ИначеЕсли ДополнительныеПараметры.Открыть Тогда
		НачатьЗапускПриложения(Новый ОписаниеОповещения, ИмяФайлаНаКлиенте);
		Закрыть(Новый Структура("ИмяФайлаИлиАдрес, ИмяФайлаНаКлиенте", ИмяФайлаИлиАдрес, ИмяФайлаНаКлиенте));
	Иначе
		Состояние(НСтр("ru = 'Файл получен'"));
		Закрыть(Новый Структура("ИмяФайлаИлиАдрес, ИмяФайлаНаКлиенте", ИмяФайлаИлиАдрес, ИмяФайлаНаКлиенте));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьПорцию(Знач ИмяФайлаИлиАдрес, Знач ПутьФайлаWindows, Знач ПутьФайлаLinux, Знач Номер, Знач Адрес, Знач РазмерПорции)
	
	ИмяФайлаНаСервере = ФайлыБТС.ПолноеИмяФайлаВСеансе(ИмяФайлаИлиАдрес, ПутьФайлаWindows, ПутьФайлаLinux);
	ЧтениеДанных = Новый ЧтениеДанных(ИмяФайлаНаСервере);
	ЧтениеДанных.Пропустить(Номер * РазмерПорции);
	Буфер = ЧтениеДанных.ПрочитатьВБуферДвоичныхДанных(РазмерПорции);
	ДвоичныеДанные = ПолучитьДвоичныеДанныеИзБуфераДвоичныхДанных(Буфер);
	ЧтениеДанных.Закрыть();
	
	ПоместитьВоВременноеХранилище(ДвоичныеДанные, Адрес);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОшибке(ИнформацияОбОшибке, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	ПрерватьЗапись = Истина;
	Если ДополнительныеПараметры.Свойство("ПотокЗаписи") Тогда
		ДополнительныеПараметры.ПотокЗаписи.НачатьЗакрытие(Новый ОписаниеОповещения("ПослеЗакрытияПотока", ЭтотОбъект, ДополнительныеПараметры));
	КонецЕсли;
	Закрыть();
		
КонецПроцедуры

#КонецОбласти
