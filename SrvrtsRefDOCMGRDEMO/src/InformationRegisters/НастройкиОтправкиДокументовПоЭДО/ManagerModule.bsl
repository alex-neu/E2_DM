
#Область СлужебныйПрограммныйИнтерфейс

// Возвращает настройки отправи внутненних документов по ЭДО.
// 
// Параметры:
//   Организация - Справочник.Организации - Организация для которой необходимо получить правила отправки.
//   Контрагент - Справочник.Контрагенты - Контрагент правил.
// 
// Возвращаемое значение:
//  Таблица значений:
//      * Отправитель - Справочник.Организации - Организация.
//      * Получатель - Справочник.Контрагенты - Контрагент.
//      * ВидДокумента - Справочник.ВидыВнутреннихДокументов - Вид внутреннего документа.
//      * Отправлять - Булево - возможно ли отправлять по ЭДО этот вид документов.
//      * ВидЭД - Перечисление.ВидыЭД - Вид ЭД, которым будет отправлен документ.
//      * ТипЭД - Перечисление.ТипыЭД - Тип ЭД, которым будет отправлен документ.
//      * ТребуетсяОтветнаяПодпись - Булево - Требовать ответную подпись.
//      * ТребуетсяИзвещениеОПолучении - Булево - Требовать извещение о получении.
Функция НастройкиОтправкиДокументовПоЭДО(Организация, Контрагент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОписаниеТипаБулево = Новый ОписаниеТипов("Булево");
	ОписаниеТипаСтрока = Новый ОписаниеТипов("Строка");
	
	ИсходящиеДокументы = Новый ТаблицаЗначений;
	
	ИсходящиеДокументы.Колонки.Добавить("Отправитель"                  , Метаданные.ОпределяемыеТипы.Организация.Тип);
	ИсходящиеДокументы.Колонки.Добавить("Получатель"                   , Метаданные.ОпределяемыеТипы.УчастникЭДО.Тип);
	ИсходящиеДокументы.Колонки.Добавить("ВидДокумента"                 , Новый ОписаниеТипов("СправочникСсылка.ВидыВнутреннихДокументов"));
	
	ИсходящиеДокументы.Колонки.Добавить("Отправлять"                   , ОписаниеТипаБулево);
	ИсходящиеДокументы.Колонки.Добавить("ВидЭД"                        , Новый ОписаниеТипов("ПеречислениеСсылка.ВидыЭД"));
	ИсходящиеДокументы.Колонки.Добавить("ТипЭД"                        , Новый ОписаниеТипов("ПеречислениеСсылка.ТипыЭД"));
	ИсходящиеДокументы.Колонки.Добавить("ТребуетсяОтветнаяПодпись"     , ОписаниеТипаБулево);
	ИсходящиеДокументы.Колонки.Добавить("ТребуетсяИзвещениеОПолучении" , ОписаниеТипаБулево);
	
	ВидыДокументов = ОбменСКонтрагентамиДОСлужебный.ВидыДокументовДляОтправкиПоЭДО();
	
	Для Каждого ВидДокумента Из ВидыДокументов Цикл
		НоваяСтрока = ИсходящиеДокументы.Добавить();
		
		НоваяСтрока.Отправитель = Организация;
		НоваяСтрока.Получатель = Контрагент;
		НоваяСтрока.ВидДокумента = ВидДокумента;
		
		НоваяСтрока.Отправлять = Ложь;
		НоваяСтрока.ВидЭД = Перечисления.ВидыЭД.ПустаяСсылка();
		НоваяСтрока.ТипЭД = Перечисления.ТипыЭД.Прочее;
		НоваяСтрока.ТребуетсяОтветнаяПодпись = Истина;
		НоваяСтрока.ТребуетсяИзвещениеОПолучении = Истина;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиОтправкиДокументовПоЭДО.ВидДокумента КАК ВидДокумента,
		|	НастройкиОтправкиДокументовПоЭДО.Отправлять КАК Отправлять,
		|	НастройкиОтправкиДокументовПоЭДО.ВидЭД КАК ВидЭД,
		|	НастройкиОтправкиДокументовПоЭДО.ТипЭД КАК ТипЭД,
		|	НастройкиОтправкиДокументовПоЭДО.ТребуетсяОтветнаяПодпись КАК ТребуетсяОтветнаяПодпись,
		|	НастройкиОтправкиДокументовПоЭДО.ТребуетсяИзвещениеОПолучении КАК ТребуетсяИзвещениеОПолучении
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиДокументовПоЭДО КАК НастройкиОтправкиДокументовПоЭДО
		|ГДЕ
		|	НастройкиОтправкиДокументовПоЭДО.Отправитель = &Организация
		|	И НастройкиОтправкиДокументовПоЭДО.Получатель = &Контрагент";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Отбор = Новый Структура("ВидДокумента", Выборка.ВидДокумента);
		СтрокиНастроек = ИсходящиеДокументы.НайтиСтроки(Отбор);
		
		Для Каждого СтрокаНастроек Из СтрокиНастроек Цикл
			ЗаполнитьЗначенияСвойств(СтрокаНастроек, Выборка, , "ВидДокумента");
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ИсходящиеДокументы;
	
КонецФункции

Функция НастройкиОтправкиВидаДокумента(Организация, Контрагент, ВидДокумента) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиОтправкиДокументовПоЭДО.ВидЭД КАК ВидЭД,
		|	НастройкиОтправкиДокументовПоЭДО.ТипЭД КАК ТипЭД,
		|	НастройкиОтправкиДокументовПоЭДО.ТребуетсяОтветнаяПодпись КАК ТребуетсяОтветнаяПодпись,
		|	НастройкиОтправкиДокументовПоЭДО.ТребуетсяИзвещениеОПолучении КАК ТребуетсяИзвещениеОПолучении
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиДокументовПоЭДО КАК НастройкиОтправкиДокументовПоЭДО
		|ГДЕ
		|	НастройкиОтправкиДокументовПоЭДО.Отправитель = &Организация
		|	И НастройкиОтправкиДокументовПоЭДО.Получатель = &Контрагент
		|	И НастройкиОтправкиДокументовПоЭДО.ВидДокумента = &ВидДокумента
		|	И НастройкиОтправкиДокументовПоЭДО.Отправлять";
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ВидДокумента", ВидДокумента);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		НастройкиОтправки = Новый Структура("ВидЭД, ТипЭД, ТребуетсяОтветнаяПодпись, ТребуетсяИзвещениеОПолучении");
		ЗаполнитьЗначенияСвойств(НастройкиОтправки, Выборка);
		
		Возврат НастройкиОтправки;
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции


#КонецОбласти