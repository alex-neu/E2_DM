#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ВыгружатьСразу Тогда
		ДатаНачала = Параметры.ДатаНачала;
		ДатаОкончания = Параметры.ДатаОкончания;
		СпособВыгрузки = Параметры.СпособВыгрузки;
		Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СпособВыгрузки) Тогда
		СпособВыгрузки = Перечисления.СпособыВыгрузкиОбращений.ВФайл;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.ВыгружатьСразу Тогда
		Отказ = Истина;
		Выгрузить(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКоманд

&НаКлиенте
Процедура Выгрузить(Команда)
	
	АдресРезультата = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("АдресРезультата", АдресРезультата);
	ПараметрыВыгрузки.Вставить("ДатаНачала", ДатаНачала);
	ПараметрыВыгрузки.Вставить("ДатаОкончания", ДатаОкончания);
	ПараметрыВыгрузки.Вставить("СпособВыгрузки", СпособВыгрузки);
	ПараметрыВыгрузки.Вставить("ИдентификаторФормы", УникальныйИдентификатор);
	ПараметрыВыгрузки.Вставить("Организация", Организация);
	
	НачатьВыгрузку(ПараметрыВыгрузки);
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если Результат.Успешно Тогда
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыгрузитьЗавершение",
			ЭтаФорма,
			Результат);
			
		Если СпособВыгрузки = ПредопределенноеЗначение("Перечисление.СпособыВыгрузкиОбращений.ВФайл") Тогда
			
			ИмяФайлаБезРасширения = СтрШаблон(
				НСтр("ru = 'Выгрузка %1 от %2'"),
				Формат(Результат.Номер, "ЧГ=0"),
				Формат(Результат.Дата, "ДФ='дд.ММ.гггг'"));
			РасширениеБезТочки = "zip";
			ИмяФайлаПоУмолчанию = ИмяФайлаБезРасширения + "." + РасширениеБезТочки;
			
			СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией");
			
			СведенияОФайле.ИмяБезРасширения = ИмяФайлаБезРасширения;
			СведенияОФайле.АдресВременногоХранилищаФайла = Результат.АдресФайла;
			
			СведенияОФайле.РасширениеБезТочки = РасширениеБезТочки;
			СведенияОФайле.ВремяИзменения = Результат.Дата;
			СведенияОФайле.ВремяИзмененияУниверсальное = ТекущаяДата();
			СведенияОФайле.Автор = ПользователиКлиентСервер.ТекущийПользователь();
			
			РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(Результат.Документ, СведенияОФайле);
			
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(ИмяФайлаПоУмолчанию, Результат.АдресФайла);
			ПолучаемыеФайлы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОписаниеФайла);
			ДиалогВыбораФайлов = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
			ДиалогВыбораФайлов.ПолноеИмяФайла = ИмяФайлаПоУмолчанию;
			ДиалогВыбораФайлов.Фильтр = "*.zip|*.zip";
			ДиалогВыбораФайлов.Заголовок = НСтр("ru = 'Выберите папку для сохранения файла'");
			НачатьПолучениеФайлов(ОписаниеОповещения, ПолучаемыеФайлы, ДиалогВыбораФайлов, Истина);
			
		Иначе
			
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, Результат);
			
		КонецЕсли;
		
	Иначе
		
		Если Результат.ПроблемныеОбъекты.Количество() <> 0 Тогда
			ПараметрыФормы = Новый Структура("ПроблемныеОбъекты", Результат.ПроблемныеОбъекты);
			ОткрытьФорму("Обработка.ВыгрузкаВССТУ.Форма.ПроблемныеОбъекты",
				ПараметрыФормы,,,,,,
				РежимОткрытияОкнаФормы.Независимый);
		ИначеЕсли ЗначениеЗаполнено(Результат.Сообщение) Тогда
			ПоказатьПредупреждение(, Результат.Сообщение);
		Иначе
			ПоказатьПредупреждение(, НСтр("ru = 'Выгрузить не удалось.'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыгрузитьЗавершение(Результат, ПараметрыВыгрузки) Экспорт
	
	Если Результат <> Неопределено Тогда
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура НачатьВыгрузку(ПараметрыВыгрузки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Истина);
	Результат.Вставить("Сообщение", "");
	Результат.Вставить("ВыгруженныеОбращения", Новый Массив);
	Результат.Вставить("ВыгруженныеФайлы", Новый Массив);
	Результат.Вставить("ПроблемныеОбъекты", Новый Массив);
	
	Документ = Документы.ВыгрузкаВССТУ.СоздатьДокумент();
	Документ.Дата = ТекущаяДатаСеанса();
	Документ.Ответственный = ПользователиКлиентСервер.ТекущийПользователь();
	ЗаполнитьЗначенияСвойств(Документ, ПараметрыВыгрузки);
	
	НашаОрганизация = ПараметрыВыгрузки.Организация;
	ИдентификаторОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НашаОрганизация, "ИдентификаторССТУ");
	
	Если Не ЗначениеЗаполнено(ИдентификаторОрганизации) Тогда
		Результат.Успешно = Ложь;
		Результат.Сообщение = НСтр(
			"ru = 'Не заполнен идентификатор организации (учреждения).
			|Заполнить его можно в карточке ""Организации""'");
		ПоместитьВоВременноеХранилище(Результат, ПараметрыВыгрузки.АдресРезультата);
		Возврат;
	КонецЕсли;
		
	ПараметрыВыгрузки.Вставить("ИдентификаторОргана", ИдентификаторОрганизации);
	
	Если ПараметрыВыгрузки.СпособВыгрузки = Перечисления.СпособыВыгрузкиОбращений.ВФайл Тогда
		ИмяZipФайла = ПолучитьИмяВременногоФайла("zip");
		ЗаписьZipФайла = Новый ЗаписьZipФайла(ИмяZipФайла);
	КонецЕсли;
	
	ФайлыJSONКУдалению = Новый Массив;
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ОбращенияВопросы.Ссылка КАК Документ
		|ИЗ
		|	Справочник.ВходящиеДокументы.ВопросыОбращения КАК ОбращенияВопросы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыВходящихДокументов КАК ВидыВходящихДокументов
		|		ПО ОбращенияВопросы.Ссылка.ВидДокумента = ВидыВходящихДокументов.Ссылка
		|ГДЕ
		|	ВидыВходящихДокументов.ЯвляетсяОбращениемОтГраждан
		|	И НЕ ОбращенияВопросы.Ссылка.ПометкаУдаления
		|	И ОбращенияВопросы.Ссылка.ДатаРегистрации > ДАТАВРЕМЯ(1, 1, 1)
		|	И (ОбращенияВопросы.Ссылка.ДатаРегистрации МЕЖДУ &ДатаНачала И &ДатаОкончания
		|			ИЛИ ОбращенияВопросы.ДатаОтвета МЕЖДУ &ДатаНачала И &ДатаОкончания)
		|	%1");
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьУчетПоОрганизациям") Тогда 
		Запрос.Текст = СтрШаблон(Запрос.Текст,
			"И ОбращенияВопросы.Ссылка.Организация = &Организация");
		Запрос.УстановитьПараметр("Организация", ПараметрыВыгрузки.Организация);
	Иначе 
		Запрос.Текст = СтрШаблон(Запрос.Текст, "");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ДатаНачала", ПараметрыВыгрузки.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(ПараметрыВыгрузки.ДатаОкончания));
	Обращения = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрОбращение Из Обращения Цикл
		Обращение = СтрОбращение.Документ;
		РезультатЗаписиJSON = ЗаписатьОбращениеВJSON(Обращение, ПараметрыВыгрузки);
		Если РезультатЗаписиJSON.Успешно Тогда
			Если ПараметрыВыгрузки.СпособВыгрузки = Перечисления.СпособыВыгрузкиОбращений.ВФайл Тогда
				ЗаписьZipФайла.Добавить(РезультатЗаписиJSON.ИмяФайла);
				ФайлыJSONКУдалению.Добавить(РезультатЗаписиJSON.ИмяФайла);
			
			КонецЕсли;
			Результат.ВыгруженныеОбращения.Добавить(Обращение);
			ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Результат.ВыгруженныеФайлы,
				РезультатЗаписиJSON.ВыгруженныеФайлы);
			СтрокаДокумента = Документ.Обращения.Добавить();
			СтрокаДокумента.Обращение = Обращение;
		Иначе
			Результат.Успешно = Ложь;
			Результат.Сообщение = РезультатЗаписиJSON.Сообщение;
			Если ЗначениеЗаполнено(РезультатЗаписиJSON.ПроблемныйОбъект) Тогда
				ПроблемныйОбъект = Новый Структура;
				ПроблемныйОбъект.Вставить("Объект", РезультатЗаписиJSON.ПроблемныйОбъект);
				ПроблемныйОбъект.Вставить("Сообщение", РезультатЗаписиJSON.СообщениеПроблемногоОбъекта);
				Результат.ПроблемныеОбъекты.Добавить(ПроблемныйОбъект);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Результат.Успешно Тогда
		Документ.УстановитьНовыйНомер();
		Документ.Записать(РежимЗаписиДокумента.Запись);
		Результат.Вставить("Документ", Документ.Ссылка);
		Результат.Вставить("Дата", Документ.Дата);
		Результат.Вставить("Номер", Документ.Номер);
		Если ПараметрыВыгрузки.СпособВыгрузки = Перечисления.СпособыВыгрузкиОбращений.ВФайл Тогда
			ЗаписьZipФайла.Записать();
			ДвоичныеДанные = Новый ДвоичныеДанные(ИмяZipФайла);
			АдресФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные,
				ПараметрыВыгрузки.ИдентификаторФормы);
			Результат.Вставить("АдресФайла", АдресФайла);
			Результат.Вставить("ИмяФайла", ИмяZipФайла);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого ФайлJSONКУдалению Из ФайлыJSONКУдалению Цикл
		УдалитьФайлы(ФайлJSONКУдалению);
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Результат, ПараметрыВыгрузки.АдресРезультата);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаписатьОбращениеВJSON(Обращение, ПараметрыВыгрузки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Истина);
	Результат.Вставить("Сообщение", "");
	Результат.Вставить("ИмяФайла", ПолучитьИмяВременногоФайла("json"));
	Результат.Вставить("ВыгруженныеФайлы", Новый Массив);
	Результат.Вставить("ПроблемныйОбъект", Неопределено);
	Результат.Вставить("СообщениеПроблемногоОбъекта", "");
	
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.ОткрытьФайл(Результат.ИмяФайла);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Обращение,
		"ДатаРегистрации, РегистрационныйНомер, 
		|ДатаСоздания, ИсходящийНомер,
		|Отправитель, СрокИсполненияПервоначальный, СрокИсполнения,
		|ВопросыОбращения");
	
	Вопросы = Реквизиты.ВопросыОбращения.Выгрузить();
	
	ЗаписьJSON.ЗаписатьНачалоОбъекта();
	
	ЗаписьJSON.ЗаписатьИмяСвойства("departmentId");
	ЗаписьJSON.ЗаписатьЗначение(ПараметрыВыгрузки.ИдентификаторОргана);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("isDirect");
	// Если обращение не направлено из иного органа, то значит обращение поступило напрямую непосредственно от заявителя
	Если ЗначениеЗаполнено(Реквизиты.ИсходящийНомер) Тогда 
		ЗаписьJSON.ЗаписатьЗначение(Ложь);
	Иначе 
		ЗаписьJSON.ЗаписатьЗначение(Истина);
	КонецЕсли;
	
	ЗаписьJSON.ЗаписатьИмяСвойства("format");
	ЗаписьJSON.ЗаписатьЗначение("Other");
	
	ЗаписьJSON.ЗаписатьИмяСвойства("number");
	ЗаписьJSON.ЗаписатьЗначение(Реквизиты.РегистрационныйНомер);
	
	ЗаписьJSON.ЗаписатьИмяСвойства("createDate");
	ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
	
	ЗаписьJSON.ЗаписатьИмяСвойства("name");
	ЗаписьJSON.ЗаписатьЗначение(Строка(Реквизиты.Отправитель));
	
	Если ЗначениеЗаполнено(Реквизиты.Отправитель) Тогда 
		ДанныеОтправителя = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Реквизиты.Отправитель, "ЮрФизЛицо, ФизЛицо");
		Если ДанныеОтправителя.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда 
			Емайл = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				ДанныеОтправителя.ФизЛицо,
				Справочники.ВидыКонтактнойИнформации.EmailФизическогоЛица,,
				ТекущаяДатаСеанса());
			ПочтовыйАдрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				ДанныеОтправителя.ФизЛицо,
				Справочники.ВидыКонтактнойИнформации.ДомашнийАдресФизическогоЛица,,
				ТекущаяДатаСеанса());
		Иначе 
			Емайл = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				Реквизиты.Отправитель,
				Справочники.ВидыКонтактнойИнформации.EmailКонтрагента,,
				ТекущаяДатаСеанса());
			ПочтовыйАдрес = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформацииОбъекта(
				Реквизиты.Отправитель,
				Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента,,
				ТекущаяДатаСеанса());
		КонецЕсли;
	КонецЕсли;
	
	ЗаписьJSON.ЗаписатьИмяСвойства("address");
	ЗаписьJSON.ЗаписатьЗначение(Строка(ПочтовыйАдрес));
	
	ЗаписьJSON.ЗаписатьИмяСвойства("Email");
	ЗаписьJSON.ЗаписатьЗначение(Строка(Емайл));
	
	ЗаписьJSON.ЗаписатьИмяСвойства("questions");
	ЗаписьJSON.ЗаписатьНачалоМассива();
	
	РезультатыСФайлами = Новый Массив;
	РезультатыСФайлами.Добавить(Перечисления.РезультатыРассмотренияОбращений.Поддержано);
	РезультатыСФайлами.Добавить(Перечисления.РезультатыРассмотренияОбращений.ВТомЧислеМерыПриняты);
	РезультатыСФайлами.Добавить(Перечисления.РезультатыРассмотренияОбращений.Разъяснено);
	РезультатыСФайлами.Добавить(Перечисления.РезультатыРассмотренияОбращений.НеПоддержано);
	
	СвязанныеДокументы = Новый ТаблицаЗначений;
	СвязанныеДокументы.Колонки.Добавить("СопроводительныйДокумент");
	СвязанныеДокументы.Колонки.Добавить("Вопрос");
	СвязанныеДокументы.Колонки.Добавить("СопроводительныйДокументСтрока");
	СвязанныеДокументы.Колонки.Добавить("РегистрационныйНомер");
	СвязанныеДокументы.Колонки.Добавить("ДатаРегистрации");
	СвязанныеДокументы.Колонки.Добавить("ОтветныйДокумент");
	СвязанныеДокументы.Колонки.Добавить("ОтветныйДокументСтрока");
	СвязанныеДокументы.Колонки.Добавить("ОтветныйРегистрационныйНомер");
	СвязанныеДокументы.Колонки.Добавить("ОтветныйДатаРегистрации");
	
	РаботаСОбращениямиВызовСервера.ЗаполнитьСвязанныеДокументы(
		Обращение, СвязанныеДокументы);
	
	Для Каждого Вопрос Из Вопросы Цикл
		
		ЗаписьJSON.ЗаписатьНачалоОбъекта();
		
		ЗаписьJSON.ЗаписатьИмяСвойства("code");
		КодРазделаСтрокой = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вопрос.Раздел, "Код");
		КодТематикиСтрокой = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вопрос.Тематика, "Код");
		КодТемыСтрокой = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вопрос.Тема, "Код");
		КодВопросаСтрокой = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вопрос.Вопрос, "Код");
		ПолныйКодВопроса = СтрШаблон("%1.%2.%3.%4",
			?(ЗначениеЗаполнено(КодРазделаСтрокой), КодРазделаСтрокой, "0000"),
			?(ЗначениеЗаполнено(КодТематикиСтрокой), КодТематикиСтрокой, "0000"),
			?(ЗначениеЗаполнено(КодТемыСтрокой), КодТемыСтрокой, "0000"),
			?(ЗначениеЗаполнено(КодВопросаСтрокой), КодВопросаСтрокой, "0000"));
		ЗаписьJSON.ЗаписатьЗначение(ПолныйКодВопроса);
		
		ЗаписьJSON.ЗаписатьИмяСвойства("status");
		
		Если Вопрос.РезультатРассмотрения = 
			Перечисления.РезультатыРассмотренияОбращений.Поддержано Тогда
			
			ЗаписьJSON.ЗаписатьЗначение("Supported");
			
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("actionsTaken");
			ЗаписьJSON.ЗаписатьЗначение(Ложь);
			ЗаписьJSON.ЗаписатьИмяСвойства("responseDate"); 
			ЗаписьJSON.ЗаписатьЗначение(Формат(Вопрос.ДатаОтвета, "ДФ=гггг-ММ-дд"));
			
		ИначеЕсли Вопрос.РезультатРассмотрения = 
			Перечисления.РезультатыРассмотренияОбращений.ВТомЧислеМерыПриняты Тогда
			
			ЗаписьJSON.ЗаписатьЗначение("Supported");
			
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("actionsTaken");
			ЗаписьJSON.ЗаписатьЗначение(Истина);
			ЗаписьJSON.ЗаписатьИмяСвойства("responseDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Вопрос.ДатаОтвета, "ДФ=гггг-ММ-дд"));
			
		ИначеЕсли Вопрос.РезультатРассмотрения = 
			Перечисления.РезультатыРассмотренияОбращений.Разъяснено Тогда
			
			ЗаписьJSON.ЗаписатьЗначение("Explained");
			
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("responseDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Вопрос.ДатаОтвета, "ДФ=гггг-ММ-дд"));
			
		ИначеЕсли Вопрос.РезультатРассмотрения = 
			Перечисления.РезультатыРассмотренияОбращений.НеПоддержано Тогда
			
			ЗаписьJSON.ЗаписатьЗначение("NotSupported");
			
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("responseDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Вопрос.ДатаОтвета, "ДФ=гггг-ММ-дд"));
			
		ИначеЕсли Вопрос.РезультатРассмотрения = 
			Перечисления.РезультатыРассмотренияОбращений.ОставленоБезОтвета Тогда
			
			ЗаписьJSON.ЗаписатьЗначение("LeftWithoutAnswer");
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("responseDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Вопрос.ДатаОтвета, "ДФ=гггг-ММ-дд"));
			
		ИначеЕсли Не ЗначениеЗаполнено(Вопрос.РезультатРассмотрения) Тогда
			
			Если ЗначениеЗаполнено(Реквизиты.СрокИсполненияПервоначальный) 
				И ЗначениеЗаполнено(Реквизиты.СрокИсполнения) 
				И Реквизиты.СрокИсполнения > Реквизиты.СрокИсполненияПервоначальный Тогда 
				ЗаписьJSON.ЗаписатьЗначение("InWorkExtended");
			Иначе 
				ЗаписьJSON.ЗаписатьЗначение("InWork");
			КонецЕсли;
			
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			
		ИначеЕсли Вопрос.РезультатРассмотрения = 
			Перечисления.РезультатыРассмотренияОбращений.НаправленоВИнойОрган Тогда
			
			ЗаписьJSON.ЗаписатьЗначение("Transferred");
			ЗаписьJSON.ЗаписатьИмяСвойства("incomingDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаСоздания, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("registrationDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(Реквизиты.ДатаРегистрации, "ДФ=гггг-ММ-дд"));
			
			ЗаписьJSON.ЗаписатьИмяСвойства("transfer");
			ЗаписьJSON.ЗаписатьНачалоОбъекта();
			
			ЗаписьJSON.ЗаписатьИмяСвойства("departmentId");
			
			Если Не ЗначениеЗаполнено(Вопрос.ОрганДляПередачи) Тогда 
				Результат.Успешно = Ложь;
				Результат.Сообщение = НСтр("ru = 'Не указан орган (учреждение), в который перенаправлено обращение.'");
				Результат.ПроблемныйОбъект = Обращение;
				Результат.СообщениеПроблемногоОбъекта = Результат.Сообщение;
			Иначе
				ИдентификаторОргана = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Вопрос.ОрганДляПередачи,
				"ИдентификаторССТУ");
			
				Если Не ЗначениеЗаполнено(ИдентификаторОргана) Тогда 
					Результат.Успешно = Ложь;
					Результат.Сообщение = НСтр("ru = 'Не заполнен идентификатор органа (учреждения), в который перенаправлено обращение.'");
					Результат.ПроблемныйОбъект = Вопрос.ОрганДляПередачи;
					Результат.СообщениеПроблемногоОбъекта = Результат.Сообщение;
					
				КонецЕсли;
			КонецЕсли;
			
			ИсходящаяДатаДокумента = Дата(1, 1, 1); ИсходящийНомерДокумента = "";
			СтрокиСопроводительные = СвязанныеДокументы.НайтиСтроки(
				Новый Структура("Вопрос", Вопрос.Вопрос));
			Если СтрокиСопроводительные.Количество() > 0 Тогда 
				ИсходящаяДатаДокумента = СтрокиСопроводительные[0].ДатаРегистрации;
				ИсходящийНомерДокумента = СтрокиСопроводительные[0].РегистрационныйНомер;
			Иначе 
				Результат.Успешно = Ложь;
				Результат.Сообщение = НСтр("ru = 'Не найден сопроводительный документ.'");
				Результат.ПроблемныйОбъект = Обращение;
				Результат.СообщениеПроблемногоОбъекта = Результат.Сообщение;
			КонецЕсли;
			
			ЗаписьJSON.ЗаписатьЗначение(ИдентификаторОргана);
			ЗаписьJSON.ЗаписатьИмяСвойства("transferDate");
			ЗаписьJSON.ЗаписатьЗначение(Формат(ИсходящаяДатаДокумента, "ДФ=гггг-ММ-дд"));
			ЗаписьJSON.ЗаписатьИмяСвойства("transferNumber");
			ЗаписьJSON.ЗаписатьЗначение(ИсходящийНомерДокумента);
			
			ЗаписьJSON.ЗаписатьКонецОбъекта();
			
		Иначе
			
			ЗаписьJSON.ЗаписатьЗначение("NotReceived");
			
		КонецЕсли;
		
		Если РезультатыСФайлами.Найти(Вопрос.РезультатРассмотрения) <> Неопределено Тогда
			ОтветныйДокумент = Неопределено;
			СтрокиОтветные = СвязанныеДокументы.НайтиСтроки(
				Новый Структура("Вопрос", Вопрос.Вопрос));
			Если СтрокиОтветные.Количество() > 0 Тогда 
				ОтветныйДокумент = СтрокиОтветные[0].ОтветныйДокумент;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ОтветныйДокумент) Тогда 
				РезультатЗаписиФайла = ЗаписатьФайл(ЗаписьJSON, ОтветныйДокумент, ПараметрыВыгрузки);
				Если РезультатЗаписиФайла.Успешно Тогда
					Если РезультатЗаписиФайла.Файл <> Неопределено Тогда
						Результат.ВыгруженныеФайлы.Добавить(РезультатЗаписиФайла.Файл);
					КонецЕсли;
				Иначе
					Результат.Успешно = Ложь;
					Результат.Сообщение = РезультатЗаписиФайла.Сообщение;
					Результат.ПроблемныйОбъект = РезультатЗаписиФайла.ПроблемныйОбъект;
					Результат.СообщениеПроблемногоОбъекта = РезультатЗаписиФайла.СообщениеПроблемногоОбъекта;
				КонецЕсли;
			Иначе
				Результат.Успешно = Ложь;
				Результат.Сообщение = СтрШаблон(НСтр("ru = 'Нет ответного документа по вопросу ""%1""'"), Вопрос.Вопрос);
				Результат.ПроблемныйОбъект = Обращение;
				Результат.СообщениеПроблемногоОбъекта = Результат.Сообщение;
			КонецЕсли;
		КонецЕсли;
		
		ЗаписьJSON.ЗаписатьКонецОбъекта();
		
	КонецЦикла;
	
	ЗаписьJSON.ЗаписатьКонецМассива();
	
	ЗаписьJSON.ЗаписатьКонецОбъекта();
	
	ЗаписьJSON.Закрыть();
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаписатьФайл(ЗаписьJSON, ОтветныйДокумент, ПараметрыВыгрузки)
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Структура;
	Результат.Вставить("Успешно", Истина);
	Результат.Вставить("Сообщение", "");
	Результат.Вставить("ПроблемныйОбъект", Неопределено);
	Результат.Вставить("СообщениеПроблемногоОбъекта", "");
	Результат.Вставить("Файл", Неопределено);
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Файлы.Ссылка КАК Ссылка,
		|	Файлы.ПолноеНаименование КАК ПолноеНаименование,
		|	Файлы.ТекущаяВерсияРасширение КАК ТекущаяВерсияРасширение
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|ГДЕ
		|	Файлы.ВладелецФайла = &ОтветныйДокумент
		|	И НЕ Файлы.ПометкаУдаления");
	Запрос.УстановитьПараметр("ОтветныйДокумент", ОтветныйДокумент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Результат.Вставить("Файл", Выборка.Ссылка);
		
		ЗаписьJSON.ЗаписатьИмяСвойства("attachment");
		ЗаписьJSON.ЗаписатьНачалоОбъекта();
		
		ЗаписьJSON.ЗаписатьИмяСвойства("name");
		ЗаписьJSON.ЗаписатьЗначение(СтрШаблон("%1.%2",
			Выборка.ПолноеНаименование,
			Выборка.ТекущаяВерсияРасширение));
		
		ЗаписьJSON.ЗаписатьИмяСвойства("content");
		ДвоичныеДанные = РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(Выборка.Ссылка);
		ЗаписьJSON.ЗаписатьЗначение(Base64Строка(ДвоичныеДанные));
		
		ЗаписьJSON.ЗаписатьКонецОбъекта();
		
		Возврат Результат;
		
	КонецЦикла;
	
	Если Выборка.Количество() = 0 Тогда
		Результат.Успешно = Ложь;
		Результат.ПроблемныйОбъект = ОтветныйДокумент;
		Результат.СообщениеПроблемногоОбъекта = НСтр("ru = 'Нет файлов'");
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти