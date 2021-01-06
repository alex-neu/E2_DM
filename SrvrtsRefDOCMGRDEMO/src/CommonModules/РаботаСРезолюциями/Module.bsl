////////////////////////////////////////////////////////////////////////////////
// МОДУЛЬ ДЛЯ РАБОТЫ С РЕЗОЛЮЦИЯМИ
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру ключевых реквизитов резолюции.
//
// Возвращаемое значение:
//  Структура.
//
Функция ПолучитьСтруктуруКлючевыхРеквизитовРезолюции() Экспорт
	
	МассивИмен = Справочники.Резолюции.ПолучитьИменаКлючевыхРеквизитов();
	
	СтруктураРезолюции = Новый Структура;
	
	Для Каждого Имя Из МассивИмен Цикл
		СтруктураРезолюции.Вставить(Имя);
	КонецЦикла;
		
	Возврат СтруктураРезолюции;
	
КонецФункции

// Возвращает резолюции документа.
//
// Параметры:
//  Документ - ссылка на внутренний или входящий документ.
//  ТолькоАктивные - Булево - возвращать только не помеченные на удаление резолюции
//                   (по умолчанию Истина).
//  ПолучитьДанныеЭП - Булево - возвращать информацию об электронной подписи резолюции
//                     (по умолчанию Ложь).
//  Источник - ЗадачаСсылка.ЗадачаИсполнителя, БизнесПроцессСсылка.Рассмотрение - задача или процесс
//             создавшие резолюцию (по умолчанию Неопределено).
//
// Возвращаемое значение:
//  ТаблицаЗначений
//
Функция ПолучитьРезолюции(Документ, ТолькоАктивные = Истина, ПолучитьДанныеЭП = Ложь, Источник = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Если ПолучитьДанныеЭП Тогда
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Резолюции.Ссылка,
			|	Резолюции.ПометкаУдаления,
			|	Резолюции.АвторРезолюции,
			|	Резолюции.ВнесРезолюцию,
			|	Резолюции.ДатаРезолюции,
			|	Резолюции.Документ,
			|	Резолюции.Источник,
			|	Резолюции.Подписана,
			|	Резолюции.ТекстРезолюции,
			|	ЭП.ДатаПодписи КАК ДатаПодписи,
			|	ЭП.УстановившийПодпись КАК УстановившийПодпись,
			|	ЭП.ДатаПроверкиПодписи КАК ДатаПроверкиПодписи,
			|	ЭП.ПодписьВерна КАК ПодписьВерна,
			|	ЭП.ТекстОшибкиПроверкиПодписи КАК ТекстОшибкиПроверкиПодписи,
			|	ЭП.ТекстОшибкиПроверкиСертификата КАК ТекстОшибкиПроверкиСертификата
			|ИЗ
			|	Справочник.Резолюции КАК Резолюции
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЭлектронныеПодписи КАК ЭП
			|	ПО ЭП.Объект = Резолюции.Ссылка
			|ГДЕ
			|	Резолюции.Документ = &Документ";
	Иначе
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Резолюции.Ссылка,
			|	Резолюции.ПометкаУдаления,
			|	Резолюции.АвторРезолюции,
			|	Резолюции.ВнесРезолюцию,
			|	Резолюции.ДатаРезолюции,
			|	Резолюции.Документ,
			|	Резолюции.Источник,
			|	Резолюции.Подписана,
			|	Резолюции.ТекстРезолюции
			|ИЗ
			|	Справочник.Резолюции КАК Резолюции
			|ГДЕ
			|	Резолюции.Документ = &Документ";
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	Если ТолькоАктивные Тогда
		Запрос.Текст = Запрос.Текст + " И Резолюции.ПометкаУдаления = Ложь";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Источник) Тогда
		Запрос.Текст = Запрос.Текст + " И Резолюции.Источник = &Источник";
		Запрос.УстановитьПараметр("Источник", Источник);
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + " УПОРЯДОЧИТЬ ПО Резолюции.ДатаРезолюции УБЫВ";
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

// Возвращает резолюции документа на указанную дату.
//
// Параметры:
//  Документ - ссылка на внутренний или входящий документ.
//  ДатаРезолюции - Дата - дата, на которую необходимо найти резолюцию.
//
// Возвращаемое значение:
//  ТаблицаЗначений
//
Функция ПолучитьРезолюциюПоДате(Документ, ДатаРезолюции) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Резолюции.Ссылка
		|ИЗ
		|	Справочник.Резолюции КАК Резолюции
		|ГДЕ
		|	Резолюции.Документ = &Документ
		|	И Резолюции.ДатаРезолюции = &ДатаРезолюции
		|	И Резолюции.ПометкаУдаления = Ложь";
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("ДатаРезолюции", ДатаРезолюции);
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат Результат;
	
КонецФункции

// Заполняет резолюции для формы.
//
// Параметры:
//  ЭтаФорма - ФормаКлиентскогоПриложения
//  ТолькоАктивные - Булево - возвращать только не помеченные на удаление резолюции
//                 (по умолчанию Истина).
//
Процедура ЗаполнитьСписокРезолюций(ЭтаФорма, ТолькоАктивные = Истина) Экспорт
	
	Документ = ЭтаФорма.Объект.Ссылка;
	Элементы = ЭтаФорма.Элементы;
	
	Резолюции = ПолучитьРезолюции(Документ, ТолькоАктивные, Истина);
	
	ТаблицаРезолюций = ЭтаФорма.Резолюции;
	ТаблицаРезолюций.Очистить();
	
	Для Каждого Резолюция Из Резолюции Цикл
		НоваяСтрока = ТаблицаРезолюций.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Резолюция);
		НоваяСтрока.Объект = Резолюция.Ссылка;
		НоваяСтрока.КартинкаСтатусаПодписи = 0;
		Если Резолюция.Подписана Тогда
			Если Не ЗначениеЗаполнено(Резолюция.ДатаПроверкиПодписи) Тогда
				НоваяСтрока.КартинкаСтатусаПодписи = 1;
			Иначе
				НоваяСтрока.КартинкаСтатусаПодписи = ?(Резолюция.ПодписьВерна, 2, 3);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ЭтаФорма.КоличествоРезолюций = Резолюции.Количество();
	
	Если Резолюции.Количество() = 0 Тогда 
		Элементы.ГруппаРезолюцииСтраницы.ТекущаяСтраница = Элементы.СтраницаНетРезолюций;
	Иначе
		Элементы.ГруппаРезолюцииСтраницы.ТекущаяСтраница = Элементы.СтраницаЕстьРезолюции;
	КонецЕсли;	
	
	Если Резолюции.Количество() = 0 Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ИСТИНА
			|ИЗ
			|	Справочник.Резолюции КАК Резолюции
			|ГДЕ
			|	Резолюции.Документ = &Документ
			|	И Резолюции.ПометкаУдаления";
		Запрос.УстановитьПараметр("Документ", Документ);
		КоличествоУдаленныхРезолюций = Запрос.Выполнить().Выбрать().Количество();
		Если КоличествоУдаленныхРезолюций = 0 Тогда
			Элементы.ПоказатьУдаленныеРезолюции.Видимость = Ложь;
		Иначе
			Элементы.ПоказатьУдаленныеРезолюции.Видимость = Истина;
			Элементы.ПоказатьУдаленныеРезолюции.Заголовок = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Показать удаленные (%1)'"),
					КоличествоУдаленныхРезолюций);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	// Формирование сводки
	Если Резолюции.Количество() > 0 Тогда
		
		HTMLПредставлениеРезолюций = "";
		Для Каждого Резолюция Из Резолюции Цикл
			HTMLПредставлениеРезолюций = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				"%1<div class=""field"" %2><p>%3</p><p><span class=""status %4"">%5</span></p><p>%6</p></div>",
				HTMLПредставлениеРезолюций,
				?(Резолюция.ПометкаУдаления, "style=""text-decoration: line-through""", ""),
				СтрЗаменить(Резолюция.ТекстРезолюции, Символы.ПС, "<br/>"),
				?(Резолюция.Подписана, ?(Не ЗначениеЗаполнено(Резолюция.ДатаПроверкиПодписи), "not", ?(Резолюция.ПодписьВерна, "true", "false")), ""),
				Резолюция.АвторРезолюции,
				Формат(Резолюция.ДатаРезолюции, "ДФ='dd.MM.yyyy ЧЧ:мм'"));
		КонецЦикла;
			
		ЭтаФорма.РезолюцияHTMLПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			"<html>
			|<head><meta http-equiv=""X-UA-Compatible"" content=""IE=edge""></head>
			|<body>
			|<style>
			|* { font-family: sans-serif; font-size: 9pt; }
			|body { padding: 0; margin: 8px; overflow: auto; }
			|a { color: #1E90FF; }
			|p { padding: 0 0 4px 0; margin: 0; }
			|.field { margin-bottom: 6px; padding: 6px 8px 2px 8px; }
			|.active { background-color: #EEEEEE; }
			|.status { background-position: center right; background-repeat: no-repeat; padding: 1px 24px 2px 0; }
			|.not { background-image: url(""data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAB3RJTUUH3gcIDAYg91pdKgAAAAd0RVh0QXV0aG9yAKmuzEgAAAAMdEVYdERlc2NyaXB0aW9uABMJISMAAAAKdEVYdENvcHlyaWdodACsD8w6AAAADnRFWHRDcmVhdGlvbiB0aW1lADX3DwkAAAAJdEVYdFNvZnR3YXJlAF1w/zoAAAALdEVYdERpc2NsYWltZXIAt8C0jwAAAAh0RVh0V2FybmluZwDAG+aHAAAAB3RFWHRTb3VyY2UA9f+D6wAAAAh0RVh0Q29tbWVudAD2zJa/AAAABnRFWHRUaXRsZQCo7tInAAACAklEQVQ4ja2TsWsUQRjF35udOZNKK5tDAgtXyFleaxLBFPkDUooEJKTKXpWrlJAuVrtdECGFdvkDRFJ4mvbaw+Lg8AhnoZXdejs7zyJz4YhREPzK4f2+ed98bygJi5Vl2RrJdQAdSS0AIDkCMJDUL4ri46Ke8wbdbveepG2S9yX1SQ5ms9kIABqNRktSh+S6pM8kT/I8v7hqEOF9AMMkSd5UVbWSJElbUhodjOu6HjrnJnVdPwHQJvkyz/MLCwCStgEMrbWnVVVtGmOaAIYATqPT1Biz4b2fOudOvfdz5pB7e3trJHeNMc+895skfywtLX06Ojr6uThrr9e7VZblqqTb1tp3IYTXko5tnKtfVdWKMaYpqSzL8mmWZbhekr6SbEZtn+S6BdAheZAkSTvaTouiePUbfbmhHZLDqB0AODCSWrPZbCQplTS+CbzmYiwpjUzL3qCZZFm28wd+cv3Akhw1Go0WgDGANM/z939z0O12HwMYR2ZkcZmwTgjh3Biz0ev1zsuyXAXwBcADY8x3AKjr+s7y8vKZpHYI4cwY85DkwMbU7Trn3nrvp2VZri6scTS/eWGNU+fcJITwXNIxJSHLshcAvsUgPSLZJDmcPyrJVFI7wh+891sA7hZFcWij4ETSvvce1tqrKAPYigbGIYQz59zEe38VZeB/fabF+tfv/AvEjVUkU5cRDAAAAABJRU5ErkJggg==""); }
			|.true { background-image: url(""data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAB3RJTUUH3gcIDAcDTCYdGQAAAAd0RVh0QXV0aG9yAKmuzEgAAAAMdEVYdERlc2NyaXB0aW9uABMJISMAAAAKdEVYdENvcHlyaWdodACsD8w6AAAADnRFWHRDcmVhdGlvbiB0aW1lADX3DwkAAAAJdEVYdFNvZnR3YXJlAF1w/zoAAAALdEVYdERpc2NsYWltZXIAt8C0jwAAAAh0RVh0V2FybmluZwDAG+aHAAAAB3RFWHRTb3VyY2UA9f+D6wAAAAh0RVh0Q29tbWVudAD2zJa/AAAABnRFWHRUaXRsZQCo7tInAAABwElEQVQ4ja2TMWsUURSFv7nz8hQbrWwWCQxsIWOZ1s0KpvAHpBQJSCZdunRKSGlnlxEhhXb7A0S2cDXttoPFwOIS1kIru3H2zX0W+0Z3l0UQPOXl3nPePfe8yHvPMqIs3gX6wA7QDeUSGAMjnzcfV/pbgiiL7wAHwF1gBIypKQGwdANhH/gMXPi8ufpNEIZPgMIYfeNq2caQoiQACBMchbE6dU4eAynwwufNlQkvOQAKjA5cLY8QOigFMABASRD2XC0zrA5w0s6cRRzKLnBkjD4Nwz+2ruun+qX/ubyrPY6uzSvpodw0Vt85J6+BcxP2GrlatoNyNa/kSZTFrEJA+YrQCb0joG+COadh5wIh8Xnzig2IsvhwsSopyhg4FaBLTRkMm2waXMMEJQkX6poNDdOgtAnT9YIBSixdZMHs8+b93+SjLH6IMAnZKA2LhO3guETYs8fR5bySHvAFuIfwHQDHra0bOgRJcQwR7gNjwyJ1R8bqW1fLbF5Jb+mMZau8dMZZCNQz4LxN4nPgG0YH1PIAoQMU/DE1AVKUGVY/4GQfuO3z5qw18QI4wQnGrkR5H2ijPFyPMvyvz7Tm8j9951+Qy9eWUE15/AAAAABJRU5ErkJggg==""); }
			|.false { background-image: url(""data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAAB3RJTUUH3gcIDAcaKE212QAAAAd0RVh0QXV0aG9yAKmuzEgAAAAMdEVYdERlc2NyaXB0aW9uABMJISMAAAAKdEVYdENvcHlyaWdodACsD8w6AAAADnRFWHRDcmVhdGlvbiB0aW1lADX3DwkAAAAJdEVYdFNvZnR3YXJlAF1w/zoAAAALdEVYdERpc2NsYWltZXIAt8C0jwAAAAh0RVh0V2FybmluZwDAG+aHAAAAB3RFWHRTb3VyY2UA9f+D6wAAAAh0RVh0Q29tbWVudAD2zJa/AAAABnRFWHRUaXRsZQCo7tInAAACBUlEQVQ4ja2TsWtTURTGf/fm3ZcSClZBl1BDX/IGiWNX0wh26B/QUaQgpX9BN6V07F9QROigW0cHkQ5Gu2YNgi99+ihxsIMRpLzcE+91yEuNWgTBbzz3fOd+55zvKO89s0hUbUVj2sAySDyJmgToOqQT++zNbL6aFjhRtUVgA8wtBx2NdL/hE4B5VOwwyxraIO+Ag7rPTi8KnKjaosNsg/RCwmfnjGohYRMkKhSkFturUM4s9j6Ypkb26j47DQolGyC9OdThOXYtRFWBnoNDAA1RiFrNsYMK6jBHCg676j03VzRmK0A9zLFrGvN1ge9vr/sPo9lez9RSeUip5ZArc4Qvx/inDtkPNKbtoDORrapjJB9iHgxVg19RwiGfAqieM6oFhB2Naas+9RcgO2Ai4IuDKPb9J1yCRDU2NaTAVZAUzI4GiSfTlsgh6WXEWUxyJCo4cfBnimSJamxeTpfs90gAJplHYjCphqju+6/+puBENe4BacFJAqDrMMtj7HGIWj1TS8dDSi2Qjxpua8IzAItduIY+Ate0+KOA8I6GbuCQjsZsVSg/z7GDIaXWZI3ZCEimP/9coxtUKGdj/COH7E+d+NjB54mR/N0AqmB606FqTATSHMOggnqd49c13Kj7bHc6xAMw2znC3IWVaWpYL95Tiz+qUM7ywsoge/C/jmkW/3rOPwBzWQNrm2r0hAAAAABJRU5ErkJggg==""); }
			|</style>
			|%1
			|</body>
			|</html>",
			HTMLПредставлениеРезолюций);
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет возможность подписания резолюции для текущего пользователя.
//
// Параметры:
//  Резолюция - ссылка или объект справочника Резолюции.
//
// Возвращаемое значение:
//  Булево
//
Функция ПроверитьДоступНаПодписание(Резолюция) Экспорт
	
	Если ТипЗнч(Резолюция) = Тип("СправочникСсылка.Резолюции")
		Или ТипЗнч(Резолюция) = Тип("СправочникОбъект.Резолюции") Тогда
		ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
		// Подписать резолюцию может только автор либо внесший резолюцию.
		Возврат
			Резолюция.ВнесРезолюцию = ТекущийПользователь
			Или Резолюция.АвторРезолюции = ТекущийПользователь;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Устанавливает / снимает пометку на удаление на резолюцию.
//
// Возвращаемое значение:
//  Истина, если установка пометки прошла успешно.
//
Функция УстановитьПометкуНаУдаление(Резолюция, ЗначениеПометкиУдаления) Экспорт

	Попытка
		ОбъектРезолюции = Резолюция.Ссылка.ПолучитьОбъект();
		ОбъектРезолюции.Заблокировать();
	Исключение
		Возврат Ложь;
	КонецПопытки;
		
	ОбъектРезолюции.УстановитьПометкуУдаления(ЗначениеПометкиУдаления);
	ОбъектРезолюции.Разблокировать();
	
	Возврат Истина;
	
КонецФункции

// Определяет, является ли пользователем автором либо внесшим резолюцию.
//
// Параметры:
//  Резолюция - ссылка на справочник Резолюции
//  Пользователь - ссылка на справочник Пользователи - если не задан, то проверяется текущий
//                 пользователь.
//
// Возвращаемое значение:
//  Булево.
//
Функция ЭтоАвторРезолюции(Резолюция, Пользователь = Неопределено) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	
	Возврат Пользователи.ЭтоПолноправныйПользователь()
		Или Пользователь = Резолюция.АвторРезолюции
		Или Пользователь = Резолюция.ВнесРезолюцию;
		
КонецФункции

#КонецОбласти
