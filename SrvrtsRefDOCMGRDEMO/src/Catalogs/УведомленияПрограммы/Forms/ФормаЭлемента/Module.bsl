#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИндексВидУведомления = -1;
	Если Объект.ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Ошибка Тогда
		ИндексВидУведомления = 2;
	ИначеЕсли Объект.ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Предупреждение Тогда
		ИндексВидУведомления = 1;
	ИначеЕсли Объект.ВидУведомления = Перечисления.ВидыУведомленийПрограммы.Информация Тогда
		ИндексВидУведомления = 0;
	КонецЕсли;
	
	Элементы.ПерейтиКПредмету.Видимость = ЗначениеЗаполнено(Объект.Объект);
	
	НужноОтметитьПросмотр = Не Объект.Просмотрено;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	Если НужноОтметитьПросмотр Тогда
		ОтметитьПросмотрНаСервере(Объект.Ссылка);
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Параметры.РежимРаботы = "ПоказУведомлений" И ИмяСобытия = "ЗакрытьПоказУведомлений" И Открыта() Тогда
		НужноОтметитьПросмотр = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Описание = СтрЗаменить(ТекущийОбъект.Описание, "<body>", "<body scroll=auto>");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОписаниеПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаС_HTMLКлиент.ОткрытьСсылку(Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКПредмету(Команда)
	
	ПоказатьЗначение(, Объект.Объект);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ОтметитьПросмотрНаСервере(УведомлениеПрограммы)
	
	Справочники.УведомленияПрограммы.ОтметитьПросмотр(УведомлениеПрограммы);
	
КонецПроцедуры

#КонецОбласти