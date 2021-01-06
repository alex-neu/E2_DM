
#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ФУНЦИИ БИБЛИОТЕКИ

// Функция возвращает массив дат, которые отличается указанной даты на количество дней,
// входящих в указанный график
//
// Параметры
//	Календарь		- календарь, который необходимо использовать, тип СправочникСсылка.Календари
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата
//	МассивДней		- массив с количеством дней, на которые нужно увеличить дату начала, тип Массив,Число
//	РассчитыватьСледующуюДатуОтПредыдущей	- нужно ли рассчитывать следующую дату от предыдущей или
//											  все даты рассчитываются от переданной даты
//
// Возвращаемое значение
//	Массив		- массив дат, увеличенных на количество дней, входящих в график
//
Функция ПолучитьМассивДатПоКалендарю(Знач Календарь, Знач ДатаОт, Знач МассивДней, Знач РассчитыватьСледующуюДатуОтПредыдущей = Ложь) Экспорт
	
	ДатаОт = НачалоДня(ДатаОт);
	
	ТаблицаДат = Новый ТаблицаЗначений;
	ТаблицаДат.Колонки.Добавить("ИндексСтроки", Новый ОписаниеТипов("Число"));
	ТаблицаДат.Колонки.Добавить("КоличествоДней", Новый ОписаниеТипов("Число"));
	
	КоличествоДней = 0;
	НомерСтроки = 0;
	Для Каждого СтрокаДней Из МассивДней Цикл
		КоличествоДней = КоличествоДней + СтрокаДней;
		
		Строка = ТаблицаДат.Добавить();
		Строка.ИндексСтроки			= НомерСтроки;
		Если РассчитыватьСледующуюДатуОтПредыдущей Тогда
			Строка.КоличествоДней	= КоличествоДней;
		Иначе
			Строка.КоличествоДней	= СтрокаДней;
		КонецЕсли;
			
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Календарь",	Календарь);
	Запрос.УстановитьПараметр("ДатаОт",		ДатаОт);
	Запрос.УстановитьПараметр("Таблица",	ТаблицаДат);
	
	// Алгоритм работает следующим образом:
	//  Получаем для ДатаОт каким днем с начала года эта дата является
	//  К этому дню прибавляем количество дней с начала года, которое должно быть у конечной даты
	//  Получаем максимальный номер дня в году для этого года
	//  Проверяем, не превышает ли полученное число количество дней
	//  Если превышает, используем следующий год, если нет, то текущий
	//  Ищем, минимальную дату, которая соответствует нужному нам дню в году
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.ИндексСтроки КАК ИндексСтроки,
	|	Таблица.КоличествоДней КАК КоличествоДней
	|ПОМЕСТИТЬ ВТПриращениеДней
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КалендарныеГрафики.Год,
	|	МАКСИМУМ(КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода) КАК ДнейВГрафике
	|ПОМЕСТИТЬ ВТКоличествоДнейВГрафикеПоГодам
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.ДатаГрафика >= &ДатаОт
	|	И КалендарныеГрафики.Календарь = &Календарь
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|
	|СГРУППИРОВАТЬ ПО
	|	КалендарныеГрафики.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КоличествоДнейВГрафикеПоГодам.Год,
	|	СУММА(ЕСТЬNULL(КоличествоДнейПредыдущихГодов.ДнейВГрафике, 0)) КАК ДнейВГрафике
	|ПОМЕСТИТЬ ВТКоличествоДнейСУчетомПредыдущихГодов
	|ИЗ
	|	ВТКоличествоДнейВГрафикеПоГодам КАК КоличествоДнейВГрафикеПоГодам
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТКоличествоДнейВГрафикеПоГодам КАК КоличествоДнейПредыдущихГодов
	|		ПО (КоличествоДнейПредыдущихГодов.Год < КоличествоДнейВГрафикеПоГодам.Год)
	|
	|СГРУППИРОВАТЬ ПО
	|	КоличествоДнейВГрафикеПоГодам.Год
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода) КАК КоличествоДнейВГрафикеСНачалаГода
	|ПОМЕСТИТЬ ВТКоличествоДнейВГрафикеНаДатуОтсчета
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.ДатаГрафика >= &ДатаОт
	|	И КалендарныеГрафики.Год = ГОД(&ДатаОт)
	|	И КалендарныеГрафики.Календарь = &Календарь
	|	И КалендарныеГрафики.ДеньВключенВГрафик
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПриращениеДней.ИндексСтроки,
	|	ЕСТЬNULL(КалендарныеГрафики.ДатаГрафика, НЕОПРЕДЕЛЕНО) КАК ДатаПоКалендарю
	|ИЗ
	|	ВТПриращениеДней КАК ПриращениеДней
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКоличествоДнейВГрафикеНаДатуОтсчета КАК КоличествоДнейВГрафикеНаДатуОтсчета
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКоличествоДнейСУчетомПредыдущихГодов КАК КоличествоДнейСУчетомПредыдущихГодов
	|			ПО (КоличествоДнейСУчетомПредыдущихГодов.Год = КалендарныеГрафики.Год)
	|		ПО (КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода = КоличествоДнейВГрафикеНаДатуОтсчета.КоличествоДнейВГрафикеСНачалаГода - КоличествоДнейСУчетомПредыдущихГодов.ДнейВГрафике + ПриращениеДней.КоличествоДней)
	|			И (КалендарныеГрафики.ДатаГрафика >= &ДатаОт)
	|			И (КалендарныеГрафики.Календарь = &Календарь)
	|			И (КалендарныеГрафики.ДеньВключенВГрафик)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПриращениеДней.ИндексСтроки";
	Выборка = Запрос.Выполнить().Выбрать();
	
	МассивДат = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДатаПоКалендарю = Неопределено Тогда
			СообщениеОбОшибке = НСтр("ru = 'Календарь ""%1"" не заполнен с даты %2 на указанное количество рабочих дней.'");
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				СообщениеОбОшибке,
				Календарь, Формат(ДатаОт, "ДЛФ=D"));
		КонецЕсли;
		
		МассивДат.Добавить(Выборка.ДатаПоКалендарю);
	КонецЦикла;
	
	Возврат МассивДат;
	
КонецФункции

// Функция возвращает дату, которая отличается указанной даты на количество дней,
// входящих в указанный график
//
// Параметры
//	Календарь		- календарь, который необходимо использовать, тип СправочникСсылка.Календари
//	ДатаОт			- дата, от которой нужно рассчитать количество дней, тип Дата
//	КоличествоДней	- количество дней, на которые нужно увеличить дату начала, тип Число
//
// Возвращаемое значение
//	Дата			- дата, увеличенная на количество дней, входящих в график
//
Функция ПолучитьДатуПоКалендарю(Знач Календарь, Знач ДатаОт, Знач КоличествоДней) Экспорт
	
	ДатаОт = НачалоДня(ДатаОт);
	
	Если КоличествоДней = 0 Тогда
		Возврат ДатаОт;
	КонецЕсли;
	
	МассивДней = Новый Массив;
	МассивДней.Добавить(КоличествоДней);
	
	МассивДат = ПолучитьМассивДатПоКалендарю(Календарь, ДатаОт, МассивДней);
	
	Возврат МассивДат[0];
	
КонецФункции

// Функция определяет количество дней, входящих в календарь, для указанного периода
//
// Параметры
//	Календарь		- календарь, который необходимо использовать, тип СправочникСсылка.Календари
//	ДатаНачала		- дата начала периода
//	ДатаОкончания	- дата окончания периода
//
// Возвращаемое значение
//	Число		- количество дней между датами начала и окончания
//
Функция ПолучитьРазностьДатПоКалендарю(Знач Календарь, Знач ДатаНачала, Знач ДатаОкончания) Экспорт
	
	ДатаНачала		= НачалоДня(ДатаНачала);
	ДатаОкончания	= НачалоДня(ДатаОкончания);
	
	Если ДатаНачала = ДатаОкончания Тогда
		Возврат 0;
	КонецЕсли;
	
	РазныеГода = Год(ДатаНачала) <> Год(ДатаОкончания);
	
	Запрос = Новый Запрос;
	
	МассивДатНачала = Новый Массив;
	МассивДатНачала.Добавить(ДатаНачала);
	Если РазныеГода Тогда
		МассивДатНачала.Добавить(НачалоДня(КонецГода(ДатаНачала)));
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Календарь",			Календарь);
	Запрос.УстановитьПараметр("МассивДатНачала",	МассивДатНачала);
	Запрос.УстановитьПараметр("ГодДатыНачала",		Год(ДатаНачала));
	
	Запрос.УстановитьПараметр("ДатаОкончания",		ДатаОкончания);
	Запрос.УстановитьПараметр("ГодДатыОкончания",	Год(ДатаОкончания));
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КалендарныеГрафики.КоличествоДнейВГрафикеСНачалаГода КАК КоличествоДней,
	|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Календарь = &Календарь
	|	И (КалендарныеГрафики.Год = &ГодДатыНачала
	|				И КалендарныеГрафики.ДатаГрафика В (&МассивДатНачала)
	|			ИЛИ КалендарныеГрафики.Год = &ГодДатыОкончания
	|				И КалендарныеГрафики.ДатаГрафика = &ДатаОкончания)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДатаГрафика";
	ТаблицаДней = Запрос.Выполнить().Выгрузить();
	
	Если НачалоДня(КонецГода(ДатаНачала)) = ДатаНачала Тогда 
		НоваяСтрока = ТаблицаДней.Вставить(1);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТаблицаДней[0]);
	КонецЕсли;
	
	Если ТаблицаДней.Количество() < ?(РазныеГода, 3, 2) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Календарь ""%1"" не заполнен на период %2.'");
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СообщениеОбОшибке,
			Календарь, ПредставлениеПериода(ДатаНачала, КонецДня(ДатаОкончания)));
	КонецЕсли;
	
	КоличествоДнейДатыНачала = ТаблицаДней[0].КоличествоДней;
	КоличествоДнейДатыОкончания = ТаблицаДней[?(РазныеГода, 2, 1)].КоличествоДней + ?(РазныеГода, ТаблицаДней[1].КоличествоДней, 0);
	
	Возврат КоличествоДнейДатыОкончания - КоличествоДнейДатыНачала;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБНОВЛЕНИЕ ИНФОРМАЦИОННОЙ БАЗЫ

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"КалендарныеГрафики");
	
КонецПроцедуры

// Объявляет служебные события подсистемы КалендарныеГрафики:
// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииСлужебныхСобытий(КлиентскиеСобытия, СерверныеСобытия) Экспорт
	
	
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
		
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.6.2";
	Обработчик.Процедура = "КалендарныеГрафики.СоздатьПроизводственныйКалендарьНа2010Год";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.1.1.6";
	Обработчик.Процедура = "КалендарныеГрафики.СоздатьПроизводственныйКалендарьНа2011Год";
	
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.2.2.5";
	Обработчик.Процедура = "КалендарныеГрафики.ПеренестиВыходныеДниМая2012Года";
	
КонецПроцедуры

// См. одноименную процедуру в общем модуле ПользователиПереопределяемый.
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	
КонецПроцедуры

// Процедура заполняет регистр сведений Календарные графики за указанный год
//
// Параметры
//	НомерГода		- число, номер года, за который необходимо заполнить регистр
//	РабочиеДни		- массив, дни, приходящиеся на выходные, которые следует считать рабочими
//	ПраздничныеДни	- массив, дни, приходящиеся на рабочие, которые следует считать выходными
//
// Возвращаемое значение
//	Нет
//
Процедура ЗаполнитьКалендарныйГрафик(НомерГода, РабочиеДни, ПраздничныеДни, ЭтоОбновление = Ложь)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Календари.Ссылка
	|ИЗ
	|	Справочник.Календари КАК Календари
	|ГДЕ
	|	Календари.Наименование = &НаименованиеКалендаря";
	
	НаименованиеКалендаря = НСтр("ru = 'Производственный календарь'");
	Запрос.Параметры.Вставить("НаименованиеКалендаря", НаименованиеКалендаря);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ПроизводственныйКалендарь = Выборка.Ссылка;
		
	Иначе
		ПроизводственныйКалендарь = Справочники.Календари.СоздатьЭлемент();
		ПроизводственныйКалендарь.Наименование = НаименованиеКалендаря;
		ПроизводственныйКалендарь.Записать();
		
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.КалендарныеГрафики.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Календарь.Установить(ПроизводственныйКалендарь.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(НомерГода);
	
	КоличествоРабочихДнейСНачалаГода = 0;
	
	Для НомерМесяца = 1 По 12 Цикл
		Для НомерДня = 1 По День(КонецМесяца(Дата(НомерГода, НомерМесяца, 1))) Цикл
			ДатаГрафика = Дата(НомерГода, НомерМесяца, НомерДня);
			
			ДеньВключенВГрафик = ПраздничныеДни.Найти(ДатаГрафика) = Неопределено
				И (РабочиеДни.Найти(ДатаГрафика) <> Неопределено ИЛИ ДеньНедели(ДатаГрафика) <= 5);
			
			Если ДеньВключенВГрафик Тогда
				КоличествоРабочихДнейСНачалаГода = КоличествоРабочихДнейСНачалаГода + 1;
			КонецЕсли;
			
			Строка = НаборЗаписей.Добавить();
			Строка.Календарь							= ПроизводственныйКалендарь.Ссылка;
			Строка.Год									= НомерГода;
			Строка.ДатаГрафика							= ДатаГрафика;
			Строка.ДеньВключенВГрафик					= ДеньВключенВГрафик;
			Строка.КоличествоДнейВГрафикеСНачалаГода	= КоличествоРабочихДнейСНачалаГода;
		КонецЦикла;
	КонецЦикла;
	
	Если ЭтоОбновление Тогда
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(НаборЗаписей);
	Иначе
		НаборЗаписей.Записать(Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2010 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
Процедура СоздатьПроизводственныйКалендарьНа2010Год() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2010";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2010 год
	
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2010, 1, 1));
	ПраздничныеДни.Добавить(Дата(2010, 1, 2));
	ПраздничныеДни.Добавить(Дата(2010, 1, 3));
	ПраздничныеДни.Добавить(Дата(2010, 1, 4));
	ПраздничныеДни.Добавить(Дата(2010, 1, 5));
	ПраздничныеДни.Добавить(Дата(2010, 1, 7));
	ПраздничныеДни.Добавить(Дата(2010, 2, 23));
	ПраздничныеДни.Добавить(Дата(2010, 3, 8));
	ПраздничныеДни.Добавить(Дата(2010, 5, 1));
	ПраздничныеДни.Добавить(Дата(2010, 5, 9));
	ПраздничныеДни.Добавить(Дата(2010, 6, 12));
	ПраздничныеДни.Добавить(Дата(2010, 11, 4));
	
	// Переносы праздников с выходных дней
	ПраздничныеДни.Добавить(Дата(2010, 1, 6));
	ПраздничныеДни.Добавить(Дата(2010, 1, 8));
	ПраздничныеДни.Добавить(Дата(2010, 2, 22));
	РабочиеДни.Добавить(Дата(2010, 2, 27));
	ПраздничныеДни.Добавить(Дата(2010, 5, 3));
	ПраздничныеДни.Добавить(Дата(2010, 5, 10));
	ПраздничныеДни.Добавить(Дата(2010, 6, 14));
	ПраздничныеДни.Добавить(Дата(2010, 11, 5));
	РабочиеДни.Добавить(Дата(2010, 11, 7));
	
	ЗаполнитьКалендарныйГрафик(2010, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2011 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
Процедура СоздатьПроизводственныйКалендарьНа2011Год() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2011";
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2011 год
	
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2011, 1, 1));
	ПраздничныеДни.Добавить(Дата(2011, 1, 2));
	ПраздничныеДни.Добавить(Дата(2011, 1, 3));
	ПраздничныеДни.Добавить(Дата(2011, 1, 4));
	ПраздничныеДни.Добавить(Дата(2011, 1, 5));
	ПраздничныеДни.Добавить(Дата(2011, 1, 7));
	ПраздничныеДни.Добавить(Дата(2011, 2, 23));
	ПраздничныеДни.Добавить(Дата(2011, 3, 8));
	ПраздничныеДни.Добавить(Дата(2011, 5, 1));
	ПраздничныеДни.Добавить(Дата(2011, 5, 9));
	ПраздничныеДни.Добавить(Дата(2011, 6, 12));
	ПраздничныеДни.Добавить(Дата(2011, 11, 4));
	
	// Переносы праздников с выходных дней
	ПраздничныеДни.Добавить(Дата(2011, 1, 6));
	ПраздничныеДни.Добавить(Дата(2011, 1, 10));
	ПраздничныеДни.Добавить(Дата(2011, 5, 2));
	ПраздничныеДни.Добавить(Дата(2011, 6, 13));
	
	ЗаполнитьКалендарныйГрафик(2011, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2012 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2012 год 
//
Процедура СоздатьПроизводственныйКалендарьНа2012Год(Замещать = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2012";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2012 год
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2012, 1, 1));
	ПраздничныеДни.Добавить(Дата(2012, 1, 2));
	ПраздничныеДни.Добавить(Дата(2012, 1, 3));
	ПраздничныеДни.Добавить(Дата(2012, 1, 4));
	ПраздничныеДни.Добавить(Дата(2012, 1, 5));
	ПраздничныеДни.Добавить(Дата(2012, 1, 7));
	ПраздничныеДни.Добавить(Дата(2012, 2, 23));
	ПраздничныеДни.Добавить(Дата(2012, 3, 8));
	ПраздничныеДни.Добавить(Дата(2012, 5, 1));
	ПраздничныеДни.Добавить(Дата(2012, 5, 9));
	ПраздничныеДни.Добавить(Дата(2012, 6, 12));
	ПраздничныеДни.Добавить(Дата(2012, 11, 4));
	
	// Переносы праздников с выходных дней
	ПраздничныеДни.Добавить(Дата(2012, 1, 6));
	ПраздничныеДни.Добавить(Дата(2012, 1, 9));
	ПраздничныеДни.Добавить(Дата(2012, 3, 9));
	РабочиеДни.Добавить(Дата(2012, 3, 11));
	ПраздничныеДни.Добавить(Дата(2012, 4, 30));
	РабочиеДни.Добавить(Дата(2012, 4, 28));
	ПраздничныеДни.Добавить(Дата(2012, 6, 11));
	РабочиеДни.Добавить(Дата(2012, 6, 9));
	ПраздничныеДни.Добавить(Дата(2012, 11, 5));
	ПраздничныеДни.Добавить(Дата(2012, 12, 31));
	РабочиеДни.Добавить(Дата(2012, 12, 29));
	
	ЗаполнитьКалендарныйГрафик(2012, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура выполняет перенос праздничных дней в мае 2012 года 
// в соответствии с Постановлением Правительства РФ от 15 марта 2012 г. N 201
//
Процедура ПеренестиВыходныеДниМая2012Года() Экспорт
	
	// Перенос дней осуществляется только в том случае, 
	// если календарь полностью соответствует состоянию 
	// на момент заполнения данными 2012 года
	
	ПроизводственныйКалендарь = Справочники.Календари.НайтиПоНаименованию("Производственный календарь");
	Если Не ЗначениеЗаполнено(ПроизводственныйКалендарь) Тогда
		Возврат;
	КонецЕсли;

	РабочиеДни = Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(ПроизводственныйКалендарь, 2012);
	
	// Состояние заполненности производственного календаря на 2012 год
	НачатьТранзакцию();
	СоздатьПроизводственныйКалендарьНа2012Год(Истина);
	РабочиеДни2012 = Справочники.Календари.ПрочитатьДанныеГрафикаИзРегистра(ПроизводственныйКалендарь, 2012);
	ОтменитьТранзакцию();
	
	Если Не ОбщегоНазначенияКлиентСервер.СпискиЗначенийИдентичны(РабочиеДни, РабочиеДни2012) Тогда
		// В календаре есть изменения - перенос дней не осуществляется
		Возврат;
	КонецЕсли;
	
	// Выполняется перенос выходных дней:
	// - с 5 мая на 7 мая,
	// - с 12 мая на 8 мая
	
	// При этом необходимо перезаполнить поле "КоличествоДнейВГрафикеСНачалаГода" 
	// за период с 5 по 12 мая
	
	ПоляЗаписиКалендаря = "Календарь, Год, ДатаГрафика, ДеньВключенВГрафик, КоличествоДнейВГрафикеСНачалаГода";
	
	ЗаписиКалендаря = Новый Массив;
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 5), Истина, 82));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 6), Ложь, 82));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 7), Ложь, 82));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 8), Ложь, 82));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 9), Ложь, 82));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 10), Истина, 83));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 11), Истина, 84));
	ЗаписиКалендаря.Добавить(Новый Структура(ПоляЗаписиКалендаря, ПроизводственныйКалендарь, 2012, Дата(2012, 5, 12), Истина, 85));
	
	Для Каждого ДанныеЗаписи Из ЗаписиКалендаря Цикл
		ЗаписьКалендаря = РегистрыСведений.КалендарныеГрафики.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(ЗаписьКалендаря, ДанныеЗаписи);
		ЗаписьКалендаря.Прочитать();
		ЗаполнитьЗначенияСвойств(ЗаписьКалендаря, ДанныеЗаписи);
		ЗаписьКалендаря.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2013 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2013 год 
//
Процедура СоздатьПроизводственныйКалендарьНа2013Год(Замещать = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2013";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2013 год
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2013, 1, 1));
	ПраздничныеДни.Добавить(Дата(2013, 1, 2));
	ПраздничныеДни.Добавить(Дата(2013, 1, 3));
	ПраздничныеДни.Добавить(Дата(2013, 1, 4));
	ПраздничныеДни.Добавить(Дата(2013, 1, 5));
	ПраздничныеДни.Добавить(Дата(2013, 1, 6));
	ПраздничныеДни.Добавить(Дата(2013, 1, 7));
	ПраздничныеДни.Добавить(Дата(2013, 1, 8));
	
	ПраздничныеДни.Добавить(Дата(2013, 3, 8));
	
	ПраздничныеДни.Добавить(Дата(2013, 5, 1));
	ПраздничныеДни.Добавить(Дата(2013, 5, 2));
	ПраздничныеДни.Добавить(Дата(2013, 5, 3));
	
	ПраздничныеДни.Добавить(Дата(2013, 5, 9));
	ПраздничныеДни.Добавить(Дата(2013, 5, 10));
	
	ПраздничныеДни.Добавить(Дата(2013, 6, 12));
	ПраздничныеДни.Добавить(Дата(2013, 11, 4));
	
	ЗаполнитьКалендарныйГрафик(2013, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2014 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2014 год 
//
Процедура СоздатьПроизводственныйКалендарьНа2014Год(Замещать = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2014";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2014 год
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2014, 1, 1));
	ПраздничныеДни.Добавить(Дата(2014, 1, 2));
	ПраздничныеДни.Добавить(Дата(2014, 1, 3));
	ПраздничныеДни.Добавить(Дата(2014, 1, 4));
	ПраздничныеДни.Добавить(Дата(2014, 1, 5));
	ПраздничныеДни.Добавить(Дата(2014, 1, 6));
	ПраздничныеДни.Добавить(Дата(2014, 1, 7));
	ПраздничныеДни.Добавить(Дата(2014, 1, 8));
	
	ПраздничныеДни.Добавить(Дата(2014, 3, 10));
	
	ПраздничныеДни.Добавить(Дата(2014, 5, 1));
	ПраздничныеДни.Добавить(Дата(2014, 5, 2));
	ПраздничныеДни.Добавить(Дата(2014, 5, 9));
	
	ПраздничныеДни.Добавить(Дата(2014, 6, 12));
	ПраздничныеДни.Добавить(Дата(2014, 6, 13));
	
	ПраздничныеДни.Добавить(Дата(2014, 11, 3));
	ПраздничныеДни.Добавить(Дата(2014, 11, 4));
	
	ЗаполнитьКалендарныйГрафик(2014, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2015 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2015 год 
//
Процедура СоздатьПроизводственныйКалендарьНа2015Год(Замещать = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2015";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2015 год
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2015, 1, 1));
	ПраздничныеДни.Добавить(Дата(2015, 1, 2));
	ПраздничныеДни.Добавить(Дата(2015, 1, 3));
	ПраздничныеДни.Добавить(Дата(2015, 1, 4));
	ПраздничныеДни.Добавить(Дата(2015, 1, 5));
	ПраздничныеДни.Добавить(Дата(2015, 1, 6));
	ПраздничныеДни.Добавить(Дата(2015, 1, 7));
	ПраздничныеДни.Добавить(Дата(2015, 1, 8));
	ПраздничныеДни.Добавить(Дата(2015, 1, 9));
	
	ПраздничныеДни.Добавить(Дата(2015, 2, 23));
	ПраздничныеДни.Добавить(Дата(2015, 3, 9));
	
	ПраздничныеДни.Добавить(Дата(2015, 5, 1));
	ПраздничныеДни.Добавить(Дата(2015, 5, 4));
	ПраздничныеДни.Добавить(Дата(2015, 5, 11));
	
	ПраздничныеДни.Добавить(Дата(2015, 6, 12));
	ПраздничныеДни.Добавить(Дата(2015, 11, 4));
	
	ЗаполнитьКалендарныйГрафик(2015, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2016 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2016 год 
//
Процедура СоздатьПроизводственныйКалендарьНа2016Год(Замещать = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.Календарь
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2016";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2016 год
	РабочиеДни = Новый Массив;
	ПраздничныеДни = Новый Массив;
	
	// праздники РФ
	ПраздничныеДни.Добавить(Дата(2016, 1, 1));
	ПраздничныеДни.Добавить(Дата(2016, 1, 2));
	ПраздничныеДни.Добавить(Дата(2016, 1, 3));
	ПраздничныеДни.Добавить(Дата(2016, 1, 4));
	ПраздничныеДни.Добавить(Дата(2016, 1, 5));
	ПраздничныеДни.Добавить(Дата(2016, 1, 6));
	ПраздничныеДни.Добавить(Дата(2016, 1, 7));
	ПраздничныеДни.Добавить(Дата(2016, 1, 8));
	
	РабочиеДни.Добавить(Дата(2016, 2, 20));
	ПраздничныеДни.Добавить(Дата(2016, 2, 22));
	ПраздничныеДни.Добавить(Дата(2016, 2, 23));
	
	ПраздничныеДни.Добавить(Дата(2016, 3, 7));
	ПраздничныеДни.Добавить(Дата(2016, 3, 8));
	
	ПраздничныеДни.Добавить(Дата(2016, 5, 2));
	ПраздничныеДни.Добавить(Дата(2016, 5, 3));
	ПраздничныеДни.Добавить(Дата(2016, 5, 9));
	
	ПраздничныеДни.Добавить(Дата(2016, 6, 13));
	
	ПраздничныеДни.Добавить(Дата(2016, 11, 4));
	
	ЗаполнитьКалендарныйГрафик(2016, РабочиеДни, ПраздничныеДни);
	
КонецПроцедуры

// Процедура создает в справочнике Календари календарь на 2017 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год.
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2017 год.
//
Процедура СоздатьПроизводственныйКалендарьНа2017Год(Замещать = Ложь, ЭтоОбновление = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.ДатаГрафика
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2017
	|	И (ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) >= 6
	|				И КалендарныеГрафики.ДеньВключенВГрафик
	|			ИЛИ ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) < 6
	|				И НЕ КалендарныеГрафики.ДеньВключенВГрафик)";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2017 год
	РабочиеДни = Новый Массив;
	
	ПраздничныеДни = ПраздничныеДни2017();
	
	ЗаполнитьКалендарныйГрафик(2017, РабочиеДни, ПраздничныеДни, ЭтоОбновление);
	
КонецПроцедуры

// Возвращает массив праздничных дней 2017 года.
//
Функция ПраздничныеДни2017()
	
	ПраздничныеДни = Новый Массив;
	
	ПраздничныеДни.Добавить(Дата(2017, 1, 1));
	ПраздничныеДни.Добавить(Дата(2017, 1, 2));
	ПраздничныеДни.Добавить(Дата(2017, 1, 3));
	ПраздничныеДни.Добавить(Дата(2017, 1, 4));
	ПраздничныеДни.Добавить(Дата(2017, 1, 5));
	ПраздничныеДни.Добавить(Дата(2017, 1, 6));
	ПраздничныеДни.Добавить(Дата(2017, 1, 7));
	ПраздничныеДни.Добавить(Дата(2017, 1, 8));
	
	ПраздничныеДни.Добавить(Дата(2017, 2, 23));
	ПраздничныеДни.Добавить(Дата(2017, 2, 24));
	
	ПраздничныеДни.Добавить(Дата(2017, 3, 8));
	
	ПраздничныеДни.Добавить(Дата(2017, 5, 1));
	ПраздничныеДни.Добавить(Дата(2017, 5, 8));
	ПраздничныеДни.Добавить(Дата(2017, 5, 9));
	
	ПраздничныеДни.Добавить(Дата(2017, 6, 12));
	
	ПраздничныеДни.Добавить(Дата(2017, 11, 4));
	ПраздничныеДни.Добавить(Дата(2017, 11, 6));
	
	Возврат ПраздничныеДни;
	
КонецФункции

// Процедура создает в справочнике Календари календарь на 2019 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год.
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2019 год.
//
Процедура СоздатьПроизводственныйКалендарьНа2019Год(Замещать = Ложь, ЭтоОбновление = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.ДатаГрафика
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2019
	|	И (ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) >= 6
	|				И КалендарныеГрафики.ДеньВключенВГрафик
	|			ИЛИ ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) < 6
	|				И НЕ КалендарныеГрафики.ДеньВключенВГрафик)";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2019 год
	РабочиеДни = Новый Массив;
	
	ПраздничныеДни = ПраздничныеДни2019();
	
	ЗаполнитьКалендарныйГрафик(2019, РабочиеДни, ПраздничныеДни, ЭтоОбновление);
	
КонецПроцедуры

// Возвращает массив праздничных дней 2019 года.
//
Функция ПраздничныеДни2019()
	
	ПраздничныеДни = Новый Массив;
	
	ПраздничныеДни.Добавить(Дата(2019, 1, 1));
	ПраздничныеДни.Добавить(Дата(2019, 1, 2));
	ПраздничныеДни.Добавить(Дата(2019, 1, 3));
	ПраздничныеДни.Добавить(Дата(2019, 1, 4));
	ПраздничныеДни.Добавить(Дата(2019, 1, 5));
	ПраздничныеДни.Добавить(Дата(2019, 1, 6));
	ПраздничныеДни.Добавить(Дата(2019, 1, 7));
	ПраздничныеДни.Добавить(Дата(2019, 1, 8));
	
	ПраздничныеДни.Добавить(Дата(2019, 2, 23));
	ПраздничныеДни.Добавить(Дата(2019, 2, 24));
	
	ПраздничныеДни.Добавить(Дата(2019, 3, 8));
	ПраздничныеДни.Добавить(Дата(2019, 3, 9));
	ПраздничныеДни.Добавить(Дата(2019, 3, 10));
	
	ПраздничныеДни.Добавить(Дата(2019, 5, 1));
	ПраздничныеДни.Добавить(Дата(2019, 5, 2));
	ПраздничныеДни.Добавить(Дата(2019, 5, 3));
	ПраздничныеДни.Добавить(Дата(2019, 5, 4));
	ПраздничныеДни.Добавить(Дата(2019, 5, 5));
	
	ПраздничныеДни.Добавить(Дата(2019, 5, 9));
	ПраздничныеДни.Добавить(Дата(2019, 5, 10));
	ПраздничныеДни.Добавить(Дата(2019, 5, 11));
	ПраздничныеДни.Добавить(Дата(2019, 5, 12));
	
	ПраздничныеДни.Добавить(Дата(2019, 6, 12));
	
	ПраздничныеДни.Добавить(Дата(2019, 11, 4));
	
	Возврат ПраздничныеДни;
	
КонецФункции

// Процедура создает в справочнике Календари календарь на 2020 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год.
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2019 год.
//
Процедура СоздатьПроизводственныйКалендарьНа2020Год(Замещать = Ложь, ЭтоОбновление = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КалендарныеГрафики.ДатаГрафика
	|ИЗ
	|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
	|ГДЕ
	|	КалендарныеГрафики.Год = 2020
	|	И (ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) >= 6
	|				И КалендарныеГрафики.ДеньВключенВГрафик
	|			ИЛИ ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) < 6
	|				И НЕ КалендарныеГрафики.ДеньВключенВГрафик)";
	
	Если Не Замещать И Не Запрос.Выполнить().Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	// Записываем данные за 2020 год
	РабочиеДни = Новый Массив;
	
	ПраздничныеДни = ПраздничныеДни2020();
	
	ЗаполнитьКалендарныйГрафик(2020, РабочиеДни, ПраздничныеДни, ЭтоОбновление);
	
КонецПроцедуры

// Возвращает массив праздничных дней 2020 года.
//
Функция ПраздничныеДни2020()
	
	ПраздничныеДни = Новый Массив;
	
	ПраздничныеДни.Добавить(Дата(2020, 1, 1));
	ПраздничныеДни.Добавить(Дата(2020, 1, 2));
	ПраздничныеДни.Добавить(Дата(2020, 1, 3));
	ПраздничныеДни.Добавить(Дата(2020, 1, 4));
	ПраздничныеДни.Добавить(Дата(2020, 1, 5));
	ПраздничныеДни.Добавить(Дата(2020, 1, 6));
	ПраздничныеДни.Добавить(Дата(2020, 1, 7));
	ПраздничныеДни.Добавить(Дата(2020, 1, 8));
	
	ПраздничныеДни.Добавить(Дата(2020, 2, 23));
	ПраздничныеДни.Добавить(Дата(2020, 2, 24));
	
	ПраздничныеДни.Добавить(Дата(2020, 3, 8));
	ПраздничныеДни.Добавить(Дата(2020, 3, 9));
	
	ПраздничныеДни.Добавить(Дата(2020, 5, 1));
	ПраздничныеДни.Добавить(Дата(2020, 5, 2));
	ПраздничныеДни.Добавить(Дата(2020, 5, 3));
	ПраздничныеДни.Добавить(Дата(2020, 5, 4));
	ПраздничныеДни.Добавить(Дата(2020, 5, 5));
	
	ПраздничныеДни.Добавить(Дата(2020, 5, 9));
	ПраздничныеДни.Добавить(Дата(2020, 5, 10));
	ПраздничныеДни.Добавить(Дата(2020, 5, 11));
	
	ПраздничныеДни.Добавить(Дата(2020, 6, 12));
	
	ПраздничныеДни.Добавить(Дата(2020, 11, 4));
	
	Возврат ПраздничныеДни;
	
КонецФункции

// Процедура создает в справочнике Календари календарь на 2021 год, соответствующий производственному
// календарю Российской Федерации, если в справочнике нет ни одного календаря за этот год.
//
// Параметры:
//	Замещать - булево, если Истина, запись производится вне зависимости от наличия данных за 2021 год.
//
Процедура СоздатьПроизводственныйКалендарьНа2021Год(Замещать = Ложь, ЭтоОбновление = Ложь) Экспорт
	
	Если Не Замещать И ПроизводственныйКалендарьСуществует(2021) Тогда
		Возврат;
	КонецЕсли;

	// Записываем данные за 2021 год
	РабочиеДни = Новый Массив;
	РабочиеДни.Добавить(Дата(2021, 2, 20));
	
	ПраздничныеДни = ПраздничныеДни2021();
	
	ЗаполнитьКалендарныйГрафик(2021, РабочиеДни, ПраздничныеДни, ЭтоОбновление);
	
КонецПроцедуры

// Возвращает массив праздничных дней 2021 года.
//
Функция ПраздничныеДни2021()
	
	ПраздничныеДни = Новый Массив;
	
	ПраздничныеДни.Добавить(Дата(2021, 1, 1));
	ПраздничныеДни.Добавить(Дата(2021, 1, 2));
	ПраздничныеДни.Добавить(Дата(2021, 1, 3));
	ПраздничныеДни.Добавить(Дата(2021, 1, 4));
	ПраздничныеДни.Добавить(Дата(2021, 1, 5));
	ПраздничныеДни.Добавить(Дата(2021, 1, 6));
	ПраздничныеДни.Добавить(Дата(2021, 1, 7));
	ПраздничныеДни.Добавить(Дата(2021, 1, 8));
	ПраздничныеДни.Добавить(Дата(2021, 1, 9));
	ПраздничныеДни.Добавить(Дата(2021, 1, 10));
	
	ПраздничныеДни.Добавить(Дата(2021, 2, 22));
	ПраздничныеДни.Добавить(Дата(2021, 2, 23));
	
	ПраздничныеДни.Добавить(Дата(2021, 3, 8));
	
	ПраздничныеДни.Добавить(Дата(2021, 5, 1));
	ПраздничныеДни.Добавить(Дата(2021, 5, 2));
	ПраздничныеДни.Добавить(Дата(2021, 5, 3));
	
	ПраздничныеДни.Добавить(Дата(2021, 5, 8));
	ПраздничныеДни.Добавить(Дата(2021, 5, 9));
	ПраздничныеДни.Добавить(Дата(2021, 5, 10));
	
	ПраздничныеДни.Добавить(Дата(2021, 6, 12));
	ПраздничныеДни.Добавить(Дата(2021, 6, 13));
	ПраздничныеДни.Добавить(Дата(2021, 6, 14));
	
	ПраздничныеДни.Добавить(Дата(2021, 11, 4));
	ПраздничныеДни.Добавить(Дата(2021, 11, 5));
	
	ПраздничныеДни.Добавить(Дата(2021, 12, 31));
	
	Возврат ПраздничныеДни;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

// См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов.
// 
// Параметры:
// 	Классификаторы - См. РаботаСКлассификаторамиПереопределяемый.ПриДобавленииКлассификаторов.Классификаторы
// 	ОписаниеКлассификатора - Строка -  
// 
Процедура ПриДобавленииКлассификаторов(Классификаторы) Экспорт
	
КонецПроцедуры

// См. РаботаСКлассификаторамиПереопределяемый.ПриЗагрузкеКлассификатора.
Процедура ПриЗагрузкеКлассификатора(Идентификатор, Версия, Адрес, Обработан, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

// Конец ИнтернетПоддержкаПользователей.РаботаСКлассификаторами

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет, есть ли календарь за указанный год.
//
// Параметры:
//	Год - Число - проверяемый год.
//
// Возвращаемое значение:
//	Булево - Истина, если календарь существует.
//
Функция ПроизводственныйКалендарьСуществует(Год)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КалендарныеГрафики.ДатаГрафика КАК ДатаГрафика
		|ИЗ
		|	РегистрСведений.КалендарныеГрафики КАК КалендарныеГрафики
		|ГДЕ
		|	КалендарныеГрафики.Год = &Год
		|	И (ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) >= 6
		|				И КалендарныеГрафики.ДеньВключенВГрафик
		|			ИЛИ ДЕНЬНЕДЕЛИ(КалендарныеГрафики.ДатаГрафика) < 6
		|				И НЕ КалендарныеГрафики.ДеньВключенВГрафик)";
	Запрос.Параметры.Вставить("Год", Год);
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти
