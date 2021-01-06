
&НаКлиенте
Процедура ОтменитьПроверку(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВнутренниеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВнутренниеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИсходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ИсходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрагенты Тогда
		ВыбранныйЭлемент = Элементы.Контрагенты;
	КонецЕсли;	
	Если ВыбранныйЭлемент.ВыделенныеСтроки.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Для снятия отметки о проеверке необходимо выделить элементы в списке.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru = 'Снять с выбранных элементов (%1) отметку о проверке?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ВыбранныйЭлемент.ВыделенныеСтроки.Количество());
	Режим = Новый СписокЗначений;
	Режим.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Снять'"));
	Режим.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не снимать'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОтменитьПроверкуПродолжение",
		ЭтотОбъект,
		Новый Структура("ВыбранныйЭлемент", ВыбранныйЭлемент));

	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Режим, , КодВозвратаДиалога.Нет);
		
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПроверкуПродолжение(Результат, Прараметры) Экспорт 

	Если Результат <> КодВозвратаДиалога.Да Тогда
	    ОтменитьПроверкуНаСервере();
		Прараметры.ВыбранныйЭлемент.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПриСозданииНаСервереРедакцииКонфигурации();	

	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ВнутренниеДокументы) Тогда 
		Элементы.СтраницаВнутренниеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ВходящиеДокументы) Тогда
		Элементы.СтраницаВходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.ИсходящиеДокументы) Тогда
		Элементы.СтраницаИсходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.Контрагенты) Тогда
		Элементы.СтраницаКонтрагенты.Видимость = Ложь;
	КонецЕсли;
	
	ВыполнятьПроверкуЭПНаСервере = ЭлектроннаяПодпись.ПроверятьЭлектронныеПодписиНаСервере();
	
	ПоказыватьПроверенные = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ПоказыватьПроверенные");
	Если ПоказыватьПроверенные = Неопределено Тогда
		ПоказыватьПроверенные = Ложь;
	КонецЕсли;
	
	ПоказыватьТолькоПодписанные = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ПоказыватьТолькоПодписанные");
	Если ПоказыватьТолькоПодписанные = Неопределено Тогда
		ПоказыватьТолькоПодписанные = Ложь;
	КонецЕсли;
		
	ПериодЗагрузки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ПериодЗагрузки");
	ПериодПроверки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ПериодПроверки");
	ОтборПроверил = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ОтборПроверил");
	ОтборОрганизация = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ОтборОрганизация");
	ОтборСтатусПроверкиЭП = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(ИмяФормы, "ОтборСтатусПроверкиЭП");
	
	УстановитьОтборыВсехСписков();
	
	ОбновитьСписокФайлов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыВсехСписков()
	
	УстановитьОтборПроверен(ВходящиеДокументы);
	УстановитьОтборПроверен(ВнутренниеДокументы);
	УстановитьОтборПроверен(ИсходящиеДокументы);
	УстановитьОтборПроверен(Контрагенты);
	
	УстановитьОтборПоПериодуЗагрузки(ВходящиеДокументы);
	УстановитьОтборПоПериодуЗагрузки(ВнутренниеДокументы);
	УстановитьОтборПоПериодуЗагрузки(ИсходящиеДокументы);
	УстановитьОтборПоПериодуЗагрузки(Контрагенты);
	
	УстановитьОтборПоПериодуПроверки(ВходящиеДокументы);
	УстановитьОтборПоПериодуПроверки(ВнутренниеДокументы);
	УстановитьОтборПоПериодуПроверки(ИсходящиеДокументы);
	УстановитьОтборПоПериодуПроверки(Контрагенты);
	
	УстановитьОтборПоПроверил(ВходящиеДокументы);
	УстановитьОтборПоПроверил(ВнутренниеДокументы);
	УстановитьОтборПоПроверил(ИсходящиеДокументы);
	УстановитьОтборПоПроверил(Контрагенты);	
	
	УстановитьОтборПодписан(ВходящиеДокументы);
	УстановитьОтборПодписан(ВнутренниеДокументы);
	УстановитьОтборПодписан(ИсходящиеДокументы);
	УстановитьОтборПодписан(Контрагенты);
	
	УстановитьОтборПоОрганизации(ВходящиеДокументы);
	УстановитьОтборПоОрганизации(ВнутренниеДокументы);
	УстановитьОтборПоОрганизации(ИсходящиеДокументы);
	
	УстановитьОтборПоСтатусуПроверкиЭП(ВходящиеДокументы);
	УстановитьОтборПоСтатусуПроверкиЭП(ВнутренниеДокументы);
	УстановитьОтборПоСтатусуПроверкиЭП(ИсходящиеДокументы);
		
	ПолучитьКоличествоВсехОбъектовСервер();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПроверен(Список)
	
	Если ПоказыватьПроверенные = Ложь Тогда
		УстановитьОтборСпискаПроверен(Список);
	Иначе
		УдалитьОтборСписка(Список, "Проверен");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПодписан(Список)
	
	Если ПоказыватьТолькоПодписанные = Истина Тогда
		УстановитьОтборСпискаПодписан(Список);
	Иначе
		УдалитьОтборСписка(Список, "ПодписанЭП");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСпискаПроверен(Список)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"Проверен",
		ПоказыватьПроверенные,
		ВидСравненияКомпоновкиДанных.Равно);
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСпискаПодписан(Список)
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор,
		"ПодписанЭП",
		ПоказыватьТолькоПодписанные,
		ВидСравненияКомпоновкиДанных.Равно);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УдалитьОтборСписка(Список, ИмяОтбора)
	ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, ИмяОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтбора(Элемент)
	ПриИзмененииОтбораСервер(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ПериодПроверкиПриИзменении(Элемент)
	ПриИзмененииОтбораСервер(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьТолькоПодписанныеПриИзменении(Элемент)
	ПриИзмененииОтбораСервер(Элемент.Имя);
КонецПроцедуры

&НаКлиенте
Процедура ОтборПроверилПриИзменении(Элемент)
	ПриИзмененииОтбораСервер(Элемент.Имя);
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииОтбораСервер(ИмяЭлемента)
	
	УстановитьОтборыВсехСписков();	
	ПолучитьКоличествоВсехОбъектовСервер();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериодуЗагрузки(Список)
	УдалитьЭлементыОтбораПоПредставлению(Список, "ДатаЗагрузкиНачало");
	УдалитьЭлементыОтбораПоПредставлению(Список, "ДатаЗагрузкиОкончание");
	Если ЗначениеЗаполнено(ПериодЗагрузки.ДатаНачала) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"ДатаЗагрузки",
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
			ПериодЗагрузки.ДатаНачала,
			"ДатаЗагрузкиНачало",
			Истина);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПериодЗагрузки.ДатаОкончания) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"ДатаЗагрузки",
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			ПериодЗагрузки.ДатаОкончания,
			"ДатаЗагрузкиОкончание");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПериодуПроверки(Список)
	УдалитьЭлементыОтбораПоПредставлению(Список, "ДатаПроверкиНачало");
	УдалитьЭлементыОтбораПоПредставлению(Список, "ДатаПроверкиОкончание");
	Если ЗначениеЗаполнено(ПериодПроверки.ДатаНачала) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"ДатаПроверки",
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
			ПериодПроверки.ДатаНачала,
			"ДатаПроверкиНачало",
			Истина);
	КонецЕсли;
	Если ЗначениеЗаполнено(ПериодПроверки.ДатаОкончания) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"ДатаПроверки",
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			ПериодПроверки.ДатаОкончания,
			"ДатаПроверкиОкончание");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоПроверил(Список)
	
	УдалитьОтборСписка(Список, "Проверил");
	
	Если ЗначениеЗаполнено(ОтборПроверил) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"Проверил",
			ВидСравненияКомпоновкиДанных.Равно,
			ОтборПроверил);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоОрганизации(Список)
	
	УдалитьОтборСписка(Список, "Организация");
	
	Если ЗначениеЗаполнено(ОтборОрганизация) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"Организация",
			ВидСравненияКомпоновкиДанных.Равно,
			ОтборОрганизация);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСтатусуПроверкиЭП(Список)
	
	УдалитьОтборСписка(Список, "СтатусЭП");
	
	Если ЗначениеЗаполнено(ОтборСтатусПроверкиЭП) Тогда
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.Отбор,
			"СтатусЭП",
			ВидСравненияКомпоновкиДанных.Равно,
			ОтборСтатусПроверкиЭП);
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура УдалитьЭлементыОтбораПоПредставлению(Список, Представление)
	УдаляемыеЭлементы = Новый Массив;
	Для Каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если ЭлементОтбора.Представление = Представление Тогда
			УдаляемыеЭлементы.Добавить(ЭлементОтбора);
		КонецЕсли;
	КонецЦикла;
	Для каждого УдаляемыйЭлемент Из УдаляемыеЭлементы Цикл
		Список.Отбор.Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПриЗакрытии(ЗавершениеРаботы) Тогда
		Возврат;
	КонецЕсли;
	
	ПриЗакрытииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииСервер()
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ПоказыватьПроверенные", ПоказыватьПроверенные);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ПериодЗагрузки", ПериодЗагрузки);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ПериодПроверки", ПериодПроверки);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ОтборПроверил", ОтборПроверил);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ПоказыватьТолькоПодписанные", ПоказыватьТолькоПодписанные);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ОтборОрганизация", ОтборОрганизация);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(ИмяФормы, "ОтборСтатусПроверкиЭП", ОтборСтатусПроверкиЭП);
	
КонецПроцедуры

&НаКлиенте
Процедура ВходящиеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыОткрытия.Вставить("ПроверкаЗагруженныхДанных", Истина);
	ОткрытьФорму("Справочник.ВходящиеДокументы.ФормаОбъекта", ПараметрыОткрытия)
КонецПроцедуры

&НаКлиенте
Процедура ВнутренниеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыОткрытия.Вставить("ПроверкаЗагруженныхДанных", Истина);
	ОткрытьФорму("Справочник.ВнутренниеДокументы.ФормаОбъекта", ПараметрыОткрытия)
КонецПроцедуры

&НаКлиенте
Процедура ИсходящиеДокументыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыОткрытия.Вставить("ПроверкаЗагруженныхДанных", Истина);
	ОткрытьФорму("Справочник.ИсходящиеДокументы.ФормаОбъекта", ПараметрыОткрытия)
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Ключ", Элемент.ТекущиеДанные.Ссылка);
	ПараметрыОткрытия.Вставить("ПроверкаЗагруженныхДанных", Истина);
	ОткрытьФорму("Справочник.Контрагенты.ФормаОбъекта", ПараметрыОткрытия)
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПроверкаЗагруженныхДанных" Тогда
		ОбработкаОповещенияСервер();
	ИначеЕсли ИмяСобытия = "УстановкаРеквизитовДокументов" Тогда
		ОбработкаОповещенияСервер();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаОповещенияСервер()
	ПолучитьКоличествоВсехОбъектовСервер();
	Элементы.ВходящиеДокументы.Обновить();
	Элементы.ВнутренниеДокументы.Обновить();
	Элементы.ИсходящиеДокументы.Обновить();
	Элементы.Контрагенты.Обновить();
КонецПроцедуры

&НаСервере
Процедура ПолучитьКоличествоВсехОбъектовСервер()
	КоличествоВходящихДокументов = ПолучитьКоличествоОбъектовСервер("ВходящиеДокументы");
	КоличествоВнутреннихДокументов = ПолучитьКоличествоОбъектовСервер("ВнутренниеДокументы");
	КоличествоИсходящихДокументов = ПолучитьКоличествоОбъектовСервер("ИсходящиеДокументы");
	КоличествоКонтрагентов = ПолучитьКоличествоОбъектовСервер("Контрагенты");
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоОбъектовСервер(Имя)
	
	//ТекстЗапроса =
	//"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	//|	СУММА(ВЫБОР
	//|			КОГДА ПроверкаЗагруженныхДанных.Проверен
	//|				ТОГДА 0
	//|			ИНАЧЕ 1
	//|		КОНЕЦ) КАК НеПроверено,
	//|	СУММА(1) КАК Всего
	//|ИЗ
	//|	Справочник.[Имя] КАК Документы
	//|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПроверкаЗагруженныхДанных КАК ПроверкаЗагруженныхДанных
	//|		ПО (ПроверкаЗагруженныхДанных.Объект = Документы.Ссылка)
	//|ГДЕ
	//|	(&ДатаЗагрузкиБольшеЛибоРавно = ДАТАВРЕМЯ(1, 1, 1)
	//|			ИЛИ ПроверкаЗагруженныхДанных.ДатаЗагрузки >= &ДатаЗагрузкиБольшеЛибоРавно)
	//|	И (&ДатаЗагрузкиМеньшеЛибоРавно = ДАТАВРЕМЯ(1, 1, 1)
	//|			ИЛИ ПроверкаЗагруженныхДанных.ДатаЗагрузки <= &ДатаЗагрузкиМеньшеЛибоРавно)";
	//Запрос = Новый Запрос(СтрЗаменить(ТекстЗапроса, "[Имя]", Имя));
	//Запрос.УстановитьПараметр("ДатаЗагрузкиБольшеЛибоРавно", ПериодЗагрузки.ДатаНачала);
	//Запрос.УстановитьПараметр("ДатаЗагрузкиМеньшеЛибоРавно", ПериодЗагрузки.ДатаОкончания);
	//РезультатЗапросаТаблица = Запрос.Выполнить().Выгрузить();
	//
	//КоличествоДокументов = Формат(РезультатЗапросаТаблица[0].Всего, "ЧГ=0");
	//Если Не ПустаяСтрока(КоличествоДокументов) Тогда
	//	Если РезультатЗапросаТаблица[0].НеПроверено > 0 Тогда
	//		ДобавитьЗначениеКСтрокеЧерезРазделитель(КоличествоДокументов, " / ", Формат(РезультатЗапросаТаблица[0].НеПроверено, "ЧГ=0"));
	//	КонецЕсли;
	//КонецЕсли;
	//
	//Возврат КоличествоДокументов;
	
КонецФункции

&НаКлиенте
Процедура ПриАктивизацииСтроки(Элемент)
	
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		ОбновитьСписокФайлов();
	Иначе
		ОбновитьСписокФайлов(Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокФайлов(ВладелецФайла = Неопределено)
	Файлы.Параметры.УстановитьЗначениеПараметра("ВладелецФайла", ВладелецФайла);
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.СтраницаВнутренниеДокументы Тогда
		ПриАктивизацииСтроки(Элементы.ВнутренниеДокументы);
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаВходящиеДокументы Тогда
		ПриАктивизацииСтроки(Элементы.ВходящиеДокументы);
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаИсходящиеДокументы Тогда
		ПриАктивизацииСтроки(Элементы.ИсходящиеДокументы);
	ИначеЕсли ТекущаяСтраница = Элементы.СтраницаКонтрагенты Тогда
		ПриАктивизацииСтроки(Элементы.Контрагенты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРеквизиты(Команда)
	
	СписокДокументов = Новый Массив;
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВходящиеДокументы Тогда
		Для каждого ВыделеннаяСтрока Из Элементы.ВходящиеДокументы.ВыделенныеСтроки Цикл
			СписокДокументов.Добавить(ВыделеннаяСтрока);
		КонецЦикла;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВнутренниеДокументы Тогда	
		Для каждого ВыделеннаяСтрока Из Элементы.ВнутренниеДокументы.ВыделенныеСтроки Цикл
			СписокДокументов.Добавить(ВыделеннаяСтрока);
		КонецЦикла;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИсходящиеДокументы Тогда	
		Для каждого ВыделеннаяСтрока Из Элементы.ИсходящиеДокументы.ВыделенныеСтроки Цикл
			СписокДокументов.Добавить(ВыделеннаяСтрока);
		КонецЦикла;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрагенты Тогда	
		СписокДокументов.Добавить(Элементы.Контрагенты.ТекущаяСтрока);
	Иначе
		Возврат;
	КонецЕсли;
	
	Если СписокДокументов.Количество() = 0 Тогда
		Возврат;
	ИначеЕсли СписокДокументов.Количество() = 1 Тогда
		Если ЗначениеЗаполнено(СписокДокументов[0]) Тогда
			ПоказатьЗначение(, СписокДокументов[0]);
		КонецЕсли;
	Иначе
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Документы", СписокДокументов);
		ОткрытьФорму("ОбщаяФорма.УстановкаРеквизитовДокументов", ПараметрыОткрытия, ЭтаФорма);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	КакОткрывать = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ДействиеПоДвойномуЩелчкуМыши;
	Если КакОткрывать = "ОткрыватьКарточку" Тогда
		ПоказатьЗначение(, ВыбраннаяСтрока);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ВыбраннаяСтрока, Неопределено, ЭтаФорма.УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЭП(Документ)
	
	РаботаСЭП.ЗаполнитьСписокПодписей(Документ, ТаблицаПодписей, 
		УникальныйИдентификатор, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Проверено(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВнутренниеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВнутренниеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИсходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ИсходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрагенты Тогда
		ВыбранныйЭлемент = Элементы.Контрагенты;
	КонецЕсли;
	Если ВыбранныйЭлемент.ВыделенныеСтроки.Количество() = 0 Тогда
		ТекстПредупреждения = НСтр("ru = 'Для проверки необходимо выделить элементы в списке.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	ТекстВопроса = НСтр("ru = 'Проверить выбранные элементы (%1)?'");
	ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, ВыбранныйЭлемент.ВыделенныеСтроки.Количество());
	Режим = Новый СписокЗначений;
	Режим.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Проверить'"));
	Режим.Добавить(КодВозвратаДиалога.Нет, НСтр("ru = 'Не проверять'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПровереноПродолжение",
		ЭтотОбъект,
		Новый Структура("ВыбранныйЭлемент", ВыбранныйЭлемент));
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Режим, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровереноПродолжение(Результат, Параметры) Экспорт 

	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Индекс = 0; ВыбранныйЭлемент = Параметры.ВыбранныйЭлемент;
	Для Каждого Документ Из ВыбранныйЭлемент.ВыделенныеСтроки Цикл
		
		Попытка
			
			Индекс = Индекс + 1;
			ИмяСРасширением = Строка(Документ);
			Прогресс = Индекс * 100 / ВыбранныйЭлемент.ВыделенныеСтроки.Количество();
			Состояние(НСтр("ru = 'Идет проверка ЭП документа:'"), Прогресс, ИмяСРасширением);
			
			ЗаполнитьСписокЭП(Документ);
			
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Если ИнформацияОбОшибке.Описание = "ОшибкаПроверки" Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Электронные подписи документа ""%1"" неверны.
					|Документ не сможет быть зарегистрирован.
					|Отправителю документа направлено сообщение об ошибке.'"), 
					Строка(Документ));
				ПоказатьПредупреждение(, ТекстСообщения);
				Прервать;
			Иначе
				ОписаниеОшибкиИнфо = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Во время проверки ЭП документа ""%1"" произошла неизвестная ошибка.'",
						ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), 
					Строка(Документ));
				
				ТекстСообщения = ТекстСообщения + Строка(ОписаниеОшибкиИнфо);
			КонецЕсли;
			
			Состояние(ТекстСообщения);
			
			ЗаписьЖурналаРегистрацииСервер(ТекстСообщения);
			
		КонецПопытки;
			
	КонецЦикла;
	
	ПровереноНаСервере();
	ВыбранныйЭлемент.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаписьЖурналаРегистрацииСервер(ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(
		НСтр("ru = 'Проверка загруженных данных'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Ошибка,,,
		ТекстСообщения);
	
КонецПроцедуры

&НаСервере
Процедура ПровереноНаСервере()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВнутренниеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВнутренниеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИсходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ИсходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрагенты Тогда
		ВыбранныйЭлемент = Элементы.Контрагенты;
	КонецЕсли;
	
	МенеджерЗаписиРегистра = РегистрыСведений.ПроверкаЗагруженныхДанных.СоздатьМенеджерЗаписи();
	Для Каждого ВыделеннаяСтрока Из ВыбранныйЭлемент.ВыделенныеСтроки Цикл
		МенеджерЗаписиРегистра.Объект = ВыделеннаяСтрока;
		МенеджерЗаписиРегистра.Прочитать();
		МенеджерЗаписиРегистра.Проверен = Истина;
		МенеджерЗаписиРегистра.Проверил = ПользователиКлиентСервер.ТекущийПользователь();
		МенеджерЗаписиРегистра.ДатаПроверки = ТекущаяДатаСеанса();
		МенеджерЗаписиРегистра.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПроверкуНаСервере()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВнутренниеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВнутренниеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаВходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ВходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаИсходящиеДокументы Тогда
		ВыбранныйЭлемент = Элементы.ИсходящиеДокументы;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаКонтрагенты Тогда
		ВыбранныйЭлемент = Элементы.Контрагенты;
	КонецЕсли;
	
	МенеджерЗаписиРегистра = РегистрыСведений.ПроверкаЗагруженныхДанных.СоздатьМенеджерЗаписи();
	Для Каждого ВыделеннаяСтрока Из ВыбранныйЭлемент.ВыделенныеСтроки Цикл
		МенеджерЗаписиРегистра.Объект = ВыделеннаяСтрока;
		МенеджерЗаписиРегистра.Прочитать();
		МенеджерЗаписиРегистра.Проверен = Ложь;
		МенеджерЗаписиРегистра.Проверил = Справочники.Пользователи.ПустаяСсылка();
		МенеджерЗаписиРегистра.ДатаПроверки = Дата(1,1,1);
		МенеджерЗаписиРегистра.Записать();
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УстановитьОтборыВсехСписков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьСНепровереннымиЭППриИзменении(Элемент)
	
	УстановитьОтборыВсехСписков();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервереРедакцииКонфигурации()	
	
	Элементы.ОтборОрганизация.Заголовок = РедакцииКонфигурацииКлиентСервер.Организация();
		
КонецПроцедуры
