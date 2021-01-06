////////////////////////////////////////////////////////////////////////////////
// Подсистема "Организации".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает организацию по умолчанию.
// Если в ИБ есть только одна организация, которая не помечена на удаление и не является предопределенной,
// то будет возвращена ссылка на нее, иначе будет возвращена пустая ссылка.
//
// Возвращаемое значение:
//     СправочникСсылка.Организации - ссылка на организацию.
//
Функция ОрганизацияПоУмолчанию() Экспорт
	
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
	
КонецФункции

// Возвращает признак использования нескольких организаций.
Функция ИспользуетсяНесколькоОрганизаций() Экспорт
	
	Возврат ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Условные вызовы подсистем БСП.

// Определить объекты метаданных, в модулях менеджеров которых ограничивается возможность 
// редактирования реквизитов при групповом изменении.
//
// Параметры:
//   Объекты - Соответствие - в качестве ключа указать полное имя объекта метаданных,
//                            подключенного к подсистеме "Групповое изменение объектов". 
//                            Дополнительно в значении могут быть перечислены имена экспортных функций:
//                            "РеквизитыНеРедактируемыеВГрупповойОбработке",
//                            "РеквизитыРедактируемыеВГрупповойОбработке".
//                            Каждое имя должно начинаться с новой строки.
//                            Если указана пустая строка, значит в модуле менеджера определены обе функции.
//
Процедура ПриОпределенииОбъектовСРедактируемымиРеквизитами(Объекты) Экспорт
	Объекты.Вставить(Метаданные.Справочники.Организации.ПолноеИмя(), "РеквизитыНеРедактируемыеВГрупповойОбработке");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления"].Добавить(
		"ОрганизацииСлужебный");
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииВидовОграниченийПравОбъектовМетаданных"].Добавить(
			"ОрганизацииСлужебный");
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		СерверныеОбработчики["СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииВидовДоступа"].Добавить(
			"ОрганизацииСлужебный");
	КонецЕсли;
	
КонецПроцедуры

// Добавляет процедуры-обработчики обновления, необходимые данной подсистеме.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                  общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.1.3.16";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "Справочники.Организации.ОбновитьПредопределенныеВидыКонтактнойИнформацииОрганизаций";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "2.2.1.12";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.Процедура = "Справочники.Организации.ЗаполнитьКонстантуИспользоватьНесколькоОрганизаций";
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Заполняет состав видов доступа, используемых при ограничении прав объектов метаданных.
// Если состав видов доступа не заполнен, отчет "Права доступа" покажет некорректные сведения.
//
// Обязательно требуется заполнить только виды доступа, используемые
// в шаблонах ограничения доступа явно, а виды доступа, используемые
// в наборах значений доступа могут быть получены из текущего состояния
// регистра сведений НаборыЗначенийДоступа.
//
//  Для автоматической подготовки содержимого процедуры следует
// воспользоваться инструментами разработчика для подсистемы.
// Управление доступом.
//
// Параметры:
//  Описание     - Строка, многострочная строка формата <Таблица>.<Право>.<ВидДоступа>[.Таблица объекта].
//                 Например, Документ.ПриходнаяНакладная.Чтение.Организации
//                           Документ.ПриходнаяНакладная.Чтение.Контрагенты
//                           Документ.ПриходнаяНакладная.Изменение.Организации
//                           Документ.ПриходнаяНакладная.Изменение.Контрагенты
//                           Документ.ЭлектронныеПисьма.Чтение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.ЭлектронныеПисьма.Изменение.Объект.Документ.ЭлектронныеПисьма
//                           Документ.Файлы.Чтение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Чтение.Объект.Документ.ЭлектронноеПисьмо
//                           Документ.Файлы.Изменение.Объект.Справочник.ПапкиФайлов
//                           Документ.Файлы.Изменение.Объект.Документ.ЭлектронноеПисьмо
//                 Вид доступа Объект предопределен, как литерал, его нет в предопределенных элементах.
//                 ПланыВидовХарактеристик.ВидыДоступа. Этот вид доступа используется в шаблонах ограничений доступа,
//                 как "ссылка" на другой объект, по которому ограничивается таблица.
//                 Когда вид доступа "Объект" задан, также требуется задать типы таблиц, которые используются
//                 для этого вида доступа. Т.е. перечислить типы, которые соответствующие полю,
//                 использованному в шаблоне ограничения доступа в паре с видом доступа "Объект".
//                 При перечислении типов по виду доступа "Объект" нужно перечислить только те типы поля,
//                 которые есть у поля РегистрыСведений.НаборыЗначенийДоступа.Объект, остальные типы лишние.
// 
Процедура ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(Описание) Экспорт
	
	
	
КонецПроцедуры

// Заполняет виды доступа, используемые в ограничениях прав доступа.
// Виды доступа Пользователи и ВнешниеПользователи уже заполнены.
// Их можно удалить, если они не требуются для ограничения прав доступа.
//
// Параметры:
//  ВидыДоступа - ТаблицаЗначений - с колонками:
//   * Имя                    - Строка - имя используемое в описании поставляемых
//                                       профилей групп доступа и текстах ОДД.
//   * Представление          - Строка - представляет вид доступа в профилях и группах доступа.
//   * ТипЗначений            - Тип    - тип ссылки значений доступа.
//                                       Например, Тип("СправочникСсылка.Номенклатура").
//   * ТипГруппЗначений       - Тип    - тип ссылки групп значений доступа.
//                                       Например, Тип("СправочникСсылка.ГруппыДоступаНоменклатуры").
//   * НесколькоГруппЗначений - Булево - Истина указывает, что для значения доступа (Номенклатуры), можно
//                                       выбрать несколько групп значений (Групп доступа номенклатуры).
//
Процедура ПриЗаполненииВидовДоступа(ВидыДоступа) Экспорт
	
	ВидДоступа = ВидыДоступа.Добавить();
	ВидДоступа.Имя = "Организации";
	ВидДоступа.Представление = НСтр("ru = 'Организации'");
	ВидДоступа.ТипЗначений   = Тип("СправочникСсылка.Организации");
	
КонецПроцедуры

// Обработчик подписки на событие ПроверитьЗначениеОпцииИспользоватьНесколькоОрганизаций.
// Вызывается при записи элемента справочника "Организации".
//
Процедура ПроверитьЗначениеОпцииИспользоватьНесколькоОрганизацийПриЗаписи(Источник, Отказ) Экспорт
	
	Если НЕ Источник.ЭтоГруппа
		И НЕ ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций")
		И Справочники.Организации.КоличествоОрганизаций() > 1 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		Константы.ИспользоватьНесколькоОрганизаций.Установить(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
