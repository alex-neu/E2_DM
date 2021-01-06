#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// Создание заполняемого предмета задачи
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("ШаблонДокумента") Тогда
		СтандартнаяОбработка = Ложь;
		ВыбраннаяФорма = Метаданные.Справочники.СообщенияОбсуждений.Формы.ФормаЭлемента;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПраваДоступа

// Возвращает строку, содержащую перечисление полей доступа через запятую.
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат "Ссылка,Автор,Документ,Папка";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ПредметТемы = ОбъектДоступа.Документ;
	
	Если ЗначениеЗаполнено(ПредметТемы) Тогда
		
		ТипПредмета = ТипЗнч(ПредметТемы);
		ВладелецПрав = ПредметТемы;
		Если ТипПредмета = Тип("СправочникСсылка.Файлы") Тогда
			ВладелецПрав = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредметТемы, "ВладелецФайла");
		ИначеЕсли ТипПредмета = Тип("СправочникСсылка.ПроектныеЗадачи") Тогда
			ВладелецПрав = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПредметТемы, "Владелец");
		КонецЕсли;
		
		ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаОтВладельца(
			ОбъектДоступа, ТаблицаДескрипторов, ВладелецПрав);
		
		Если ПротоколРасчетаПрав <> Неопределено Тогда
			ЗаписьПротокола = Новый Структура("Элемент, Описание",
				ПредметТемы, НСтр("ru = 'Права на предмет темы'"));
			ПротоколРасчетаПрав.Добавить(ЗаписьПротокола);
		КонецЕсли;
	
	Иначе
		
		ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаСтандартно(
			ОбъектДоступа, ТаблицаДескрипторов);
		
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие метода.
// 
Функция ЕстьМетодПолучитьПраваПользователейПоОбъектам() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает права пользователей на объекты.
// 
Функция ПолучитьПраваПользователейПоОбъектам(ОбъектыДоступа, Пользователи = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаПрав = ДокументооборотПраваДоступа.ТаблицаПравПользователейПоОбъектам();
	
	// Права по дескрипторам.
	ТаблицаПравПоДескрипторам =
		РегистрыСведений.ПраваПоДескрипторамДоступаОбъектов.ПолучитьПраваПользователейПоОбъектам(
			ОбъектыДоступа, Пользователи, Ложь);
	
	ТаблицаПравПоДескрипторам.Индексы.Добавить("ОбъектДоступа");
	
	// Получение данных по темам.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТемыОбсуждений.Ссылка,
		|	ТемыОбсуждений.Автор,
		|	МАКСИМУМ(НЕ ДескрипторыДляОбъектов.Объект ЕСТЬ NULL ) КАК ЕстьРабочаяГруппа,
		|	ТемыОбсуждений.Документ КАК Предмет,
		|	ТемыОбсуждений.Документ <> НЕОПРЕДЕЛЕНО КАК ЭтоПредметнаяТема,
		|	ТемыОбсуждений.Папка
		|ИЗ
		|	Справочник.ТемыОбсуждений КАК ТемыОбсуждений
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДескрипторыДляОбъектов КАК ДескрипторыДляОбъектов
		|		ПО ТемыОбсуждений.Ссылка = ДескрипторыДляОбъектов.Объект
		|			И (ДескрипторыДляОбъектов.ТипДескриптора = 1)
		|ГДЕ
		|	ТемыОбсуждений.Ссылка В(&ОбъектыДоступа)
		|
		|СГРУППИРОВАТЬ ПО
		|	ТемыОбсуждений.Ссылка,
		|	ТемыОбсуждений.Автор,
		|	ТемыОбсуждений.Документ <> НЕОПРЕДЕЛЕНО,
		|	ТемыОбсуждений.Папка");
		
	Запрос.УстановитьПараметр("ОбъектыДоступа", ОбъектыДоступа);
	Результат = Запрос.Выполнить();
	
	// Получение прав папок.
	Папки = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
		Папки, Результат.Выгрузить().ВыгрузитьКолонку("Папка"), Истина);
	ПраваПапок = ДокументооборотПраваДоступа.ПолучитьПраваПользователейПоОднотипнымОбъектам(
		Папки, Истина, Пользователи);
	ПраваПапок.Индексы.Добавить("ОбъектДоступа, Пользователь");
	
	// Заполнение таблицы прав.
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЭтоПредметнаяТема Тогда
			// Дополнение таблицы прав по дескрипторам неограниченными правами на предмет.
			ИдПредмета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Выборка.Предмет.Метаданные());
			ДокументооборотПраваДоступа.РасширитьТаблицуПравНеограниченнымиПравами(
				ТаблицаПрав,
				ИдПредмета, 
				ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Выборка.Ссылка),
				Пользователи);
		КонецЕсли;
		
		// Заполнение таблицы прав.
		СтрокиПравПоДескрипторам = ТаблицаПравПоДескрипторам.НайтиСтроки(
			Новый Структура("ОбъектДоступа", Выборка.Ссылка));
		
		// Если есть рабочая группа, то права совпадают с правами по дескрипторам.
		Если Выборка.ЕстьРабочаяГруппа Тогда
			Для Каждого СтрокаПравПоДескрипторам Из СтрокиПравПоДескрипторам Цикл
				ЗаполнитьЗначенияСвойств(ТаблицаПрав.Добавить(), СтрокаПравПоДескрипторам);
			КонецЦикла;
			Продолжить;
		КонецЕсли;
		
		// Если нет рабочей группы, права на изменение получают автор и модератор.
		Для Каждого СтрокаПравПоДескрипторам Из СтрокиПравПоДескрипторам Цикл
			
			Стр = ТаблицаПрав.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, СтрокаПравПоДескрипторам, "ОбъектДоступа, Пользователь, Чтение");
			
			// Автор
			Если Стр.Пользователь = Выборка.Автор Тогда
				Стр.Добавление = ?(Выборка.ЭтоПредметнаяТема,
					СтрокаПравПоДескрипторам.Чтение, СтрокаПравПоДескрипторам.Добавление);
				Стр.Изменение = Истина;
				Стр.Удаление = Истина;
				Продолжить;
			КонецЕсли;
			
			// Модератор получает полные права на не предметные темы.
			Если Выборка.ЭтоПредметнаяТема Тогда
				Продолжить;
			КонецЕсли;
			
			СтруктураПоиска = Новый Структура(
				"ОбъектДоступа, Пользователь", Выборка.Папка, Стр.Пользователь);
			СтрокиПравПапки = ПраваПапок.НайтиСтроки(СтруктураПоиска);
			
			Если СтрокиПравПапки.Количество() = 1 И СтрокиПравПапки[0].Изменение Тогда
				Стр.Изменение = Истина;
				Стр.Добавление = Истина;
				Стр.Удаление = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ИдентификаторОМ = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
		Метаданные.Справочники.ТемыОбсуждений);
	
	ДокументооборотПраваДоступа.РасширитьТаблицуПравРуководителямиИДелегатами(ТаблицаПрав);
	ДокументооборотПраваДоступа.РасширитьТаблицуПравНеограниченнымиПравами(
		ТаблицаПрав, ИдентификаторОМ, ОбъектыДоступа, Пользователи);
		
	// Отбор по пользователям.
	ТаблицаПравСОтбором = ДокументооборотПраваДоступа.ТаблицаПравПользователейПоОбъектам();
	Если Пользователи = Неопределено Тогда
		ТаблицаПравСОтбором = ТаблицаПрав.Скопировать();
	Иначе
		Для Каждого Пользователь Из Пользователи Цикл
			НайденныеСтроки = ТаблицаПрав.НайтиСтроки(Новый Структура("Пользователь", Пользователь));
			Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				ЗаполнитьЗначенияСвойств(ТаблицаПравСОтбором.Добавить(), НайденнаяСтрока);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТаблицаПравСОтбором;
	
КонецФункции

// Заполняет переданный дескриптор доступа 
Процедура ЗаполнитьОсновнойДескриптор(ОбъектДоступа, ДескрипторДоступа) Экспорт
	
	// Папка
	ДокументооборотПраваДоступа.ЗаполнитьПапкуДескриптораОбъекта(ОбъектДоступа, ДескрипторДоступа);
	
КонецПроцедуры

// Возвращает признак того, что менеджер содержит метод ЗапросДляРасчетаПрав()
// 
Функция ЕстьМетодЗапросДляРасчетаПрав() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает запрос для расчета прав доступа по дескрипторам объекта
// 
// Параметры:
//  
//  Дескрипторы - Массив - массив дескрипторов, чьи права нужно рассчитать
//  ИдОбъекта - Ссылка - идентификатор объекта метаданных, назначенный переданным дескрипторам
//  МенеджерОбъектаДоступа - СправочникМенеджер, ДокументМенеджер - менеджер объекта доступа
// 
// Возвращаемое значение - Запрос - запрос, который выберет права доступа для переданного массива дескрипторов
// 
Функция ЗапросДляРасчетаПрав(Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа) Экспорт
	
	Запрос = Справочники.ДескрипторыДоступаОбъектов.ЗапросДляСтандартногоРасчетаПрав(
		Дескрипторы, ИдОбъекта, МенеджерОбъектаДоступа, Истина, Ложь);
	
	Возврат Запрос;
	
КонецФункции

// Заполняет протокол расчета прав дескрипторов
// 
// Параметры:
//  
//  ПротоколРасчетаПрав - Массив - протокол для заполнения
//  ЗапросПоПравам - Запрос - запрос, который использовался для расчета прав дескрипторов
//  Дескрипторы - Массив - массив дескрипторов, чьи права были рассчитаны
//  
Процедура ЗаполнитьПротоколРасчетаПрав(ПротоколРасчетаПрав, ЗапросПоПравам) Экспорт
	
	Справочники.ДескрипторыДоступаОбъектов.ЗаполнитьПротоколРасчетаПравСтандартно(
		ПротоколРасчетаПрав, ЗапросПоПравам);
	
КонецПроцедуры

// Проверяет наличие метода.
// 
Функция ЕстьМетодПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает таблицу значений с правилами обработки настроек прав папки,
// которые следует применять для расчета прав объекта
// 
Функция ПолучитьПравилаОбработкиНастроекПравПапки() Экспорт
	
	ТаблицаПравил = ДокументооборотПраваДоступа.ТаблицаПравилОбработкиНастроекПапки();
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ЧтениеПапокИТем";
	Стр.Чтение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ДобавлениеТемИСообщений";
	Стр.Добавление = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ИзменениеТемИСообщений";
	Стр.Изменение = Истина;
	
	Стр = ТаблицаПравил.Добавить();
	Стр.Настройка = "ПометкаУдаленияТемИСообщений";
	Стр.Удаление = Истина;
	
	Возврат ТаблицаПравил;
	
КонецФункции

#КонецОбласти

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Карточка",
			"Тема обсуждения",
			ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			,
			"Справочник.ТемыОбсуждений.ПФ_MXL_Карточка");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаСообщения";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.ТемыОбсуждений.ПФ_MXL_Карточка");
	ОбластьШапкаТемы = Макет.ПолучитьОбласть("ШапкаТемы");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ОбъектПечати Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Заполнение реквизитов темы обсуждения
		ОбластьШапкаТемы.Параметры.Название = Строка(ОбъектПечати) + " (" + ТипЗнч(ОбъектПечати) + ")" ;
		ОбластьШапкаТемы.Параметры.Автор = Строка(ОбъектПечати.Автор);
		ОбластьШапкаТемы.Параметры.Дата = ОбъектПечати.ДатаСоздания;
		ОбластьШапкаТемы.Параметры.Раздел = ОбъектПечати.Папка;
		Если ЗначениеЗаполнено(ОбъектПечати.Документ) Тогда
			ОбластьШапкаТемы.Параметры.Предмет = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					"%1 (%2)",
					Строка(ОбъектПечати.Документ),
					ТипЗнч(ОбъектПечати.Документ));	
		Иначе
			ОбластьШапкаТемы.Параметры.Предмет = НСтр("ru = 'без предмета'");	
		КонецЕсли;
		ОбластьШапкаТемы.Параметры.ЭтоЗакрытаяТема = 
			?(ОбъектПечати.Закрытая, НСтр("ru = 'Это закрытая тема'"), НСтр("ru = 'Это открытая тема'"));
					
		ПервоеСообщениеТемы = РаботаСОбсуждениями.НайтиПервоеСообщениеТемы(ОбъектПечати);
		ОбластьШапкаТемы.Параметры.Текст = ПервоеСообщениеТемы.ТекстСообщения;
		
		ДвоичныеДанныеФото = ОбъектПечати.Автор.ФизЛицо.ФайлФотографии.Получить();
		Если ЗначениеЗаполнено(ДвоичныеДанныеФото) Тогда
			КартинкаФото = Новый Картинка(ДвоичныеДанныеФото);
		Иначе
			КартинкаФото = БиблиотекаКартинок.ПользовательБезФото;
		КонецЕсли;
		ОбластьШапкаТемы.Рисунки.ФотоАвтора.Картинка = КартинкаФото;
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТемы);
		
		// Заполнение рабочей группы темы
		РабочаяГруппаТемы = РаботаСРабочимиГруппами.ПолучитьРабочуюГруппуДокумента(ОбъектПечати);
		Если РабочаяГруппаТемы.Количество() > 0 Тогда
			ОбластьРабочаяГруппаШапка = Макет.ПолучитьОбласть("РабочаяГруппаШапка");
			ТабличныйДокумент.Вывести(ОбластьРабочаяГруппаШапка);
			Для Каждого УчастникРабочейГруппы Из РабочаяГруппаТемы Цикл
				ОбластьРабочаяГруппаУчастник = Макет.ПолучитьОбласть("РабочаяГруппаУчастник");
				ОбластьРабочаяГруппаУчастник.Параметры.УчастникРабочейГруппы = УчастникРабочейГруппы.Участник;
				ОбластьРабочаяГруппаУчастник.Параметры.ТипУчастника = ТипЗнч(УчастникРабочейГруппы.Участник);
				ТабличныйДокумент.Вывести(ОбластьРабочаяГруппаУчастник);
			КонецЦикла;
		КонецЕсли;
		
		// Получение информации о последнем сообщении темы
		СведенияОТеме = РаботаСОбсуждениями.ПолучитьСведенияОТеме(ОбъектПечати);
	
		Если СведенияОТеме <> Неопределено Тогда
			КоличествоОтветов = СведенияОТеме.КоличествоСообщений;
			ДатаПоследнегоСообщения = СведенияОТеме.ДатаПоследнегоСообщения;
			АвторПоследнегоСообщения = СведенияОТеме.АвторПоследнегоСообщения;
			
			ОбластьПоследнееСообщение = Макет.ПолучитьОбласть("ПоследнееСообщение");
			ОбластьПоследнееСообщение.Параметры.АвторПоследнегоСообщения = АвторПоследнегоСообщения;
			ОбластьПоследнееСообщение.Параметры.ДатаПоследнегоСообщения = ДатаПоследнегоСообщения;
			ОбластьПоследнееСообщение.Параметры.ОтветовВсего = КоличествоОтветов;
						
			ЗапросПоследнееСообщение = Новый Запрос;
			ЗапросПоследнееСообщение.Текст = 
				"ВЫБРАТЬ ПЕРВЫЕ 1
				|	СообщенияОбсуждений.ТекстСообщения
				|ИЗ
				|	Справочник.СообщенияОбсуждений КАК СообщенияОбсуждений
				|ГДЕ
				|	СообщенияОбсуждений.ВладелецСообщения = &Тема
				|
				|УПОРЯДОЧИТЬ ПО
				|	СообщенияОбсуждений.ДатаСоздания УБЫВ";
			ЗапросПоследнееСообщение.УстановитьПараметр("Тема", ОбъектПечати);
			Выборка = ЗапросПоследнееСообщение.Выполнить().Выбрать();
			Если Выборка.Следующий() Тогда
				ОбластьПоследнееСообщение.Параметры.ТекстПоследнегоСообщения = Выборка.ТекстСообщения;
			Иначе
				ОбластьПоследнееСообщение.Параметры.ТекстПоследнегоСообщения = "";
			КонецЕсли;
			
			ДвоичныеДанныеФото = АвторПоследнегоСообщения.ФизЛицо.ФайлФотографии.Получить();
			Если ЗначениеЗаполнено(ДвоичныеДанныеФото) Тогда
				КартинкаФото = Новый Картинка(ДвоичныеДанныеФото);
			Иначе
				КартинкаФото = БиблиотекаКартинок.ПользовательБезФото;
			КонецЕсли;
			ОбластьПоследнееСообщение.Рисунки.ФотоАвтораПоследнегоСообщения.Картинка = КартинкаФото;
			
			ТабличныйДокумент.Вывести(ОбластьПоследнееСообщение);
		КонецЕсли;
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбъектПечати);
	КонецЦикла;		

	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

// Создает новую тему.
Функция СоздатьНовуюТему(РеквизитыТемы, Автор = Неопределено, РабочаяГруппаДобавить = Неопределено, РабочаяГруппаУдалить = Неопределено) Экспорт
	
	НоваяТема = СоздатьЭлемент();
	
	ЗаполнитьЗначенияСвойств(НоваяТема, РеквизитыТемы);
	
	Наименование = РеквизитыТемы.Наименование;
	Если Не ЗначениеЗаполнено(НоваяТема.Наименование) И ЗначениеЗаполнено(НоваяТема.Документ) Тогда
		НоваяТема.Наименование = НСтр("ru = 'Обсуждение ""%1""'");
		НоваяТема.Наименование = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НоваяТема.Наименование, НоваяТема.Документ);
	КонецЕсли;
	
	НоваяТема.ТемаДокумента = ЗначениеЗаполнено(РеквизитыТемы.Документ);
	
	Если Не ЗначениеЗаполнено(Автор) Тогда
		Автор = ПользователиКлиентСервер.ТекущийПользователь();
	КонецЕсли;
	НоваяТема.Автор = Автор;
	
	Если ЗначениеЗаполнено(РабочаяГруппаДобавить) Тогда
		НоваяТема.ДополнительныеСвойства.Вставить("РабочаяГруппаДобавить", РабочаяГруппаДобавить);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(РабочаяГруппаУдалить) Тогда
		 НоваяТема.ДополнительныеСвойства.Вставить("РабочаяГруппаУдалить", РабочаяГруппаУдалить);
	КонецЕсли;
	
	НоваяТема.Записать();
	
	Возврат НоваяТема.Ссылка;
	
КонецФункции

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Тема'");
	
КонецФункции

// Возвращает структуру реквизитов темы форума.
//
// Возвращаемое значение:
//  Структура - Структура реквизитов темы форума.
//
Функция ПолучитьСтруктуруРеквизитов() Экспорт
	
	СтруктураРеквизитов = Новый Структура("Наименование, Документ, Папка, Закрытая");
	
	Возврат СтруктураРеквизитов;
	
КонецФункции

// Возвращает структуру полей темы обсуждений
//
// Возвращаемое значение:
//   Структура
//     Наименование
//     Закрытая
//     Документ
//     Автор
//     ДатаСоздания
//     ТемаДокумента
//
Функция ПолучитьСтруктуруТемыОбсуждений() Экспорт
	
	СтруктураТемыОбсуждения = Новый Структура;
	СтруктураТемыОбсуждения.Вставить("Наименование");
	СтруктураТемыОбсуждения.Вставить("Закрытая");
	СтруктураТемыОбсуждения.Вставить("Документ");
	СтруктураТемыОбсуждения.Вставить("Папка");
	СтруктураТемыОбсуждения.Вставить("Автор");
	СтруктураТемыОбсуждения.Вставить("ДатаСоздания");
	СтруктураТемыОбсуждения.Вставить("ТемаДокумента");
	СтруктураТемыОбсуждения.Вставить("ТекстСообщения");
	
	Возврат СтруктураТемыОбсуждения;
	
КонецФункции

// Создает и записывает в БД тему обсуждений
//
// Параметры:
//   СтруктураТемыОбсуждения - Структура - структура полей темы обсуждений.
//
// Возвращаемое значение:
//   СправочникСсылка.ТемыОбсуждений - созданная тема.
//
Функция СоздатьТемуОбсуждений(СтруктураТемыОбсуждения) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Тема");
	Результат.Вставить("ПервоеСообщениеТемы");
	
	Попытка
		
		НачатьТранзакцию();
		
		НоваяТемаОбсуждений = СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(НоваяТемаОбсуждений, СтруктураТемыОбсуждения);
		НоваяТемаОбсуждений.Записать();
		
		СправочникСообщения = Справочники.СообщенияОбсуждений;
		НовоеСообщение = СправочникСообщения.СоздатьЭлемент();
		НовоеСообщение.ВладелецСообщения = НоваяТемаОбсуждений.Ссылка;
		НовоеСообщение.ПервоеСообщениеТемы = Истина;
		
		Если ЗначениеЗаполнено(СтруктураТемыОбсуждения.ТекстСообщения) Тогда
			НовоеСообщение.ТекстСообщения = СтруктураТемыОбсуждения.ТекстСообщения;
		Иначе
			НовоеСообщение.ТекстСообщения = НоваяТемаОбсуждений.Наименование;
		КонецЕсли;
		
		НовоеСообщение.Записать();
		
		Результат.Тема = НоваяТемаОбсуждений.Ссылка;
		Результат.ПервоеСообщениеТемы = НовоеСообщение.Ссылка;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли
