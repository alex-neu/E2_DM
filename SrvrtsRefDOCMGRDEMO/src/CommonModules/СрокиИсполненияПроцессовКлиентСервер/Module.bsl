
////////////////////////////////////////////////////////////////////////////////
// <Сроки исполнения процессов клиент сервер: содержит процедуры и функции по работе со сроками процессов.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает формат даты для сроков процессов в зависимости
// от настройки ИспользоватьДатуИВремяВСрокахЗадач.
//
// Параметры:
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - значение настройки.
//
Функция ФорматДатыСроковПроцессовИЗадач(ИспользоватьДатуИВремяВСрокахЗадач) Экспорт
	
	Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
		Шаблон = "ДФ='dd.MM.yy HH:mm'; ДП='%1'";
	Иначе
		Шаблон = "ДФ='dd.MM.yy'; ДП='%1'";
	КонецЕсли;
	
	Возврат СтрШаблон(Шаблон, НСтр("ru = 'не определен'"));
	
КонецФункции

// Убирает секунды в переданной дате.
//
// Параметры
//   ДатаИВремя - Дата
//
Процедура УбратьСекундыВДате(ДатаИВремя) Экспорт
	
	ДатаИВремя = НачалоДня(ДатаИВремя) + Час(ДатаИВремя) * 3600 + Минута(ДатаИВремя) * 60;
	
КонецПроцедуры

// Возвращает представление длительности.
//
// Параметры:
//  Дни, Часы, Минуты - Число - длительность в днях, часах и минутах
//
// Возвращаемое значение:
//  Строка - представление длительности строкой.
//
Функция ПредставлениеДлительности(Дни, Часы, Минуты) Экспорт
	
	Если Дни = 0 И Часы = 0 И Минуты = 0 Тогда
		Возврат НСтр("ru = 'не определен'");
	КонецЕсли;
	
	ПредставлениеДни = "";
	ПредставлениеЧасы = "";
	ПредставлениеМинуты = "";
	
	ЕстьДни = ЗначениеЗаполнено(Дни);
	ЕстьЧасы = ЗначениеЗаполнено(Часы);
	ЕстьМинуты = ЗначениеЗаполнено(Минуты);
	
	Если ЕстьДни Тогда
		
		Если ЕстьЧасы И ЕстьМинуты Тогда 
			ШаблонПредставления = НСтр("ru = '%1 дн.'");
		Иначе
			ШаблонПредставления = "%1 "
				+ ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
					Дни, НСтр("ru = 'день, дня, дней'"));
		КонецЕсли;
		
		ПредставлениеДни = СтрШаблон(ШаблонПредставления, Дни);
	КонецЕсли;
	
	Если ЕстьЧасы Тогда
		
		Если ЕстьДни И ЕстьМинуты Тогда
			ШаблонПредставления = НСтр("ru = ' %1 ч.'");
		Иначе
			ШаблонПредставления = " %1 "
				+ ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
					Часы, НСтр("ru = 'час, часа, часов'"));
		КонецЕсли;
		
		ПредставлениеЧасы = СтрШаблон(ШаблонПредставления, Часы);
	КонецЕсли;
	
	Если ЕстьМинуты Тогда
		
		Если ЕстьДни И ЕстьЧасы Тогда
			ШаблонПредставления = НСтр("ru = ' %1 мин.'");
		Иначе
			ШаблонПредставления = " %1 "
				+ ОбщегоНазначенияДокументооборотКлиентСервер.ПредметИсчисленияПрописью(
					Минуты, НСтр("ru = 'минута, минуты, минут'"));
		КонецЕсли;
		
		ПредставлениеМинуты = СтрШаблон(ШаблонПредставления, Минуты);
	КонецЕсли;
	
	Представление = ПредставлениеДни + ПредставлениеЧасы + ПредставлениеМинуты;
	
	Представление = СокрЛП(Представление);
	
	Возврат Представление;
	
КонецФункции

// Возвращает длительность по представлению
//
// Параметры:
//   ПредставлениеДлительности - Строка - представление длительности
//
// Возвращаемое значение:
//   Структура
//      Дни - Число
//      Часы - Число
//      Минуты - Число
//
Функция ДлительностьПоПредставлению(ПредставлениеДлительности) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Дни", 0);
	Результат.Вставить("Часы", 0);
	Результат.Вставить("Минуты", 0);
	
	// Если передана пустая строка, то возвращает нулевая длительность.
	Если Не ЗначениеЗаполнено(ПредставлениеДлительности) Тогда
		Возврат Результат;
	КонецЕсли;
	
	СтрокаДляОбработки = СокрЛ(ПредставлениеДлительности);
	
	// Если представление длительности содержит только число, то
	// возвращается длительность с указанным количеством дней.
	Если ЭтоЧисло(СтрокаДляОбработки) Тогда
		Результат.Дни = Число(СтрокаДляОбработки);
		Возврат Результат;
	КонецЕсли;
	
	// Если в строке указаны спец. символы, то возвращается
	// Неопределено, т.е. ошибка.
	Если СтрНайти(СтрокаДляОбработки, "@")
		Или СтрНайти(СтрокаДляОбработки, "#")
		Или СтрНайти(СтрокаДляОбработки, "$") Тогда
		
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'дней'"), " @ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'день'"), " @ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'дня'"), " @ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'дн.'"), " @ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'д.'"), " @ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'д'"), " @ ");
	
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'часов'"), " # ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'часа'"), " # ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'час'"), " # ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'ч.'"), " # ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'ч'"), " # ");
	
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'минуты'"), " $ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'минута'"), " $ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'минут'"), " $ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'мин.'"), " $ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'мин'"), " $ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'м.'"), " $ ");
	СтрокаДляОбработки = СтрЗаменить(СтрокаДляОбработки, НСтр("ru = 'м'"), " $ ");
	
	ЧислоОбозначенийДн = СтрЧислоВхождений(СтрокаДляОбработки, "@");
	ЧислоОбозначенийЧ = СтрЧислоВхождений(СтрокаДляОбработки, "#");
	ЧислоОбозначенийМин = СтрЧислоВхождений(СтрокаДляОбработки, "$");
	
	// Если в строке указано несколько обозначений дней, часов или минут, то возвращается
	// Неопределено, т.е. ошибка.
	Если ЧислоОбозначенийДн > 1 Или ЧислоОбозначенийЧ > 1 Или ЧислоОбозначенийМин > 1 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЧислоОбозначенийДн > 0 Тогда
		СтрокиДляОбработки = СтрРазделить(СтрокаДляОбработки, "@");
		Если ЭтоЧисло(СокрЛП(СтрокиДляОбработки[0])) Тогда
			Дни = Число(СтрокиДляОбработки[0]);
			Результат.Дни = Окр(Дни, 0, 1);
		КонецЕсли;
		
		Если СтрокиДляОбработки.Количество() > 1 Тогда
			СтрокаДляОбработки = СтрокиДляОбработки[1];
		КонецЕсли;
	КонецЕсли;
	
	Если ЧислоОбозначенийЧ > 0 Тогда
		СтрокиДляОбработки = СтрРазделить(СтрокаДляОбработки, "#");
		Если ЭтоЧисло(СокрЛП(СтрокиДляОбработки[0])) Тогда
			Часы = Число(СтрокиДляОбработки[0]);
			Результат.Часы = Окр(Часы, 0, 1);
		КонецЕсли;
		
		Если СтрокиДляОбработки.Количество() > 1 Тогда
			СтрокаДляОбработки = СтрокиДляОбработки[1];
		КонецЕсли;
	КонецЕсли;
	
	Если ЧислоОбозначенийМин > 0 Тогда
		СтрокиДляОбработки = СтрРазделить(СтрокаДляОбработки, "$");
		Если ЭтоЧисло(СокрЛП(СтрокиДляОбработки[0])) Тогда
			Минуты = Число(СтрокиДляОбработки[0]);
			Результат.Минуты = Окр(Минуты, 0, 1);
		КонецЕсли;
	КонецЕсли;
	
	// Корректировка значений
	Если Результат.Дни > 999 Тогда
		Результат.Дни = 999;
	КонецЕсли;
	Если Результат.Часы > 23 Тогда
		Результат.Часы = 23;
	КонецЕсли;
	Если Результат.Минуты > 59 Тогда
		Результат.Минуты = 59;
	КонецЕсли;
	
	Если Результат.Дни = 0 И Результат.Часы = 0 И Результат.Минуты = 0 Тогда
		Возврат Неопределено;
	Иначе
		Возврат Результат;
	КонецЕсли;
	
КонецФункции

// Возвращает дату по представлению
//
// Параметры:
//   ПредставлениеДаты - Строка - дата в виде строки
//
// Возвращаемое значение:
//   Дата, Неопределено - если по представлению не удалось определить дату, то возвращается Неопределено.
//
Функция ДатаПоПредставлению(ПредставлениеДаты) Экспорт
	
	Результат = Неопределено;
	
	Если Не ЗначениеЗаполнено(ПредставлениеДаты) Тогда
		Возврат Результат;
	КонецЕсли;
	
	День = 0;
	Месяц = 0;
	Год = 0;
	Часы = 0;
	Минуты = 0;
	
	РазделительДатыВремени = НСтр("ru = ' '");
	РазделительВоВремени1 = НСтр("ru = ':'");
	РазделительВоВремени2 = НСтр("ru = '.'");
	РазделительВоВремени3 = НСтр("ru = ','");
	РазделительДаты1 = НСтр("ru = '.'");
	РазделительДаты2 = НСтр("ru = ','");
	
	СтрДатаИВремя = СтрРазделить(ПредставлениеДаты, РазделительДатыВремени);
	КолСтрДатаИВремя = СтрДатаИВремя.Количество();
	
	Если КолСтрДатаИВремя > 2 Тогда
		Возврат Результат;
	КонецЕсли;
	
	СтрДатаИВремя[0] = СтрЗаменить(СтрДатаИВремя[0], РазделительДаты2, РазделительДаты1);
	
	СтрДата = СтрРазделить(СтрДатаИВремя[0], РазделительДаты1);
	КолСтрДата = СтрДата.Количество();
	
	Если КолСтрДата <> 3 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Если ЭтоЧисло(СтрДата[0]) Тогда
		День = Число(СтрДата[0]);
		Если День > 30 Тогда
			Год = День;
			День = 0;
		КонецЕсли;
	Иначе
		Возврат Результат;
	КонецЕсли;
	
	Если ЭтоЧисло(СтрДата[1]) Тогда
		Месяц = Число(СтрДата[1]);
	Иначе
		Возврат Результат;
	КонецЕсли;
	
	Если ЭтоЧисло(СтрДата[2]) Тогда
		Если День = 0 Тогда
			День = Число(СтрДата[2]);
		Иначе
			Год = Число(СтрДата[2]);
		КонецЕсли;
	Иначе
		Возврат Результат;
	КонецЕсли;
	
	Если Год < 100 Тогда
		Год = Год + 2000;
	КонецЕсли;
	
	Если КолСтрДатаИВремя = 2 Тогда
		
		СтрДатаИВремя[1] = СтрЗаменить(СтрДатаИВремя[1], РазделительВоВремени2, РазделительВоВремени1);
		СтрДатаИВремя[1] = СтрЗаменить(СтрДатаИВремя[1], РазделительВоВремени3, РазделительВоВремени1);
		
		СтрВремя = СтрРазделить(СтрДатаИВремя[1], РазделительВоВремени1);
		КолСтрВремя = СтрВремя.Количество();
		
		Если КолСтрВремя = 1 Или КолСтрВремя > 2 Тогда
			Возврат Результат;
		Иначе
			
			Если ЭтоЧисло(СтрВремя[0]) Тогда
				Часы = Число(СтрВремя[0]);
			Иначе
				Возврат Результат;
			КонецЕсли;
			
			Если ЭтоЧисло(СтрВремя[1]) Тогда
				Минуты = Число(СтрВремя[1]);
			Иначе
				Возврат Результат;
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		#Если Сервер Тогда
			ТекущаяДата = ТекущаяДатаСеанса();
		#Иначе
			ТекущаяДата = ТекущаяДата();
		#КонецЕсли
		Часы = Час(ТекущаяДата);
		Минуты = Минута(ТекущаяДата);
	КонецЕсли;
	
	Попытка
		Результат = Дата(Год, Месяц, День, Часы, Минуты, 0);
	Исключение
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Возвращает варианты установки срока исполнения
//
// Возвращаемое значение:
//  Структура:
//   * ТочныйСрок
//   * ОтносительныйСрок
//
Функция ВариантыУстановкиСрокаИсполнения() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТочныйСрок",
		ПредопределенноеЗначение("Перечисление.ВариантыУстановкиСрокаИсполнения.ТочныйСрок"));
	Результат.Вставить("ОтносительныйСрок",
		ПредопределенноеЗначение("Перечисление.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок"));
		
	Возврат Результат;
		
КонецФункции

// Определяет, является ли текущий исполнитель Ответственным
//
// Параметры:
//  СтрокаИсполнителя - СтрокаТаблицыЗначений, ДанныеФормыЭлементКоллекции - строка в таблице Исполнители.
//
// Возвращаемое значение:
//   Булево - возвращает Истину, если в текущей строке есть поле Ответственный, и оно имеет значение Истина.
//
Функция ЭтоСтрокаОтвественного(СтрокаИсполнителя) Экспорт
	
	Возврат ЗначениеСвойстваОбъекта(СтрокаИсполнителя, "Ответственный", Ложь);
	
КонецФункции

// Возвращает свойство объекта. В случае отсутствия свойства, возвращает пустое значение.
//
// Параметры:
//  Объект - Произвольный - Любой объект с полями/реквизитами/свойствами.
//  ИмяСвойства - Строка - Имя свойства, значение которого необходимо определить.
//  ПустоеЗначение - Произвольный - Пустое значение свойства.
//
// Возвращаемое значение:
//  Произвольный
//
Функция ЗначениеСвойстваОбъекта(Объект, ИмяСвойства, ПустоеЗначение) Экспорт
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить(ИмяСвойства, ПустоеЗначение);
	
	ЗаполнитьЗначенияСвойств(СтруктураПоиска, Объект);
	
	Возврат СтруктураПоиска[ИмяСвойства];
	
КонецФункции

#КонецОбласти

#Область ПрограммныйИнтерфейс_КарточкиПроцессовИШаблонов

// Возвращает структуру параметров для настройки доступности
// элемента управления сроком.
//
// Используется в процедуре НастроитьЭлементУправленияСроком.
//
// Может быть переопределена в
// СрокиИсполненияПроцессовКлиентСерверПереопределяемый.ПриОпределенииПараметровДоступностиЭлементаУправления
//
// Возвращаемое значение:
//  Структура
//   * ДоступностьПоШаблону - Булево - настройка доступности реквизита по шаблону процесса.
//
Функция ПараметрыДоступностиЭлементаУправления() Экспорт
	
	Параметры = Новый Структура;
	
	СтандартнаяОбработка = Истина;
	
	СрокиИсполненияПроцессовКлиентСерверПереопределяемый.
		ПриОпределенииПараметровДоступностиЭлементаУправления(
			Параметры, СтандартнаяОбработка);
	
	Параметры.Вставить("ДоступностьПоШаблону");
	
	Возврат Параметры;
	
КонецФункции

// Настраивает возможность изменения значения элемента управления сроком.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - форма процесса.
//  ЭлементУправленияСроком - ПолеФормы - поле формы управления сроком.
//  РеквизитПредставлениеСрока - Строка - реквизит содержащий представление срока.
//  ПараметрыДоступности - Структура - см. функцию ПараметрыДоступностиЭлементаУправления.
//
Процедура НастроитьЭлементУправленияСроком(Форма,
	ЭлементУправленияСроком,
	РеквизитПредставлениеСрока,
	ПараметрыДоступности) Экспорт
	
	ДоступностьПоШаблону = ПараметрыДоступности.ДоступностьПоШаблону;
	
	СтандартнаяОбработка = Истина;
	
	СрокиИсполненияПроцессовКлиентСерверПереопределяемый.ПриНастройкеЭлементаУправленияСроком(
		Форма, ЭлементУправленияСроком, РеквизитПредставлениеСрока,
		ПараметрыДоступности, СтандартнаяОбработка);
		
	Если Не СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	// Устанавливаем значения по умолчанию (включаем доступность всех полей)
	ЭлементУправленияСроком.ТолькоПросмотр = Ложь;
	
	// Устанвавливаем заначение в зависимости от параметров формы
	Если Форма.ТолькоПросмотр Тогда
		// Если форма процесса недоступна для изменения, тогда не даем менять сроки.
		ЭлементУправленияСроком.ТолькоПросмотр = Истина;
	ИначеЕсли ДоступностьПоШаблону = Ложь И ЗначениеЗаполнено(РеквизитПредставлениеСрока) Тогда
		// Если изменение запрещено по шаблону и сроки заполнены, тогда запрещаем менять.
		ЭлементУправленияСроком.ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет представление сроков исполнения в карточке процесса/шаблона
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма процесса
//
Процедура ЗаполнитьПредставлениеСроковИсполненияВФорме(Форма) Экспорт
	
	Если Форма.Объект.Свойство("Исполнители") Тогда
		ЗаполнитьПредставлениеСроковВТаблицеИсполнителей(
			Форма.Объект.Исполнители,
			Форма.ИспользоватьДатуИВремяВСрокахЗадач,
			ЗначениеЗаполнено(Форма.ДатаОтсчетаДляРасчетаСроков));
	КонецЕсли;
	
	Если Форма.Объект.Свойство("Исполнитель") Тогда
		
		Если ЗначениеЗаполнено(Форма.ДатаОтсчетаДляРасчетаСроков) Тогда
			СрокИсполнения = Форма.Объект.СрокИсполнения;
		Иначе
			СрокИсполнения = Дата(1,1,1);
		КонецЕсли;
		
		ЗаполнитьПредставлениеСроковУчастника(
			Форма.СрокИсполненияПредставление,
			СрокИсполнения,
			Форма.Объект.СрокИсполненияДни,
			Форма.Объект.СрокИсполненияЧасы,
			Форма.Объект.СрокИсполненияМинуты,
			Форма.Объект.ВариантУстановкиСрокаИсполнения,
			Форма.ИспользоватьДатуИВремяВСрокахЗадач);
	КонецЕсли;
	
	Если Форма.Объект.Свойство("СрокОбработкиРезультатов") Тогда
		
		Если ЗначениеЗаполнено(Форма.ДатаОтсчетаДляРасчетаСроков) Тогда
			СрокОбработкиРезультатов = Форма.Объект.СрокОбработкиРезультатов;
		Иначе
			СрокОбработкиРезультатов = Дата(1,1,1);
		КонецЕсли;
		
		ЗаполнитьПредставлениеСроковУчастника(
			Форма.СрокОбработкиРезультатовПредставление,
			СрокОбработкиРезультатов,
			Форма.Объект.СрокОбработкиРезультатовДни,
			Форма.Объект.СрокОбработкиРезультатовЧасы,
			Форма.Объект.СрокОбработкиРезультатовМинуты,
			Форма.Объект.ВариантУстановкиСрокаОбработкиРезультатов,
			Форма.ИспользоватьДатуИВремяВСрокахЗадач);
	КонецЕсли;
	
	Если Форма.Объект.Свойство("СрокИсполненияПроцесса") Тогда
		
		Дата = Дата(1,1,1);
		Если ЗначениеЗаполнено(Форма.ДатаОтсчетаДляРасчетаСроков)
			И ЗначениеЗаполнено(Форма.Объект.СрокИсполненияПроцесса) Тогда
			
			Дата = Форма.Объект.СрокИсполненияПроцесса;
		КонецЕсли;
		
		Дни = 0;
		Часы = 0;
		Минуты = 0;
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("СрокИсполненияПроцессаДни");
		
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, Форма);
		
		Если СтруктураПоиска.СрокИсполненияПроцессаДни <> Неопределено Тогда
			Дни = Форма.СрокИсполненияПроцессаДни;
			Часы = Форма.СрокИсполненияПроцессаЧасы;
			Минуты = Форма.СрокИсполненияПроцессаМинуты;
		КонецЕсли;
		
		ЗаполнитьПредставлениеСрокаИсполненияПроцесса(
			Форма.СрокИсполненияПроцессаПредставление,
			Дата, Дни, Часы, Минуты,
			Форма.ИспользоватьДатуИВремяВСрокахЗадач);
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет представление срока исполнения в таблице исполнителей процесса.
//
// Параметры:
//  РеквизитИсполнители - ДанныеФормыКоллекция - таблица исполнителей процесса.
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - признак использования даты и времени
//                                                в сроках исполнения.
//  ВключитьВПредставлениеТочныйСрок - Булево - признак, определяющий необходимость
//                                              включения в представление точного срока.
//
Процедура ЗаполнитьПредставлениеСроковВТаблицеИсполнителей(
	РеквизитИсполнители,
	ИспользоватьДатуИВремяВСрокахЗадач,
	ВключитьВПредставлениеТочныйСрок = Истина) Экспорт
	
	Для Каждого СтрИсполнитель Из РеквизитИсполнители Цикл
		
		Если ВключитьВПредставлениеТочныйСрок Тогда
			СрокИсполнения = СтрИсполнитель.СрокИсполнения;
		Иначе
			СрокИсполнения = Дата(1,1,1);
		КонецЕсли;
		
		СтрИсполнитель.СрокИсполненияПредставление = ПредставлениеСрокаИсполнения(
			СрокИсполнения,
			СтрИсполнитель.СрокИсполненияДни,
			СтрИсполнитель.СрокИсполненияЧасы,
			СтрИсполнитель.СрокИсполненияМинуты,
			ИспользоватьДатуИВремяВСрокахЗадач,
			СтрИсполнитель.ВариантУстановкиСрокаИсполнения);
	КонецЦикла;
	
КонецПроцедуры

// Заполняет представление срока исполнения участника процесса.
//
// Параметры:
//  СрокИсполненияПредставление - Строка - представление срока исполнения.
//  СрокИсполнения - Дата - срок исполнения датой.
//  СрокИсполненияДни, СрокИсполненияЧасы, СрокИсполненияМинуты - Число - относительный срок исполнения.
//  ВариантУстановкиСрокаИсполнения - ПеречислениеСсылка.ВариантыУстановкиСрокаИсполнения - вариант установки срока.
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - признак использования даты и времени в сроках исполнения.
//
Процедура ЗаполнитьПредставлениеСроковУчастника(
	СрокИсполненияПредставление,
	СрокИсполнения,
	СрокИсполненияДни,
	СрокИсполненияЧасы,
	СрокИсполненияМинуты,
	ВариантУстановкиСрокаИсполнения,
	ИспользоватьДатуИВремяВСрокахЗадач) Экспорт
	
	СрокИсполненияПредставление = ПредставлениеСрокаИсполнения(
			СрокИсполнения,
			СрокИсполненияДни,
			СрокИсполненияЧасы,
			СрокИсполненияМинуты,
			ИспользоватьДатуИВремяВСрокахЗадач,
			ВариантУстановкиСрокаИсполнения);
	
КонецПроцедуры

// Заполняет представление срока исполнения процесса.
//
// Параметры:
//  СрокИсполненияПредставление - Строка - представление срока исполнения процесса.
//  СрокИсполнения - Дата - Срок исполнения процесса датой.
//  СрокИсполненияДни, СрокИсполненияЧасы, СрокИсполненияМинуты - Число - относительный срок исполнения процесса.
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - признак использования даты и времени в сроках исполнения.
//
Процедура ЗаполнитьПредставлениеСрокаИсполненияПроцесса(
	СрокИсполненияПредставление,
	СрокИсполнения,
	СрокИсполненияДни,
	СрокИсполненияЧасы,
	СрокИсполненияМинуты,
	ИспользоватьДатуИВремяВСрокахЗадач) Экспорт
	
	Если ЗначениеЗаполнено(СрокИсполнения)
		И (ЗначениеЗаполнено(СрокИсполненияДни)
			Или ЗначениеЗаполнено(СрокИсполненияЧасы)
			Или ЗначениеЗаполнено(СрокИсполненияМинуты)) Тогда
		
		СрокИсполненияПредставление = ПредставлениеСрокаИсполнения(
			СрокИсполнения,
			СрокИсполненияДни,
			СрокИсполненияЧасы,
			СрокИсполненияМинуты,
			ИспользоватьДатуИВремяВСрокахЗадач,
			ПредопределенноеЗначение("Перечисление.ВариантыУстановкиСрокаИсполнения.ОтносительныйСрок"));
		
	ИначеЕсли ЗначениеЗаполнено(СрокИсполненияДни)
			Или ЗначениеЗаполнено(СрокИсполненияЧасы)
			Или ЗначениеЗаполнено(СрокИсполненияМинуты) Тогда
		
		СрокИсполненияПредставление = ПредставлениеДлительности(
			СрокИсполненияДни,
			СрокИсполненияЧасы,
			СрокИсполненияМинуты);
	Иначе
		ФормаДаты = ФорматДатыСроковПроцессовИЗадач(ИспользоватьДатуИВремяВСрокахЗадач);
		СрокИсполненияПредставление = Формат(СрокИсполнения, ФормаДаты);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает представление срока исполнения в виде
// дата (длительность) или длительность (дата).
//
// Параметры:
//  Дата - Дата - срок исполнения датой.
//  Дни, Часы, Минуты - Число - длительность исполнения.
//  ИспользоватьДатуИВремяВСрокахЗадач - Булево - признак использования даты и времени в сроках
//                                       процессов и задач.
//  ВариантУстановкиСрока - ПеречислениеСсылка.ВариантыУстановкиСрокаИсполнения - вариант
//                          установки срока исполнения.
//
Функция ПредставлениеСрокаИсполнения(Дата, Дни, Часы, Минуты,
	ИспользоватьДатуИВремяВСрокахЗадач, ВариантУстановкиСрока) Экспорт
	
	Представление = "";
	
	ЗаполненТочныйСрок = ЗначениеЗаполнено(Дата);
	
	ЗаполненОтносительныйСрок = Дни > 0
		Или (ИспользоватьДатуИВремяВСрокахЗадач И (Часы > 0 Или Минуты > 0));
	
	Если Не ЗаполненТочныйСрок И Не ЗаполненОтносительныйСрок Тогда
		Возврат Представление;
	КонецЕсли;
	
	ФормаДаты = ФорматДатыСроковПроцессовИЗадач(ИспользоватьДатуИВремяВСрокахЗадач);
	
	Если ЗаполненТочныйСрок И ЗаполненОтносительныйСрок Тогда
		
		ВариантыУстановкиСрока = СрокиИсполненияПроцессовКлиентСервер.ВариантыУстановкиСрокаИсполнения();
		
		Если ВариантУстановкиСрока = ВариантыУстановкиСрока.ТочныйСрок Тогда
			ПерваяЧастьПредставления = Формат(Дата, ФормаДаты);
			Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
				ВтораяЧастьПердставления = ПредставлениеДлительности(Дни, Часы, Минуты);
			Иначе
				ВтораяЧастьПердставления = ПредставлениеДлительности(Дни, 0, 0);
			КонецЕсли;
		Иначе
			ВтораяЧастьПердставления = Формат(Дата, ФормаДаты);
			Если ИспользоватьДатуИВремяВСрокахЗадач Тогда
				ПерваяЧастьПредставления = ПредставлениеДлительности(Дни, Часы, Минуты);
			Иначе
				ПерваяЧастьПредставления = ПредставлениеДлительности(Дни, 0, 0);
			КонецЕсли;
		КонецЕсли;
		
		Представление = СтрШаблон("%1 (%2)",
			ПерваяЧастьПредставления,
			ВтораяЧастьПердставления);
		
	ИначеЕсли ЗаполненТочныйСрок Тогда
		Представление = Формат(Дата, ФормаДаты);
	Иначе
		Представление = ПредставлениеДлительности(Дни, Часы, Минуты);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет, является ли переданная строка числом
//
// Параметры:
//   СтрокаСимволов - Строка - строка символов
//
// Возвращаемое значение:
//   Булево - возвращает Истина, если строка является числом
//
Функция ЭтоЧисло(СтрокаСимволов)
	
	СтрокаСимволов = СокрЛП(СтрокаСимволов);
	
	Если Не ЗначениеЗаполнено(СтрокаСимволов) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаСтроки = СтрДлина(СтрокаСимволов);
	
	Для ТекущийСимвол = 1 По ДлинаСтроки Цикл
		
		КодСимвола = КодСимвола(СтрокаСимволов, ТекущийСимвол);
		
		Если КодСимвола < 48 Или КодСимвола > 57 Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти