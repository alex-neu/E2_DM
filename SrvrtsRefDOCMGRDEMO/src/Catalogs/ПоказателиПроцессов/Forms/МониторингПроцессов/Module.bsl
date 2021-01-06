#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущийПользователь",
		ПользователиКлиентСервер.ТекущийПользователь());
	
	// Вариант работы формы.
	УстановитьВариантФормы();
	
	// Показывать удаленные - при первом открытии формы нужно не отображать удаленные.
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПоказательПроцесса" Тогда
		Элементы.Список.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	// Показывать удаленные.
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если Копирование Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	МониторингПроцессовКлиент.ОткрытьДиалогСозданияПоказателяПроцесса(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВосстановитьПоказателиПоУмолчанию(Команда)
	
	МониторингПроцессовКлиент.ВосстановитьПоказателиПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьУдаленные(Команда)
	
	ПоказыватьУдаленные = Не ПоказыватьУдаленные;
	УстановитьОтборПоказыватьУдаленные();
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеПоказатели(Команда)
	
	МониторингПроцессовКлиент.ОткрытьФормуВсеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьОтчеты(Команда)
	
	ОткрытьФорму("Отчет.МониторингПроцессов.Форма", , ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоказыватьУдаленные()
	
	Параметр = Список.Параметры.НайтиЗначениеПараметра(
		Новый ПараметрКомпоновкиДанных("ОтборПоказыватьУдаленные"));
	Параметр.Использование = Ложь;
	
	Элементы.ПоказыватьУдаленные.Пометка = ПоказыватьУдаленные;
	
	Если Не ПоказыватьУдаленные Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОтборПоказыватьУдаленные", Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантФормы()
	
	Если Параметры.РежимВыбора Тогда
		Параметры.ВариантФормы = "ВыборПодбор";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.ВариантФормы) Тогда
		Параметры.ВариантФормы = "ВсеПоказатели";
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, Параметры.ВариантФормы);
	
	Если Параметры.ВариантФормы = "ВсеПоказатели" Тогда
		
		Заголовок = СтрШаблон("%1 (%2)", Заголовок, НСтр("ru = 'Все показатели'"));
		
		Элементы.Список.РежимВыбора = Ложь;
		
	ИначеЕсли Параметры.ВариантФормы = "МоиПоказатели" Тогда
		
		Список.Параметры.УстановитьЗначениеПараметра("АктивнаПодписка", Истина);
		
		Элементы.СправочникПоказателиПроцессовОтслеживать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСправочникПоказателиПроцессовОтслеживать.Видимость = Ложь;
		
		Элементы.Список.РежимВыбора = Ложь;
		
	ИначеЕсли Параметры.ВариантФормы = "ВыборПодбор" Тогда
		
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		Элементы.Список.РежимВыбора = Истина;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			Элементы.Список.МножественныйВыбор = Истина;
		КонецЕсли;
		
		Элементы.Значение.Видимость = Ложь;
		Элементы.ГруппаДинамикаВся.Видимость = Ложь;
		Элементы.СправочникПоказателиПроцессовОтслеживать.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюСправочникПоказателиПроцессовОтслеживать.Видимость = Ложь;
		
	Иначе
		
		Элементы.Список.РежимВыбора = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Список.УсловноеОформление.Элементы.Очистить();
	МониторингПроцессов.УстановитьУсловноеОформление(Список.УсловноеОформление, Параметры.ВариантФормы);
	
КонецПроцедуры

#КонецОбласти