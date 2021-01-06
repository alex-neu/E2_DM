#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПраваДоступа

// Возвращает строку, содержащую перечисление полей доступа через запятую.
Функция ПолучитьПоляДоступа() Экспорт
	
	Возврат 
		"Ссылка,
		|Автор,
		|ВладелецСообщения";
	
КонецФункции

// Проверяет наличие метода.
// 
Функция ЕстьМетодЗаполнитьДескрипторыОбъекта() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Заполняет переданную таблицу дескрипторов объекта.
// 
Процедура ЗаполнитьДескрипторыОбъекта(ОбъектДоступа, ТаблицаДескрипторов, ПротоколРасчетаПрав = Неопределено) Экспорт
	
	ДокументооборотПраваДоступа.ЗаполнитьДескрипторыОбъектаОтВладельца(
		ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.ВладелецСообщения);
	
	Если ЗначениеЗаполнено(ОбъектДоступа.Автор) Тогда
		
		ДокументооборотПраваДоступа.ДобавитьИндивидуальныйДескриптор(
			ОбъектДоступа, ТаблицаДескрипторов, ОбъектДоступа.Автор, Истина);
		
		Если ПротоколРасчетаПрав <> Неопределено Тогда
			ЗаписьПротокола = Новый Структура("Элемент, Описание",
				ОбъектДоступа.Автор, НСтр("ru = 'Автор сообщения'"));
			ПротоколРасчетаПрав.Добавить(ЗаписьПротокола);
		КонецЕсли;
		
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
	
	// Получение данных по сообщениям.
	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	СообщенияОбсуждений.Ссылка,
		|	СообщенияОбсуждений.Автор,
		|	ТемыОбсуждений.Папка,
		|	ТемыОбсуждений.Документ КАК Предмет,
		|	ТемыОбсуждений.Документ <> НЕОПРЕДЕЛЕНО КАК ЭтоПредметнаяТема
		|ИЗ
		|	Справочник.СообщенияОбсуждений КАК СообщенияОбсуждений
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТемыОбсуждений КАК ТемыОбсуждений
		|		ПО СообщенияОбсуждений.ВладелецСообщения = ТемыОбсуждений.Ссылка
		|ГДЕ
		|	СообщенияОбсуждений.Ссылка В(&ОбъектыДоступа)
		|
		|СГРУППИРОВАТЬ ПО
		|	СообщенияОбсуждений.Ссылка,
		|	СообщенияОбсуждений.Автор,
		|	ТемыОбсуждений.Папка,
		|	ТемыОбсуждений.Документ,
		|	ТемыОбсуждений.Документ <> НЕОПРЕДЕЛЕНО");
		
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
		
		СтрокиПравПоДескрипторам = ТаблицаПравПоДескрипторам.НайтиСтроки(
			Новый Структура("ОбъектДоступа", Выборка.Ссылка));
		
		// Если нет рабочей группы, права на изменение получают автор и модератор.
		Для Каждого СтрокаПравПоДескрипторам Из СтрокиПравПоДескрипторам Цикл
			
			Стр = ТаблицаПрав.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, СтрокаПравПоДескрипторам, "ОбъектДоступа, Пользователь, Чтение");
			
			// Автор
			Если Стр.Пользователь = Выборка.Автор Тогда
				Стр.Добавление = Истина;
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
		Метаданные.Справочники.СообщенияОбсуждений);
	
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

#КонецОбласти

#Область Печать

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Карточка") Тогда
		
		// Формируем табличный документ и добавляем его в коллекцию печатных форм
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Карточка",
			"Сообщение форума",
			ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати),
			,
			"Справочник.СообщенияОбсуждений.ПФ_MXL_Карточка");
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПечатьКарточки(МассивОбъектов, ОбъектыПечати, ПараметрыПечати)
	
	ИспользоватьДополнительныеРеквизитыИСведения = ПолучитьФункциональнуюОпцию("ИспользоватьДополнительныеРеквизитыИСведения");
	
	// Создаем табличный документ и устанавливаем имя параметров печати
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_КарточкаСообщения";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("Справочник.СообщенияОбсуждений.ПФ_MXL_Карточка");
	ОбластьКарточка = Макет.ПолучитьОбласть("Карточка");
	
	ПервыйДокумент = Истина;
	
	Для Каждого ОбъектПечати Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		// Запомним номер строки с которой начали выводить текущий документ
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ОбластьКарточка.Параметры.Автор = ОбъектПечати.Автор;
		ОбластьКарточка.Параметры.Дата = 
			?(ЗначениеЗаполнено(ОбъектПечати.ДатаИзменения), ОбъектПечати.ДатаИзменения, ОбъектПечати.ДатаСоздания);
		ОбластьКарточка.Параметры.Тема = Строка(ОбъектПечати.ВладелецСообщения);
		ОбластьКарточка.Параметры.Текст = ОбъектПечати.ТекстСообщения;
		
		ДвоичныеДанныеФото = ОбъектПечати.Автор.ФизЛицо.ФайлФотографии.Получить();
		Если ЗначениеЗаполнено(ДвоичныеДанныеФото) Тогда
			КартинкаФото = Новый Картинка(ДвоичныеДанныеФото);
		Иначе
			КартинкаФото = БиблиотекаКартинок.ПользовательБезФото;
		КонецЕсли;
		
		ОбластьКарточка.Рисунки.Фото.Картинка = КартинкаФото;
        ТабличныйДокумент.Вывести(ОбластьКарточка);
		
		// В табличном документе зададим имя области в которую был 
		// выведен объект. Нужно для возможности печати по-комплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ОбъектПечати);
	КонецЦикла;		

	Возврат ТабличныйДокумент;
	
КонецФункции

#КонецОбласти

// Проверяет, подходит ли объект к шаблону бизнес-процесса
Функция ШаблонПодходитДляАвтозапускаБизнесПроцессаПоОбъекту(ШаблонСсылка, ПредметСсылка, Подписчик, ВидСобытия, Условие) Экспорт
	
	Возврат БизнесСобытияВызовСервера.ШаблонПодходитДляАвтозапускаБизнесПроцессаПоПредмету(ШаблонСсылка, 
		ПредметСсылка, Подписчик, ВидСобытия, Условие);
	
КонецФункции

// Возвращает имя предмета процесса по умолчанию
//
Функция ПолучитьИмяПредметаПоУмолчанию(Ссылка) Экспорт
	
	Возврат НСтр("ru='Сообщение'");
	
КонецФункции

#КонецОбласти

#КонецЕсли