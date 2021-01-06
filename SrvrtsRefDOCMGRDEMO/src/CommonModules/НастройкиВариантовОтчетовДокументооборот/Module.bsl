#Область СлужебныеПроцедурыИФункции

// Устанавливает пометку удаления для настройки варианта отчетов 
//
// Параметры
//   ИмяОтчета - Строка - Имя отчета, вариант которого нужно пометить на удаление
//   КлючВарианта - Строка - Название варианта отчета или уникальный идентификатор, который нужно пометить на удаление
//
Процедура УдалитьНастройкуВариантаОтчета(ИмяОтчета, КлючВарианта) Экспорт
	
	НастройкаВариантОтчета = ПолучитьНастройкуВариантаОтчета(ИмяОтчета, КлючВарианта);
	
	Если Не НастройкаВариантОтчета = Неопределено Тогда
		
		НастройкаОбъект = НастройкаВариантОтчета.ПолучитьОбъект();
		НастройкаОбъект.ДополнительныеСвойства.Вставить("ЗаполнениеПредопределенных", Истина);
		
		Попытка
			НастройкаОбъект.ПометкаУдаления = Истина;
			Если ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(НастройкаОбъект);
			Иначе
				НастройкаОбъект.Записать();
			КонецЕсли;
		Исключение
			Инфо = ИнформацияОбОшибке();
			ЗаписьЖурналаРегистрации(
				НСтр("ru = 'Ошибка установки пометки удаления'", Метаданные.ОсновнойЯзык.КодЯзыка),
				УровеньЖурналаРегистрации.Ошибка,НастройкаОбъект.Метаданные(),
				НастройкаОбъект.Ссылка,
				ПодробноеПредставлениеОшибки(Инфо));
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

// Находит настройку варианта отчета 
//
// Параметры
//   ИмяОтчета - Строка - Имя отчета, для которого нужно найти настройку
//   КлючВарианта - Строка - Название варианта отчета или уникальный идентификатор, по которому нужно найти настройку
//
// Возвращаемое значение:
//   НастройкиВариантовОтчетовДокументооборот.Ссылка - если найдено и Неопределено в противном случае.
//
Функция ПолучитьНастройкуВариантаОтчета(ИмяОтчета, КлючВарианта) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст ="ВЫБРАТЬ
	              |	НастройкиВариантовОтчетовДокументооборот.Ссылка
	              |ИЗ
	              |	Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
	              |ГДЕ
	              |	НастройкиВариантовОтчетовДокументооборот.КлючВарианта = &КлючВарианта
	              |	И НастройкиВариантовОтчетовДокументооборот.Отчет.Имя = &Отчет
	              |	И НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления";
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	Запрос.УстановитьПараметр("Отчет", ИмяОтчета);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка =Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);

	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

//Установка категорий и разделов для "Настройки варианта отчета".
//
// Параметры
//   ОбъектНастройкаВариантаОтчет -  объект "НастройкиВариантовОтчетовДокументооборот"
//   СписокКатегорий - список значений
//   СписокРазделов - список значений
//
Процедура УстановитьКатегорииИРазделы(ОбъектНастройкаВариантаОтчет, СписокКатегорий, СписокРазделов) Экспорт
	
	ОбъектНастройкаВариантаОтчет.Категории.Очистить();
	Если НЕ СписокКатегорий.Количество() = 0 Тогда
		
		Для Каждого Категория из СписокКатегорий Цикл
			НоваяСтрока = ОбъектНастройкаВариантаОтчет.Категории.Добавить();
			НоваяСтрока.Категория = Категория.Значение;
		КонецЦикла;
		
	Иначе
		// Если отчету не задано ни одной категории, то добавляем его в категорию "БезКатегории"
		НоваяСтрока = ОбъектНастройкаВариантаОтчет.Категории.Добавить();
		НоваяСтрока.Категория = Справочники.КатегорииОтчетов.БезКатегории;
	КонецЕсли;
	
	Если НЕ СписокРазделов.Количество() = 0 Тогда
		
		ОбъектНастройкаВариантаОтчет.Размещение.Очистить();
		
		Для Каждого Раздел из СписокРазделов Цикл
			НоваяСтрокаРаздел = ОбъектНастройкаВариантаОтчет.Размещение.Добавить();
			НоваяСтрокаРаздел.Раздел = Раздел.Значение;
		КонецЦикла;
		
	КонецЕсли;

Конецпроцедуры

//Обработчик события при записи варианта отчетов.
//Создает элемент справочника "НастройкиВариантовОтчетовДокументооборот" 
//при записи нового элемента в справочнике "ВариантыОтчетов" 
//
// Параметры
//   Источник - СправочникОбъект.ВариантыОтчетов
//   Отказ -булево
//
Процедура ВариантОтчетаПриЗаписиПриЗаписи(Источник, Отказ) Экспорт
	
	Если МиграцияПриложенийПереопределяемый.ЭтоЗагрузка(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Отчет = Источник.Отчет;
	КлючВарианта = Источник.КлючВарианта;
	
	//Ищем ключ варианта отчета, из которого нужно скопировать настройки.
	//Этот вариант отчета имеет ключ заданный в конфигураторе и соотвествует ключу из родителя верхнего уровня. 
	ПрототипВариантаОтчета = Источник;
	Пока НЕ ПрототипВариантаОтчета.Родитель.Пустая() Цикл
		ПрототипВариантаОтчета = ПрототипВариантаОтчета.Родитель;
	КонецЦикла;
	КлючВариантаПрототип = ПрототипВариантаОтчета.КлючВарианта;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст ="ВЫБРАТЬ
			|	НастройкиВариантовОтчетовДокументооборот.Ссылка
			|ИЗ
			|	Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
			|ГДЕ
			|	НастройкиВариантовОтчетовДокументооборот.КлючВарианта = &КлючВарианта
			|	И НастройкиВариантовОтчетовДокументооборот.Отчет = &Отчет
			|	И НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Отчет", Отчет);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Запрос.Выполнить().Выбрать();
	
	Если Источник.ПометкаУдаления Тогда
		// Удаление варианта отчета БСП, удаляем и в НастройкиВариантовОтчетовДокументооборот.
		Если Результат.Следующий() Тогда
			Настройка = Результат.Ссылка.ПолучитьОбъект();
			Настройка.ДополнительныеСвойства.Вставить("ЗаполнениеПредопределенных", Истина);
			Настройка.ПометкаУдаления = Истина;
			Настройка.Записать();
		КонецЕсли;
		
	Иначе
		// Добавление или изменение имеющегося варианта отчета.
		Если Результат.Следующий() Тогда
			Настройка = Результат.Ссылка.ПолучитьОбъект();
		Иначе
			
			Настройка = Справочники.НастройкиВариантовОтчетовДокументооборот.СоздатьЭлемент();
			Настройка.Отчет = Отчет;
			Настройка.КлючВарианта = КлючВарианта;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КлючВариантаПрототип) Тогда
			ЗаполнитьВариантОтчетаПоПрототипу(Настройка, Отчет, КлючВариантаПрототип);
		КонецЕсли;
		
		Настройка.Наименование = Источник.Наименование;
		Настройка.Пользовательский = Источник.Пользовательский;
		Настройка.Автор = Источник.Автор;
		Настройка.ТолькоДляАвтора = Источник.ТолькоДляАвтора;
		
		Настройка.Записать();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

//Заполняет настройку варианта отчета по найденному прототипу настройки.
//
// Параметры
//   Настройка - СправочникОбъект.НастройкиВариантовОтчетовДокументооборот
//   Отчет - строковое название отчета прототипа
//   КлючВарианта - строковое название варианта отчета прототипа
//
Процедура ЗаполнитьВариантОтчетаПоПрототипу(Настройка, Отчет, КлючВарианта)
	
	Запрос = Новый Запрос;
	
	Запрос.Текст ="ВЫБРАТЬ
			|	НастройкиВариантовОтчетовДокументооборот.Ссылка Как Прототип
			|ИЗ
			|	Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
			|ГДЕ
			|	НастройкиВариантовОтчетовДокументооборот.КлючВарианта = &КлючВарианта
			|	И НастройкиВариантовОтчетовДокументооборот.Отчет = &Отчет
			|	И НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления";

	Запрос.УстановитьПараметр("Отчет", Отчет);
	Запрос.УстановитьПараметр("КлючВарианта", КлючВарианта);
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Следующий() Тогда
		
		Тч = Результат.Прототип.Размещение.Выгрузить();
		Настройка.Размещение.Загрузить(Тч);
		
		Тч = Результат.Прототип.Категории.Выгрузить();
		Настройка.Категории.Загрузить(Тч);
		
		Настройка.ХранилищеСнимокОтчета = Результат.Прототип.ХранилищеСнимокОтчета;
		
	КонецЕсли;
	
КонецПроцедуры

// Находит элемент справочника "ИдентификаторыОбъектовМетаданных"соответствующий параметру "ИмяРаздела" 
//
// Параметры
//   ИмяРаздела - Строка - Имя раздела конфигурации
//
// Возвращаемое значение:
//   Справочники.ИдентификаторыОбъектовМетаданных - Найденный элемент справочника.
//
Функция ПолучитьРазделОтчетаПоИмени(ИмяРаздела) Экспорт
	
	Возврат ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.Подсистемы[ИмяРаздела]);
	
КонецФункции

// Процедура устанавливает категории и разделы для отчетов, у которых не определен метод  "ЗаполнитьСписокКатегорийИРазделовОтчета".
// Например, для отчетов БСП(на поддержке) или для не типовых отчетов(по умолчанию получать категорию "БезКатегории").
//
// Параметры
//   НастройкаВариантаОтчета -  объект "НастройкиВариантовОтчетовДокументооборот"
//
Процедура ЗаполнитьКатегорииИРазделыИсключения(НастройкаВариантаОтчета)
	
	Если ТипЗнч(НастройкаВариантаОтчета.Отчет) = Тип("Строка") Тогда
		ИмяОтчета = Строка(НастройкаВариантаОтчета.Отчет);
	Иначе
		ИмяОтчета = НастройкаВариантаОтчета.Отчет.Имя;
	КонецЕсли;
	
	НастройкаВариантаОтчета.Категории.Очистить();

	Если ИмяОтчета = "ДействующиеСогласияНаОбработкуПерсональныхДанных" 
		Или ИмяОтчета = "ИстекающиеСогласияНаОбработкуПерсональныхДанных" Тогда
		
		Новаястрока = НастройкаВариантаОтчета.Категории.Добавить();
		НоваяСтрока.Категория = Справочники.КатегорииОтчетов.ПерсональныеДанные;
	Иначе
		Новаястрока = НастройкаВариантаОтчета.Категории.Добавить();
		НоваяСтрока.Категория = Справочники.КатегорииОтчетов.БезКатегории;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииНастройкаВариантовОтчетовДокументооборотПриОбновленииИБ

// Заполняет настройки отчетов по умолчанию
//Вызывается при обновлении ИБ
//
// Параметры
//   ОбновлятьПринудительно - Булево - Принудительное обновление настроек вариантов отчета. 
//    Позволяет заменить пользовательские настройки на типовые.
//
Процедура ЗаполнитьНастройкиВариантовОтчетовДокументооборот(ОбновлятьПринудительно = Ложь) Экспорт 
	
	УдалитьУстаревшиеНастройкиВариантовОтчетов();
	
	Типы = Новый ОписаниеТипов("Строка");
	
	Массив = Новый Массив();
	Массив.Добавить("Строка");
	Массив.Добавить("СправочникСсылка.ИдентификаторыОбъектовМетаданных");
	
	ТипОтчет = Новый ОписаниеТипов(Массив);
	
	Дерево = Новый ДеревоЗначений();
	Дерево.Колонки.Добавить("Синоним", Типы);
	Дерево.Колонки.Добавить("Ключ", Типы);
	Дерево.Колонки.Добавить("Пользовательский", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Автор", Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	Дерево.Колонки.Добавить("ТолькоДляАвтора", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Разделы", Новый ОписаниеТипов("СписокЗначений"));

	Дерево.Колонки.Добавить("Отчет", ТипОтчет);
	
	Дерево.Строки.Очистить();
	
	ТекстЗапроса ="ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
			|	ВариантыОтчетов.Наименование КАК Наименование,
			|	ВариантыОтчетов.КлючВарианта,
			|	НЕ ВариантыОтчетов.Пользовательский КАК Предопределенный,
			|	ВариантыОтчетов.Отчет,
			|	ВариантыОтчетов.Автор,
			|	ВариантыОтчетов.ТолькоДляАвтора
			|ИЗ
			|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиВариантовОтчетов КАК НастройкиВариантовОтчетов
			|		ПО (НастройкиВариантовОтчетов.Вариант = ВариантыОтчетов.Ссылка)
			|ГДЕ
			|	ВариантыОтчетов.Отчет = &ИдентификаторОтчета
			|	И НЕ ВариантыОтчетов.ПометкаУдаления
			|
			|УПОРЯДОЧИТЬ ПО
			|	Предопределенный УБЫВ,
			|	Наименование";
	
	ЗапросПоВариантам = Новый Запрос;
	ЗапросПоВариантам.Текст = ТекстЗапроса;
	
	// Собираем дерево отчетов и вариантов отчетов
	//Проходим по всем отчетам в метаданных.
	Для Каждого Эл из Метаданные.Отчеты Цикл
		
		ОтчетМенеджер = Отчеты[Эл.Имя];
		Если Эл.ОсновнаяСхемаКомпоновкиДанных = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		Макет = ОтчетМенеджер.ПолучитьМакет(Эл.ОсновнаяСхемаКомпоновкиДанных.Имя);
		
		Разделы = Новый СписокЗначений();
		Разделы = ПолучитьРазделыОтчета(Эл);
		// Добавляем отчет
		ВетвьОтчет = Дерево.Строки.Добавить();
		ВетвьОтчет.Синоним = Эл.Синоним;
		ВетвьОтчет.Ключ = Эл.Имя;
		ВетвьОтчет.Разделы = Разделы;
		ВетвьОтчет.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Эл.ПолноеИмя());
		
		Если Эл.ХранилищеВариантов = Неопределено Тогда
			
			// Добавляем варианты из числа предопределенных в макете 
			Для каждого Вариант Из Макет.ВариантыНастроек Цикл
				Строка = ВетвьОтчет.Строки.Добавить();
				Строка.Синоним = Вариант.Представление;
				Строка.Ключ = Вариант.Имя;
				Строка.Разделы = Разделы;
				Строка.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Эл.ПолноеИмя());
			КонецЦикла;
			
			// Добавляем пользовательские варианты
			СписокВариантов = ХранилищеВариантовОтчетов.ПолучитьСписок("Отчет." + Эл.Имя);
			Для каждого Вариант Из СписокВариантов Цикл
				
				Строка = ВетвьОтчет.Строки.Добавить();
				Строка.Синоним = Вариант.Представление;
				Строка.Ключ = Вариант.Значение;
				Строка.Пользовательский = Истина;
				Строка.Разделы = Разделы;
				Строка.Отчет = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Эл.ПолноеИмя());
				
			КонецЦикла;
			
		Иначе
			
			// Добавляем варианты из справочника "ВариантыОтчетов"
			ЗапросПоВариантам.УстановитьПараметр("ИдентификаторОтчета", 
			ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Эл.ПолноеИмя()));
			
			УстановитьПривилегированныйРежим(Истина);
			ТаблицаВариантов = ЗапросПоВариантам.Выполнить().Выгрузить();
			УстановитьПривилегированныйРежим(Ложь);
			
			Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
				Строка = ВетвьОтчет.Строки.Добавить();
				Строка.Синоним = СтрокаТаблицы.Наименование;
				Строка.Ключ    = СтрокаТаблицы.КлючВарианта;
				Строка.Пользовательский = ?(СтрокаТаблицы.Предопределенный = Истина, Ложь, Истина);
				Строка.Автор    = СтрокаТаблицы.Автор;
				Строка.ТолькоДляАвтора    = СтрокаТаблицы.ТолькоДляАвтора;
				Строка.Разделы = Разделы;
				Строка.Отчет = СтрокаТаблицы.Отчет;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Обходим дерево. Устанавливаем категории отчетов по умолчанию, макет образца отчета.
	//Разделы устанавливаем по принадлежности отчетов к подсистемам.
	Для Каждого Отчет из Дерево.Строки Цикл
		Для Каждого Вариант Из  Отчет.Строки Цикл
			
			Запрос =  Новый Запрос;
			Запрос.Текст =
						"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
						|	НастройкиВариантовОтчетовДокументооборот.Ссылка
						|ИЗ
						|	Справочник.НастройкиВариантовОтчетовДокументооборот КАК НастройкиВариантовОтчетовДокументооборот
						|ГДЕ
						|	НастройкиВариантовОтчетовДокументооборот.Отчет = &Отчет
						|	И НастройкиВариантовОтчетовДокументооборот.КлючВарианта = &КлючВарианта
						|	И НЕ НастройкиВариантовОтчетовДокументооборот.ПометкаУдаления";
			
			Запрос.УстановитьПараметр("КлючВарианта", Вариант.Ключ);
			Запрос.УстановитьПараметр("Отчет", Вариант.Отчет);
				
			ОбновлятьНастройки = Истина;
			
			Выборка = Запрос.Выполнить().Выбрать();
			
			Если Не Выборка.Следующий() Тогда
				
				НоваяНастройка = Справочники.НастройкиВариантовОтчетовДокументооборот.СоздатьЭлемент();
				
			Иначе
				
				НоваяНастройка = Выборка.Ссылка.ПолучитьОбъект();
				ОбновлятьНастройки = НЕ (НоваяНастройка.РедактируетсяВручную Или НоваяНастройка.Пользовательский); 
				
			КонецЕсли;
			
			Если ОбновлятьПринудительно = Истина ИЛИ ОбновлятьНастройки Тогда
				
				Попытка
					НоваяНастройка.Отчет = Отчет.Отчет; 
				Исключение 
					НоваяНастройка.Отчет = Отчет.Наименование; 
				КонецПопытки;
				
				НоваяНастройка.КлючВарианта = Вариант.Ключ;
				НоваяНастройка.Наименование = Вариант.Синоним;
				НоваяНастройка.Пользовательский = Вариант.Пользовательский;
				НоваяНастройка.ТолькоДляАвтора = Вариант.ТолькоДляАвтора;
				НоваяНастройка.Автор = Вариант.Автор;
				
				УстановитьПризнакВспомогательногоОтчета(НоваяНастройка);
								
				Если Не НоваяНастройка.Вспомогательный Тогда
					МенеджерОтчета = Отчеты[НоваяНастройка.Отчет.Имя];

					УстановитьНастройкиОтчетаПоУмолчанию(МенеджерОтчета,
						Новый Структура("НастройкаВариантаОтчета", НоваяНастройка));
					
					//Если у варианта отчета не были заполнены настройки разделов, то добавляем по подсистемам конфигурации.
					Если НоваяНастройка.Размещение.Количество() =0 Тогда
						
						Для каждого Раздел Из Вариант.Разделы Цикл
							РазделОтчета = НоваяНастройка.Размещение.Найти(
							ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Раздел.Значение), "Раздел");
							Если РазделОтчета = Неопределено Тогда
								НоваяСтрока = НоваяНастройка.Размещение.Добавить();
								НоваяСтрока.Раздел = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Раздел.Значение);
							КонецЕсли;
						КонецЦикла;
						
					КонецЕсли;
					
				КонецЕсли;
				
				Если ОбновлениеИнформационнойБазы.ЭтоВызовИзОбработчикаОбновления() Тогда
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(НоваяНастройка);
				Иначе
					НоваяНастройка.Записать();
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Заполняет по умолчанию отчет
//
// Параметры
//   МенеджерОтчета - Объект менеджер отчета 
//   ПараметрыЗаполненя - настройки, которые необходимо применить к отчету
//
Процедура УстановитьНастройкиОтчетаПоУмолчанию(МенеджерОтчета, ПараметрыЗаполненя) Экспорт
	
	Если ТипЗнч(ПараметрыЗаполненя) =  Тип("Структура") И 
			ПараметрыЗаполненя.Свойство("НастройкаВариантаОтчета") Тогда
		
		НастройкаВариантаОтчета = ПараметрыЗаполненя.НастройкаВариантаОтчета;
		
		КлючВариантаОтчета = НастройкаВариантаОтчета.КлючВарианта;
		
		СписокКатегорий = Новый СписокЗначений(); 
		СписокРазделов = Новый  СписокЗначений();
		
		КлючВариантаОтчета = НастройкаВариантаОтчета.КлючВарианта;
		ИмяОтчета = НастройкаВариантаОтчета.Отчет.Имя;
		
		ЕстьНастройкиПоУмолчанию = Истина;
		Попытка
			МенеджерОтчета.ЗаполнитьСписокКатегорийИРазделовОтчета(КлючВариантаОтчета, СписокКатегорий, СписокРазделов);
		Исключение
			// У отчета в модуле менеджера отсуствует метод ЗаполнитьСписокКатегорийИРазделовОтчета
			
			ЕстьНастройкиПоУмолчанию = Ложь;

			ТекстОшибки = НСтр("ru = 'У отчета отсуствует метод ЗаполнитьСписокКатегорийИРазделовОтчета'",
				Метаданные.ОсновнойЯзык.КодЯзыка); 
				
			Инфо = ИнформацияОбОшибке();
			
			ЗаписьЖурналаРегистрации(
				ТекстОшибки,
				УровеньЖурналаРегистрации.Ошибка,
				,
				НастройкаВариантаОтчета.Ссылка,
				НСтр("ru = 'Отчет'") + ": """ + ИмяОтчета + """"
				+ Символы.ПС + Символы.ПС + ПодробноеПредставлениеОшибки(Инфо));
			
		КонецПопытки;
		
		КлючВариантаОтчета = НастройкаВариантаОтчета.КлючВарианта;
		ИмяОтчета = НастройкаВариантаОтчета.Отчет.Имя;
		
		Попытка 
			ДанныеМакета = Отчеты[ИмяОтчета].ПолучитьМакет("ОбразецОтчета" + КлючВариантаОтчета);
			Если ТипЗнч(ДанныеМакета) = Тип("ДвоичныеДанные") Тогда
				КартинкаОтчет = Новый Картинка(ДанныеМакета);
			КонецЕсли;
			
		Исключение
			//В настройках по умолчанию отсутсвуют снимок отчета и макет отчета
			КартинкаОтчет = Неопределено;
		КонецПопытки;
		
		Если НЕ КартинкаОтчет = Неопределено Тогда
			// Если для отчета существует снимок, то загружаем его в справочник
			НастройкаВариантаОтчета.ХранилищеСнимокОтчета = Новый ХранилищеЗначения(КартинкаОтчет);
			
		Иначе
			 // Если нет  снимка, то загружаем картинку из библиотеки 
			НастройкаВариантаОтчета.ХранилищеСнимокОтчета = Новый ХранилищеЗначения(БиблиотекаКартинок.ОбразецОтчетаПустой);

		КонецЕсли;
		
		Если ЕстьНастройкиПоУмолчанию Тогда
			
			УстановитьКатегорииИРазделы(НастройкаВариантаОтчета, СписокКатегорий, СписокРазделов);
			
		Иначе
			
			ЗаполнитьКатегорииИРазделыИсключения(НастройкаВариантаОтчета);
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

// Находит элемент справочника "ИдентификаторыОбъектовМетаданных"соответствующий параметру "ИмяРаздела" 
//
// Параметры
//   Отчет - ОбъектМетаданных: Отчет
//
// Возвращаемое значение:
//   РазделыОтчета - Список значений - разделы конфигурации, к которым относится отчет.
//
Функция ПолучитьРазделыОтчета(Отчет)
	
	РазделыОтчета = Новый СписокЗначений();
	
	Раздел = Метаданные.Подсистемы.ДокументыИФайлы;
	Если ПодсистемаСодержитОтчет(Раздел, Отчет) Тогда
		РазделыОтчета.Добавить(Раздел);
	КонецЕсли;
	
	Раздел = Метаданные.Подсистемы.НСИ;
	Если ПодсистемаСодержитОтчет(Раздел, Отчет) Тогда
		РазделыОтчета.Добавить(Раздел);
	КонецЕсли;
	
	Раздел = Метаданные.Подсистемы.НастройкаИАдминистрирование;
	Если ПодсистемаСодержитОтчет(Раздел, Отчет) Тогда
		РазделыОтчета.Добавить(Раздел);
	КонецЕсли;
	
	Раздел = Метаданные.Подсистемы.СовместнаяРабота;
	Если ПодсистемаСодержитОтчет(Раздел, Отчет) Тогда
		РазделыОтчета.Добавить(Раздел);
	КонецЕсли;
	
	Раздел = Метаданные.Подсистемы.УчетВремени;
	Если ПодсистемаСодержитОтчет(Раздел, Отчет) Тогда
		РазделыОтчета.Добавить(Раздел);
	КонецЕсли;
	
	Раздел = Метаданные.Подсистемы.УправлениеБизнесПроцессами;
	Если ПодсистемаСодержитОтчет(Раздел, Отчет) Тогда
		РазделыОтчета.Добавить(Раздел);
	КонецЕсли;
	
	Возврат РазделыОтчета;
	
КонецФункции

// Проверяет вхождение отчета в соответствующую подсистему
//
// Параметры
//   Подсистема - Метаданные.Подсистемы
//   Отчет - ОбъектМетаданных: Отчет
//
// Возвращаемое значение:
//   Булево - Истина если отчет принадлежит подсистеме и ложь если нет.
//
Функция ПодсистемаСодержитОтчет(Подсистема, Отчет)
	
	Если Подсистема.Состав.Содержит(Отчет) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для каждого Эл Из Подсистема.Подсистемы Цикл
		Если ПодсистемаСодержитОтчет(Эл, Отчет) Тогда
			Возврат Истина;
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Процедура удаляет устаревшие настройки вариантов отчетов. Вызывается при обновлении ИБ
//
// Параметры
//   нет
//
Процедура УдалитьУстаревшиеНастройкиВариантовОтчетов()
	
	ИмяОтчета = "АнализВерсийОбъектов"; 
	КлючВарианта = "Основной";
	
	НастройкиВариантовОтчетовДокументооборот.УдалитьНастройкуВариантаОтчета(ИмяОтчета, КлючВарианта);
	
КонецПроцедуры

// Процедура устанавливает признак вспомогательного отчета. 
//
// Параметры
//   НастройкаВариантаОтчета -  объект "НастройкиВариантовОтчетовДокументооборот"
//
Процедура УстановитьПризнакВспомогательногоОтчета(НастройкаВариантаОтчета)
		
	НастройкаВариантаОтчета.Вспомогательный = Ложь;

	Если ТипЗнч(НастройкаВариантаОтчета.Отчет) = Тип("Строка") Тогда
		ИмяОтчета = Строка(НастройкаВариантаОтчета.Отчет);
	Иначе
		ИмяОтчета = НастройкаВариантаОтчета.Отчет.Имя;
	КонецЕсли;
	
	Если ИмяОтчета = "АнализВерсийОбъектов" 
		Или ИмяОтчета = "ДескрипторыДоступа"
		Или ИмяОтчета = "ДиаграммаСостоянияЭДО"
		Или ИмяОтчета = "ДосьеКонтрагента"
		Или ИмяОтчета = "ЗамерыПроизводительности"
		Или ИмяОтчета = "ИспользуемыеВнешниеРесурсы"
		Или ИмяОтчета = "МестаИспользованияСсылок"
		Или ИмяОтчета = "Метрики"
		Или ИмяОтчета = "СведенияОПользователях"
		Или ИмяОтчета = "СоставОчередиОбновленияПрав"
		Или ИмяОтчета = "СводкаПоКонтрагенту"
		Или ИмяОтчета = "ПроверкаЦелостностиТома"
	Тогда
		НастройкаВариантаОтчета.Вспомогательный = Истина;
	КонецЕсли;

КонецПроцедуры


#КонецОбласти
