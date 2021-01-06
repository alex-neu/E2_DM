////////////////////////////////////////////////////////////////////////////////
// Работа с часовыми поясами (клиент-сервер).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает часовой пояс, заданный смещением.
//
// Возвращаемое значение:
//  Строка, Неопределено - Часовой пояс,заданный смещением, в формате GMT{+/-}hh:mm. Если среди допустимых часовых поясов нет допустимого - возвращает Неопределено.
//
Функция ЧасовойПоясСмещением(СмещениеСтандартногоВремени) Экспорт
	
	МинимальноеСмещениеЧасов = 0;
	МаксимальноеСмещениеЧасов = 0;
	ЧасовыеПоясаПоСмещению = Новый Соответствие;
	ИзвестныеЧасовыеПояса = ИзвестныеЧасовыеПояса();
	Для Каждого ДанныеЧасовогоПояса Из ИзвестныеЧасовыеПояса() Цикл
		ЧасовыеПоясаПоСмещению.Вставить(
			ДанныеЧасовогоПояса.НаправлениеСмещения + Строка(ДанныеЧасовогоПояса.СмещениеЧасов),
			ДанныеЧасовогоПояса);
	КонецЦикла;
	
	ДанныеСмещения = ДанныеСмещения(СмещениеСтандартногоВремени);
	Если ДанныеСмещения.СмещениеМинут > 30 Тогда
		ДанныеСмещения.СмещениеЧасов = ДанныеСмещения.СмещениеЧасов + 1;
		ДанныеСмещения.СмещениеМинут = 0;
	Иначе
		ДанныеСмещения.СмещениеМинут = 0;
	КонецЕсли;
	
	ДанныеЧасовогоПояса = ЧасовыеПоясаПоСмещению.Получить(
		ДанныеСмещения.НаправлениеСмещения + Строка(ДанныеСмещения.СмещениеЧасов));
	Если ДанныеЧасовогоПояса = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДанныеЧасовогоПояса.ЧасовойПояс;
	
КонецФункции

// Возвращает данные известного часового пояса.
//
// Параметры:
//  ЧасовойПояс - Строка - Часовой пояс в формате GMT{+/-}hh:mm.
// 
// Возвращаемое значение:
//  Структура, Неопределено - Данные известного часового пояса. Если часовой пояс не известен - возвращает Неопределено.
//
Функция ДанныеЧасовогоПояса(ЧасовойПояс) Экспорт
	
	Для Каждого ДанныеЧасовогоПояса Из ИзвестныеЧасовыеПояса() Цикл
		
		Если ДанныеЧасовогоПояса.ЧасовойПояс <> ЧасовойПояс Тогда
			Продолжить;
		КонецЕсли;
		
		Возврат ДанныеЧасовогоПояса;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Преобразует дату в часовом поясе сеанса к местному времени.
//
// Параметры:
//  Дата                    - Дата      - Дата в часовом поясе сеанса.
//  ПараметрыПреобразования - Структура - Параметры преобразования местно времени. См. РаботаСЧасовымиПоясами.ПараметрыПреобразованияМестногоВремени().
// 
// Возвращаемое значение:
//  Дата - Местное время.
//
Функция ПривестиКМестномуВремени(ДатаСеанса, ПараметрыПреобразования) Экспорт
	
	Если Не ЗначениеЗаполнено(ДатаСеанса) Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	Если ПараметрыПреобразования.РежимОтображенияМестногоВремени =
			ПредопределенноеЗначение("Перечисление.РежимыОтображенияМестногоВремени.ВремяСеанса") Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	ДанныеПоясаСеанса = ДанныеЧасовогоПояса(ПараметрыПреобразования.ЧасовойПоясПоУмолчанию);
	ДанныеМестногоПояса = ДанныеЧасовогоПояса(ПараметрыПреобразования.МестныйЧасовойПояс);
	Если ДанныеМестногоПояса = Неопределено Или ДанныеПоясаСеанса = Неопределено Тогда
		Возврат ДатаСеанса;
	КонецЕсли;
	
	УниверсальнаяДата = УниверсальноеВремяПоДаннымПояса(ДатаСеанса, ДанныеПоясаСеанса);
	
	Возврат МестноеВремяПоДаннымПояса(УниверсальнаяДата, ДанныеМестногоПояса);
	
КонецФункции

// Преобразует местное время к дате в часовом поясе сеанса.
//
// Параметры:
//  Дата                    - Дата      - Местное время.
//  ПараметрыПреобразования - Структура - Параметры преобразования местно времени. См. РаботаСЧасовымиПоясами.ПараметрыПреобразованияМестногоВремени().
// 
// Возвращаемое значение:
//  Дата - Дата в часовом поясе сеанс.
//
Функция ПривестиКВремениСеанса(МестнаяДата, ПараметрыПреобразования) Экспорт
	
	Если Не ЗначениеЗаполнено(МестнаяДата) Тогда
		Возврат МестнаяДата;
	КонецЕсли;
	
	Если ПараметрыПреобразования.РежимОтображенияМестногоВремени =
			ПредопределенноеЗначение("Перечисление.РежимыОтображенияМестногоВремени.ВремяСеанса") Тогда
		Возврат МестнаяДата;
	КонецЕсли;
	
	ДанныеПоясаСеанса = ДанныеЧасовогоПояса(ПараметрыПреобразования.ЧасовойПоясПоУмолчанию);
	ДанныеМестногоПояса = ДанныеЧасовогоПояса(ПараметрыПреобразования.МестныйЧасовойПояс);
	Если ДанныеМестногоПояса = Неопределено Или ДанныеПоясаСеанса = Неопределено Тогда
		Возврат МестнаяДата;
	КонецЕсли;
	
	УниверсальнаяДата = УниверсальноеВремяПоДаннымПояса(МестнаяДата, ДанныеМестногоПояса);
	
	Возврат МестноеВремяПоДаннымПояса(УниверсальнаяДата, ДанныеПоясаСеанса);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует данные известных часовых поясов.
// 
// Возвращаемое значение:
//  Массив из Структура - Данные известных часовых поясов. См. РаботаСЧасовымиПоясамиКлиентСервер.НовыйДанныеЧасовогоПояса().
//
Функция ИзвестныеЧасовыеПояса()
	
	ИзвестныеЧасовыеПояса = Новый Массив;
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-12:00) Линия перемены дат'"),
			"-",
			12,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-11:00) Время в формате UTC -11'"),
			"-",
			11,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-10:00) Гавайи'"),
			"-",
			10,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-09:00) Аляска'"),
			"-",
			9,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-08:00) Тихоокеанское время (США и Канада)'"),
			"-",
			8,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-07:00) Горное время (США и Канада)'"),
			"-",
			7,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-06:00) Центральное время (США и Канада)'"),
			"-",
			6,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-05:00) Восточное время (США и Канада)'"),
			"-",
			5,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-04:00) Атлантическое время (Канада)'"),
			"-",
			4,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-03:00) Бразилия'"),
			"-",
			3,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-02:00) Время в формате UTC -02'"),
			"-",
			2,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC-01:00) Азорские острова'"),
			"-",
			1,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+00:00) Лондон'"),
			"+",
			0,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+01:00) Берлин'"),
			"+",
			1,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+02:00) Калининград'"),
			"+",
			2,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+03:00) Москва'"),
			"+",
			3,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+04:00) Саратов'"),
			"+",
			4,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+05:00) Екатеринбург'"),
			"+",
			5,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+06:00) Омск'"),
			"+",
			6,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+07:00) Новосибирск'"),
			"+",
			7,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+08:00) Иркутск'"),
			"+",
			8,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+09:00) Якутск'"),
			"+",
			9,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+09:30) Дарвин'"),
			"+",
			9,
			30));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+10:00) Владивосток'"),
			"+",
			10,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+11:00) Сахалин'"),
			"+",
			11,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+12:00) Петропавлоск-Камчатский'"),
			"+",
			12,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+13:00) Самоа'"),
			"+",
			13,
			0));
	
	ИзвестныеЧасовыеПояса.Добавить(
		НовыйДанныеЧасовогоПояса(
			НСтр("ru = '(UTC+14:00) Острова Киритимати'"),
			"+",
			14,
			0));
	
	Возврат ИзвестныеЧасовыеПояса;
	
КонецФункции

// Формирует структуру данных часового пояса.
//
// Параметры:
//  Представление       - Строка - Представление часового пояса.
//  НаправлениеСмещения - Строка - Направление смещения часового пояса "+" или "-".
//  СмещениеЧасов       - Число  - Смещение часов.
//  СмещениеМинут       - Число  - Смещение минут.
// 
// Возвращаемое значение:
//  Структура - Структура данных часового пояса.
//   * ЧасовойПояс         - Строка - Часовой пояс в формате GMT{+/-}hh:mm.
//   * Представление       - Строка - Представление часового пояса.
//   * НаправлениеСмещения - Строка - Направление смещения часового пояса "+" или "-".
//   * СмещениеЧасов       - Число  - Смещение часов.
//   * СмещениеМинут       - Число  - Смещение минут.
//
Функция НовыйДанныеЧасовогоПояса(Представление, НаправлениеСмещения, СмещениеЧасов, СмещениеМинут)
	
	ДанныеЧасовогоПояса = Новый Структура(
		"ЧасовойПояс, Представление, НаправлениеСмещения, СмещениеЧасов, СмещениеМинут");
	ДанныеЧасовогоПояса.НаправлениеСмещения = НаправлениеСмещения;
	ДанныеЧасовогоПояса.СмещениеЧасов = СмещениеЧасов;
	ДанныеЧасовогоПояса.СмещениеМинут = СмещениеМинут;
	ДанныеЧасовогоПояса.Представление = Представление;
	ДанныеЧасовогоПояса.ЧасовойПояс = ЧасовойПоясЧастями(НаправлениеСмещения, СмещениеЧасов, СмещениеМинут);
	
	Возврат ДанныеЧасовогоПояса;
	
КонецФункции

// Формирует данные смещения по смещению стандартного времени.
//
// Параметры:
//  СмещениеСтандартногоВремени - Число - Смещение стандартного времени.
// 
// Возвращаемое значение:
//  Структура - Данные смещения. См. РаботаСЧасовымиПоясамиКлиентСервер.НовыйДанныеСмещения().
//
Функция ДанныеСмещения(СмещениеСтандартногоВремени)
	
	СекундВМинуте = 60;
	СекундВЧасе = 3600;
	
	ДанныеСмещения = НовыйДанныеСмещения();
	ДанныеСмещения.НаправлениеСмещения = ?(СмещениеСтандартногоВремени >= 0, "+", "-");
	ДанныеСмещения.СмещениеЧасов = Цел(СмещениеСтандартногоВремени / СекундВЧасе);
	ДанныеСмещения.СмещениеМинут =
		Цел((СмещениеСтандартногоВремени - ДанныеСмещения.СмещениеЧасов * СекундВЧасе) / СекундВМинуте);
	
	Возврат ДанныеСмещения;
	
КонецФункции

// Формирует новую структуру данных смещения.
// 
// Возвращаемое значение:
//  Структура - Пустая структура данных смещения.
//   * НаправлениеСмещения - Строка - Направление смещения часового пояса "+" или "-".
//   * СмещениеЧасов       - Число  - Смещение часов.
//   * СмещениеМинут       - Число  - Смещение минут.
//
Функция НовыйДанныеСмещения()
	
	ДанныеСмещения = Новый Структура("НаправлениеСмещения, СмещениеЧасов, СмещениеМинут");
	ДанныеСмещения.НаправлениеСмещения = "";
	ДанныеСмещения.СмещениеЧасов = 0;
	ДанныеСмещения.СмещениеМинут = 0;
	
	Возврат ДанныеСмещения;
	
КонецФункции

// Формирует часовой пояс, заданный частями.
//
// Параметры:
//  НаправлениеСмещения - Строка - Направление смещения часового пояса "+" или "-".
//  СмещениеЧасов       - Число  - Смещение часов.
//  СмещениеМинут       - Число  - Смещение минут.
// 
// Возвращаемое значение:
//  Строка - Часовой пояс в формате GMT{+/-}hh:mm.
//
Функция ЧасовойПоясЧастями(НаправлениеСмещения, СмещениеЧасов, СмещениеМинут)
	
	Возврат СтрШаблон("GMT%1%2:%3",
		НаправлениеСмещения,
		Формат(СмещениеЧасов, "ЧЦ=2; ЧН=00; ЧВН="),
		Формат(СмещениеМинут, "ЧЦ=2; ЧН=00; ЧВН="));
	
КонецФункции

// Преобразует дату в часовом поясе в универсальную дату.
//
// Параметры:
//  МестноеВремя - Дата      - Дата в часовом поясе.
//  ДанныеПояса  - Структура - Данные часового пояса. См. РаботаСЧасовымиПоясамиКлиентСервер.НовыйДанныеЧасовогоПояса().
// 
// Возвращаемое значение:
//  Дата - Универсальная дата.
//
Функция УниверсальноеВремяПоДаннымПояса(МестноеВремя, ДанныеПояса)
	
	СекундВМинуте = 60;
	СекундВЧасе = 3600;
	
	УниверсальнаяДата = МестноеВремя;
	Если ДанныеПояса.НаправлениеСмещения = "+" Тогда
		УниверсальнаяДата = УниверсальнаяДата
			- ДанныеПояса.СмещениеЧасов * СекундВЧасе
			- ДанныеПояса.СмещениеМинут * СекундВМинуте;
	ИначеЕсли ДанныеПояса.НаправлениеСмещения = "-" Тогда
		УниверсальнаяДата = УниверсальнаяДата
			+ ДанныеПояса.СмещениеЧасов * СекундВЧасе
			+ ДанныеПояса.СмещениеМинут * СекундВМинуте;
	КонецЕсли;
	
	Возврат УниверсальнаяДата;
	
КонецФункции

// Преобразует универсальную дату в дату в часовом поясе.
//
// Параметры:
//  УниверсальноеВремя - Дата      - Универсальная дата
//  ДанныеПояса        - Структура - Данные часового пояса. См. РаботаСЧасовымиПоясамиКлиентСервер.НовыйДанныеЧасовогоПояса().
// 
// Возвращаемое значение:
//  Дата - Дата в часовом поясе.
//
Функция МестноеВремяПоДаннымПояса(УниверсальноеВремя, ДанныеПояса)
	
	СекундВМинуте = 60;
	СекундВЧасе = 3600;
	
	МестноеВремя = УниверсальноеВремя;
	Если ДанныеПояса.НаправлениеСмещения = "+" Тогда
		МестноеВремя = МестноеВремя
			+ ДанныеПояса.СмещениеЧасов * СекундВЧасе
			+ ДанныеПояса.СмещениеМинут * СекундВМинуте;
	ИначеЕсли ДанныеПояса.НаправлениеСмещения = "-" Тогда
		МестноеВремя = МестноеВремя
			- ДанныеПояса.СмещениеЧасов * СекундВЧасе
			- ДанныеПояса.СмещениеМинут * СекундВМинуте;
	КонецЕсли;
	
	Возврат МестноеВремя;
	
КонецФункции

#КонецОбласти